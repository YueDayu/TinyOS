from OscilloscopeMsg import *

# class node:
#     def __init__(self, id):
#         self.id = id
#         self.couter = []
#         self.timestamp = []
#         self.tem = []
#         self.hum = []
#         self.par = []

class data:
    def __init__(self):
        self.nodes = {}

    def update(self, msg):
        id = msg.get_id()
        if id not in self.nodes:
            self.nodes[id] = {
                'id': id,
                'couter': [],
                'timestamp': [],
                'tem': [],
                'hum': [],
                'par': []
            }
            print self.nodes[id]
        counter = msg.get_count()
        self.nodes[id]['couter'].append(counter)
        self.nodes[id]['couter'].append(counter + 1)
        self.nodes[id]['timestamp'] += msg.get_timestamps()
        self.nodes[id]['tem'] += msg.get_temReadings()
        self.nodes[id]['hum'] += msg.get_humReadings()
        self.nodes[id]['par'] += msg.get_parReadings()
        with open('result.txt','a') as f:
            f.write(str(id) + " " + str(counter) + " " + str(msg.get_timestamps()[0]) + " " + str(msg.get_temReadings()[0]) 
                + " " + str(msg.get_humReadings()[0]) + " " + str(msg.get_parReadings()[0]) + "\n")
            f.write(str(id) + " " + str(counter + 1) + " " + str(msg.get_timestamps()[1]) + " " + str(msg.get_temReadings()[1]) 
                + " " + str(msg.get_humReadings()[1]) + " " + str(msg.get_parReadings()[1]) + "\n")

    def clear_data(self):
        self.nodes = {}

