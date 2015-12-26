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
  message_t sendBuf;
  bool sendBusy;

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
    local.interval = DEFAULT_INTERVAL;
    local.id = TOS_NODE_ID;
    local.count = 0;
    local.version = 0;
    temp.temReading = 0;
    temp.humReading = 0;
    temp.parReading = 0;
    ackCount = 0;
    if (call RadioControl.start() != SUCCESS)
      report_problem();
  }

  void startTimer() {
    call Timer.startPeriodic(local.interval);
    reading = 0;
  }

  void sendPacket(sensorPacket_t *packet, uint8_t dest){
    memcpy(call AMSend.getPayload(&sendBuf, sizeof(local)), packet, sizeof local);
    call PacketAck.requestAck(&sendBuf);
    if (call AMSend.send(dest, &sendBuf, sizeof local) == SUCCESS)
      sendBusy = TRUE;
    if (!sendBusy)
      report_problem();
    currentDest = dest;
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
    if (!sendBusy)
    {
      if (TOS_NODE_ID < omsg->id && TOS_NODE_ID != MIN_ID)
          {
            sendPacket(omsg, TOS_NODE_ID - 1);
            sendBusy = TRUE;
          }
      if (TOS_NODE_ID > omsg->id && TOS_NODE_ID != MAX_ID)
          {
            sendPacket(omsg, TOS_NODE_ID + 1);
            sendBusy = TRUE;
          }
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
	      if (!sendBusy && sizeof local <= call AMSend.maxPayloadLength())
	        {
	          // Don't need to check for null because we've already checked length
	          // above
            sendPacket(&local, TOS_NODE_ID - 1);
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
    sensorPacket_t* tempPacket = msg->data;
    if (error == SUCCESS && call PacketAck.wasAcked(msg)){
      sendBusy = FALSE;
      report_sent();
      ackCount = 0;
    }
    else
    {
      report_problem();
      if(ackCount < MAX_RESEND)
      {
        sendPacket(tempPacket, currentDest);
        ackCount++;
      } else {
        ackCount = 0;
        sendBusy = FALSE;
      }
    }
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
