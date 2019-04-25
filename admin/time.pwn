#include <a_samp>
#include <izcmd>
#include <sscanf2>

COMMAND:timeset(playerid,params[])
{
    new timeid;
    if(sscanf(params,"i",timeid)) SendClientMessage(playerid,-1,"Usage: /timeset [time id]");
    else SetWorldTime(timeid);
    return CMD_SUCCESS;
}