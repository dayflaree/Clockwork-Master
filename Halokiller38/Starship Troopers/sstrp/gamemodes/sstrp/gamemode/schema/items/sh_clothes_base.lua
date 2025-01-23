--[[
Name: "sh_clothes_base.lua".
Product: "Severance".
--]]

local ITEM = {};

ITEM.name = "Clothes Base";
ITEM.model = "models/props_c17/suitcase_passenger_physics.mdl";
ITEM.weight = 2;
ITEM.useText = "Wear";
ITEM.category = "Clothing";
ITEM.description = "A suitcase full of clothes.";
ITEM.isBaseItem = true;

-- A function to get the model name.
function ITEM:GetModelName(player, group)
	local name;
	
	if (!player) then
		player = g_LocalPlayer;
	end;
	
	if (group) then
		name = string.gsub(string.lower( nexus.player.GetDefaultModel(player) ), "^.-/.-/", "");
	else
		name = string.gsub(string.lower( nexus.player.GetDefaultModel(player) ), "^.-/.-/.-/", "");
	end;
	
	if ( !string.find(name, "male") and !string.find(name, "female") ) then
		if (group) then
			group = "group05/";
		else
			group = "";
		end;
		
		if (SERVER) then
			if (nexus.player.GetGender(player) == GENDER_FEMALE) then
				return group.."female_04.mdl";
			else
				return group.."male_05.mdl";
			end;
		elseif (nexus.player.GetGender(player) == GENDER_FEMALE) then
			return group.."female_04.mdl";
		else
			return group.."male_05.mdl";
		end;
	else
		return name;
	end;
end;

-- Called when the item's client side model is needed.
function ITEM:GetClientSideModel()
	local replacement;
	
	if (self.GetReplacement) then
		replacement = self:GetReplacement(g_LocalPlayer);
	end;
	
	if (type(replacement) == "string") then
		return replacement;
	elseif (self.replacement) then
		return self.replacement;
	elseif (self.group) then
		return "models/mobileinfantry/"..self:GetModelName();
	end;
end;

-- Called when a player changes clothes.
function ITEM:OnChangeClothes(player, boolean)
	if (boolean) then
		local replacement;
		
		if (self.GetReplacement) then
			replacement = self:GetReplacement(player);
		end;
		
		if (type(replacement) == "string") then
			player:SetModel(replacement);
		elseif (self.replacement) then
			player:SetModel(self.replacement);
		elseif (self.group) then
			player:SetModel( "models/mobileinfantry/"..self:GetModelName(player) );
		end;
	else
		nexus.player.SetDefaultModel(player);
		nexus.player.SetDefaultSkin(player);
	end;
	
	if (self.OnChangedClothes) then
		self:OnChangedClothes(player, boolean);
	end;
end;

-- Called when the item's local amount is needed.
function ITEM:GetLocalAmount(amount)
	if (g_LocalPlayer:GetSharedVar("sh_Clothes") == self.index) then
		return amount - 1;
	else
		return amount;
	end;
end;

-- Called to get whether a player has the item equipped.
function ITEM:HasPlayerEquipped(player)
	if (SERVER) then
		return (player:GetCharacterData("clothes") == self.index);
	else
		return (player:GetSharedVar("sh_Clothes") == self.index);
	end;
end;

-- Called when a player has unequipped the item.
function ITEM:OnPlayerUnequipped(player)
	SCHEMA:PlayerWearClothes(player, false);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position)
	if (player:GetCharacterData("clothes") == self.index) then
		if (player:HasItem(self.uniqueID) == 1) then
			nexus.player.Notify(player, "You cannot drop this while you are wearing it!");
			
			return false;
		end;
	end;
end;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if ( player:Alive() and !player:IsRagdolled() ) then
		if (!self.CanPlayerWear or self:CanPlayerWear(player, itemEntity) != false) then
			SCHEMA:PlayerWearClothes(player, self);
			
			if (itemEntity) then
				return true;
			end;
		end;
	else
		nexus.player.Notify(player, "Sorry, you cannot do that right now!");
	end;
	
	return false;
end;

nexus.item.Register(ITEM);