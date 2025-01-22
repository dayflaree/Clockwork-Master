
local Clockwork = Clockwork;
local PLUGIN = PLUGIN;

local string = string;
local type = type;
local setmetatable = setmetatable;

PLUGIN.types = {
	["commendation"] = "l",
	["note"] = "n",
	["civilStatus"] = "c",
	["loyalistTier"] = "t",
	["violation"] = "v",
	["socEndStatus"] = "s"
};

Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");

PLUGIN.defaultCivilStatus = {["none"] = true, ["unit"] = true, ["citizen"] = true};
PLUGIN.defaultSocEndStatus = {["none"] = true};

function PLUGIN:CanPlayerAddEntry(player, targetKey, entryType)
	local key;
	if (CLIENT) then
		key = Clockwork.player:GetCharacterKey(player);
	else
		key = player:GetCharacter().key;
	end;
	if (key == targetKey) then
		return false;
	end;

	local factionTable = Clockwork.faction:FindByID(player:GetFaction());
	if (factionTable.recordView and factionTable.recordView >= 1) then
		return true;
	elseif (entryType == self.types.note or entryType == self.types.commendation) then
		if ((factionTable.loaylistRecordView and factionTable.loaylistRecordView >= 1) or Clockwork.player:HasAnyFlags(player, "lL")) then
			return true;
		end;
	end;

	if (factionTable.canAddRecord and factionTable.canAddRecord[entryType]) then
		return true;
	end;
end;

function PLUGIN:CanPlayerHideEntry(player, record)
	local key;
	if (CLIENT) then
		key = Clockwork.player:GetCharacterKey(player);
	else
		key = player:GetCharacter().key;
	end;

	if (record.createdByKey == key) then
		return true;
	end;

	local factionTable = Clockwork.faction:FindByID(player:GetFaction());
	if (factionTable.recordView and factionTable.recordView >= 2) then
		return true;
	elseif (record.type == self.types.note or record.type == self.types.commendation or record.type == self.types.loyalistTier) then
		if ((factionTable.loaylistRecordView and factionTable.loaylistRecordView >= 2) or Clockwork.player:HasFlags(player, "L")) then
			return true;
		end;
	end;

	if (factionTable.canHideRecord and factionTable.canHideRecord[record.type]) then
		return true;
	end;
end;

function PLUGIN:CanPlayerChangeCivilStatus(player, targetKey, targetFaction, oldStatus, newStatus)
	local factionTable = Clockwork.faction:FindByID(player:GetFaction());
	if (!factionTable.recordView and !factionTable.loaylistRecordView and !Clockwork.player:HasAnyFlags(player, "lL")) then
		return false;
	end;

	if (oldStatus and (string.find(oldStatus, "loyalist[789]"))) then
		if (player:GetFaction() == FACTION_MPF or (!Clockwork.player:HasFlags(player, "L") and factionTable.loyalistRecordview != 2)) then
			return false;
		end;
	end;

	if (newStatus and string.find(newStatus, "loyalist")) then
		if (player:GetFaction() == FACTION_MPF) then
			return false;
		end;
	end;

	if (newStatus and (!string.find(newStatus, "loyalist%d") and !PLUGIN.defaultCivilStatus[newStatus]) and !Schema:PlayerIsCombine(player)) then
		return false;
	end;

	if (oldStatus and (!string.find(oldStatus, "loyalist%d") and !PLUGIN.defaultCivilStatus[oldStatus]) and !Schema:PlayerIsCombine(player)) then
		return false;
	end;

	return true;
end;

function PLUGIN:GetStatus(list, selected, vp, lt)
	for i = #list, 1, -1 do
		if (list[i].uniqueID == selected or self:HasStatus(list[i], vp, lt)) then
			return list[i];
		end;
	end;

	return list[1];
end;

function PLUGIN:HasStatus(status, vp, lt)
	if (status.autoSet and (status.vp[1] <= vp and vp <= status.vp[2] and status.lt[1] <= lt and lt <= status.lt[2])) then
		return true;
	else
		return false;
	end;
end;

local maxVP = 12;
PLUGIN.loyalistTiers = {};
local loyalistTiers = {
	{name = "Zeta Tier", icon = "user_gray", maxVP = maxVP - 1},
	{name = "Epsilon Tier", icon = "user_orange", maxVP = maxVP - 1},
	{name = "Sigma Tier", icon = "sum", maxVP = maxVP - 1},
	{name = "Delta Tier", icon = "user_red", maxVP = maxVP - 1},
	{name = "Gamma Tier", icon = "user", maxVP = maxVP - 1},
	{name = "Beta Tier", icon = "user_green", maxVP = maxVP - 1},
	{name = "Alpha Tier", icon = "star"},
	{name = "Omega Tier", icon = "shield"}
};

