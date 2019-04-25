#include <a_samp>
#include <izcmd>
#include <sscanf2>

COMMAND:veh(playerid,params[])
{
    new vid, Float:x, Float:y, Float:z, Float:az;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, az);
    if(sscanf(params,"i",vid)) SendClientMessage(playerid,-1,"Usage: /veh [vehicle id]");
    else CreateVehicle(vid, x+5, y+5, z, az, -1, -1, 60);
    return CMD_SUCCESS;
}