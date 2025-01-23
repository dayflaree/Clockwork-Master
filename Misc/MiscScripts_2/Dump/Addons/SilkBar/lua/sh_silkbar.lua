MODULES = {}

function AddSilkModule(MODULE)
	if (MODULE) then
		Msg("[SilkBar] -> Loading Module '"..MODULE.Name.."'\n")
		table.insert(MODULES, MODULE)
	end
	if (CLIENT) then
		for k, v in pairs(MODULE.MENU) do
			return
		end
	end
end

function AddModule(menu, cmd, func)
    table.insert(SilkBar.menu, {
        cmd = cmd,
        func = func
    })
end

local modules = file.FindInLua("modules/*.lua")
for _, file in pairs(modules) do
	AddCSLuaFile( "modules/" .. file )
	include( "modules/" .. file )
end

function SB_PrintModules()
	Msg("[SilkBar] -> Loaded Modules:\n")
	for k, v in pairs(MODULES) do
		Msg("-> "..v.Name.."\n")
	end
end
concommand.Add("SB_PrintModules", SB_PrintModules)

function SB_FindPlayer(u_info)
	for k, ply in pairs(players.GetAll()) do
		if ply:SteamID() == u_info then
			return ply
		end
		if ply:UniqueID() == u_info then
			return ply
		end
		if ply:UserID() == u_info then
			return ply
		end
		if string.find(string.lower(ply:Nick()), string.lower(u_info)) then
			return ply
		end
	end
end

