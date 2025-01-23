MiniGM = {}
MiniGM.__index = MiniGM

MiniGH.Gamemodes = {}

for _, f in pairs(file.FindInLua("gms/*")) do	
	local id = string.sub(f, 1, -5)
	
	MGM = {}
	MGM.__index = {}
	
	AddCSLuaFile("gms/" .. f)
	include("gms/" .. f)
	
	MiniGM.Gamemodes[id] = GM
	
	for name, func in pairs(MGM.Hooks) do
		hook.Add(name, "MGM_" .. id .. "_" .. name, function(ply, ...)
			if MiniGM:IsGamemodeActive(id) then
				if SERVER then
					func(unpack({...}))
				end
				
				if CLIENT then
					if LocalPlayer:IsPlayingMGM(id) then
						func(ply, unpack({...}))
					end
				end
			end
		end)
	end
end