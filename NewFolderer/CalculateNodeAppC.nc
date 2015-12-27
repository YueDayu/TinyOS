#include "CalculateNode.h"

configuration CalculateNodeAppC {}
implementation {
    components CalculateNodeC, MainC, ActiveMessageC, LedsC,
    new AMSenderC(AM_CALCULATENODE),
    new AMReceiverC(AM_CALCULATENODE);

    CalculateNodeC.Boot -> MainC;
    CalculateNodeC.RadioControl -> ActiveMessageC;
    CalculateNodeC.AMSend -> AMSenderC;
    CalculateNodeC.Receive -> AMReceiverC;
    CalculateNodeC.Leds -> LedsC;
}
