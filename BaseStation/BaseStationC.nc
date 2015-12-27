#include "../SensorNode/SensorNode.h"

configuration BaseStationC {
}
implementation {
  components MainC, BaseStationP, LedsC;
  components ActiveMessageC as Radio, SerialActiveMessageC as Serial;
  
  MainC.Boot <- BaseStationP;

  BaseStationP.RadioControl -> Radio;
  BaseStationP.SerialControl -> Serial;
  
  BaseStationP.UartSend -> Serial.AMSend[AM_SENSORNODE];
  BaseStationP.UartReceive -> Serial.Receive[AM_SENSORNODE];
  BaseStationP.UartPacket -> Serial;
  BaseStationP.UartAMPacket -> Serial;
  
  BaseStationP.RadioSend -> Radio.AMSend[AM_SENSORNODE];
  BaseStationP.RadioReceive -> Radio.Receive[AM_SENSORNODE];
  BaseStationP.RadioPacket -> Radio;
  BaseStationP.RadioAMPacket -> Radio;

  BaseStationP.PackAck -> Radio;
  
  BaseStationP.Leds -> LedsC;
}