function PLUGIN:ClockworkInitialized() 
	self.endangermentStatusList = {};
	self.endangermentStatusList.default = self:NewStatusList("Default");
	self:SetStatus(self.endangermentStatusList.default, "none", "None", nil, 0);
	self:SetStatus(self.endangermentStatusList.default, "person_interest_malignant", "Person Of Interest", "error_delete", 1, 9);
	self:SetStatus(self.endangermentStatusList.default, "person_interest_loyalist1", "Person Of Interest", "error_add", 1, nil, nil, 7);
	self:SetStatus(self.endangermentStatusList.default, "person_interest_loyalist2", "Person Of Interest", "error", 1, 6, nil, 1);
	self:SetStatus(self.endangermentStatusList.default, "bol", "Be On Lookout", "magnifier", 1);
	self:SetStatus(self.endangermentStatusList.default, "malignant", "Malignant", "delete", 2, 12);
	self:SetStatus(self.endangermentStatusList.default, "anti_citizen", "Anti-Citizen", "exclamation", 3, 24);

	self.endangermentStatusList[1] = self:NewStatusList("Combine", {FACTION_MPF, FACTION_OTA});
	self:SetStatus(self.endangermentStatusList[1], "none", "None");

	self.civilStatusList = {};
	self.civilStatusList.default = self:NewStatusList("Default");
	self:SetStatus(self.civilStatusList.default, "citizen", "Citizen", "status_online", 0);
	for k, v in ipairs(loyalistTiers) do
		v.tier = k * 2;
		if (!PLUGIN.safeTier and !v.maxVP) then
			PLUGIN.safeTier = v.tier;
		end;
		self.loyalistTiers["loyalist"..v.tier] = v;
		self:SetStatus(self.civilStatusList.default, "loyalist"..v.tier, v.name, v.icon, 1, nil, v.maxVP, v.tier, v.tier); 
		
		local approvedTier = {name = v.name.." (A)", icon = v.icon, maxVP = v.maxVP, tier = v.tier + 1};
		self.loyalistTiers["loyalist"..(v.tier + 1).."a"] = approvedTier;
		self:SetStatus(self.civilStatusList.default, "loyalist"..(v.tier + 1).."a", v.name.." (A)", v.icon, 2, nil, v.maxVP, v.tier + 1, v.tier + 1);
	end;
	self:SetStatus(self.civilStatusList.default, "missing", "Missing", "status_away", 3);
	self:SetStatus(self.civilStatusList.default, "dissociative", "Dissociative", "status_busy", 4);
	self:SetStatus(self.civilStatusList.default, "revoked", "Citizenship Revoked", "status_offline", 4, 12, nil, nil, PLUGIN.safeTier);
	self:SetStatus(self.civilStatusList.default, "deceased", "Deceased", "cross", 5);
	self:SetStatus(self.civilStatusList.default, "amputated", "Amputated", "cancel", 6);
		
	self.civilStatusList[1] = self:NewStatusList("Combine", {FACTION_MPF, FACTION_OTA});
	self:SetStatus(self.civilStatusList[1], "unit", "Unit");

	Clockwork.kernel:SaveSchemaData("plugins/datafile/civilStatusList", self.civilStatusList);
end;

-- Creates a basic status list.
function PLUGIN:NewStatusList(listName, factions, default)
	if (!listName or type(listName) != "string" or listName == "") then
		ErrorNoHalt("[Records] Error creating status list: no listName provided\n");
		return;
	end;

	local list = {list = {}, factions = {}, name = listName};
	if (factions and type(factions) == "table") then
		for k, faction in pairs(factions) do
			list.factions[faction] = true;
		end;
	end;

	return list;
end;

local listElement = {
	__lt = function(a, b) return a.level < b.level end,
	__le = function(a, b) return a.level <= b.level end,
	__eq = function(a, b) return a.level == b.level end
};

-- Adds/Sets a status on the given status list. Will ensure all values are correct.
function PLUGIN:SetStatus(statusList, uniqueID, name, icon, level, minVP, maxVP, minLT, maxLT)
	if (!statusList or type(statusList) != "table" or !statusList.list or type(statusList.list) != "table") then
		debug.Trace();
		ErrorNoHalt("[Records] Invalid statusList provided.\n");
		return false;
	end;

	if (!uniqueID or type(uniqueID) != "string" or uniqueID == "") then
		ErrorNoHalt("[Records] Invalid uniqueID provided.\n");
		return false;
	end;

	uniqueID = string.lower(uniqueID);

	if (!name or type(name) != "string" or name == "") then
		name = uniqueID;
	end;

	if (!level or type(level) != "number") then
		level = 0;
	end;

	local autoSet = true;
	if (minVP or maxVP or minLT or maxLT) then
		if (!minVP or type(minVP) != "number" or minVP < 0) then
			minVP = 0;
		end;

		if (!maxVP or type(maxVP) != "number") then
			maxVP = math.huge;
		elseif (maxVP < minVP) then
			maxVP = minVP;
		end;

		if (!minLT or type(minLT) != "number" or minLT < 0) then
			minLT = 0;
		end;

		if (!maxLT or type(maxLT) != "number") then
			maxLT = math.huge;
		elseif (maxLT < minLT) then
			maxLT = minVP;
		end;
	else
		autoSet = false;
	end;

	if (!icon or type(icon) != "string") then
		icon = "user";
	end;

	statusList.list[#statusList.list + 1] = {uniqueID = uniqueID, autoSet = autoSet, name = name, level = level, icon = icon, vp = {minVP, maxVP}, lt = {minLT, maxLT}};
	setmetatable(statusList.list[#statusList.list], listElement);
end;

-- REturns the proper socio-endangerment status list for the faction
function PLUGIN:GetSocEndStatusList(faction)
	return self:GetStatusList(self.endangermentStatusList, faction);
end;

-- Returns the proper civil status list for the faction
function PLUGIN:GetCivilStatusList(faction)
	return self:GetStatusList(self.civilStatusList, faction);
end;

-- Returns the proper status list for the faction
function PLUGIN:GetStatusList(list, faction)
	for k, v in pairs(list) do
		if (k == "default") then
			continue;
		end;

		if (v.factions[faction]) then
			return v;
		end;
	end;

	return list.default;
end;