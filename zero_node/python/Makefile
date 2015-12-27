GEN=answerMsg.py

all: $(GEN)

answerMsg.py: ../CalculateNode.h
	mig python -target=null $(CFLAGS) -python-classname=answerMsg ../CalculateNode.h resultPack -o $@

clean:
	rm -f *.cpy $(GEN)
