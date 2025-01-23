ITEM.Name = "LL Arm Armor"
ITEM.Enabled = true
ITEM.Description = "Armor for your left lower arm."
ITEM.Cost = 100
ITEM.Model = "models/props_combine/headcrabcannister01a.mdl"
ITEM.Bone = "ValveBiped.Bip01_L_Forearm"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item.ID)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
	
	ModifyHat = function(ent, pos, ang)
		ent:SetModelScale(Vector(0.15, 0.15, 0.15))
		pos = pos + (ang:Forward() * 6)
		--ang:RotateAroundAxis(ang:Right(), 200)
		return ent, pos, ang
	end
}