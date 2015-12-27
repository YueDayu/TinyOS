GEN=OscilloscopeMsg.java Constants.java

all: oscilloscope.jar

oscilloscope.jar: Oscilloscope.class
	jar cf $@ *.class

OscilloscopeMsg.java: ../SensorNode/SensorNode.h
	mig -target=null -java-classname=OscilloscopeMsg java ../SensorNode/SensorNode.h sensorPacket -o $@

Constants.java: ../SensorNode/SensorNode.h
	ncg -target=null -java-classname=Constants java ../SensorNode/SensorNode.h NREADINGS DEFAULT_INTERVAL -o $@

Oscilloscope.class: $(wildcard *.java) $(GEN)
	javac *.java

clean:
	rm -f *.class $(GEN)

veryclean: clean
	rm oscilloscope.jar
