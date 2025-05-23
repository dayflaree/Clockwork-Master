ITEM.Name = "100 Armor"
ITEM.Enabled = true
ITEM.Description = "Gives you 100 more armor."
ITEM.Cost = 100
ITEM.Model = "models/props_combine/suit_charger001.mdl"

ITEM.Functions = {
	OnGive = function(ply, item)
		item.Hooks.PlayerSpawn(ply, item)
	end,
	
	OnTake = function(ply, item)
		ply:SetArmor(ply:Armor() - 100 >= 0 and ply:Armor() - 100 or 0)
	end
}

ITEM.Hooks = {
	PlayerSpawn = function(ply, item)
		ply:SetArmor(ply:Armor() + 100)
	end
}