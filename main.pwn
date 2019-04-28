#include <a_samp>
#include <core>
#include <float>

// useful command libraries
#include <smartcmd>
#include <sscanf2>

// admin commands
#include "admin/standalones.pwn"
#include "admin/tempobject.pwn"

// player commands
#include "player/standalones.pwn"

#pragma tabsize 0

#define PLAYER_KILL_MONEY_REWARD	250
#define PLAYER_KILL_XP_REWARD    	5

#define COLOR_DEFAULT				0xAAAAAAFF
#define COLOR_FAILURE           	0xD62B20FF
#define COLOR_ADMINCHAT           	0x2A74D6FF

#define COLOR_PRIVILEGE_LOWMODERATOR           	"E0914C"
#define COLOR_PRIVILEGE_MIDMODERATOR           	"E67E22"
#define COLOR_PRIVILEGE_HIGHMODERATOR           "C96A16"
#define COLOR_PRIVILEGE_ADMINISTRATOR           "E74C3C"
#define COLOR_PRIVILEGE_FOUNDER           		"CC392A"


// enums
#include "core/enums/dialogs.pwn"
#include "core/enums/playerdata.pwn"
#include "core/enums/privileges.pwn"
#include "core/enums/memberships.pwn"

new 
    DB: Database;
new gPData[MAX_PLAYERS][playerdata];
new Text:websiteUrlTextDraw, PlayerText:playerLevelTextDraw[MAX_PLAYERS];

stock getPname(playerid)  
{  
    new pname[24];  
    GetPlayerName(playerid, pname, sizeof(pname));  
    return pname;  
}

stock calcRequiredXP(lvl)  
{  
    new value = 25*lvl*(1+lvl);
    return value;  
}

public increaseLevel(playerid)  
{  
    new string[128];
	gPData[playerid][level] += 1;

    PlayerTextDrawDestroy(playerid, playerLevelTextDraw[playerid]);
	format(string, sizeof(string), "Level %d", gPData[playerid][level])
	playerLevelTextDraw[playerid] = CreatePlayerTextDraw(playerid, 553.000000, 101.000000, string);
	PlayerTextDrawAlignment(playerid, playerLevelTextDraw[playerid], 2);
	PlayerTextDrawBackgroundColor(playerid, playerLevelTextDraw[playerid], 0x000000ff);
	PlayerTextDrawFont(playerid, playerLevelTextDraw[playerid], 2);
	PlayerTextDrawLetterSize(playerid, playerLevelTextDraw[playerid], 0.299999, 1.300000);
	PlayerTextDrawColor(playerid, playerLevelTextDraw[playerid], 0xffffffff);
	PlayerTextDrawSetProportional(playerid, playerLevelTextDraw[playerid], 1);
	PlayerTextDrawSetShadow(playerid, playerLevelTextDraw[playerid], 1);
	PlayerTextDrawShow(playerid, playerLevelTextDraw[playerid]);

	SetPlayerScore(playerid,gPData[playerid][level]);

	SendClientMessage(playerid,COLOR_DEFAULT,"Congratulations, you have leveled up!");
}

