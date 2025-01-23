--[[
Server Stats by _Undefined
Hooks used:
	- PlayerInitialSpawn
	PlayerDeath
	- PlayerSpawnedProp
	- PlayerSpawnedRagdoll
	- PlayerDisconnected
*/
]]--

STATS = {}
STATS.Queries = {}

function STATS.QueueLength(ply, cmd, args)
	ply:ChatPrint("Queries left to process: "..#STATS.Queries)
end
concommand.Add("statsprint", STATS.QueueLength)

function STATS.Init()
	STATS.DB = gdatabase.MakeConnection("195.90.99.4", "ubs", "u85", "ubs")
	table.insert(STATS.Queries, "INSERT INTO `server_conns` (`c_time`) VALUES ('"..os.time().."')")
end
hook.Add("Initialize", "STATSInit", STATS.Init)
concommand.Add("dbstart", STATS.Init)

function STATS.FirstSpawn(ply)
	table.insert(STATS.Queries, "INSERT INTO `server_spawns` (`s_name`, `s_s_id`, `s_date`) VALUES ('"..ply:Nick().."', '"..ply:SteamID().."', '"..os.time().."')")
end
hook.Add("PlayerInitialSpawn", "STATSplayerInitialSpawn", STATS.FirstSpawn)

function STATS.SpawnedProp(ply, model, ent)
	table.insert(STATS.Queries, "INSERT INTO `server_propspawns` (`ps_name`, `ps_s_id`, `ps_p_name`, `ps_date`) VALUES ('"..ply:Nick().."', '"..ply:SteamID().."', '"..model.."', '"..os.time().."')")
end
hook.Add("PlayerSpawnedProp", "STATSplayerSpawnedProp", STATS.SpawnedProp)

function STATS.SpawnedRagdoll(ply, model, ent)
	table.insert(STATS.Queries, "INSERT INTO `server_ragdollspawns` (`rs_name`, `rs_s_id`, `rs_p_name`, `rs_date`) VALUES ('"..ply:Nick().."', '"..ply:SteamID().."', '"..model.."', '"..os.time().."')")
end
hook.Add("PlayerSpawnedRagdoll", "STATSplayerSpawnedRagdoll", STATS.SpawnedRagdoll)

function STATS.PlayerDisconnect(ply)
	table.insert(STATS.Queries, "INSERT INTO `server_disconns` (`d_name`, `d_s_id`, `d_date`) VALUES ('"..ply:Nick().."', '"..ply:SteamID().."', '"..os.time().."')")
end
hook.Add("PlayerDisconnected", "STATSplayerDisconnected", STATS.PlayerDisconnect)

function STATS.PlayerSay(ply, text, toall)
	table.insert(STATS.Queries, "INSERT INTO `server_chat` (`c_name`, `c_s_id`, `c_date`, `c_text`) VALUES ('"..ply:Nick().."', '"..ply:SteamID().."', '"..os.time().."', '"..text.."')")
end
hook.Add("PlayerSay", "STATSplayerSay", STATS.PlayerSay)

function RandomKey(Table)
	local temp = {}
	for k, v in pairs(Table) do
		table.insert(temp, k)
	end
	local key = table.Random(temp)
	table.remove(Table, key)
	return key, Table[key]
end  

function STATS.DoStats()
	if table.Count(STATS.Queries) > 0 then
		local rk, rv = RandomKey(STATS.Queries)
		q = gdatabase.Query(rv, STATS.DB)
	end
end
timer.Create("stats_do", 1, 0, STATS.DoStats)
