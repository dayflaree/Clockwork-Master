local ITEM = {}

ITEM.Name = "Explosive Canister"
ITEM.UniqueName = "explosive_canister"
ITEM.Icon = "bomb"
ITEM.Description = "A canister that blows up."
ITEM.Author = "_Undefined"
ITEM.Date = "15th August 2009"
ITEM.Model = "models/props_junk/propane_tank001a.mdl"
ITEM.Skin = 0
ITEM.ClassName = "prop_physics"
ITEM.Price = 20
ITEM.RemoveOnUse = true
ITEM.Modes = {TEAM_RP, TEAM_DM}

if SERVER then
	function ITEM:Use(ply)
		
	end
end

INVENTORY:RegisterItem(ITEM)