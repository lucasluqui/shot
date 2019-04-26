#include <a_samp>

#define COLOR_DEFAULT			0xAAAAAAFF
#define COLOR_FAILURE           0xD62B20FF

public OnPlayerCommandReceived(playerid,cmdtext[])
{
	new playerState = GetPlayerState(playerid);
    if (playerState != PLAYER_STATE_SPECTATING && playerState != PLAYER_STATE_WASTED){
        return 1;
    }
    SendClientMessage(playerid,COLOR_FAILURE,"You can not input commands right now.")
    return 0;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success) {
    if (!success) {
        new string[128];
        format(string, sizeof(string), "Command %s not found.", cmdtext);
        SendClientMessage(playerid,COLOR_FAILURE,string);
        //return 0;
    }
    return 1;
}