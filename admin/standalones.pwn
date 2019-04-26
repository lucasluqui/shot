#include <a_samp>
#include <izcmd>
#include <sscanf2>

#define COLOR_DEFAULT			0xAAAAAAFF
#define COLOR_FAILURE           0xD62B20FF

COMMAND:timeset(playerid,params[])
{
    new timeid;
    if(sscanf(params,"i",timeid)) return SendClientMessage(playerid,COLOR_FAILURE,"Usage: /timeset [time id]");
    else SetWorldTime(timeid);
    return CMD_SUCCESS;
}

COMMAND:weatherset(playerid,params[])
{
    new weatherid;
    if(sscanf(params,"i",weatherid)) return SendClientMessage(playerid,COLOR_FAILURE,"Usage: /weatherset [weather id]");
    else SetWeather(weatherid);
    return CMD_SUCCESS;
}