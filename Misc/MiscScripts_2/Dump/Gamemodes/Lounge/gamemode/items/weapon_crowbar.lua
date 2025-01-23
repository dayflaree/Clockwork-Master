local ITEM = {}

ITEM.Name = "Crowbar"
ITEM.UniqueName = "weapon_crowbar"
ITEM.Icon = "wand"
ITEM.Description = "Hit the shit outta things."
ITEM.Author = "_Undefined"
ITEM.Date = "16th August 2009"
ITEM.Model = "models/weapons/w_crowbar.mdl"
ITEM.ClassName = ""
ITEM.Price = 20
ITEM.RemoveOnUse = true
ITEM.Modes = {TEAM_RP, TEAM_BUILD}

if SERVER then
	function ITEM:Use(ply)
		ply:Give("weapon_crowbar")
	end
end

INVENTORY:RegisterItem(ITEM)