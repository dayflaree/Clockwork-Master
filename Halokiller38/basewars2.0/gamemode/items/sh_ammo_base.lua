local ITEM = {};
ITEM.derive = "item_base";
ITEM.isBaseItem = true;

ITEM.name = "Base Ammo";

ITEM.uniqueID = "ammo_base";

ITEM.camFOV = 30;

function ITEM:OnUse(player)
	if (self.ammoClass and self.rounds) then
		-- for k, v in pairs(player:GetWeapons()) do
			-- local weaponTable = RP.Item:GetWeapon(v);
			-- if (weaponTable) then
				-- if (string.lower(weaponTable.ammoClass) == string.lower(self.ammoClass)) then
					player:GiveAmmo(self.rounds, self.ammoClass);
					player:SetAmmoData();
					self:RemoveInventory(player);
				-- end;
			-- else
				-- player:N
		-- end;
	else
		player:Notify("Developer Error: Must define ammoClass and rounds as values of the ammo item table!");
	end;
end;

function ITEM:Description(descMeta)
	descMeta:Color(Color(50, 200, 0)); descMeta:Text("Category: "); descMeta:Color(Color(255, 255, 255)); descMeta:Text(self.category);
	descMeta:NewLine(); descMeta:Color(Color(50, 200, 0)); descMeta:Text("Weight: "); descMeta:Color(Color(255, 255, 255)); descMeta:Text(self.weight.."kg");	
	descMeta:NewLine(); descMeta:Color(Color(50, 200, 0)); descMeta:Text("Rounds: "); descMeta:Color(Color(255, 255, 255)); descMeta:Text(tostring(self.rounds));
	descMeta:HorizontalRule();
	
	descMeta:Color(Color(255, 255, 255));
	if (type(self.CustomDesc) == "function") then
		self:CustomDesc(descMeta);
	end;
	
	return descMeta:Get();
end;

RP.Item:New(ITEM);