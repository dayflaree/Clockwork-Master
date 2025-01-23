local ITEM = {};
ITEM.derive = "item_base";
ITEM.isBaseItem = true;
ITEM.name = "Base Weapon";
ITEM.category = "Weapons";
ITEM.uniqueID = "weapon_base";
ITEM.camFOV = 40;

ITEM.Clip = 0;
ITEM.ClipMax = 30;

function ITEM:OnUse(player)
	if (self.weaponClass) then
		if (self.isPrimary) then
			if (self.ammoClass) then
				if (player:GetAmmoCount(self.ammoClass) > 0) then
					player:LoadPrimary(self.itemID);
				else
					player:Notify("You do not have any ammo for that weapon!");
				end;
			else
				player:LoadPrimary(self.itemID);
			end;
		elseif (self.isSecondary) then
			if (self.ammoClass) then
				if (player:GetAmmoCount(self.ammoClass) > 0) then
					player:LoadSecondary(self.itemID);
				else
					player:Notify("You do not have any ammo for that weapon!");
				end;
			else
				player:LoadSeconadry(self.itemID);
			end;
		else
			player:LoadEquipment(self.itemID);
		end;
	else
		player:Notify("Developer Error: Must define a weapon class (The weapon's 'gmod name')!");
	end;
end;

function ITEM:Description(descMeta)
	descMeta:Color(Color(50, 200, 0)); descMeta:Text("Category: "); descMeta:Color(Color(255, 255, 255)); descMeta:Text(self.category);
	descMeta:NewLine(); descMeta:Color(Color(50, 200, 0)); descMeta:Text("Weight: "); descMeta:Color(Color(255, 255, 255)); descMeta:Text(self.weight.."kg");
	descMeta:NewLine(); descMeta:Color(Color(50, 200, 0)); descMeta:Text("Clip: "); descMeta:Color(Color(255, 255, 255)); descMeta:Text(tostring(self.Clip or 0).."/"..tostring(self.ClipMax));
	descMeta:NewLine(); descMeta:Color(Color(50, 200, 0)); descMeta:Text("Unloaded Rounds: "); descMeta:Color(Color(255, 255, 255)); descMeta:Text(tostring(self.ExtraRounds or 0));
	descMeta:NewLine(); descMeta:Color(Color(200, 50, 0)); descMeta:Text("Damage: "); descMeta:Color(Color(255, 255, 255)); descMeta:Text(tostring(self.Damage or 0));
	descMeta:NewLine(); descMeta:Color(Color(200, 50, 0)); descMeta:Text("Spread: "); descMeta:Color(Color(255, 255, 255)); descMeta:Text(tostring(self.Spread or 0));
	
	descMeta:HorizontalRule();
	
	descMeta:Color(Color(255, 255, 255));
	if (type(self.CustomDesc) == "function") then
		self:CustomDesc(descMeta);
	end;
	
	return descMeta:Get();
end;

RP.Item:New(ITEM);