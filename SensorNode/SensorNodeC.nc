#include "Timer.h"
#include "SensorNode.h"

module SensorNodeC @safe()
{
  uses {
    interface Boot;
    interface SplitControl as RadioControl;
    interface AMSend;
    interface Receive;
    interface Timer<TMilli>;
    interface Read<uint16_t> as Tem;
    interface Read<uint16_t> as Hum;
    interface Read<uint16_t> as Par;
    interface Leds;
    interface PacketAcknowledgements as PacketAck;
  }
}
implementation
{
  enum {
    QUEUE_LEN = 20
  };

  message_t  queueBufs[QUEUE_LEN];
  message_t  *ONE_NOK queue[QUEUE_LEN];
  uint8_t    queueDest[QUEUE_LEN];
  uint8_t    queueAck[QUEUE_LEN];
  uint8_t    queryIn, queryOut;
  bool       sendBusy, queryFull;

  sensorPacket_t local;
  tempReading_t temp;

  uint8_t reading; /* 0 to NREADINGS */
  uint8_t ackCount;
  uint8_t currentDest;

  // Use LEDs to report various status issues.
  void report_problem() { call Leds.led0Toggle(); }
  void report_sent() { call Leds.led1Toggle(); }
  void report_received() { call Leds.led2Toggle(); }

  event void Boot.booted() {
    uint8_t i;
    local.interval = DEFAULT_INTERVAL;
    local.id = TOS_NODE_ID;
    local.count = 0;
    local.version = 0;
    temp.temReading = 0;
    temp.humReading = 0;
    temp.parReading = 0;
    ackCount = 0;

    for (i = 0; i < QUEUE_LEN; i++) {
      queue[i] = &queueBufs[i];
      queueDest[i] = 0;
      queueAck[i] = 0;
    }
    queryIn = queryOut = 0;
    sendBusy = FALSE;
    queryFull = FALSE;

    if (call RadioControl.start() != SUCCESS)
      report_problem();
  }

  void startTimer() {
    call Timer.startPeriodic(local.interval);
    reading = 0;
  }

  task void SendTask() {
    message_t* msg;
    uint8_t    dest;
    report_sent();
    atomic
      if (queryIn == queryOut && !queryFull)
      {
        sendBusy = FALSE;
        return;
      }

    msg = queue[queryOut];
    dest = queueDest[queryOut];

    if (dest > MAX_ID) {
      sendBusy = FALSE;
      post SendTask();
      return;
    }

    call PacketAck.requestAck(msg);
    if (!call AMSend.send(dest, msg, sizeof local) == SUCCESS) {
      report_problem();
      post SendTask();
    }
  }


  event void RadioControl.startDone(error_t error) {
    startTimer();
  }

  event void RadioControl.stopDone(error_t error) {
  }

  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
    sensorPacket_t *omsg = payload;

    report_received();

    /* If we receive a newer version, update our interval. 
       If we hear from a future count, jump ahead but suppress our own change
    */
    if (omsg->version > local.version)
      {
	    local.version = omsg->version;
	    local.interval = omsg->interval;
	    startTimer();
      }
      if (!queryFull)
      {
        memcpy(call AMSend.getPayload(queue[queryIn], sizeof(local)), omsg, sizeof local);
        if (TOS_NODE_ID < omsg->id && TOS_NODE_ID != MIN_ID) {
          queueDest[queryIn] = TOS_NODE_ID - 1;
        } else if (TOS_NODE_ID > omsg->id && TOS_NODE_ID != MAX_ID) {
          queueDest[queryIn] = TOS_NODE_ID + 1;
        } else {
          return msg;
        }
        queueAck[queryIn] = 0;
        if (++queryIn >= QUEUE_LEN)
          queryIn = 0;
        if (queryIn == queryOut)
          queryFull = TRUE;

        if (!sendBusy)
          {
            post SendTask();
            sendBusy = TRUE;
          }
      } else {
        report_problem();
      }
    return msg;
  }

  /* At each sample period:
     - if local sample buffer is full, send accumulated samples
     - read next sample
  */
  event void Timer.fired() {
  local.count++;
  local.timestamps[reading] = call Timer.getNow();
  local.humReadings[reading] = temp.humReading;
  local.temReadings[reading] = temp.temReading;
  local.parReadings[reading] = temp.parReading;
  reading++;
    if (reading >= NREADINGS && TOS_NODE_ID != MIN_ID)
      {
        atomic
      if (!queryFull)
      {
        memcpy(call AMSend.getPayload(queue[queryIn], sizeof(local)), &local, sizeof local);
        queueDest[queryIn] = TOS_NODE_ID - 1;
        queueAck[queryIn] = 0;
        if (++queryIn >= QUEUE_LEN)
          queryIn = 0;
        if (queryIn == queryOut)
          queryFull = TRUE;

        if (!sendBusy)
          {
            post SendTask();
            sendBusy = TRUE;
          }
      } else {
        report_problem();
      }
	      reading = 0;
      }

	/* Part 2 of cheap "time sync": increment our count if we didn't
	   jump ahead. */
    if (call Tem.read() != SUCCESS)
      report_problem();
    if (call Hum.read() != SUCCESS)
      report_problem();
    if (call Par.read() != SUCCESS)
      report_problem();
  }

  event void AMSend.sendDone(message_t* msg, error_t error) {
    if ((!call PacketAck.wasAcked(msg) || error != SUCCESS) && queueAck[queryOut] < MAX_RESEND) {
      report_problem();
      queueAck[queryOut]++;
    }
    else
      atomic
      if (msg == queue[queryOut])
        {
          if (++queryOut >= QUEUE_LEN)
            queryOut = 0;
          if (queryFull)
            queryFull = FALSE;
        }
    
    post SendTask();
  }

  event void Tem.readDone(error_t result, uint16_t data) {
    if (result != SUCCESS)
      {
	data = 0xffff;
	report_problem();
      }
    temp.temReading = data;
  }

  event void Hum.readDone(error_t result, uint16_t data) {
    if (result != SUCCESS)
      {
  data = 0xffff;
  report_problem();
      }
    temp.humReading = data;
  }

  event void Par.readDone(error_t result, uint16_t data) {
    if (result != SUCCESS)
      {
  data = 0xffff;
  report_problem();
      }
    temp.parReading = data;
  }
}
