configuration SensorNodeAppC {}
implementation {
    components SensorNodeC, MainC, ActiveMessageC, LedsC,
    new TimerMilliC(),
    new SensirionSht11C() as SensorTemHum,
    new HamamatsuS1087ParC() as SenorPAR,
    new AMSenderC(AM_SENSENODE),
    new AMReceiverC(AM_SENSENODE);

    SensorNodeC.Boot -> MainC;
    SensorNodeC.RadioControl -> ActiveMessageC;
    SensorNodeC.AMSend -> AMSenderC;
    SensorNodeC.Receive -> AMReceiverC;
    SensorNodeC.Timer -> TimerMilliC;
    SensorNodeC.Leds -> LedsC;
    SensorNodeC.Read -> Sensor;
    SensorNodeC.Tem -> SensorTemHum.Temperature;
    SensorNodeC.Hum -> SensorTemHum.Humidity;
    SensorNodeC.Par -> SenorPAR;
}