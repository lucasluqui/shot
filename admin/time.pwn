#include <a_samp>
#include <core>
#include <float>
#include <izcmd>
#include <sscsanf2>

COMMAND:timeset(playerid,params[])
{
    new timeid;
      if(sscanf(params,"i",timeid)) SendClientMessage(playerid,-1,"Usage: /timeset [time id]");
      else SetWorldTime(timeid);
    return CMD_SUCCESS;
}