public pullData(playerid)
{
	new 
	DBResult: Result, buf[129];

	format(buf, sizeof buf, "SELECT * FROM playerdata WHERE name = '%q' LIMIT 1", gPData[playerid][name]);
	Result = db_query(Database, buf);

	if (db_num_rows(Result))
	{
		gPData[playerid][id] = db_get_field_assoc_int(Result, "id");
		gPData[playerid][privilege] = db_get_field_assoc_int(Result, "privilege");
		gPData[playerid][membership] = db_get_field_assoc_int(Result, "membership");
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

public submitData(playerid)
{
	new Query[300];

	GetPlayerPos(playerid, gPData[playerid][pposx], gPData[playerid][pposy], gPData[playerid][pposz]);
	GetPlayerFacingAngle(playerid, gPData[playerid][pposa]);
	format(Query, sizeof Query, "UPDATE playerdata SET level=%d, xp=%d, balance=%d, pposx=%f, pposy=%f, pposz=%f, pposa=%f, skinid=%d WHERE id = %d", gPData[playerid][level], gPData[playerid][xp], gPData[playerid][balance], gPData[playerid][pposx], gPData[playerid][pposy], gPData[playerid][pposz], gPData[playerid][pposa], gPData[playerid][skinid], gPData[playerid][id]);
	db_query(Database, Query);
}

public sendToAdminChat(playerid, msg[])
{
	new pname[MAX_PLAYER_NAME], string[128];
	GetPlayerName(playerid, pname, sizeof(pname));
	for(new i; i < MAX_PLAYERS; i++)
    {
        if(isStaff(i))
		{
			format(string, sizeof string, "Administration: %s: %s", pname, msg);
			SendClientMessage(i,COLOR_ADMINCHAT,string);
        }
    }
}

public isStaff(playerid)
{
	if(gPData[playerid][privilege] >= PRIVILEGE_LOWMODERATOR)
	{
		return 1;
	}
	return 0;
}

public isCash(playerid)
{
	if(gPData[playerid][membership] >= MEMBERSHIP_CASH)
	{
		return 1;
	}
	return 0;
}

stock getPrivilegeName(playerid)
{
	new prname[64];
	switch(gPData[playerid][privilege])
	{
		case PRIVILEGE_LOWMODERATOR:{prname = "Novice Staff";}
		case PRIVILEGE_MIDMODERATOR:{prname = "Staff";}
		case PRIVILEGE_HIGHMODERATOR:{prname = "High Staff";}
		case PRIVILEGE_ADMINISTRATOR:{prname = "Administrator";}
		case PRIVILEGE_FOUNDER:{prname = "Founder";}
		default:{prname = "None";}
	}
	return prname;
}

stock getPrivilegeColor(playerid)
{
	new prcolor[64];
	switch(gPData[playerid][privilege])
	{
		case PRIVILEGE_LOWMODERATOR:{prcolor = COLOR_PRIVILEGE_LOWMODERATOR;}
		case PRIVILEGE_MIDMODERATOR:{prcolor = COLOR_PRIVILEGE_MIDMODERATOR;}
		case PRIVILEGE_HIGHMODERATOR:{prcolor = COLOR_PRIVILEGE_HIGHMODERATOR;}
		case PRIVILEGE_ADMINISTRATOR:{prcolor = COLOR_PRIVILEGE_ADMINISTRATOR;}
		case PRIVILEGE_FOUNDER:{prcolor = COLOR_PRIVILEGE_FOUNDER;}
		default:{prcolor = "";}
	}
	return prcolor;
}

stock getMembershipName(playerid)
{
	new mbname[64];
	switch(gPData[playerid][membership])
	{
		case MEMBERSHIP_CASH:{mbname = "VIP";}
		case MEMBERSHIP_BIGCASH:{mbname = "VIP+";}
		default:{mbname = "None";}
	}
	return mbname;
}

forward increaseLevel(playerid);
forward pullData(playerid);
forward submitData(playerid);
forward sendToAdminChat(playerid, msg[]);
forward isStaff(playerid);
forward isCash(playerid);
forward getPrivilegeName(playerid);
forward getMembershipName(playerid);
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

	websiteUrlTextDraw = TextDrawCreate(70.000000,432.000000,"www.~Y~p~W~hoenix~Y~n~W~etwork.net");
	TextDrawAlignment(websiteUrlTextDraw,2);
	TextDrawBackgroundColor(websiteUrlTextDraw,0x000000ff);
	TextDrawFont(websiteUrlTextDraw,2);
	TextDrawLetterSize(websiteUrlTextDraw,0.199999,1.300000);
	TextDrawColor(websiteUrlTextDraw,0xffffffff);
	TextDrawSetOutline(websiteUrlTextDraw,1);
	TextDrawSetProportional(websiteUrlTextDraw,1);
	TextDrawSetShadow(websiteUrlTextDraw,1);

    if ((Database = db_open("players.db")) == DB: 0)
    {
        print("Failed to open a connection to playerdata database."); 
    } 
    else
    { 
        db_query(Database, "PRAGMA synchronous = OFF");
		new createTable[600] = "CREATE TABLE IF NOT EXISTS playerdata (id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(24) COLLATE NOCASE, password VARCHAR(129), privilege INTEGER DEFAULT 0 NOT NULL, membership INTEGER DEFAULT 0 NOT NULL, level INTEGER DEFAULT 1 NOT NULL, xp INTEGER DEFAULT 0 NOT NULL,";
		strcat(createTable, " balance INTEGER DEFAULT 2500 NOT NULL, skinid INTEGER DEFAULT 73 NOT NULL, pposx REAL DEFAULT 0.0 NOT NULL, pposy REAL DEFAULT 0.0 NOT NULL, pposz REAL DEFAULT 0.0 NOT NULL, pposa REAL DEFAULT 0.0 NOT NULL)");
        db_query(Database, createTable);
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
	TextDrawShowForPlayer(playerid, websiteUrlTextDraw);
    return 1;
}

public OnPlayerDisconnect(playerid, reason) 
{
	submitData(playerid);
	
	new  
        tmp[playerdata]; 

    gPData[playerid] = tmp;
    return 1; 
}  

public OnPlayerSpawn(playerid)
{
	if(IsPlayerNPC(playerid)) return 1;
	
	if(gPData[playerid][statsSet] < 1)
	{
		SetPlayerPos(playerid, gPData[playerid][pposx], gPData[playerid][pposy], gPData[playerid][pposz]);
		SetPlayerFacingAngle(playerid, gPData[playerid][pposa]);
		SetPlayerScore(playerid,gPData[playerid][level]);
		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid, gPData[playerid][balance]);

		new string[128];
		format(string, sizeof(string), "Level %d", gPData[playerid][level])
		playerLevelTextDraw[playerid] = CreatePlayerTextDraw(playerid, 553.000000, 101.000000, string);
		PlayerTextDrawAlignment(playerid, playerLevelTextDraw[playerid], 2);
		PlayerTextDrawBackgroundColor(playerid, playerLevelTextDraw[playerid], 0x000000ff);
		PlayerTextDrawFont(playerid, playerLevelTextDraw[playerid], 2);
		PlayerTextDrawLetterSize(playerid, playerLevelTextDraw[playerid], 0.299999, 1.300000);
		PlayerTextDrawColor(playerid, playerLevelTextDraw[playerid], 0xffffffff);
		PlayerTextDrawSetProportional(playerid, playerLevelTextDraw[playerid], 1);
		PlayerTextDrawSetShadow(playerid, playerLevelTextDraw[playerid], 1);
		PlayerTextDrawShow(playerid, playerLevelTextDraw[playerid]);

		gPData[playerid][statsSet] = 1;
	}
	else
	{
		SetPlayerPos(playerid, 2493.9133, -1682.3986, 13.3382);
	}

	SetPlayerInterior(playerid,0);
	TogglePlayerClock(playerid,0);
	SetPlayerSkin(playerid, gPData[playerid][skinid]);
	GivePlayerWeapon(playerid,WEAPON_MP5,9999);
	GivePlayerWeapon(playerid,WEAPON_SILENCED,9999);
	GivePlayerWeapon(playerid,WEAPON_AK47,9999);
	GivePlayerWeapon(playerid,WEAPON_SPRAYCAN,9999);

	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{ 	
	gPData[playerid][skinid] = GetPlayerSkin(playerid);
	
	GivePlayerMoney(playerid, 100); // GTA automatically deducts $100 on death.
	
	if(killerid != INVALID_PLAYER_ID)
	{
		gPData[killerid][balance] += PLAYER_KILL_MONEY_REWARD;
		GivePlayerMoney(killerid, PLAYER_KILL_MONEY_REWARD);
		gPData[killerid][xp] += PLAYER_KILL_XP_REWARD;
		new requiredXP = calcRequiredXP(gPData[killerid][level]);
		if(gPData[killerid][xp] >= requiredXP)
		{
			increaseLevel(killerid);
		}	
	}
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

            new
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
			gPData[playerid][loggedin] = 1;
			TogglePlayerSpectating(playerid,false);
		}
		case DIALOG_LOGIN:
		{
			if(!response) return Kick(playerid);
            
			new 
                buf[129];
            
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
	if(GetPlayerWeapon(playerid) == WEAPON_MINIGUN && gPData[playerid][privilege] < PRIVILEGE_ADMINISTRATOR) {
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

public OnPlayerCommandReceived(cmdid, playerid, cmdtext[])
{
	new playerState = GetPlayerState(playerid);
    if (playerState != PLAYER_STATE_SPECTATING && playerState != PLAYER_STATE_WASTED)
    {
        if(GetCommandFlags(cmdid) <= gPData[playerid][privilege] || GetCommandFlags(cmdid) <= gPData[playerid][membership])
        {
			return 1;
		}
		else
		{
			SendClientMessage(playerid,COLOR_FAILURE,"You do not met the requirements to execute this command.");
			return 0;
		}
    }
    SendClientMessage(playerid,COLOR_FAILURE,"You can not input commands right now.");
    return 0;
}

public OnPlayerCommandPerformed(cmdid, playerid, cmdtext[], success) {
    if (!success) {
        new string[128];
        format(string, sizeof(string), "Command %s not found.", cmdtext);
        SendClientMessage(playerid,COLOR_FAILURE,string);
    }
    return 1;
}








COMMAND:staff(cmdid, playerid, params[])
{
    if(!isnull(params)) {
        return SendClientMessage(playerid,COLOR_FAILURE,"No parameters required.");
    }

    new string[128], found;
	format(string, sizeof(string), "* Online Staff:");
	SendClientMessage(playerid,COLOR_DEFAULT,string);

    for(new i; i < MAX_PLAYERS; i++)
    {
        if(gPData[i][privilege] >= PRIVILEGE_LOWMODERATOR)
		{
			new pname[MAX_PLAYER_NAME];
        	GetPlayerName(i, pname, sizeof(pname));
			format(string, sizeof(string), "{%s}** %s %s (ID: %d)", getPrivilegeColor(playerid), getPrivilegeName(playerid), pname, i);
			SendClientMessage(playerid,COLOR_DEFAULT,string);
            found++;
        }
    }
    if(found == 0){
        SendClientMessage(playerid,COLOR_DEFAULT,"There are no staff members online.");
    }
    return CMD_SUCCESS;
}

COMMAND:stats(cmdid, playerid, params[])
{
	new string[128];
	SendClientMessage(playerid,COLOR_DEFAULT,"* Your stats:");
	format(string, sizeof(string), "ID DB: %d | Rank: %s | Membership: %s | Level: %d | Experience: %d/%d | Balance: %d | Skin ID: %d", gPData[playerid][id], getPrivilegeName(playerid), getMembershipName(playerid), gPData[playerid][level], gPData[playerid][xp], calcRequiredXP(gPData[playerid][level]), gPData[playerid][balance], gPData[playerid][skinid]);
	SendClientMessage(playerid,COLOR_DEFAULT,string);
    return CMD_SUCCESS;
}

COMMAND:id(cmdid, playerid, params[])
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
            format(string, sizeof(string), "%s (ID: %d) (Level: %d)", pname, i, gPData[i][level]);
            SendClientMessage(playerid,COLOR_DEFAULT,string);
            found++;
        }
    }
    if(found == 0){
        SendClientMessage(playerid,COLOR_DEFAULT,"No players found.");
    }
    return CMD_SUCCESS;
}

COMMAND<PRIVILEGE_LOWMODERATOR>:a(cmdid, playerid, params[])
{
    sendToAdminChat(playerid, params);
    return CMD_SUCCESS;
}