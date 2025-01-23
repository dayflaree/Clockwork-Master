--[[
Name: "sh_auto.lua".
Product: "Nexus".
--]]

if (!NEXUS) then
	NEXUS = GM;
end;

nexus = {};
NEXUS.Name = "Nexus";
NEXUS.Email = "kurozael@gmail.com";
NEXUS.Author = "kurozael";
NEXUS.Website = "http://kurozael.com";
NEXUS.NexusFolder = GM.Folder;
NEXUS.SchemaFolder = NEXUS.Folder;

include("sh_core.lua");
include("sh_enums.lua");

hook.Remove("Think", "CheckSchedules");

if (!GetWorldEntity) then
	GetWorldEntity = function()
		return Entity(0);
	end;
end

g_Player, g_Team, g_File = player, team, file;

NEXUS:DeriveFromSandbox();
NEXUS:IncludeDirectory("nexus/gamemode/core/libraries/");
NEXUS:IncludeDirectory("nexus/gamemode/core/directory/");
NEXUS:IncludeDirectory("nexus/gamemode/core/overwatch/");
NEXUS:IncludeDirectory("nexus/gamemode/core/config/");

if (SERVER) then
	nexus.mount.unloaded = NEXUS:RestoreSchemaData("mounts");
	
	resource.AddFile("data/nexus/schemas/"..NEXUS:GetSchemaFolder().."/mounts.txt");
else
	local fileName = "nexus/schemas/"..NEXUS:GetSchemaFolder().."/mounts.txt";
	local fileData = file.Read(fileName);
	
	if (fileData and fileData != "") then
		nexus.mount.unloaded = glon.decode(fileData);
	else
		nexus.mount.unloaded = {};
	end;
	
	if ( file.Exists(fileName) ) then
		file.Delete(fileName);
	end;
end;

NEXUS:RegisterGlobalSharedVar("sh_NoMySQL", NWTYPE_BOOL);
NEXUS:RegisterGlobalSharedVar("sh_Minute", NWTYPE_NUMBER);
NEXUS:RegisterGlobalSharedVar("sh_Date", NWTYPE_STRING);
NEXUS:RegisterGlobalSharedVar("sh_Hour", NWTYPE_NUMBER);
NEXUS:RegisterGlobalSharedVar("sh_Day", NWTYPE_NUMBER);

nexus.player.RegisterSharedVar("sh_TargetRecognises", NWTYPE_BOOL, true);
nexus.player.RegisterSharedVar("sh_StartActionTime", NWTYPE_FLOAT);
nexus.player.RegisterSharedVar("sh_InventoryWeight", NWTYPE_NUMBER, true);
nexus.player.RegisterSharedVar("sh_ActionDuration", NWTYPE_NUMBER);
nexus.player.RegisterSharedVar("sh_WeaponRaised", NWTYPE_BOOL);
nexus.player.RegisterSharedVar("sh_Initialized", NWTYPE_BOOL);
nexus.player.RegisterSharedVar("sh_ForcedAnim", NWTYPE_NUMBER);
nexus.player.RegisterSharedVar("sh_FallenOver", NWTYPE_BOOL, true);
nexus.player.RegisterSharedVar("sh_Ragdolled", NWTYPE_NUMBER);
nexus.player.RegisterSharedVar("sh_MaxHealth", NWTYPE_NUMBER, true);
nexus.player.RegisterSharedVar("sh_MaxArmor", NWTYPE_NUMBER, true);
nexus.player.RegisterSharedVar("sh_PhysDesc", NWTYPE_STRING);
nexus.player.RegisterSharedVar("sh_Ragdoll", NWTYPE_ENTITY);
nexus.player.RegisterSharedVar("sh_Jogging", NWTYPE_BOOL);
nexus.player.RegisterSharedVar("sh_Faction", NWTYPE_NUMBER);
nexus.player.RegisterSharedVar("sh_Action", NWTYPE_STRING);
nexus.player.RegisterSharedVar("sh_Gender", NWTYPE_NUMBER);
nexus.player.RegisterSharedVar("sh_Banned", NWTYPE_BOOL, true);
nexus.player.RegisterSharedVar("sh_Flags", NWTYPE_STRING);
nexus.player.RegisterSharedVar("sh_Drunk", NWTYPE_NUMBER, true);
nexus.player.RegisterSharedVar("sh_Model", NWTYPE_STRING, true);
nexus.player.RegisterSharedVar("sh_Wages", NWTYPE_NUMBER, true);
nexus.player.RegisterSharedVar("sh_Cash", NWTYPE_NUMBER, true);
nexus.player.RegisterSharedVar("sh_Name", NWTYPE_STRING);
nexus.player.RegisterSharedVar("sh_Key", NWTYPE_NUMBER);
NEXUS:IncludeSchema();

if (SCHEMA) then
	if ( NEXUS:IncludeMounts("nexus/gamemode/mounts/") ) then
		NEXUS:IncludeDirectory("nexus/gamemode/core/attributes/");
		NEXUS:IncludeDirectory("nexus/gamemode/core/items/");
		NEXUS:IncludeDirectory("nexus/gamemode/core/derma/");
	end;
	
	if (CLIENT and NEXUS) then
		NEXUS.SpawnIconMaterial = Material("vgui/spawnmenu/hover");
		NEXUS.GradientTexture = surface.GetTextureID( nexus.schema.GetOption("gradient") );
		NEXUS.NexusSplash = Material("nexus/nexus31");
		NEXUS.ScreenBlur = Material("pp/blurscreen");
	end;
	
	if (nexus.item) then
		local itemTable = nexus.item.GetAll();
		
		for k, v in pairs(itemTable) do
			if ( v.base and !nexus.item.Merge(v, v.base) ) then
				itemTable[k] = nil;
			end;
		end;

		for k, v in pairs(itemTable) do
			v.description = v.description or "An item with no description.";
			v.category = v.category or "Other";
			v.weight = v.weight or 1;
			v.batch = v.batch or 5;
			v.model = v.model or "models/error.mdl";
			v.skin = v.skin or 0;
			v.cost = v.cost or 0;
			
			if (v.OnSetup) then
				v:OnSetup();
			end;
		end;
	end;
	
	if (CLIENT and nexus.chatBox) then
		nexus.chatBox.CreateDermaAll();
	end;

	if (nexus.command) then
		NEXUS:IncludePrefixed("sh_coms.lua");
	end;
else
	Error("Nexus -> The schema could not be found!");
end;