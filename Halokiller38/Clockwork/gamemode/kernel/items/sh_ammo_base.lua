--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New(nil, true);
ITEM.name = "Ammo Base";
ITEM.useText = "Load";
ITEM.useSound = false;
ITEM.category = "Ammunition";
ITEM.ammoClass = "pistol";
ITEM.ammoAmount = 0;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	for k, v in pairs(player:GetWeapons()) do
		local itemTable = Clockwork.item:GetByWeapon(v);
		
		if (itemTable and (itemTable("primaryAmmoClass") == self("ammoClass")
		or itemTable("secondaryAmmoClass") == self("ammoClass"))) then
			player:GiveAmmo(self("ammoAmount"), self("ammoClass"));
			return;
		end;
	end;
	
	Clockwork.player:Notify(player, "You need to equip a weapon that uses this ammunition!");
	return false;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

Clockwork.item:Register(ITEM);