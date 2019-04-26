#include <a_samp>
#include <core>
#include <float>

// useful command libraries
#include <izcmd>
#include <sscanf2>

// core handlers and misc
#include "core/dialog.pwn"
#include "core/handlecmd.pwn"

// admin commands
#include "admin/standalones.pwn"
#include "admin/tempobject.pwn"

// player commands
#include "player/standalones.pwn"

#pragma tabsize 0

#define INIT_HARDCODED_MONEY    69420
#define COLOR_DEFAULT			0xAAAAAAFF
#define COLOR_FAILURE           0xD62B20FF


// enums
#include "core/enums/dialogs.pwn"

main()
{
	print("Initializing project-shoot...\n");
}

public OnPlayerConnect(playerid)
{
  	TogglePlayerSpectating(playerid,true);
	SendClientMessage(playerid,COLOR_DEFAULT,"OnPlayerConnect was triggered here, why am I even debugging like this?!");
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
	UsePlayerPedAnims();

	return 1;
}

public OnPlayerUpdate(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(IsPlayerNPC(playerid)) return 1;
	
	/* minecraft good, minigun bad
	if(GetPlayerWeapon(playerid) == WEAPON_MINIGUN) {
	    Kick(playerid);
	    return 0;
	}
	*/

	return 1;
}

public OnPlayerText(playerid, text[])
{
    SetPlayerChatBubble(playerid, text, 0xFFFFFFFF, 40.0, 10000);
    return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
	if (bodypart == 9){
		new Float:hp;
		GetPlayerHealth(damagedid, hp);
		SetPlayerHealth(damagedid, hp-100);
	}
	if (weaponid == 38){
		new Float:hp;
		GetPlayerHealth(damagedid, hp);
		SetPlayerHealth(damagedid, hp+1);
	}
    return 1;
}