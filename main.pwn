#include <a_samp>
#include <core>
#include <float>

// useful command libraries
#include <izcmd>
#include <sscanf2>

// core handlers and misc
#include "core/dialog.pwn"

// admin commands
#include "admin/timeset.pwn"
#include "admin/weatherset.pwn"

// player commands
#include "player/veh.pwn"

#pragma tabsize 0

#define INIT_HARDCODED_MONEY    69420
#define WHITE_SUPREMACY         0xFFFFFFFF


// enums
#include "core/enums/dialogs.pwn"

main()
{
	print("Initializing project-shoot...\n");
}

public OnPlayerConnect(playerid)
{
  	TogglePlayerSpectating(playerid,true);
	SendClientMessage(playerid,WHITE_SUPREMACY,"OnPlayerConnect was triggered here, why am I even debugging like this?!");
	ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "It seems you're already registered, please type in your password:", "Login", "Exit");
 	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(IsPlayerNPC(playerid)) return 1;
	
	SetPlayerInterior(playerid,0);
	TogglePlayerClock(playerid,0);
 	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, INIT_HARDCODED_MONEY);
	GivePlayerWeapon(playerid,WEAPON_MP5,9999);
	TogglePlayerClock(playerid, 0);

	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
   	return 1;
}

public OnGameModeInit()
{
	SetGameModeText("project-shoot");
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_GLOBAL);
	ShowNameTags(1);
	SetNameTagDrawDistance(40.0);
	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	SetWeather(2);
	SetWorldTime(11);

	return 1;
}

public OnPlayerUpdate(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(IsPlayerNPC(playerid)) return 1;
	
	// minecraft good, minigun bad
	if(GetPlayerWeapon(playerid) == WEAPON_MINIGUN) {
	    Kick(playerid);
	    return 0;
	}

	return 1;
}