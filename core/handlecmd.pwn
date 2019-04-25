#include <a_samp>

public OnPlayerCommandReceived(playerid,cmdtext[])
{
	new playerState = GetPlayerState(playerid);
    if (playerState != PLAYER_STATE_SPECTATING && playerState != PLAYER_STATE_WASTED){
        return 1;
    }
    SendClientMessage(playerid,-1,"You can not input commands right now.")
    return 0;
}