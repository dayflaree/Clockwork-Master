--Server/Client variables

for k, v in pairs( TS.PlayerStats ) do

	CreatePlayerVariable( v, "Short", 10 );
	
end

CreatePlayerVariable( "Age", "Short", 0 );
CreatePlayerVariable( "Sprint", "Short", 100 );
CreatePlayerVariable( "Holstered", "Bool", true );
CreatePlayerVariable( "Consciousness", "Short", 100 );
CreatePlayerVariable( "DrunkMul", "Float", 0 );
CreatePlayerVariable( "Title", "String", "" );
CreatePlayerVariable( "Title2", "String", "" );
CreatePlayerVariable( "Bleeding", "Bool", false );
CreatePlayerVariable( "FreezeHead", "Bool", false );
CreatePlayerVariable( "CanSprint", "Bool", true );
CreatePlayerVariable( "Conscious", "Bool", true );
CreatePlayerVariable( "Cloaked", "Bool", false );

--Serverside variables
if( SERVER ) then

	TS.ServerVariables = { }

	TS.ServerVariables["Initialized"] = false;
	TS.ServerVariables["HasSeenMOTD"] = false;
	TS.ServerVariables["SpawnMenuLoaded"] = false;

	TS.ServerVariables["ProcessBars"] = { }
	TS.ServerVariables["AttachedProps"] = { }
	TS.ServerVariables["SendItemNames"] = { }
	TS.ServerVariables["ItemsDownloaded"] = { }

	TS.ServerVariables["AnimLastModel"] = "";
	TS.ServerVariables["LastWeapon"] = "";

	TS.ServerVariables["NextTimeCanChat"] = 0;
	TS.ServerVariables["NextTimeCanChatOOC"] = 0;
	TS.ServerVariables["LastKeyPress"] = 0;
	TS.ServerVariables["LastCharSelection"] = 0;
	TS.ServerVariables["LastCharCreation"] = 0;
	TS.ServerVariables["LastFlashSwitch"] = 0;
	TS.ServerVariables["LastStanceAction"] = 0;
	TS.ServerVariables["LastMOTDPrompt"] = 0;
	TS.ServerVariables["LastStorageItemAdd"] = 0;
	TS.ServerVariables["LastTargetIDUpdate"] = 0;
	TS.ServerVariables["LastItemUse"] = 0;
	TS.ServerVariables["LastF4"] = 0;
	TS.ServerVariables["LastHelp"] = 0;
	TS.ServerVariables["LastHolster"] = 0;
	TS.ServerVariables["LastConsciousRecover"] = 0;
	TS.ServerVariables["LastAimProgress"] = 0;
	TS.ServerVariables["LastStrengthProgress"] = 0;
	TS.ServerVariables["LastEnduranceProgress"] = 0;
	TS.ServerVariables["LastSpeedProgress"] = 0;
	TS.ServerVariables["LastDrag"] = 0;
	TS.ServerVariables["LastRegister"] = 0;
	TS.ServerVariables["LastCharMenu"] = 0;
	TS.ServerVariables["LastQuizCheck"] = 0;
	
end