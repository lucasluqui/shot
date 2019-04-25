#include <a_samp>
#include <sscanf2>
#include "core/enums/dialogs.pwn"

#define LOCKDOWN_PASSWORD "hyperphen"

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_LOGIN)
    {
        if(!response) // If they clicked 'Cancel' or pressed esc
        {
            Kick(playerid);
        }
        else // Pressed ENTER or clicked 'Login' button
        {
            new pwdinput[32];
            if(sscanf(inputtext, "s[32]", pwdinput)) Kick(playerid);
            {
                if(!strcmp(pwdinput, LOCKDOWN_PASSWORD)){
                    SendClientMessage(playerid, 0xFFFFFFFF, "You are now logged in!");
                    TogglePlayerSpectating(playerid,false);
                }else{
                    SendClientMessage(playerid, 0xFFFFFFFF, "LOGIN FAILED.");

                    // Re-show the login dialog
                    ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "It seems you're already registered, please type in your password:", "Login", "Exit");
                }
            }
        }
        return 1; // We handled a dialog, so return 1. Just like OnPlayerCommandText.
    }
 
    return 0; // You MUST return 0 here! Just like OnPlayerCommandText.
}