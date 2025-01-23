local ITEM = {}

ITEM.Name = "Toolgun"
ITEM.UniqueName = "gmod_tool"
ITEM.Icon = "wrench"
ITEM.Description = "Build stuff."
ITEM.Author = "_Undefined"
ITEM.Date = "16th August 2009"
ITEM.Model = "models/weapons/w_toolgun.mdl"
ITEM.Skin = 0
ITEM.ClassName = ""
ITEM.Price = 20
ITEM.RemoveOnUse = true
ITEM.Modes = {TEAM_BUILD}

if SERVER then
	function ITEM:Use(ply)
		ply:Give("gmod_tool")
	end
end

INVENTORY:RegisterItem(ITEM) // Register the Item.