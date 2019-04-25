#include <a_samp>
#include <float>
#include <izcmd>
#include <sscanf2>

COMMAND:veh(playerid,params[])
{
    new vid, distance, string[128], Float:x, Float:y, Float:z, Float:a;
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
    {
        CreateVehicle(vid, x, y, z, a, -1, -1, 60);
        new str_vid[24];
        valstr(str_vid, vid);
        format(string, sizeof string, "You have spawned a vehicle with ID %s.", str_vid);
        SendClientMessage(playerid,-1,string);
    }
    return CMD_SUCCESS;
}

COMMAND:tp(playerid,params[])
{
    new pid, target[MAX_PLAYER_NAME], invoker[MAX_PLAYER_NAME], string[128], Float:x, Float:y, Float:z;
    if(sscanf(params,"i",pid)) SendClientMessage(playerid,-1,"Usage: /tp [player id]");
    GetPlayerPos(pid, x, y, z);
    SetPlayerPos(playerid, x+2, y, z+2);
    GetPlayerName(pid, target, sizeof(target));
    GetPlayerName(playerid, invoker, sizeof(invoker));
    format(string, sizeof string, "You were teleported to %s.", target); 
    SendClientMessage(playerid,-1,string);
    format(string, sizeof string, "%s has teleported to your position.", invoker); 
    SendClientMessage(pid,-1,string);
    return CMD_SUCCESS;
}

COMMAND:bring(playerid,params[])
{
    new pid, target[MAX_PLAYER_NAME], invoker[MAX_PLAYER_NAME], string[128], Float:x, Float:y, Float:z;
    if(sscanf(params,"i",pid)) SendClientMessage(playerid,-1,"Usage: /bring [player id]");
    GetPlayerPos(playerid, x, y, z);
    SetPlayerPos(pid, x+2, y, z+2);
    GetPlayerName(pid, target, sizeof(target));
    GetPlayerName(playerid, invoker, sizeof(invoker));
    format(string, sizeof string, "You brought %s to your position.", target); 
    SendClientMessage(playerid,-1,string);
    format(string, sizeof string, "You were brought to %s position.", invoker); 
    SendClientMessage(pid,-1,string);
    return CMD_SUCCESS;
}

COMMAND:skin(playerid,params[])
{
    new sid, string[128];
    if(sscanf(params,"i",sid)) SendClientMessage(playerid,-1,"Usage: /skin [skin id]");
    SetPlayerSkin(playerid, sid);
    new str_sid[24];
    valstr(str_sid, sid);
    format(string, sizeof string, "You have changed your skin to ID %s.", str_sid); 
    SendClientMessage(playerid,-1,string);
    return CMD_SUCCESS;
}

COMMAND:wep(playerid,params[])
{
    new wid, string[128];
    if(sscanf(params,"i",wid)) SendClientMessage(playerid,-1,"Usage: /wep [weapon id]");
    GivePlayerWeapon(playerid,wid,9999);
    new str_wid[24];
    valstr(str_wid, wid);
    format(string, sizeof string, "You have given yourself weapon ID %s.", str_wid); 
    SendClientMessage(playerid,-1,string);
    return CMD_SUCCESS;
}