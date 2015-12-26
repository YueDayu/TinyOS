configuration SensorNodeAppC {}
implementation {
    components SensorNodeC, MainC, ActiveMessageC, LedsC,
    new TimerMilliC(),
    new SensirionSht11C() as SensorTemHum,
    new HamamatsuS1087ParC() as SensorPAR,
    new AMSenderC(AM_SENSORNODE),
    new AMReceiverC(AM_SENSORNODE);

    SensorNodeC.Boot -> MainC;
    SensorNodeC.RadioControl -> ActiveMessageC;
    SensorNodeC.AMSend -> AMSenderC;
    SensorNodeC.Receive -> AMReceiverC;
    SensorNodeC.Timer -> TimerMilliC;
    SensorNodeC.Leds -> LedsC;
    SensorNodeC.Tem -> SensorTemHum.Temperature;
    SensorNodeC.Hum -> SensorTemHum.Humidity;
    SensorNodeC.Par -> SensorPAR;
    SensorNodeC.PacketAck -> AMSenderC;
}