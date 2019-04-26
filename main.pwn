#include <a_samp>
#include <core>
#include <float>

// useful command libraries
#include <izcmd>
#include <sscanf2>

// core handlers and misc
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
#include "core/enums/player.pwn"

new 
    DB: Database;

new gPData[MAX_PLAYERS][playerdata];

stock getPname(playerid)  
{  
    new pname[24];  
    GetPlayerName(playerid, pname, sizeof(pname));  
    return pname;  
}

native WP_Hash(buffer[], len, const str[]);

main()
{
	print("Initializing project-shoot...\n");
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

    if ((Database = db_open("players.db")) == DB: 0)
    {
        print("Failed to open a connection to \"players.db\""); 
    } 
    else
    { 
        db_query(Database, "PRAGMA synchronous = OFF"); 
        db_query(Database, "CREATE TABLE IF NOT EXISTS playerdata (id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(24) COLLATE NOCASE, password VARCHAR(129), level INTEGER DEFAULT 1 NOT NULL, xp INTEGER DEFAULT 0 NOT NULL, balance INTEGER DEFAULT 2500 NOT NULL, pposx REAL DEFAULT 0.0 NOT NULL, pposy REAL DEFAULT 0.0 NOT NULL, pposz REAL DEFAULT 0.0 NOT NULL)"); 
    } 
    return 1; 
}

public OnGameModeExit() 
{ 
    db_close(Database);
    return 1; 
}  

public OnPlayerConnect(playerid)
{
    new  
        tmp[playerdata]; 

    gPData[playerid] = tmp; 
	TogglePlayerSpectating(playerid,true);
	SendClientMessage(playerid,COLOR_DEFAULT,"OnPlayerConnect was triggered here, why am I even debugging like this?!");

    new 
        Query[82],
        DBResult: Result;

	GetPlayerName(playerid, gPData[playerid][name], MAX_PLAYER_NAME);
	format(Query, sizeof Query, "SELECT password FROM playerdata WHERE name = '%q' LIMIT 1", gPData[playerid][name]);
	Result = db_query(Database, Query);

    if (db_num_rows(Result))
    { 
        db_get_field_assoc(Result, "password", gPData[playerid][password], 129);
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "It seems you're already registered, please type in your password:", "Login", "Exit");
    } 
    else
    {  
        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Register", "It appears to be your first time around, welcome! Please type in a password for your account below.", "Register", "Exit"); 
    } 
    db_free_result(Result); 
    return 1;
}

public OnPlayerDisconnect(playerid, reason) 
{ 
    
	new
		Query[150]; 

	GetPlayerPos(playerid, gPData[playerid][pposx], gPData[playerid][pposy], gPData[playerid][pposz]);
	format(Query, sizeof Query, "UPDATE playerdata SET pposx=%r pposy=%r pposz=%r WHERE id = %d", gPData[playerid][pposx], gPData[playerid][pposy], gPData[playerid][pposz], gPData[playerid][id]);
	db_query(Database, Query);
	
	new  
        tmp[playerdata]; 

    gPData[playerid] = tmp;
    return 1; 
}  

public OnPlayerSpawn(playerid)
{
	if(IsPlayerNPC(playerid)) return 1;
	
	SetPlayerInterior(playerid,0);
	TogglePlayerClock(playerid,0);
 	ResetPlayerMoney(playerid);
	new 
		Query[82],
		DBResult: Result;

	format(Query, sizeof Query, "SELECT (level, balance) FROM playerdata WHERE name = '%q' LIMIT 1", gPData[playerid][name]);
	Result = db_query(Database, Query);
	db_get_field_assoc(Result, "level", gPData[playerid][level], 258);
	db_get_field_assoc(Result, "balance", gPData[playerid][balance], 258);
	SetPlayerScore(playerid,gPData[playerid][level]);
	GivePlayerMoney(playerid, gPData[playerid][balance]);
	db_free_result(Result); 
	GivePlayerWeapon(playerid,WEAPON_MP5,9999);
	TogglePlayerClock(playerid, 0);
	SetPlayerPos(playerid, gPData[playerid][pposx], gPData[playerid][pposy], gPData[playerid][pposz]);

	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
   	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid){
		case DIALOG_REGISTER:
		{
			if(!response) return Kick(playerid);
			if(!(5 <= strlen(inputtext) <= 20))
			{
				ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Register", "It appears to be your first time around, welcome! Please type in a password for your account below.\n{D62B20}Password must at least have 5 characters, and it can not exceed 20.", "Register", "Exit");
				return 1;
			}

            new // a query, lucas don't forget to change the size of this if you add more stuff!
                Query[208]; 

			WP_Hash(gPData[playerid][password], 129, inputtext);
			format(Query, sizeof Query, "INSERT INTO playerdata (name, password) VALUES ('%q', '%s')", gPData[playerid][name], gPData[playerid][password]);
			db_query(Database, Query);

            new 
                DBResult: Result;

            Result = db_query(Database, "SELECT last_insert_rowid()"); 
            gPData[playerid][id] = db_get_field_int(Result);

            db_free_result(Result);

			TogglePlayerSpectating(playerid,false);
		}
		case DIALOG_LOGIN:
		{
			if(!response) return Kick(playerid);
            
			new 
                buf[129];
            
			//format(buf, sizeof buf, inputtext)
			WP_Hash(buf, 129, inputtext);
            if (strcmp(buf, gPData[playerid][password]))
			{
				ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "It seems you're already registered, please type in your password:\n{D62B20}Password did not match, try again.", "Login", "Exit");
				return 1;
			}
			new 
				DBResult: Result; 

			format(buf, sizeof buf, "SELECT * FROM playerdata WHERE name = '%q' LIMIT 1", gPData[playerid][name]);
			Result = db_query(Database, buf);

			if (db_num_rows(Result))
			{
				gPData[playerid][id] = db_get_field_assoc_int(Result, "id"); 
			} 
			db_free_result(Result);
			gPData[playerid][loggedin] = 1;
			TogglePlayerSpectating(playerid,false);
		}
		default: return 0;
	}
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
		SetPlayerHealth(damagedid, hp-95);
	}
    return 1;
}