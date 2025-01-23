--[[ 
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

Clockwork.Name = "Clockwork";
Clockwork.Email = "kurozael@gmail.com";
Clockwork.Author = "kurozael";
Clockwork.Website = "http://kurozael.com";
Clockwork.KernelVersion = 1.0;
Clockwork.SchemaFolder = Clockwork.Folder;
Clockwork.ClockworkFolder = GM.Folder;

AddCSLuaFile("kernel/sh_kernel.lua");
AddCSLuaFile("kernel/sh_enum.lua");
include("kernel/sh_enum.lua");
include("kernel/sh_kernel.lua");

if (!GetWorldEntity) then
	GetWorldEntity = function()
		return Entity(0);
	end;
end

_player, _team, _file = player, team, file;

if (CW_SCRIPT_SHARED) then
	CW_SCRIPT_SHARED = glon.decode(CW_SCRIPT_SHARED);
else
	CW_SCRIPT_SHARED = {};
end;

Clockwork:IncludeDirectory("kernel/libraries/", true);
Clockwork:IncludeDirectory("kernel/directory/", true);
Clockwork:IncludeDirectory("kernel/config/", true);
	
--[[
	This silly hack is because for some reason the entities
	from Sandbox don't even load on Linux!
--]]

GAMEMODE = Clockwork;
	Clockwork.plugin:IncludeEntities("sandbox");
	Clockwork.plugin:IncludeWeapons("sandbox");
	Clockwork.plugin:IncludeEffects("sandbox");
GAMEMODE = nil;

--[[
	Include the core gamemode entities this way so that
	Garry's stupid system doesn't make them lowercase!
--]]

Clockwork.plugin:IncludeEntities("Clockwork/gamemode");
Clockwork.plugin:IncludeWeapons("Clockwork/gamemode");
Clockwork.plugin:IncludeEffects("Clockwork/gamemode");

Clockwork:DeriveFromSandbox();
	Clockwork:IncludePlugins("plugins/", true);
	Clockwork:IncludeDirectory("kernel/system/", true);
	Clockwork:IncludeDirectory("kernel/items/", true);
	Clockwork:IncludeDirectory("kernel/derma/", true);
Clockwork:IncludeSchema();

if (CLIENT) then
	Clockwork.SpawnIconMaterial = Material("vgui/spawnmenu/hover");
	Clockwork.DefaultGradient = surface.GetTextureID("gui/gradient_down");
	Clockwork.GradientTexture = surface.GetTextureID(Clockwork.option:GetKey("gradient"));
	Clockwork.ClockworkSplash = Material("Clockwork/Clockwork");
	Clockwork.GradientCenter = surface.GetTextureID("gui/center_gradient");
	Clockwork.GradientRight = surface.GetTextureID("gui/gradient");
	Clockwork.GradientUp = surface.GetTextureID("gui/gradient_up");
	Clockwork.ScreenBlur = Material("pp/blurscreen");
	Clockwork.Gradients = {
		[GRADIENT_CENTER] = Clockwork.GradientCenter;
		[GRADIENT_RIGHT] = Clockwork.GradientRight;
		[GRADIENT_DOWN] = Clockwork.DefaultGradient;
		[GRADIENT_UP] = Clockwork.GradientUp;
	};
end;

if (CLIENT and Clockwork.chatBox) then
	Clockwork.chatBox:CreateDermaAll();
end;

-- Called when the Clockwork shared variables are added.
function Clockwork:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:Number("InvWeight", true);
	playerVars:Number("MaxHP", true);
	playerVars:Number("MaxAP", true);
	playerVars:Number("IsDrunk", true);
	playerVars:Number("Wages", true);
	playerVars:Number("Cash", true);
	playerVars:Number("ActDuration");
	playerVars:Number("ForceAnim");
	playerVars:Number("IsRagdoll");
	playerVars:Number("Faction");
	playerVars:Number("Gender");
	playerVars:Number("Key");
	
	playerVars:Bool("TargetKnows", true);
	playerVars:Bool("FallenOver", true);
	playerVars:Bool("CharBanned", true);
	playerVars:Bool("IsWepRaised");
	playerVars:Bool("Initialized");
	playerVars:Bool("IsJogMode");
	playerVars:Bool("IsRunMode");
	
	playerVars:String("PhysDesc");
	playerVars:String("Clothes", true);
	playerVars:String("Model", true);
	playerVars:String("ActName");
	playerVars:String("Flags");
	playerVars:String("Name");
	
	playerVars:Entity("Ragdoll");
	playerVars:Float("StartActTime");
	
	globalVars:String("Date");
	globalVars:Bool("NoMySQL");
	
	globalVars:Number("Minute");
	globalVars:Number("Hour");
	globalVars:Number("Day");
end;