local ITEM = {}

ITEM.Name = "Physgun"
ITEM.UniqueName = "weapon_physgun"
ITEM.Icon = "bricks"
ITEM.Description = "Move stuff."
ITEM.Author = "_Undefined"
ITEM.Date = "16th August 2009"
ITEM.Model = "models/weapons/w_physics.mdl"
ITEM.Skin = 1
ITEM.ClassName = ""
ITEM.Price = 20
ITEM.RemoveOnUse = true
ITEM.Modes = {TEAM_BUILD}

if SERVER then
	function ITEM:Use(ply)
		ply:Give("weapon_physgun")
	end
end

INVENTORY:RegisterItem(ITEM)