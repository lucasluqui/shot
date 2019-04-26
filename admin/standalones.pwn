#include <a_samp>
#include <izcmd>
#include <sscanf2>

#define COLOR_DEFAULT			0xAAAAAAFF
#define COLOR_FAILURE           0xD62B20FF

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
        format(string, sizeof string, "%s brought you to his position.", invoker); 
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
    format(string, sizeof string, "%s brought you to his position.", invoker); 
    SendClientMessage(pid,COLOR_DEFAULT,string);
    return CMD_SUCCESS;
}

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