#include <a_samp>
#include <izcmd>
#include <sscanf2>

COMMAND:weatherset(playerid,params[])
{
    new weatherid;
    if(sscanf(params,"i",weatherid)) SendClientMessage(playerid,-1,"Usage: /weatherset [weather id]");
    else SetWeather(weatherid);
    return CMD_SUCCESS;
}