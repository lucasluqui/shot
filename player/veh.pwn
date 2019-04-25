#include <a_samp>
#include <float>
#include <izcmd>
#include <sscanf2>

COMMAND:veh(playerid,params[])
{
    new vid, distance, Float:x, Float:y, Float:z, Float:a;
    distance = 5;

    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    if (GetPlayerVehicleID(playerid))
    {
        distance += 2;
        GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
    }

    x += (distance * floatsin(-a, degrees));
    y += (distance * floatcos(-a, degrees));

    if(sscanf(params,"i",vid)) SendClientMessage(playerid,-1,"Usage: /veh [vehicle id]");
    else CreateVehicle(vid, x, y, z, a, -1, -1, 60);
    return CMD_SUCCESS;
}