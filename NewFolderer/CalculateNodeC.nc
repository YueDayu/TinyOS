#include "CalculateNode.h"

module CalculateNodeC @safe()
{
  uses {
    interface Boot;
    interface SplitControl as RadioControl;
    interface AMSend;
    interface Receive;
    interface Leds;
  }
}
implementation
{
  message_t sendBuf;
  resultPack_t local;
  randomIntegerPack_t request;
  uint16_t currentTop = 0;
  uint16_t localCount = 0;
  uint32_t localSum = 0;
  uint32_t localNumbers[TOTAL_NUM];
  bool sendBusy = FALSE;
  bool over = FALSE;

  // Use LEDs to report various status issues.
  void report_problem() { call Leds.led0Toggle(); }
  void report_sent() { call Leds.led1Toggle(); }
  void report_received() { call Leds.led2Toggle(); }

  event void Boot.booted() {
    uint16_t i;
    for(i = 0; i < 2000; i++){
      localNumbers[i] = 10001;
    }
    if (call RadioControl.start() != SUCCESS)
      report_received();
  }

  void reportAbcense(uint16_t sequence){
  report_sent();
  if(localNumbers[sequence] == 10001 && !sendBusy){
    request.sequence_number = sequence;
    request.random_integer = 10001;
    memcpy(call AMSend.getPayload(&sendBuf, sizeof(request)), &request, sizeof request);
    if (call AMSend.send(AM_BROADCAST_ADDR, &sendBuf, sizeof request) == SUCCESS)
      sendBusy = TRUE;
    if (!sendBusy);
    }
  }

  void sendAbsense(uint16_t sequence, uint32_t num){
  if(!sendBusy){
    request.sequence_number = sequence;
    request.random_integer = num;
    memcpy(call AMSend.getPayload(&sendBuf, sizeof(request)), &request, sizeof request);
    if (call AMSend.send(AM_BROADCAST_ADDR, &sendBuf, sizeof request) == SUCCESS)
      sendBusy = TRUE;
    if (!sendBusy);
    }
  }

  void update(uint32_t newNum){
    if(localCount == 0)
    {
      local.min = newNum;
      local.max = newNum;
    } else {
      if(newNum > local.max)
        local.max = newNum;
      else if(newNum < local.min)
        local.min = newNum;
    }
    localSum += newNum;
  //  insertSort(newNum);
  }

  event void RadioControl.startDone(error_t error) {
    if(error != SUCCESS);
  }

  event void RadioControl.stopDone(error_t error) {
  }

  void sendResult(){
  report_problem();
  if(!sendBusy){
    memcpy(call AMSend.getPayload(&sendBuf, sizeof(local)), &local, sizeof local);
    if (call AMSend.send(0, &sendBuf, sizeof local) == SUCCESS)
      sendBusy = TRUE;
    if (!sendBusy);
    over = TRUE;
    }
  }

  void swap(uint16_t left, uint16_t right)
  {
    uint32_t temp = localNumbers[left];
    localNumbers[left] = localNumbers[right];
    localNumbers[right] = temp;
  }

  uint16_t partition(uint16_t left, uint16_t right)  
    {
    uint16_t pos = right;
    right--;
    while (left <= right)
    {
        while (left < pos && localNumbers[left] <= localNumbers[pos])
            left++;
        while (right >= 0 && localNumbers[right] > localNumbers[pos])
            right--;
        if (left >= right)
            break;
        swap(left, right);
    }
    swap(left, pos);
    return left;
  }

  uint32_t getKIndex(uint16_t midPos)  
  {
    uint16_t left = 0;
    uint16_t right = localCount - 1;
    uint16_t index = localCount + 1;
    while (index != midPos)
    {
        index = partition(left, right);
        if (index < midPos)
            left = index + 1;
        else if (index > midPos)  
            right = index - 1;  
        else
            break;
    }
    return localNumbers[index];
  }

  void getResult(){
    local.average = local.sum / TOTAL_NUM;
    local.median = (getKIndex(localCount / 2) + getKIndex(localCount / 2 - 1)) / 2;
    sendResult();
  }

  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
    randomIntegerPack_t *rec = payload;
    uint16_t thisSeq = rec->sequence_number - 1, i;
    if (!over){
    if(TOS_NODE_ID == 3 * GROUP_ID + 1){
    if(localNumbers[thisSeq] == 10001 && rec->random_integer != 10001){
    if(thisSeq > currentTop + 1)
      {
        for(i = currentTop + 1; i < thisSeq; i++)
        {
          reportAbcense(i + 1);
        }
      }
    if(thisSeq > currentTop){
      currentTop = thisSeq;
    }
    report_received();
    update(rec->random_integer);
    localNumbers[thisSeq] = rec->random_integer;
    localCount++;
    if(localCount == TOTAL_NUM){
      getResult();
    }
    }
    } else {
    if(rec->random_integer != 10001){
    localNumbers[thisSeq] = rec->random_integer;
    } else {
      if(localNumbers[thisSeq] != 10001)
        sendAbsense(thisSeq + 1, localNumbers[thisSeq]);
    }
    }
    /* If we receive a newer version, update our interval. 
       If we hear from a future count, jump ahead but suppress our own change
    */
    }
    return msg;
  }

  event void AMSend.sendDone(message_t* msg, error_t error) {
    if (error == SUCCESS){
      sendBusy = FALSE;
      report_sent();
    }
  }
}
