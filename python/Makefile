GEN=OscilloscopeMsg.py Constants.py

all: $(GEN)

OscilloscopeMsg.py: ../SensorNode/SensorNode.h
	mig python -target=null $(CFLAGS) -python-classname=OscilloscopeMsg ../SensorNode/SensorNode.h sensorPacket -o $@

Constants.py: ../SensorNode/SensorNode.h
	ncg python -target=null $(CFLAGS) -python-classname=Constants ../SensorNode/SensorNode.h NREADINGS DEFAULT_INTERVAL AM_SENSORNODE -o $@

clean:
	rm -f *.cpy $(GEN)
