from OscilloscopeMsg import *
from Constants import *
from tinyos.message import MoteIF
from time import sleep
from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
import data
import sys
import cgi
import json

class Main():
    def __init__(self, source):
        self.mif = MoteIF.MoteIF()
        self.source = self.mif.addSource(source)
        self.mif.addListener(self, OscilloscopeMsg)
        self.data = data.data()
        self.version = 0
        self.a1 = 0
        self.bad1 = 0.
        self.sum1 = 1.
        self.a2 = 0
        self.bad2 = 0.
        self.sum2 = 1.


    def receive(self, src, msg):
        # print "Received message: ", msg.get_id(), msg.get_timestamps()
        self.data.update(msg)
        print self.data.nodes
        if msg.get_id() == 1:
            if self.a1 == 0:
                self.a1 = msg.get_count()
            else:
                if msg.get_count() > self.a1 + 2:
                    self.bad1 += 1
            self.a1 = msg.get_count()
            self.sum1 += 1.0
        if msg.get_id() == 2:
            if self.a2 == 0:
                self.a2 = msg.get_count()
            else:
                if msg.get_count() > self.a2 + 2:
                    self.bad2 += 1
            self.a2 = msg.get_count()
            self.sum2 += 1.0
        print self.bad1 / self.sum1, self.bad2 / self.sum2

    
    def sendTask(self, new_num):
        ts = OscilloscopeMsg()
        self.version += 1
        ts.set_version(self.version)
        ts.set_interval(new_num)
        print "send packet"
        self.mif.sendMsg(self.source, 1, ts.get_amType(), Constants.AM_SENSORNODE, ts)
        print "send over"


m = Main("sf@localhost:9002")


class MainHttp(BaseHTTPRequestHandler):
    def do_GET(self):
        curdir = './webpage/'
        if self.path=="/":
            self.path="/index.html"

        try:
            sendReply = False
            if self.path.endswith(".html"):
                mimetype='text/html'
                sendReply = True
            if self.path.endswith(".jpg"):
                mimetype='image/jpg'
                sendReply = True
            if self.path.endswith(".gif"):
                mimetype='image/gif'
                sendReply = True
            if self.path.endswith(".js"):
                mimetype='application/javascript'
                sendReply = True
            if self.path.endswith(".css"):
                mimetype='text/css'
                sendReply = True

            if sendReply == True:
                f = open(curdir + self.path) 
                self.send_response(200)
                self.send_header('Content-type',mimetype)
                self.end_headers()
                self.wfile.write(f.read())
                f.close()
            return
        except IOError:
            self.send_error(404,'File Not Found: %s' % self.path)

    def do_POST(self):
        form = cgi.FieldStorage(
            fp=self.rfile,
            headers=self.headers,
            environ={'REQUEST_METHOD':'POST',
                     'CONTENT_TYPE':self.headers['Content-Type'],
                     })
        self.send_response(200)
        self.end_headers()
        if self.path == '/clear':
            m.data.clear_data()
            self.wfile.write('OK\n')
        elif self.path == '/set':
            num = int(form['interval'].value)
            if num >= 50:
                m.sendTask(num)
                self.wfile.write('OK\n')
            else:
                self.wfile.write('no\n')
        else:
            self.wfile.write(json.dumps(m.data.nodes))


def run():
    print('http server is starting...')
    server_address = ('127.0.0.1', 9000)
    httpd = HTTPServer(server_address, MainHttp)
    print('http server is running...')
    httpd.serve_forever()

run()
