local ITEM = {}

ITEM.Name = "Gravity Gun"
ITEM.UniqueName = "weapon_physcannon"
ITEM.Icon = "cog"
ITEM.Description = "Pickup and throw stuff."
ITEM.Author = "_Undefined"
ITEM.Date = "16th August 2009"
ITEM.Model = "models/weapons/w_physics.mdl"
ITEM.Skin = 0
ITEM.ClassName = ""
ITEM.Price = 20
ITEM.RemoveOnUse = true
ITEM.Modes = {TEAM_RP, TEAM_BUILD}

if SERVER then
	function ITEM:Use(ply)
		ply:Give("weapon_physcannon")
	end
end

INVENTORY:RegisterItem(ITEM)