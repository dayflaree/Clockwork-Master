--[[
	Free Clockwork!
--]]

Clockwork.schema.name = "Half-Life 2 Roleplay";
Clockwork.schema.author = "Spencer Sharkey";
Clockwork.schema.version = 2.0;
Clockwork.schema.description = "Roleplay based on the famous Half-Life 2 game by Valve.";
Clockwork.schema.containers = {
	["models/props_wasteland/controlroom_storagecloset001a.mdl"] = {8, "Closet"},
	["models/props_wasteland/controlroom_storagecloset001b.mdl"] = {15, "Closet"},
	["models/props_wasteland/controlroom_filecabinet001a.mdl"] = {4, "File Cabinet"},
	["models/props_wasteland/controlroom_filecabinet002a.mdl"] = {8, "File Cabinet"},
	["models/props_c17/suitcase_passenger_physics.mdl"] = {5, "Suitcase"},
	["models/props_junk/wood_crate001a_damagedmax.mdl"] = {8, "Wooden Crate"},
	["models/props_junk/wood_crate001a_damaged.mdl"] = {8, "Wooden Crate"},
	["models/props_interiors/furniture_desk01a.mdl"] = {4, "Desk"},
	["models/props_c17/furnituredresser001a.mdl"] = {10, "Dresser"},
	["models/props_c17/furnituredrawer001a.mdl"] = {8, "Drawer"},
	["models/props_c17/furnituredrawer002a.mdl"] = {4, "Drawer"},
	["models/props_c17/furniturefridge001a.mdl"] = {8, "Fridge"},
	["models/props_c17/furnituredrawer003a.mdl"] = {8, "Drawer"},
	["models/weapons/w_suitcase_passenger.mdl"] = {5, "Suitcase"},
	["models/props_junk/trashdumpster01a.mdl"] = {15, "Dumpster"},
	["models/props_junk/wood_crate001a.mdl"] = {8, "Wooden Crate"},
	["models/props_junk/wood_crate002a.mdl"] = {10, "Wooden Crate"},
	["models/items/ammocrate_rockets.mdl"] = {15, "Ammo Crate"},
	["models/props_lab/filecabinet02.mdl"] = {8, "File Cabinet"},
	["models/items/ammocrate_grenade.mdl"] = {15, "Ammo Crate"},
	["models/props_junk/trashbin01a.mdl"] = {10, "Trash Bin"},
	["models/props_c17/suitcase001a.mdl"] = {8, "Suitcase"},
	["models/items/item_item_crate.mdl"] = {4, "Item Crate"},
	["models/props_c17/oildrum001.mdl"] = {8, "Oildrum"},
	["models/items/ammocrate_smg1.mdl"] = {15, "Ammo Crate"},
	["models/items/ammocrate_ar2.mdl"] = {15, "Ammo Crate"}
};

-- local modelGroups = {"01"};

-- for _, group in pairs(modelGroups) do
	-- for k, v in pairs(_file.Find("../models/humans/group"..group.."/*.mdl")) do
		-- if (string.find(string.lower(v), "female")) then
			-- Clockwork.animation:AddFemaleHumanModel("models/humans/group"..group.."/"..v);
		-- else
			-- Clockwork.animation:AddMaleHumanModel("models/humans/group"..group.."/"..v);
		-- end;
	-- end;
-- end;


Clockwork.option:SetKey("default_date", {month = 1, year = 2005, day = 1});
Clockwork.option:SetKey("default_time", {minute = 0, hour = 0, day = 1});
Clockwork.option:SetKey("format_singular_cash", "%a");
Clockwork.option:SetKey("model_shipment", "models/items/item_item_crate.mdl");
Clockwork.option:SetKey("intro_image", "halfliferp/halfliferp");
Clockwork.option:SetKey("schema_logo", "halfliferp/logo");
Clockwork.option:SetKey("format_cash", "%a %n");
Clockwork.option:SetKey("menu_music", "music/HL2_song23_SuitSong3.mp3");
Clockwork.option:SetKey("model_cash", "models/props_lab/box01a.mdl");
Clockwork.option:SetKey("gradient", "halfliferp/bg_gradient");

Clockwork.config:ShareKey("intro_text_small");
Clockwork.config:ShareKey("intro_text_big");



-- Includes

Clockwork:IncludePrefixed("kernel/sh_auto.lua");
Clockwork:IncludePrefixed("kernel/sv_auto.lua");
Clockwork:IncludePrefixed("kernel/cl_auto.lua");

Clockwork:IncludePrefixed("kernel/sh_hooks.lua");
Clockwork:IncludePrefixed("kernel/sv_hooks.lua");
Clockwork:IncludePrefixed("kernel/cl_hooks.lua");
Clockwork:IncludePrefixed("kernel/cl_theme.lua");
Clockwork:IncludePrefixed("kernel/sh_coms.lua");

