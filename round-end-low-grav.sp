#include <sourcemod>
#include <sdktools>
#include <cstrike>

#define PLUGIN_AUTHOR "MRxMAG1C"
#define PLUGIN_VERSION "1.00"

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{
	name = "Round End Low Gravity",
	author = PLUGIN_AUTHOR,
	description = "Sets low gravity at the end of rounds",
	version = PLUGIN_VERSION,
	url = "hjemezez.dk"
};

public void OnPluginStart()
{
	HookEvent("round_end", Event_RoundEnd, EventHookMode_PostNoCopy);
	HookEvent("round_start", Event_RoundStart, EventHookMode_PostNoCopy);
}
public Action Event_RoundEnd(Event event, const char[] name, bool dontBroadcast) {
	for (int i = 1; i <= MaxClients;i++)
	if (IsClientInGame(i))
	{
		SetEntityGravity(i, 0.3);
	}
} 
public Action Event_RoundStart(Event event, const char[] name, bool dontBroadcast) {
	for (int i = 1; i <= MaxClients;i++)
	if (IsClientInGame(i))
	{
		SetEntityGravity(i, 1.0);
	}
} 