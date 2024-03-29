#include "AM.h"
#include "Serial.h"

module BaseStationP @safe() {
  uses {
    interface Boot;
    interface SplitControl as SerialControl;
    interface SplitControl as RadioControl;

    interface AMSend as UartSend;
    interface Receive as UartReceive;
    interface Packet as UartPacket;
    interface AMPacket as UartAMPacket;
    
    interface AMSend as RadioSend;
    interface Receive as RadioReceive;
    interface Packet as RadioPacket;
    interface AMPacket as RadioAMPacket;

    interface PacketAcknowledgements as PackAck;

    interface Leds;
  }
}

implementation
{
  enum {
    UART_QUEUE_LEN = 12,
    RADIO_QUEUE_LEN = 12,
  };

  message_t  uartQueueBufs[UART_QUEUE_LEN];
  message_t  * ONE_NOK uartQueue[UART_QUEUE_LEN];
  uint8_t    uartIn, uartOut;
  bool       uartBusy, uartFull;

  message_t  radioQueueBufs[RADIO_QUEUE_LEN];
  message_t  * ONE_NOK radioQueue[RADIO_QUEUE_LEN];
  uint8_t    radioIn, radioOut;
  bool       radioBusy, radioFull;

  task void uartSendTask();
  task void radioSendTask();

  void dropBlink() {
    call Leds.led2Toggle();
  }

  void failBlink() {
    call Leds.led2Toggle();
  }

  event void Boot.booted() {
    uint8_t i;

    for (i = 0; i < UART_QUEUE_LEN; i++)
      uartQueue[i] = &uartQueueBufs[i];
    uartIn = uartOut = 0;
    uartBusy = FALSE;
    uartFull = TRUE;

    for (i = 0; i < RADIO_QUEUE_LEN; i++)
      radioQueue[i] = &radioQueueBufs[i];
    radioIn = radioOut = 0;
    radioBusy = FALSE;
    radioFull = TRUE;

    call RadioControl.start();
    call SerialControl.start();
  }

  event void RadioControl.startDone(error_t error) {
    if (error == SUCCESS) {
      radioFull = FALSE;
    }
  }

  event void SerialControl.startDone(error_t error) {
    if (error == SUCCESS) {
      uartFull = FALSE;
    }
  }

  event void SerialControl.stopDone(error_t error) {}
  event void RadioControl.stopDone(error_t error) {}

  uint8_t count = 0;

  message_t* ONE receive(message_t* ONE msg, void* payload, uint8_t len);
  
  event message_t *RadioReceive.receive(message_t *msg,
                                        void *payload,
                                        uint8_t len) {
    return receive(msg, payload, len);
  }

  message_t* receive(message_t *msg, void *payload, uint8_t len) {
    message_t *ret = msg;

    atomic {
      if (!uartFull)
      {
        ret = uartQueue[uartIn];
        uartQueue[uartIn] = msg;

        uartIn = (uartIn + 1) % UART_QUEUE_LEN;
      
        if (uartIn == uartOut)
          uartFull = TRUE;

        if (!uartBusy)
          {
            post uartSendTask();
            uartBusy = TRUE;
          }
      }
      else
      dropBlink();
    }
    
    return ret;
  }

  uint8_t tmpLen;
  
  task void uartSendTask() {
    uint8_t len;
    am_addr_t addr, src;
    message_t* msg;
    atomic
      if (uartIn == uartOut && !uartFull)
      {
        uartBusy = FALSE;
        return;
      }

    msg = uartQueue[uartOut];
    tmpLen = len = call RadioPacket.payloadLength(msg);
    addr = call RadioAMPacket.destination(msg);
    src = call RadioAMPacket.source(msg);
    call UartPacket.clear(msg);
    call UartAMPacket.setSource(msg, src);

    if (call UartSend.send(addr, uartQueue[uartOut], len) == SUCCESS)
      call Leds.led1Toggle();
    else
      {
      failBlink();
      post uartSendTask();
      }
  }

  event void UartSend.sendDone(message_t* msg, error_t error) {
    if (error != SUCCESS)
      failBlink();
    else
      atomic
      if (msg == uartQueue[uartOut])
        {
          if (++uartOut >= UART_QUEUE_LEN)
            uartOut = 0;
          if (uartFull)
            uartFull = FALSE;
        }
    post uartSendTask();
  }

  event message_t *UartReceive.receive(message_t *msg,
                                       void *payload,
                                       uint8_t len) {
    message_t *ret = msg;
    bool reflectToken = FALSE;

    atomic
      if (!radioFull)
      {
        reflectToken = TRUE;
        ret = radioQueue[radioIn];
        radioQueue[radioIn] = msg;
        if (++radioIn >= RADIO_QUEUE_LEN)
          radioIn = 0;
        if (radioIn == radioOut)
          radioFull = TRUE;

        if (!radioBusy)
          {
            post radioSendTask();
            radioBusy = TRUE;
          }
      }
      else
      dropBlink();

    if (reflectToken) {
      //call UartTokenReceive.ReflectToken(Token);
    }
    
    return ret;
  }

  task void radioSendTask() {
    uint8_t len;
    am_addr_t addr,source;
    message_t* msg;
    
    atomic
      if (radioIn == radioOut && !radioFull)
      {
        radioBusy = FALSE;
        return;
      }

    msg = radioQueue[radioOut];
    len = call UartPacket.payloadLength(msg);
    addr = call UartAMPacket.destination(msg);
    source = call UartAMPacket.source(msg);

    call RadioPacket.clear(msg);
    call RadioAMPacket.setSource(msg, source);

    call PackAck.requestAck(msg);
    
    if (call RadioSend.send(addr, msg, len) == SUCCESS)
      call Leds.led0Toggle();
    else
      {
      failBlink();
      post radioSendTask();
      }
  }

  event void RadioSend.sendDone(message_t* msg, error_t error) {
    if (!call PackAck.wasAcked(msg) || error != SUCCESS)
      failBlink();
    else
      atomic
      if (msg == radioQueue[radioOut])
        {
          if (++radioOut >= RADIO_QUEUE_LEN)
            radioOut = 0;
          if (radioFull)
            radioFull = FALSE;
        }
    
    post radioSendTask();
  }
}  
