
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

-- Called when a player's character data should be saved.
function PLUGIN:PlayerSaveCharacterData(player, data)
	if (data["filterQuality"]) then
		data["filterQuality"] = math.Round(data["filterQuality"]);
	else
		data["filterQuality"] = 0;
	end;

	self:SaveClothesArmor(player);
end;

function PLUGIN:PlayerRagdolled(player, state, ragdollTable)
	local clothes = player:GetClothesItem();
	if (clothes) then
		clothes:SetData("armor", math.Clamp(player:Armor(), 0, clothes("maxArmor")));
	end;
end;

-- Called when a player's character data should be restored.
function PLUGIN:PlayerRestoreCharacterData(player, data)
	data["filterQuality"] = data["filterQuality"] or 0;
end;

-- Called when a player's shared variables should be set.
function PLUGIN:PlayerSetSharedVars(player, curTime)
	local clothes = player:GetClothesItem();
	if (clothes and (clothes("hasRebreather") or clothes("hasGasmask"))) then
		player:SetSharedVar("hasGasmask", true);
	else
		player:SetSharedVar("hasGasmask", false);
	end;

	if (clothes and clothes("isAnonymous")) then
		player:SetSharedVar("isConcealed", true);
	else
		player:SetSharedVar("isConcealed", false);
	end;

	player:SetSharedVar("filterQuality", math.Round(player:GetCharacterData("filterQuality")));
end;

function PLUGIN:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	local clothes = player:GetClothesItem()
	if (clothes) then
		player:SetMaxArmor(clothes("maxArmor"));
		if (clothes("isAnomyous")) then
			player:SetSharedVar("isConcealed", true);
		else
			player:SetSharedVar("isConcealed", false);
		end;
	else
		player:SetSharedVar("isConcealed", false);
	end;

	if (firstSpawn) then
		local items = player:GetInventory();
		for uniqueID, itemList in pairs(items) do
			for id, itemTable in pairs(itemList) do
				if (!itemTable:IsBasedFrom("filter_base")) then
					break;
				elseif (itemTable:GetData("equipped")) then
					player:SetSharedVar("maxFilterQuality", itemTable("maxFilterQuality"));
					return;
				end;
			end;
		end;
	end;
end;

-- Work in progress by Plankt0n
-- Checks if it's an authorized user, if not, ping the FACTION_MPF the location.
function PLUGIN:PlayerUseItem(player, itemTable, itemEntity)
	if (!Schema:PlayerIsCombine(player) and itemTable("isCombineSuit")) then
		local location = Schema:PlayerGetLocation(player);
			
		Schema:AddCombineDisplayLine("Downloading ping statistics for disengaged MPF STD regalia...", Color(255, 255, 255, 255), nil, player);
		Schema:AddCombineDisplayLine("WARNING! Contact established with non authorized personnel at "..location.."...", Color(255, 0, 0, 255), nil, player);
	end;
end;	

-- Called when the player takes damage
function PLUGIN:EntityTakeDamage(entity, damageInfo)
	if (entity:IsPlayer()) then
		local attacker = damageInfo:GetAttacker();
		if (attacker:IsPlayer() or attacker:IsNPC()) then
			local clothes = entity:GetClothesItem();
			if (clothes and clothes("protection") and clothes("protection") > 0) then
				damageInfo:ScaleDamage(1 - math.Clamp(clothes("protection"), 0, 1));
			end;
		end;
	end;
end;

function PLUGIN:PlayerRagdolled(player)
	self:SaveClothesArmor(player);
end;

function PLUGIN:EntityHandleMenuOption(player, entity, option, arguments)
	if (entity:GetClass() == "cw_item" and option == "Customize" and player:IsSuperAdmin()) then
		local itemTable = entity:GetItemTable();
		
		for field, data in pairs (arguments) do
			itemTable:SetData(field, data);
		end;
		Clockwork.kernel:PrintLog(LOGTYPE_MINOR, player:Name().." has customized a '"..itemTable("name").."'.");
		return true;
	end;
end;