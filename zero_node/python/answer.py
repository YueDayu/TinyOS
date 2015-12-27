from answerMsg import *
from tinyos.message import MoteIF
from time import sleep

class Main():
    def __init__(self):
        self.mif = MoteIF.MoteIF()
        self.source = self.mif.addSource("sf@localhost:9002")
        self.mif.addListener(self, answerMsg)


    def receive(self, src, msg):
        # print "Received message: ", msg.get_id(), msg.get_timestamps()
        print msg.get_max()
        print msg.get_min()
        print msg.get_sum()
        print msg.get_average()
        print msg.get_median()

if __name__ == '__main__':
    m = Main()
