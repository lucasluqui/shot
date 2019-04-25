#include <a_samp>
#include <sscanf2>
#include "core/enums/dialogs.pwn"

#define LOCKDOWN_PASSWORD "hyperphen"

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_LOGIN)
    {
        if(!response)
        {
            Kick(playerid);
        }
        else
        {
            new pwdinput[32];
            if(sscanf(inputtext, "s[32]", pwdinput)) Kick(playerid);
            {
                if(!strcmp(pwdinput, LOCKDOWN_PASSWORD)){
                    SendClientMessage(playerid, 0xFFFFFFFF, "You are now logged in!");
                    TogglePlayerSpectating(playerid,false);
                }else{
                    ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "It seems you're already registered, please type in your password:\n{D62B20}Password did not match, try again.", "Login", "Exit");
                }
            }
        }
        return 1;
    }
 
    return 0;
}