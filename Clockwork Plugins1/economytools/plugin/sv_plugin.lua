
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

local pairs = pairs;
local table = table;
local math  = math;

Clockwork.datastream:Hook("EconomyInfo", function(player, data)
	if (Clockwork.player:IsAdmin(player)) then
		Clockwork.datastream:Start(player, "EconomyInfo", PLUGIN:EconomyInfo(data[1]));
	end;
end);

function PLUGIN:EconomyInfo(arguments, returnTable, players)
	if (not players) then
		players = _player.GetAll();
		for k, v in pairs(players) do
			if (v:GetFaction() == FACTION_SRVADMIN or v:GetFaction() == FACTION_EVENT or !v:HasInitialized()) then
				players[k] = nil;
			end;
		end;
	end;

	local infoType = arguments[1];
	returnTable = returnTable or {};

	if (infoType == "cash") then
		returnTable[#returnTable + 1] = "---- CASH ----";
		for k, v in ipairs(self:GetCashInfo(arguments[2], nil, players)) do
			returnTable[#returnTable + 1] = v;
		end;
	elseif (infoType == "items") then
		returnTable[#returnTable + 1] = "---- ITEMS ----";
		for k, v in ipairs(self:GetItemsInfo(arguments[2], nil, players)) do
			returnTable[#returnTable + 1] = v;
		end;
	else
		self:EconomyInfo({"cash"}, returnTable, players);
		self:EconomyInfo({"items"}, returnTable, players);
	end;

	return returnTable;
end;

function PLUGIN:GetCashInfo(mode, returnTable, players)
	local playersCopy = {};
	for k, v in pairs(players) do
		playersCopy[k] = v;
	end;
	players = playersCopy;

	returnTable = returnTable or {};

	if (mode == "all") then
		returnTable[#returnTable + 1] = self:CalculateCashInfo(players, 0, "all");
	elseif (mode == "reduced") then
		returnTable[#returnTable + 1] = self:CalculateCashInfo(players, 0.05, "reduced");
	elseif (mode == "factions") then
		for k, v in pairs(players) do
			if (v:GetFaction() == FACTION_CITIZEN) then
				players[k] = nil;
			end;
		end;

		returnTable[#returnTable + 1] = self:CalculateCashInfo(players, 0, "factions");
	elseif (mode == "nocp") then
		for k, v in pairs(players) do
			if (v:GetFaction() == FACTION_MPF) then
				players[k] = nil;
			end;
		end;

		returnTable[#returnTable + 1] = self:CalculateCashInfo(players, 0, "noft");
	elseif (mode == "nocp_reduced") then
		for k, v in pairs(players) do
			if (v:GetFaction() == FACTION_MPF) then
				players[k] = nil;
			end;
		end;

		returnTable[#returnTable + 1] = self:CalculateCashInfo(players, 0.05, "noft_reduced");
	elseif (mode == "citizens") then
		for k, v in pairs(players) do
			if (v:GetFaction() != FACTION_CITIZEN) then
				players[k] = nil;
			end;
		end;

		returnTable[#returnTable + 1] = self:CalculateCashInfo(players, 0, "citizens");
	elseif (mode == "citizens_reduced") then
		for k, v in pairs(players) do
			if (v:GetFaction() != FACTION_CITIZEN) then
				players[k] = nil;
			end;
		end;

		returnTable[#returnTable + 1] = self:CalculateCashInfo(players, 0.05, "citizens_reduced");
	elseif (mode == "list") then
		returnTable[#returnTable + 1] = self:ListCash(players);
	else
		self:GetCashInfo("all", returnTable, players);
		self:GetCashInfo("reduced", returnTable, players);
		self:GetCashInfo("factions", returnTable, players);
		self:GetCashInfo("nompf", returnTable, players);
		self:GetCashInfo("nompf_reduced", returnTable, players);
		self:GetCashInfo("citizens", returnTable, players);
		self:GetCashInfo("citizens_reduced", returnTable, players);
		returnTable[#returnTable + 1] = self:GetContainerCash();
	end;

	return returnTable;
end;

function PLUGIN:CalculateCashInfo(playerList, ignorePercentage, mode)
	local cashList = {};
	for k, v in pairs(playerList) do
		cashList[#cashList + 1] = v:GetCash() + v:GetCharacterData("CacheCash", 0);
	end;

	table.sort(cashList);

	local ignoreAmount = math.floor(#player.GetAll() * ignorePercentage);
	if (ignorePercentage > 0 and ignoreAmount == 0) then
		ignoreAmount = 1;
	end;
	local amount = #cashList;

	for i = 1, ignoreAmount do
		cashList[i] = nil;
		cashList[amount - i + 1] = nil;
	end;

	amount = amount - 2 * ignoreAmount;

	local total = 0;
	for k, v in pairs(cashList) do
		total = total + v;
	end;

	local mean = total / amount;

	local lower = cashList[math.floor(amount / 2)] or 0;
	local higher = cashList[math.ceil(amount / 2)] or 0;
	median = (higher + lower) / 2;

	local standardDev = 0;
	for k, v in pairs(cashList) do
		standardDev = standardDev + math.pow(v - mean, 2);
	end;
	standardDev = math.sqrt(standardDev / amount);

	return table.concat({mode,
		":\n    total: ", math.Round(total),
		"\n    mean: ", math.Round(mean),
		"\n    median: ", math.Round(median),
		"\n    std: ", math.Round(standardDev),
		"\n    n: ", amount, ", ign: ", ignorePercentage
	}, "");
end;

function PLUGIN:ListCash(playerList)
	local cashList = {};
	for k, v in pairs(playerList) do
		cashList[#cashList + 1] = {v:GetCash() + v:GetCharacterData("CacheCash", 0), v:GetFaction()};
	end;

	table.sort(cashList, function(a, b) return a[1] < b[1] end);

	local printTable = {"cashlist: "};
	for k, v in ipairs(cashList) do
		printTable[#printTable + 1] = "    "..v[1].." ("..v[2]..")";
	end;

	return table.concat(printTable, "\n");
end;

function PLUGIN:GetContainerCash()
	if (cwStorage and cwStorage.storage) then
		local containers = cwStorage.storage;
		local cashList = {};
		for k, v in pairs(containers) do
			if (IsValid(v) and v.cwCash and v.cwCash > 0) then
				if (v.cwPassword and v.cwPassword != "") then
					cashList[v.cwPassword] = cashList[v.cwPassword] or 0;
					cashList[v.cwPassword] = cashList[v.cwPassword] + v.cwCash;
				else
					cashList["public"] = cashList["public"] or 0;
					cashList["public"] = cashList["public"] + v.cwCash;
				end;
			end;
		end;

		local printTable = {"containercash:\n",
		"    public: "..(cashList["public"] or 0)};
		local count = table.Count(cashList) - 1;
		local amount = 0;
		for k, v in pairs(cashList) do
			amount = amount + v;
		end;
		printTable[#printTable + 1] = "\n    private: ";
		printTable[#printTable + 1] = amount;
		printTable[#printTable + 1] = "\n    n: ";
		printTable[#printTable + 1] = count;

		return table.concat(printTable, "");
	else
		return "containercash:\n    No containers found";
	end;
end;

function PLUGIN:GetItemsInfo(mode, returnTable, players, bDontFormat)
	returnTable = returnTable or {};

	if (mode == "ground") then
		local itemEntities = ents.FindByClass("cw_item");
		for k, v in pairs(itemEntities) do
			local itemTable = v:GetItemTable();
			if (itemTable) then
				returnTable[itemTable("uniqueID")] = returnTable[itemTable("uniqueID")] or 0;
				returnTable[itemTable("uniqueID")] = returnTable[itemTable("uniqueID")] + 1;
			end;
		end;
	elseif (mode == "container" and cwStorage and cwStorage.storage) then
		local containers = cwStorage.storage;
		for k, v in pairs(containers) do
			if (IsValid(v) and v.cwInventory) then
				for k, v in pairs(v.cwInventory) do
					for k1, v1 in pairs(v) do
						returnTable[v1("uniqueID")] = returnTable[v1("uniqueID")] or 0;
						returnTable[v1("uniqueID")] = returnTable[v1("uniqueID")] + 1;
					end;
				end;
			end;
		end;
	elseif (mode == "invall") then
		for k, v in pairs(players) do
			for k1, v1 in pairs(v:GetInventory()) do
				for k2, v2 in pairs(v1) do
					returnTable[v2("uniqueID")] = returnTable[v2("uniqueID")] or 0;
					returnTable[v2("uniqueID")] = returnTable[v2("uniqueID")] + 1;
				end;
			end;

			for k1, v1 in pairs(v:GetCharacterData("CacheItems", {})) do
				for k2, v2 in pairs(v1) do
					returnTable[v2("uniqueID")] = returnTable[v2("uniqueID")] or 0;
					returnTable[v2("uniqueID")] = returnTable[v2("uniqueID")] + 1;
				end;
			end;

			for k1, v1 in pairs(v:GetWeapons()) do
				if (Clockwork.item:GetByWeapon(v1)) then
					local itemTable = Clockwork.item:GetByWeapon(v1);
					returnTable[itemTable("uniqueID")] = returnTable[itemTable("uniqueID")] or 0;
					returnTable[itemTable("uniqueID")] = returnTable[itemTable("uniqueID")] + 1;
				end;
			end;
		end;
	elseif (mode == "invcitizens") then
		for k, v in pairs(players) do
			if (v:GetFaction() == FACTION_CITIZEN) then	
				for k1, v1 in pairs(v:GetInventory()) do
					for k2, v2 in pairs(v1) do
						returnTable[v2("uniqueID")] = returnTable[v2("uniqueID")] or 0;
						returnTable[v2("uniqueID")] = returnTable[v2("uniqueID")] + 1;
					end;
				end;

				for k1, v1 in pairs(v:GetCharacterData("CacheItems", {})) do
					for k2, v2 in pairs(v1) do
						returnTable[v2("uniqueID")] = returnTable[v2("uniqueID")] or 0;
						returnTable[v2("uniqueID")] = returnTable[v2("uniqueID")] + 1;
					end;
				end;

				for k1, v1 in pairs(v:GetWeapons()) do
					if (Clockwork.item:GetByWeapon(v1)) then
						local itemTable = Clockwork.item:GetByWeapon(v1);
						returnTable[itemTable("uniqueID")] = returnTable[itemTable("uniqueID")] or 0;
						returnTable[itemTable("uniqueID")] = returnTable[itemTable("uniqueID")] + 1;
					end;
				end;
			end;
		end;
	else
		self:GetItemsInfo("ground", returnTable, players, true);
		self:GetItemsInfo("container", returnTable, players, true);
		self:GetItemsInfo("invcitizens", returnTable, players, true);
	end;

	if (!bDontFormat) then
		local tempTable = {};
		for k, v in pairs(returnTable) do
			local itemTable = Clockwork.item:FindByID("k");
			tempTable[itemTable("category")] = tempTable[itemTable("category")] or {};
			tempTable[itemTable("category")][k] = v;
		end;

		local categoryTable = {};
		for k, v in pairs(tempTable) do
			categoryTable[#categoryTable + 1] = k;
		end;

		table.sort(categoryTable);

		local printTable = {};
		for k, v in ipairs(categoryTable) do
			printTable[#printTable + 1] = "    "..v..": ";
			local tbl = {};
			for k1, v1 in pairs(tempTable[v]) do
				tbl[#tbl + 1] = "        "..k1..": "..v1;
			end;

			table.sort(tbl);

			for k, v in ipairs(tbl) do
				printTable[#printTable + 1] = v;
			end;
		end;

		return printTable;
	end;
end;