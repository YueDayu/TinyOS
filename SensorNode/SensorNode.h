#ifndef SENSORNODE_H
#define SENSORNODE_H

enum {
  NREADINGS = 2,

  DEFAULT_INTERVAL = 256,

  AM_SENSORNODE = 0x93
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

#endif
