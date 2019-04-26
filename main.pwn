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
#include "core/enums/playerdata.pwn"
#include "core/enums/privileges.pwn"

new 
    DB: Database;

new gPData[MAX_PLAYERS][playerdata];

stock getPname(playerid)  
{  
    new pname[24];  
    GetPlayerName(playerid, pname, sizeof(pname));  
    return pname;  
}

stock pullData(playerid)
{
	new 
	DBResult: Result, buf[129];

	format(buf, sizeof buf, "SELECT * FROM playerdata WHERE name = '%q' LIMIT 1", gPData[playerid][name]);
	Result = db_query(Database, buf);

	if (db_num_rows(Result))
	{
		gPData[playerid][id] = db_get_field_assoc_int(Result, "id");
		gPData[playerid][privilege] = db_get_field_assoc_int(Result, "privilege");
		gPData[playerid][level] = db_get_field_assoc_int(Result, "level");
		gPData[playerid][xp] = db_get_field_assoc_int(Result, "xp");
		gPData[playerid][balance] = db_get_field_assoc_int(Result, "balance");
		gPData[playerid][skinid] = db_get_field_assoc_int(Result, "skinid");
		gPData[playerid][pposx] = db_get_field_assoc_int(Result, "pposx");
		gPData[playerid][pposy] = db_get_field_assoc_int(Result, "pposy");
		gPData[playerid][pposz] = db_get_field_assoc_int(Result, "pposz");
		gPData[playerid][pposa] = db_get_field_assoc_int(Result, "pposa");
	} 
	db_free_result(Result);
}

stock sendToAdminChat(playerid, msg[])
{
	new pname[MAX_PLAYER_NAME], string[128];
	GetPlayerName(playerid, pname, sizeof(pname));
	for(new i; i < MAX_PLAYERS; i++)
    {
        if(isStaff(i))
		{
			format(string, sizeof string, "Administration: %s: %s", pname, msg);
			SendClientMessage(i,COLOR_DEFAULT,string);
        }
    }
}

stock isStaff(playerid)
{
	if(gPData[playerid][privilege] >= PRIVILEGE_LOWMODERATOR)
	{
		return 1;
	}
	return 0;
}

stock isCash(playerid)
{
	if(PRIVILEGE_LOWMODERATOR > gPData[playerid][privilege] >= PRIVILEGE_CASH)
	{
		return 1;
	}
	return 0;
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
        db_query(Database, "CREATE TABLE IF NOT EXISTS playerdata (id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(24) COLLATE NOCASE, password VARCHAR(129), privilege INTEGER DEFAULT 0 NOT NULL, level INTEGER DEFAULT 1 NOT NULL, xp INTEGER DEFAULT 0 NOT NULL, balance INTEGER DEFAULT 2500 NOT NULL, skinid INTEGER DEFAULT 73 NOT NULL, pposx REAL DEFAULT 0.0 NOT NULL, pposy REAL DEFAULT 0.0 NOT NULL, pposz REAL DEFAULT 0.0 NOT NULL, pposa REAL DEFAULT 0.0 NOT NULL)"); 
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
	gPData[playerid][loggedin] = 0;
	gPData[playerid][statsSet] = 0;
	TogglePlayerSpectating(playerid,true);

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
		Query[300]; 

	GetPlayerPos(playerid, gPData[playerid][pposx], gPData[playerid][pposy], gPData[playerid][pposz]);
	GetPlayerFacingAngle(playerid, gPData[playerid][pposa]);
	format(Query, sizeof Query, "UPDATE playerdata SET pposx=%f, pposy=%f, pposz=%f, pposa=%f, skinid=%d WHERE id = %d", gPData[playerid][pposx], gPData[playerid][pposy], gPData[playerid][pposz], gPData[playerid][pposa], gPData[playerid][skinid], gPData[playerid][id]);
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
	if(gPData[playerid][statsSet] < 1)
	{
		SetPlayerPos(playerid, gPData[playerid][pposx], gPData[playerid][pposy], gPData[playerid][pposz]);
		SetPlayerFacingAngle(playerid, gPData[playerid][pposa]);
		SetPlayerScore(playerid,gPData[playerid][level]);
		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid, gPData[playerid][balance]);
		gPData[playerid][statsSet] = 1;
	}
	else
	{
		SetPlayerPos(playerid, 2493.9133, -1682.3986, 13.3382);
	}
	SetPlayerSkin(playerid, gPData[playerid][skinid]);
	GivePlayerWeapon(playerid,WEAPON_MP5,9999);

	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{ 	
	gPData[playerid][skinid] = GetPlayerSkin(playerid);
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

			pullData(playerid);
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
			pullData(playerid);
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

COMMAND:staff(playerid,params[])
{
    if(!isnull(params)) {
        return SendClientMessage(playerid,COLOR_FAILURE,"No parameters required.");
    }

    new string[128], found;
	format(string, sizeof(string), "* STAFF ONLINE:");
	SendClientMessage(playerid,COLOR_DEFAULT,string);

    for(new i; i < MAX_PLAYERS; i++)
    {
        if(gPData[i][privilege] >= PRIVILEGE_LOWMODERATOR)
		{
			new pname[MAX_PLAYER_NAME];
        	GetPlayerName(i, pname, sizeof(pname));
			switch(gPData[i][privilege])
			{
				case PRIVILEGE_LOWMODERATOR:
				{
					format(string, sizeof(string), "{E67E22}** Moderator (1) %s (ID: %d)", pname, i);
					SendClientMessage(playerid,COLOR_DEFAULT,string);
				}
				case PRIVILEGE_MIDMODERATOR:
				{
					format(string, sizeof(string), "{E67E22}** Staff %s (ID: %d)", pname, i);
					SendClientMessage(playerid,COLOR_DEFAULT,string);
				}
				case PRIVILEGE_HIGHMODERATOR:
				{
					format(string, sizeof(string), "{E67E22}** Moderator (3) %s (ID: %d)", pname, i);
					SendClientMessage(playerid,COLOR_DEFAULT,string);
				}
				case PRIVILEGE_ADMINISTRATOR:
				{
					format(string, sizeof(string), "{E74C3C}** Administrator %s (ID: %d)", pname, i);
					SendClientMessage(playerid,COLOR_DEFAULT,string);
				}
				case PRIVILEGE_FOUNDER:
				{
					format(string, sizeof(string), "{E74C3C}** Founder %s (ID: %d)", pname, i);
					SendClientMessage(playerid,COLOR_DEFAULT,string);
				}
				default: return CMD_SUCCESS;
			}
            found++;
        }
    }
    if(found == 0){
        SendClientMessage(playerid,COLOR_DEFAULT,"There are no staff members online.");
    }
    return CMD_SUCCESS;
}

COMMAND:ac(playerid,params[])
{
    sendToAdminChat(playerid, params);
    return CMD_SUCCESS;
}

COMMAND:stats(playerid,params[])
{
	new string[128];
	SendClientMessage(playerid,COLOR_DEFAULT,"Your stats:");
	format(string, sizeof(string), "ID DB: %d | Privilege Level: %d | Level: %d | Experience: %d | Balance: %d | Skin ID: %d", gPData[playerid][id], gPData[playerid][privilege], gPData[playerid][level], gPData[playerid][xp], gPData[playerid][balance], gPData[playerid][skinid]);
	SendClientMessage(playerid,COLOR_DEFAULT,string);
    return CMD_SUCCESS;
}