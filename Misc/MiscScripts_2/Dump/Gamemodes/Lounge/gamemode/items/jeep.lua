local ITEM = {}

ITEM.Name = "Jeep"
ITEM.UniqueName = "jeep"
ITEM.Icon = "car"
ITEM.Description = "Just a Jeep."
ITEM.Author = "_Undefined"
ITEM.Date = "16th August 2009"
ITEM.Model = "models/buggy.mdl"
ITEM.Skin = 0
ITEM.ClassName = ""
ITEM.Price = 200
ITEM.RemoveOnUse = true
ITEM.Modes = {TEAM_BUILD}

if SERVER then
	function ITEM:Use(ply)		
		if not vehicles.PlayerSpawn(ply, "jeep", ply:GetPos() + ply:GetAngles():Forward() * 64, ply:GetAngles():Up()) then
			Msg("FAIL\n")
		end
	end	
end

INVENTORY:RegisterItem(ITEM)