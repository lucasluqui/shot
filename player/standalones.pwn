#include <a_samp>
#include <float>
#include <izcmd>
#include <sscanf2>

#define COLOR_DEFAULT			0xAAAAAAFF
#define COLOR_FAILURE           0xD62B20FF

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

    if(sscanf(params,"i",vid)) return SendClientMessage(playerid,COLOR_FAILURE,"Usage: /veh [vehicle id]");
    {
        CreateVehicle(vid, x, y, z, a, -1, -1, 60);
        new str_vid[24];
        valstr(str_vid, vid);
        format(string, sizeof string, "You have spawned a vehicle with ID %s.", str_vid);
        SendClientMessage(playerid,COLOR_DEFAULT,string);
    }
    return CMD_SUCCESS;
}

COMMAND:id(playerid,params[])
{
    if(isnull(params)) {
        return SendClientMessage(playerid,COLOR_FAILURE,"Usage: /id [name]");
    }

    new string[128], found;

    for(new i; i < MAX_PLAYERS; i++)
    {
        new pname[MAX_PLAYER_NAME];
        GetPlayerName(i, pname, sizeof(pname));
        if(strfind(pname, params, true) != -1) {
            format(string, sizeof(string), "%s (ID: %d)", pname, i);
            SendClientMessage(playerid,COLOR_DEFAULT,string);
            found++;
        }
    }
    if(found == 0){
        SendClientMessage(playerid,COLOR_DEFAULT,"No players found.");
    }
    return CMD_SUCCESS;
}

COMMAND:tp(playerid,params[])
{
    if(isnull(params)) {
        return SendClientMessage(playerid,COLOR_FAILURE,"Usage: /tp [playername]");
    }

    new found, result, target[MAX_PLAYER_NAME], invoker[MAX_PLAYER_NAME], string[128], Float:x, Float:y, Float:z;
    for(new i; i < MAX_PLAYERS; i++)
    {
        new pname[MAX_PLAYER_NAME];
        GetPlayerName(i, pname, sizeof(pname));
        if(strfind(pname, params, true) != -1) {
            result = i;
            found++;
        }
    }
    if(found == 0){
        SendClientMessage(playerid,COLOR_DEFAULT,"No players found.");
        return CMD_SUCCESS;
    }
    if(found > 1){
        SendClientMessage(playerid,COLOR_FAILURE,"More than one player was found with that name input, please be specific.");
        return CMD_SUCCESS;
    }
    if(found == 1){
        GetPlayerPos(result, x, y, z);
        SetPlayerPos(playerid, x+2, y, z+2);
        GetPlayerName(result, target, sizeof(target));
        GetPlayerName(playerid, invoker, sizeof(invoker));
        format(string, sizeof string, "You were teleported to %s.", target); 
        SendClientMessage(playerid,COLOR_DEFAULT,string);
        format(string, sizeof string, "%s has teleported to your position.", invoker); 
        SendClientMessage(result,COLOR_DEFAULT,string);
        return CMD_SUCCESS;
    }
    return CMD_SUCCESS;
}

COMMAND:bring(playerid,params[])
{
    if(isnull(params)) {
        return SendClientMessage(playerid,COLOR_FAILURE,"Usage: /bring [playername]");
    }

    new found, result, target[MAX_PLAYER_NAME], invoker[MAX_PLAYER_NAME], string[128], Float:x, Float:y, Float:z;
    for(new i; i < MAX_PLAYERS; i++)
    {
        new pname[MAX_PLAYER_NAME];
        GetPlayerName(i, pname, sizeof(pname));
        if(strfind(pname, params, true) != -1) {
            result = i;
            found++;
        }
    }
    if(found == 0){
        SendClientMessage(playerid,COLOR_DEFAULT,"No players found.");
        return CMD_SUCCESS;
    }
    if(found > 1){
        SendClientMessage(playerid,COLOR_FAILURE,"More than one player was found with that name input, please be specific.");
        return CMD_SUCCESS;
    }
    if(found == 1){
        GetPlayerPos(playerid, x, y, z);
        SetPlayerPos(result, x+2, y, z+2);
        GetPlayerName(result, target, sizeof(target));
        GetPlayerName(playerid, invoker, sizeof(invoker));
        format(string, sizeof string, "You brought %s to your position.", target); 
        SendClientMessage(playerid,COLOR_DEFAULT,string);
        format(string, sizeof string, "You were brought to %s position.", invoker); 
        SendClientMessage(result,COLOR_DEFAULT,string);
        return CMD_SUCCESS;
    }
    return CMD_SUCCESS;
}

COMMAND:otp(playerid,params[])
{
    new pid, target[MAX_PLAYER_NAME], invoker[MAX_PLAYER_NAME], string[128], Float:x, Float:y, Float:z;
    if(sscanf(params,"i",pid)) return SendClientMessage(playerid,COLOR_FAILURE,"Usage: /otp [player id]");
    GetPlayerPos(pid, x, y, z);
    SetPlayerPos(playerid, x+2, y, z+2);
    GetPlayerName(pid, target, sizeof(target));
    GetPlayerName(playerid, invoker, sizeof(invoker));
    format(string, sizeof string, "You were teleported to %s.", target); 
    SendClientMessage(playerid,COLOR_DEFAULT,string);
    format(string, sizeof string, "%s has teleported to your position.", invoker); 
    SendClientMessage(pid,COLOR_DEFAULT,string);
    return CMD_SUCCESS;
}

COMMAND:obring(playerid,params[])
{
    new pid, target[MAX_PLAYER_NAME], invoker[MAX_PLAYER_NAME], string[128], Float:x, Float:y, Float:z;
    if(sscanf(params,"i",pid)) return SendClientMessage(playerid,COLOR_FAILURE,"Usage: /obring [player id]");
    GetPlayerPos(playerid, x, y, z);
    SetPlayerPos(pid, x+2, y, z+2);
    GetPlayerName(pid, target, sizeof(target));
    GetPlayerName(playerid, invoker, sizeof(invoker));
    format(string, sizeof string, "You brought %s to your position.", target); 
    SendClientMessage(playerid,COLOR_DEFAULT,string);
    format(string, sizeof string, "You were brought to %s position.", invoker); 
    SendClientMessage(pid,COLOR_DEFAULT,string);
    return CMD_SUCCESS;
}

COMMAND:skin(playerid,params[])
{
    new sid, string[128];
    if(sscanf(params,"i",sid)) return SendClientMessage(playerid,COLOR_FAILURE,"Usage: /skin [skin id]");
    SetPlayerSkin(playerid, sid);
    new str_sid[24];
    valstr(str_sid, sid);
    format(string, sizeof string, "You have changed your skin to ID %s.", str_sid); 
    SendClientMessage(playerid,COLOR_DEFAULT,string);
    return CMD_SUCCESS;
}

COMMAND:wep(playerid,params[])
{
    new wid, string[128];
    if(sscanf(params,"i",wid)) return SendClientMessage(playerid,COLOR_FAILURE,"Usage: /wep [weapon id]");
    GivePlayerWeapon(playerid,wid,9999);
    new str_wid[24];
    valstr(str_wid, wid);
    format(string, sizeof string, "You have given yourself weapon ID %s.", str_wid); 
    SendClientMessage(playerid,COLOR_DEFAULT,string);
    return CMD_SUCCESS;
}