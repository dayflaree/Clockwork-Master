ITEM.Name = "9mm Ammo";
ITEM.Class = "ammo_9mm";
ITEM.Description = "20 Rounds";
ITEM.Model = "models/Items/BoxSRounds.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 100;
ITEM.ItemGroup = 5;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	ply:GiveAmmo(20,"pistol");
    self:Remove();
	
end
