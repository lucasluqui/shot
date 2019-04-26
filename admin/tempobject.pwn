#include <a_samp>
#include <izcmd>
#include <sscanf2>

#define COLOR_DEFAULT			0xAAAAAAFF
#define COLOR_FAILURE           0xD62B20FF

new objects;
new objectmodel[500];

COMMAND:newtobject(playerid, params[])
{
    new oid,obj;
    if (!sscanf(params,"i",oid))    return SendClientMessage(playerid,COLOR_FAILURE,"Usage: /newtobject [object id]");
    {
        new string[128];
        new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
        obj = CreateObject(oid, x+2, y+2, z+2, 0.0, 0.0, 90.0);
        format(string, sizeof(string), "Created a new temporary object (ID: %d) at %f,%f,%f,0.0,0.0,90.0",obj,oid,x,y,z);
        SendClientMessage(playerid,COLOR_DEFAULT,string);
        objectmodel[obj]=oid;
        objects++;
        EditObject(playerid, oid);
        return 1;
    }
}

COMMAND:edittobject(playerid, params[])
{
    new oid;
    if (!sscanf(params,"i",oid))    return SendClientMessage(playerid,COLOR_FAILURE,"Usage: /edittobject [object id]");
    {
        EditObject(playerid, oid);
        return 1;
    } 
}

public OnPlayerEditObject(playerid, playerobject, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ)
{
    if(response == EDIT_RESPONSE_FINAL)
    {
        SetObjectPos(objectid,fX,fY,fZ);
        SetObjectRot(objectid,fRotX,fRotY,fRotZ);
        return 1;
    }
    return 1;
}