/*
	SH HL2RP Shit
*/

Clockwork:IncludePrefixed("sh_voices.lua");
Clockwork.option:SetKey("name_cash", "Credits");
Clockwork.option:SetKey("format_cash", "%a %n");

Clockwork.animation:AddCivilProtectionModel("models/eliteghostcp.mdl");
Clockwork.animation:AddCivilProtectionModel("models/eliteshockcp.mdl");
Clockwork.animation:AddCivilProtectionModel("models/leet_police2.mdl");
Clockwork.animation:AddCivilProtectionModel("models/sect_police2.mdl");
Clockwork.animation:AddCivilProtectionModel("models/policetrench.mdl");


Clockwork.quiz:SetEnabled(true);
Clockwork.quiz:AddQuestion("Do you understand that roleplaying is slow paced and relaxed?", 1, "Yes.", "No.");
Clockwork.quiz:AddQuestion("Can you type properly, using capital letters and full-stops?", 2, "yes i can", "Yes, I can.");
Clockwork.quiz:AddQuestion("You do not need weapons to roleplay, do you understand?", 1, "Yes.", "No.");
Clockwork.quiz:AddQuestion("You do not need items to roleplay, do you understand?", 1, "Yes.", "No.");
Clockwork.quiz:AddQuestion("What is serious roleplay about?", 2, "Collecting items and upgrades.", "Developing your character.");
Clockwork.quiz:AddQuestion("What universe does this roleplay take place in?", 2, "Real Life.", "Half-Life 2.");

Clockwork.flag:Add("v", "Light Blackmarket", "Access to light blackmarket goods.");
Clockwork.flag:Add("V", "Heavy Blackmarket", "Access to heavy blackmarket goods.");
Clockwork.flag:Add("L", "Resistance Leader Flags", "Access to resistance leader goods.");


-- A function to add a custom permit.
function Clockwork.schema:AddCustomPermit(name, flag, model)
	local formattedName = string.gsub(name, "[%s%p]", "");
	local lowerName = string.lower(name);
	
	self.customPermits[ string.lower(formattedName) ] = {
		model = model,
		name = name,
		flag = flag,
		key = Clockwork:SetCamelCase(formattedName, true)
	};
end;

-- A function to check if a string is a Combine rank.
function Clockwork.schema:IsStringCombineRank(text, rank)
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
function Clockwork.schema:IsPlayerCombineRank(player, rank, realRank)
	local name = player:Name();
	
	if (type(rank) == "table") then
		for k, v in ipairs(rank) do
			if ( self:IsPlayerCombineRank(player, v, realRank) ) then
				return true;
			end;
		end;
	elseif (rank == "UNIT") then
		for i = 1, 4 do
			if (string.find(name, "%p-0"..i.."%p")) then
				return true;
			end;
		end;
	else
		return string.find(name, "%p"..rank.."%p");
	end;
end;

-- A function to get a player's Combine rank.
function Clockwork.schema:GetPlayerCombineRank(player)
	local faction;
	
	if (SERVER) then
		faction = player:QueryCharacter("faction");
	else
		faction = player:GetFaction();
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
		return 7;
	elseif ( self:IsPlayerCombineRank(player, "EpU", true) ) then
		return 6;
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
function Clockwork.schema:IsCombineFaction(faction)
	return (faction == FACTION_MPF or faction == FACTION_OTA);
end;