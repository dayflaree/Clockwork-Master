GM.Name 		= "HL2: RTS"
GM.Author 		= "_Undefined"
GM.Email 		= "admin@equinox-studios.co.uk"
GM.Website 		= "http://equinox-studios.co.uk"
GM.TeamBased 	= false

DeriveGamemode("base")

GM.Buildings = {}

function ents.FindByClassInSphere(class, start, radius)
	local r = {}
	local e = ents.FindInSphere(start, radius)
	
	if e and #e > 0 then
		for _, ent in pairs(e) do
			if ent:GetClass() == class then
				table.insert(r, ent)
			end
		end
	end
	
	return r
end

local f = string.Replace(GM.Folder, "gamemodes/", "")
	
for _, fname in pairs(file.FindInLua(f .. "/gamemode/buildings/*.lua" )) do
	AddCSLuaFile(f.. "/gamemode/buildings/" .. fname)
	
	BUILDING = {}
	include(f.. "/gamemode/buildings/" .. fname)
	GM.Buildings[BUILDING.Name] = BUILDING
	BUILDING = {}
end