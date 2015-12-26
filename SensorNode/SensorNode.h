#ifndef SENSORNODE_H
#define SENSORNODE_H

enum {
  NREADINGS = 2,

  DEFAULT_INTERVAL = 256,

  AM_SENSORNODE = 0x93,

  AM_SENSORPACKET = AM_SENSORNODE,

  MAX_ID = 2,

  MIN_ID = 0,

  MAX_RESEND = 3
};

typedef nx_struct sensorPacket {
  nx_uint16_t version; /* Version of the interval. */
  nx_uint16_t interval; /* Samping period. */
  nx_uint16_t id; /* Mote id of sending mote. */
  nx_uint16_t count;
  nx_uint16_t timestamps[NREADINGS];
  nx_uint16_t temReadings[NREADINGS];
  nx_uint16_t humReadings[NREADINGS];
  nx_uint16_t parReadings[NREADINGS];
} sensorPacket_t;

typedef nx_struct tempReading {
  nx_uint16_t temReading;
  nx_uint16_t humReading;
  nx_uint16_t parReading;
} tempReading_t;

#endif
