#include <sourcescramble>

#pragma newdecls required
#pragma semicolon 1

ConVar sm_patch_disableThrillerTaunt;
MemoryPatch g_Patch;


public Plugin myinfo =
{
	name = "[TF2] Disable Thriller Taunt",
	author = "kingo",
	description = "",
	version = "0.0.1",
	url = "https://github.com/kingofings/disableThrillerTaunt"
};

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
    if (GetEngineVersion() != Engine_TF2)SetFailState("This plugin was made for use with Team Fortress 2 only.");
    return APLRes_Success;
}

public void OnPluginStart()
{
	sm_patch_disableThrillerTaunt = CreateConVar("sm_patch_disableThrillerTaunt", "1", "Disable the thriller taunt", FCVAR_NOTIFY);
	sm_patch_disableThrillerTaunt.AddChangeHook(OnConVarChange);

	GameData gameConf = new GameData("tf2.ThrillerTaunt");
	if (!gameConf)SetFailState("Failed to load game data for tf2.ThrillerTaunt");

	g_Patch = MemoryPatch.CreateFromConf(gameConf, "CTFPlayer::ModifyOrAppendCriteria()::DisableThrillerTaunt");
	if (!g_Patch)SetFailState("Failed to create static Patch CTFPlayer::ModifyOrAppendCriteria()::DisableThrillerTaunt");

	delete gameConf;

	OnConVarChange(sm_patch_disableThrillerTaunt, "", "");
}

void OnConVarChange(ConVar convar, const char[] before, const char[] after)
{
	if (!convar.BoolValue && !StrEqual(before, ""))
	{
		g_Patch.Disable();
		LogMessage("Disabled static Patch CTFPlayer::ModifyOrAppendCriteria()::DisableThrillerTaunt");
		return;
	}

	if (!convar.BoolValue)return;
	
	if (!g_Patch.Validate())SetFailState("Failed to validate static  patch CTFPlayer::ModifyOrAppendCriteria()::DisableThrillerTaunt");
	if (g_Patch.Enable())
	{
		LogMessage("Enabled static Patch CTFPlayer::ModifyOrAppendCriteria()::DisableThrillerTaunt");
		return;
	}

	SetFailState("Failed to enable static Patch CTFPlayer::ModifyOrAppendCriteria()::DisableThrillerTaunt");
}