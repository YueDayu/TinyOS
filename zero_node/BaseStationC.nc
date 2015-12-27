#include "CalculateNode.h"

configuration BaseStationC {
}
implementation {
  components MainC, BaseStationP, LedsC;
  components ActiveMessageC as Radio, SerialActiveMessageC as Serial;
  
  MainC.Boot <- BaseStationP;

  BaseStationP.RadioControl -> Radio;
  BaseStationP.SerialControl -> Serial;
  
  BaseStationP.UartSend -> Serial.AMSend[AM_RESULTPACK];
  BaseStationP.UartReceive -> Serial.Receive[AM_RESULTPACK];
  BaseStationP.UartPacket -> Serial;
  BaseStationP.UartAMPacket -> Serial;
  
  BaseStationP.RadioSend -> Radio.AMSend[AM_RESULTPACK];
  BaseStationP.RadioReceive -> Radio.Receive[AM_RESULTPACK];
  BaseStationP.RadioPacket -> Radio;
  BaseStationP.RadioAMPacket -> Radio;

  BaseStationP.PackAck -> Radio;
  
  BaseStationP.Leds -> LedsC;
}
