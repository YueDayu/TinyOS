#ifndef CALCULATENODE_H
#define CALCULATENODE_H

enum {
  AM_CALCULATENODE = 0,

  GROUP_ID = 0,

  AM_RESULTPACK = AM_CALCULATENODE,

  TOTAL_NUM = 2000
};

typedef nx_struct randomIntegerPack {
  nx_uint16_t sequence_number;
  nx_uint32_t random_integer;
} randomIntegerPack_t;

typedef nx_struct resultPack {
  nx_uint8_t group_id;
  nx_uint32_t max;
  nx_uint32_t min;
  nx_uint32_t sum;
  nx_uint32_t average;
  nx_uint32_t median;
} resultPack_t;

#endif
