ITEM.Name = "Turtle Hat"
ITEM.Enabled = true
ITEM.Description = "Gives you a turtle hat."
ITEM.Cost = 100
ITEM.Model = "models/props/de_tides/Vending_turtle.mdl"
ITEM.Attachment = "eyes"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item.ID)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
	
	ModifyHat = function(ent, pos, ang)
		pos = pos + (ang:Forward() * -3)
		ang:RotateAroundAxis(ang:Up(), -90)
		return ent, pos, ang
	end
}