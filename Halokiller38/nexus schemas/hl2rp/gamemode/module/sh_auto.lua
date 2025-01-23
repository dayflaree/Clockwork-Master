--[[
Name: "sh_auto.lua".
Product: "Half-Life 2".
--]]

MODULE.customPermits = {};

for k, v in pairs( g_File.Find("../models/humans/group17/*.mdl") ) do
	resistance.animation.AddMaleHumanModel("models/humans/group17/"..v);
end;

resistance.animation.AddCivilProtectionModel("models/eliteghostcp.mdl");
resistance.animation.AddCivilProtectionModel("models/eliteshockcp.mdl");
resistance.animation.AddCivilProtectionModel("models/leet_police2.mdl");
resistance.animation.AddCivilProtectionModel("models/sect_police2.mdl");
resistance.animation.AddCivilProtectionModel("models/policetrench.mdl");

resistance.module.SetOption( "default_date", {month = 1, year = 2016, day = 1} );
resistance.module.SetOption( "default_time", {minute = 0, hour = 0, day = 1} );
resistance.module.SetOption("name_cash", "Tokens");
resistance.module.SetOption("model_cash", "models/props_lab/box01a.mdl");
resistance.module.SetOption("format_cash", "%a %n");
resistance.module.SetOption("intro_image", "citadel/logo");
resistance.module.SetOption("model_shipment", "models/items/item_item_crate.mdl");
resistance.module.SetOption("format_singular_cash", "%a");

resistance.module.SetFont("bar_text", "hl2_TargetIDText");
resistance.module.SetFont("main_text", "hl2_MainText");
resistance.module.SetFont("hints_text", "hl2_IntroTextTiny");
resistance.module.SetFont("large_3d_2d", "hl2_Large3D2D");
resistance.module.SetFont("chat_box_text", "hl2_ChatBoxText");
resistance.module.SetFont("menu_text_big", "hl2_MenuTextBig");
resistance.module.SetFont("target_id_text", "hl2_TargetIDText");
resistance.module.SetFont("cinematic_text", "hl2_CinematicText");
resistance.module.SetFont("date_time_text", "hl2_IntroTextSmall");
resistance.module.SetFont("intro_text_big", "hl2_IntroTextBig");
resistance.module.SetFont("menu_text_tiny", "hl2_IntroTextTiny");
resistance.module.SetFont("menu_text_small", "hl2_IntroTextSmall");
resistance.module.SetFont("intro_text_tiny", "hl2_IntroTextTiny");
resistance.module.SetFont("intro_text_small", "hl2_IntroTextSmall");
resistance.module.SetFont("player_info_text", "hl2_ChatBoxText");

RESISTANCE:RegisterGlobalSharedVar("sh_PKMode", NWTYPE_NUMBER);

resistance.player.RegisterSharedVar("sh_Antidepressants", NWTYPE_NUMBER, true);
resistance.player.RegisterSharedVar("sh_CustomClass", NWTYPE_STRING);
resistance.player.RegisterSharedVar("sh_CitizenID", NWTYPE_STRING, true);
resistance.player.RegisterSharedVar("sh_Scanner", NWTYPE_ENTITY, true);
resistance.player.RegisterSharedVar("sh_Clothes", NWTYPE_NUMBER, true);
resistance.player.RegisterSharedVar("sh_Tied", NWTYPE_NUMBER);

RESISTANCE:IncludePrefixed("sh_coms.lua");
RESISTANCE:IncludePrefixed("sh_voices.lua");
RESISTANCE:IncludePrefixed("sv_hooks.lua");
RESISTANCE:IncludePrefixed("cl_hooks.lua");

