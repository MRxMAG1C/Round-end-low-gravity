#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <clientprefs>

#define PLUGIN_AUTHOR "MRxMAG1C"
#define PLUGIN_VERSION "1.1"

#pragma semicolon 1
#pragma newdecls required

//CVars
ConVar g_ClientSettings;

//Handlers
Handle g_LowgravPlayCookie;

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
	//CVars
	g_ClientSettings = CreateConVar("lowgrav_client_preferences", "1", "Enable/Disable client preferences");
	
	//ClientPrefs
	g_LowgravPlayCookie = RegClientCookie("Low gravity switch", "", CookieAccess_Private);
	
	SetCookieMenuItem(lowgravCookieHandler, 0, "Low gravity switch");
	
	//Events
	HookEvent("round_end", Event_RoundEnd, EventHookMode_PostNoCopy);
	HookEvent("round_start", Event_RoundStart, EventHookMode_PostNoCopy);
	
	//Commands
	RegConsoleCmd("sm_lowgrav", lowgravmenu);
}
public Action Event_RoundEnd(Event event, const char[] name, bool dontBroadcast) {
	for (int i = 1; i <= MaxClients;i++)
	if (IsClientInGame(i))

	{
		if(IsValidClient(i) && (GetConVarInt(g_ClientSettings) == 0 || GetIntCookie(i, g_LowgravPlayCookie) == 0))
		{
			SetEntityGravity(i, 0.3);
		}
	}
}

public void lowgravCookieHandler(int client, CookieMenuAction action, any info, char[] buffer, int maxlen)
{
	lowgravmenu(client, 0);
}

public Action lowgravmenu(int client, int args)
{
	if(GetConVarInt(g_ClientSettings) != 1)
	{
		return Plugin_Handled;
	}
	
	int cookievalue = GetIntCookie(client, g_LowgravPlayCookie);
	Menu g_CookieMenu = new Menu(LowgravMenuHandler);
	SetMenuTitle(g_CookieMenu, "Low Gravity by: MRxMAG1C (Help from CLNissen & Nubbe)");
	char Item[128];
	if(cookievalue == 0)
	{
		Format(Item, sizeof(Item), "%s %s", "Low Gravity ON", "Selected");
		AddMenuItem(g_CookieMenu, "ON", Item);
		Format(Item, sizeof(Item), "%s", "Low Gravity OFF"); 
		AddMenuItem(g_CookieMenu, "OFF", Item);
	}
	else
	{
		Format(Item, sizeof(Item), "%s", "Low Gravity ON");
		AddMenuItem(g_CookieMenu, "ON", Item);
		Format(Item, sizeof(Item), "%s %s", "Low Gravity OFF", "Selected"); 
		AddMenuItem(g_CookieMenu, "OFF", Item);
	}
	SetMenuExitButton(g_CookieMenu, true);
	DisplayMenu(g_CookieMenu, client, 30);
	return Plugin_Continue;
}

public int LowgravMenuHandler(Handle menu, MenuAction action, int client, int param2)
{
	Handle g_CookieMenu = CreateMenu(LowgravMenuHandler);
	if (action == MenuAction_DrawItem)
	{
		return ITEMDRAW_DEFAULT;
	}
	
	else if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				SetClientCookie(client, g_LowgravPlayCookie, "0");
				lowgravmenu(client, 0);
			}
			case 1:
			{
				SetClientCookie(client, g_LowgravPlayCookie, "1");
				lowgravmenu(client, 0);
			}
		}
		CloseHandle(g_CookieMenu);
	}
	else if(action == MenuAction_End)
	{
		delete menu;
	}
	return 0;
}

public Action Event_RoundStart(Event event, const char[] name, bool dontBroadcast) {
	for (int i = 1; i <= MaxClients;i++)
	if (IsClientInGame(i))
	{
		SetEntityGravity(i, 1.0);
	}
} 

//Helpers
stock bool IsValidClient(int client)
{
	if(client <= 0 ) return false;
	if(client > MaxClients) return false;
	if(!IsClientConnected(client)) return false;
	if(IsFakeClient(client)) return false;
	return IsClientInGame(client);
}

int GetIntCookie(int client, Handle handle)
{
	char sCookieValue[11];
	GetClientCookie(client, handle, sCookieValue, sizeof(sCookieValue));
	return StringToInt(sCookieValue);
}