resistance.quiz.SetEnabled(true);
resistance.quiz.AddQuestion("Do you understand that roleplaying is slow paced and relaxed?", 1, "Yes.", "No.");
resistance.quiz.AddQuestion("Can you type properly, using capital letters and full-stops?", 2, "yes i can", "Yes, I can.");
resistance.quiz.AddQuestion("You do not need weapons to roleplay, do you understand?", 1, "Yes.", "No.");
resistance.quiz.AddQuestion("You do not need items to roleplay, do you understand?", 1, "Yes.", "No.");
resistance.quiz.AddQuestion("What do you think serious roleplaying is about?", 2, "Collecting items and upgrades.", "Developing your character.");
resistance.quiz.AddQuestion("What universe is this roleplaying game set in?", 2, "Real Life.", "Half-Life 2.");

resistance.flag.Add("v", "Light Blackmarket", "Access to light blackmarket goods.");
resistance.flag.Add("V", "Heavy Blackmarket", "Access to heavy blackmarket goods.");
resistance.flag.Add("m", "Resistance Manager", "Access to the resistance manager's goods.");

-- A function to add a custom permit.
function MODULE:AddCustomPermit(name, flag, model)
	local formattedName = string.gsub(name, "[%s%p]", "");
	local lowerName = string.lower(name);
	
	self.customPermits[ string.lower(formattedName) ] = {
		model = model,
		name = name,
		flag = flag,
		key = RESISTANCE:SetCamelCase(formattedName, true)
	};
end;

-- A function to check if a string is a Combine rank.
function MODULE:IsStringCombineRank(text, rank)
	if (type(rank) == "table") then
		for k, v in ipairs(rank) do
			if ( self:IsStringCombineRank(text, v) ) then
				return true;
			end;
		end;
	elseif (rank == "EpU") then
		if ( string.find(text, "%pSeC%p") or string.find(text, "%pDvL%p")
		or string.find(text, "%pEpU%p") ) then
			return true;
		end;
	else
		return string.find(text, "%p"..rank.."%p");
	end;
end;

-- A function to check if a player is a Combine rank.
function MODULE:IsPlayerCombineRank(player, rank, realRank)
	local name = player:Name();
	
	if (type(rank) == "table") then
		for k, v in ipairs(rank) do
			if ( self:IsPlayerCombineRank(player, v, realRank) ) then
				return true;
			end;
		end;
	elseif (rank == "EpU" and !realRank) then
		if ( string.find(name, "%pSeC%p") or string.find(name, "%pDvL%p")
		or string.find(name, "%pEpU%p") ) then
			return true;
		end;
	else
		return string.find(name, "%p"..rank.."%p");
	end;
end;

-- A function to get a player's Combine rank.
function MODULE:GetPlayerCombineRank(player)
	local faction;
	
	if (SERVER) then
		faction = player:QueryCharacter("faction");
	else
		faction = resistance.player.GetFaction(player);
	end;
	
	if (faction == FACTION_OTA) then
		if ( self:IsPlayerCombineRank(player, "OWS") ) then
			return 0;
		elseif ( self:IsPlayerCombineRank(player, "EOW") ) then
			return 1;
		else
			return 2;
		end;
	elseif ( self:IsPlayerCombineRank(player, "RCT") ) then
		return 0;
	elseif ( self:IsPlayerCombineRank(player, "04") ) then
		return 1;
	elseif ( self:IsPlayerCombineRank(player, "03") ) then
		return 2;
	elseif ( self:IsPlayerCombineRank(player, "02") ) then
		return 3;
	elseif ( self:IsPlayerCombineRank(player, "01") ) then
		return 4;
	elseif ( self:IsPlayerCombineRank(player, "OfC") ) then
		return 6;
	elseif ( self:IsPlayerCombineRank(player, "EpU", true) ) then
		return 7;
	elseif ( self:IsPlayerCombineRank(player, "DvL") ) then
		return 8;
	elseif ( self:IsPlayerCombineRank(player, "SeC") ) then
		return 9;
	elseif ( self:IsPlayerCombineRank(player, "SCN") ) then
		if ( !self:IsPlayerCombineRank(player, "SYNTH") ) then
			return 10;
		else
			return 11;
		end;
	else
		return 5;
	end;
end;

-- A function to get if a faction is Combine.
function MODULE:IsCombineFaction(faction)
	return (faction == FACTION_MPF or faction == FACTION_OTA);
end;