AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_boundaries.lua")
AddCSLuaFile("cl_buildmenu.lua")
AddCSLuaFile("cl_unitmenu.lua")
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile("cl_territories.lua")
AddCSLuaFile("cl_units.lua")
AddCSLuaFile("cl_notice.lua")
AddCSLuaFile("cl_miracles.lua")
AddCSLuaFile("cl_hints.lua")
AddCSLuaFile("cl_chatbox.lua")
AddCSLuaFile("uclip/sh_uclip.lua")


include("shared.lua")
include("resources.lua")
include("npcanims.lua")
include("commands.lua")
include("miracles.lua")
include("minimaps.lua")
include("sh_boundaries.lua")
include("uclip/sh_uclip.lua")
include("uclip/sv_uclip.lua")

/*---------------------------------------------------------
	Name: Sassilization
	Desc: A garrysmod RTS Gamemode
---------------------------------------------------------*/

local META = FindMetaTable( "Player" )
if (!META) then return end

function META:IsAllied( pl )
	if !(alliances[pl] and alliances[self]) then return end
	return table.HasValue( alliances[self], pl ) and table.HasValue( alliances[pl], self )
end

function META:SetResource( res, amount )
	return self:SetNWInt(res,amount)
end

function META:DeductResource( res, amount, noteam )
	local current = self:GetNWInt(res)
	local new = current - amount
	self:SetNWInt(res,new)
	if noteam then return end
	if !ALLIEDRESOURCES then return end
	if alliances[self] then
		for _, pl in pairs( alliances[self] ) do
			if pl and pl:IsPlayer() and alliances[pl] and table.HasValue(alliances[pl],self) then
				pl:SetNWInt(res,new)
			end
		end
	end
end

function META:AddResource( res, amount, noteam )
	local current = self:GetNWInt(res)
	local new = current + amount
	self:SetNWInt(res,new)
	if noteam then return end
	if !ALLIEDRESOURCES then return end
	if alliances[self] then
		for _, pl in pairs( alliances[self] ) do
			if pl and pl:IsPlayer() and alliances[pl] and table.HasValue(alliances[pl],self) then
				pl:SetNWInt(res,new)
			end
		end
	end
end

function META:CleanupAlliances()
	if alliances[self] then
		for _, ally in pairs( alliances[self] ) do
			if !(ValidEntity(ally) and ally:IsPlayer()) then
				table.remove( alliances[self], _ )
				self:SendLua( "AddHistory( 0, 'An Alliance has been broken', 4 )" )
				self:SetNWInt("Allies", #alliances[self])
				self:CleanupAlliances()
				break
			end
		end
	end
end

function META:CalculateUnitSupply()
	
	if MONUMENTS["jaanus"] == self then
		self:SetNWInt( "_supply", unit_limit )
		return
	end
	
	local count, houses = default_supply, 0
	count = count + self:GetNWInt( "_cities" )
	
	for _, house in pairs( ents.FindByClass( "bldg_residence" ) ) do
		if house:IsReady() and house.Overlord == self then
			houses = houses + 0.5
		end
	end
	
	count = count + houses
	
	self:SetNWInt( "_supply", math.floor( count ) )
	
end

function META:CalcPot()
	
	local pot, allies = self:GetNWInt( "_gold" ), 1
	for _, pl in pairs( alliances[self] ) do
		if pl != self and table.HasValue( alliances[pl], self ) then
			pot = pot + pl:GetNWInt("_gold")
			allies = allies + 1
		end
	end
	return math.Round( pot/allies * 0.5 )
	
end

function META:IsPrivileged()
	if self:IsAdmin() or self:IsSuperAdmin() then
		--return true
	end
	if SinglePlayer() then
		return true
	end
	for _, id in pairs(PrivilegedPlayers) do
		if string.find( self:SteamID(),id ) then
			return true
		end
	end
	return false
end

function META:Reject()
	print("Player: "..self:GetName().." has tried to illegally join the server")
	self:PrintMessage(2,"Your ticket to join has expired.")
	timer.Simple(1,self.ConCommand,self,"connect "..LOBBYIP..":"..LOBBYPORT..";password testingrofl")
	timer.Simple(2,game.ConsoleCommand,"kickid "..self:UserID().."\n" )
	return "invalid"
end

function META:ValidateTicket()

	if SinglePlayer() then GAMEMODE:StartGame() return true end
	/*if !TICKETS then return self:Reject() end
	local validated
	for _, ticket in pairs( TICKETS ) do
		if string.find( ticket.ip, string.sub(self:IPAddress(), 0, string.find(self:IPAddress(),":")-1 ) ) and !ticket.used then
			print("Player: "..self:GetName().." has successfully joined, his/her ticket is now used")
			ticket.used = true
			validated = true
			self.valid = true
			break
		end
	end
	if !validated and !self:IsSuperAdmin() and self != sass then return self:Reject() end
	for _, ticket in pairs( TICKETS ) do
		if !ticket.used then
			return false
		end
	end
	GAMEMODE:StartGame()*/
	return true

end

META = nil

AllPlayers = {}

resourceTick = true

RemovingEntCount = 0

alliances = {} --table that holds alliances between players
PreviousPlayers = {} --If a player has spawned his resources
PrivilegedPlayers = {"6036444", "12454744", "11517364", "10499372", "6134747"} --Players who can use cheats


DEBUG = false

function GM:Initialize()
	
	TICKETS = TICKETS or {}
	
	local CURRENTMAP = game.GetMap()
	if !string.find( CURRENTMAP, "sa_" ) then
		ROUNDCHANGELIMIT = 0
		victory_limit = victory_limit / 2
	end
	if CURRENTMAP == "sa_melonfield" then
		self.Allbuild = true
		victory_limit = victory_limit / 2
	end
	
	self.waitscreen = math.random( 1, 2 )
	if self.waitscreen < 10 then
		resource.AddFile("materials/jaanus/sassilization0"..self.waitscreen..".vtf")
		resource.AddFile("materials/jaanus/sassilization0"..self.waitscreen..".vmt")
	else
		resource.AddFile("materials/jaanus/sassilization"..self.waitscreen..".vtf")
		resource.AddFile("materials/jaanus/sassilization"..self.waitscreen..".vmt")
	end
	
	SetupColors()
	
	hook.Call( "Think", self )
	
	self.setup = true
	
end

function Debug( msg )
	if DEBUG then
		Msg( msg )
	end
end

function GM:ShowHelp(ply)
end

function GM:ShowTeam(ply)
end

function GM:ShowSpare1(ply)	
end

function GM:ShowSpare2(ply)
end

function GM:CanPlayerSuicide( ply )
	if !START then return false end
	return true
end

function gmod.BroadcastLua(lua)
	for _, pl in pairs(player.GetAll()) do
		pl:SendLua(lua)
	end
end

function GM:InitPostEntity()
	
	local mines = ents.FindByClass("iron_mine")
	local farms = ents.FindByClass("farm")
	if !( #mines > 0 and #farms > 0 ) then
		allow_setup = true
		Msg( "No resources exist, Allowing players to setup their own.\n" )
	else
		Msg( "There are ".. #mines .." iron mines and "..#farms.." farms.\n" )
	end
	if #ents.FindByClass("allow_setup") > 0 then
		Msg( "Allowing players to setup their own resources by allow_setup override.\n" )
		allow_setup = true
	end
	
	self.SpawnPoints = ents.FindByClass("info_player_start")
	self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass("gmod_player_start") )	
	
	hook.Call( "Think", self )
	
end

function GM:PlayerSelectSpawn( ply )
	if self.SpawnPoints == nil then
		self.SpawnPoints = ents.FindByClass("info_player_start")
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass("gmod_player_start") )	
	end
	local Count = table.Count( self.SpawnPoints )
	if Count == 0 then
		Msg( "No Spawn Points! ERROR.\n" )
		return ents.GetByID(0)
	end
	local ChosenSpawnPoint = self.SpawnPoints[1]
	if !START then
		ply.LastSpawn = ChosenSpawnPoint
		self.LastSpawn = ChosenSpawnPoint
		return ChosenSpawnPoint
	end
	local AvailableSpawns = {}
	for i=1, Count do
		local spawn = self.SpawnPoints[ i ]
		if (	spawn			&&
			spawn:IsValid()		&&
			spawn:IsInWorld()	&&
			spawn ~= ply.LastSpawn	&&
			spawn ~= self.LastSpawn	) then

			local blocked = false
			for _, ent in pairs(ents.FindInBox(spawn:GetPos() + Vector(-16, -16, 0), spawn:GetPos() + Vector(16, 16, 60))) do
				if ent and ent:IsPlayer() then
					blocked = true
				end
			end
			if not blocked then
				table.insert( AvailableSpawns, spawn )
			end
		end
	end
	if table.Count( AvailableSpawns ) <= 0 then
		ply.blocked = true
		ply.LastSpawn = ChosenSpawnPoint
		self.LastSpawn = ChosenSpawnPoint
		return ChosenSpawnPoint
	end
	ChosenSpawnPoint = AvailableSpawns[ math.random( 1, #AvailableSpawns ) ]
	ply.LastSpawn = ChosenSpawnPoint
	self.LastSpawn = ChosenSpawnPoint
	return ChosenSpawnPoint
end

function GM:PlayerInitialSpawn(pl)
	
	if pl:SteamID() == "STEAM_0:0:12454744" or SinglePlayer() then sass = pl end
	
	if !self.FailSafeTimer then
		self.FailSafeTimer = CurTime() + STARTDELAY + 40
	end

	pl.Units = {}
	pl.SelectedUnits = 0
	pl.CanDismember = true
	pl.killcashbonus = 0
	if allow_setup and !PreviousPlayers[pl:SteamID()] then
		pl.Setup = false
		pl.SetupFarm = false
		pl.SetupMine = false
		pl:SetNWBool( "_isready", false )
	else
		pl.Setup = true
		pl:SetNWBool( "_isready", true )
	end
	
	pl.Hints = {}

	local startfood = default_food
	local startgold = default_gold
	local startiron = default_iron
	if PreviousPlayers[pl:SteamID()] and !ENDROUND then --Don't let players abuse the rejoin resource reset.
		startfood = PreviousPlayers[pl:SteamID()].food
		startgold = PreviousPlayers[pl:SteamID()].gold
		startiron = PreviousPlayers[pl:SteamID()].iron
	else
		PreviousPlayers[pl:SteamID()] = {}
		PreviousPlayers[pl:SteamID()].food = startfood
		PreviousPlayers[pl:SteamID()].gold = startgold
		PreviousPlayers[pl:SteamID()].iron = startiron
	end
	
	alliances[pl] = {}
	
	pl:SetNWInt("_food", startfood)
	pl:SetNWInt("_gold", startgold)
	pl:SetNWInt("_iron", startiron)
	pl:SetNWInt("_uid", 1 )
	pl:SetNWInt("_cities", 0)
	pl:SetNWInt("_workshops", 0)
	pl:SetNWInt("_shrines", 0)
	pl:SetNWInt("_soldiers", 0)
	pl:SetNWInt("_supplied", 0)
	pl:SetNWInt("_spirits", 0)
	pl:SetNWInt("_mines", 0)
	pl:SetNWInt("_farms", 0)
	pl:SetNWInt("Allies", #alliances[pl] or 0)
	pl:SetNWBool("_built", false)
	pl:CalculateUnitSupply()
	
	pl:SetJumpPower( 280 )
	pl:SetTeam(TEAM_PLAYERS)
	ChooseColor( pl )
	SetupSpellSelection( pl )
	
	pl:ChatPrint("Welcome to Sassilization!")
	if allow_setup then pl:ChatPrint("Please setup your resource nodes!") end
	
	pl:SetNWBool("muted", self.Mute)
	
	pl.ITEMS = pl.ITEMS or {}
	
end

function GM:PlayerDisconnected(ply)

	if !(ValidEntity( ply ) and ply:IsPlayer()) then return end
	
	Msg( ply:Nick().." has disconnected" )

	SaveData( ply )
	
	if #player.GetAll()-1 == 0 and START and !ENDROUND then self:RestartGame() end
	
	for _, pl in pairs( alliances[ply] or {} ) do
		if (ValidEntity( pl ) and pl:IsPlayer()) then
			if alliances[pl] and table.HasValue( alliances[pl], ply ) then
				privateAlliance( ply, "sa_pally", {pl:UserID(), "false"})
				break
			end
		end
	end
	alliances[ply] = nil
	
	if ply.setup then
		PreviousPlayers[ply:SteamID()].food = ply:GetNWInt("_food")
		PreviousPlayers[ply:SteamID()].gold = ply:GetNWInt("_gold")
		PreviousPlayers[ply:SteamID()].iron = ply:GetNWInt("_iron")
	end
	
	for _, bldg in pairs( ents.FindByClass("bldg_*") ) do
		if bldg:GetOverlord() == ply then
			bldg:Raze("cleanup")
		end
	end
	
	for _, x in pairs(ents.FindByClass("farm")) do
		if x:GetOverlord() == ply then
			x:RemoveControl()
		end
	end
	
	for _, x in pairs(ents.FindByClass("iron_mine")) do
		if x:GetOverlord() == ply then
			x:RemoveControl()
		end
	end
	
	for _, x in pairs(ents.FindByClass("unit_*")) do
		if x:GetOverlord() == ply || x:GetOwner() == ply then
			x:Disband("cleanup")
		end
	end
	
	if !ply.MyColor then return end 
	table.insert( PlayerColors, ply.MyColor[2] )
	
end

function GM:PlayerSpawn(pl)
	
	self:SetPlayerSpeed(pl, 280, 280)
	self:PlayerLoadout(pl)
	
	if self.Mute then
		pl:SetNWBool("muted", true)
	end
	if FLYMODE then
		pl:SetMoveType(MOVETYPE_NOCLIP)
	end
	
	pl:SetCollisionGroup( COLLISION_GROUP_WORLD )
	pl:SetNoCollideWithTeammates(true)
	
	local model = pl:GetModel();
	if( model ~= pl.PlayerModel ) then
		for k, v in pairs( CivModels ) do
			if( v == model ) then
				if pl:IsVIP() then
					if string.find( model, "Group01" ) then
						validmodel = true
						break
					end
				elseif string.find( model, "Group02" ) then
					validmodel = true
					break
				end
			end
		end	
		if( not validmodel and not pl.PlayerModel ) then
			local model = CivModels[math.random( 1, #CivModels )]
			if SinglePlayer() || pl:IsVIP() then
				model = string.gsub( model, "Group", "Group01" )
			else
				model = string.gsub( model, "Group", "Group02" )
			end
			pl.PlayerModel = model	
		end
		pl:SetModel( pl.PlayerModel )
	end
	
end

function GM:PlayerLoadout(ply)
	ply:StripWeapons()
	if ply.Setup then
		ply:Give("command_staff")
		/*if ply.ITEMS.hotgroups then
			for i=1, ply.ITEMS.hotgroups do
				ply:Give("group"..i.."_staff")
			end
		end*/
		ply:SelectWeapon( "command_staff" )
	else
		ply:Give("resource_staff")
	end
end

function GM:PlayerSwitchFlashlight( pl )
	
	return false
	
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	ply:StripWeapons()
	ply:CreateRagdoll()
	return true
end

function GM:PlayerDeathThink( pl )
	if ( pl.NextSpawnTime && pl.NextSpawnTime > CurTime() ) then return end
	pl:Spawn()
end

function GM:PlayerDeath( ply, inflictor, attacker )

	ply.NextSpawnTime = CurTime() + 2

	for _, unit in pairs( ents.FindByClass("unit_*") ) do
		if unit.Overlord == ply then
			unit.Distance = 100
			unit.Ordered = false
			unit.BlockedCount = 0
			if unit:IsSelected() then
				unit:Deselect( ply )
			end
		end
	end
	ply.Units = {}
	
end

ChatCommands = {
	givemoney="givemoney",
	give="givemoney",
	mute="mute",
	muteall="muteall",
	restart="sa_restart",
	sa_restart="sa_restart",
	kick="kickname",
	kickid="kickuid",
	ban="ban"
}

function GM:PlayerSay( ply, txt, team )
	
	if string.find(txt, "CHRISASTER") then return "" end
	
	if string.find(txt, "/") == 1 then
		local command = string.sub( string.Explode( " ", txt )[1], 2 )
		if ChatCommands[command] then
			ply:ConCommand( ChatCommands[command]..string.sub( txt, string.len(command)+2 ) )
		else
			ply:SendLua( "AddHistory( 0, 'Invalid Command', 4 )" )
		end
		return ""
	end
	
	if LOBBYIP then
		tcpSend(LOBBYIP,DATAPORT,tostring("CHAT:"..SERVERID.."|"..tmysql.escape( string.gsub( ply:Name(), "|", "" ) ).."|"..tmysql.escape( string.gsub( !team and "(TEAM)"..txt or txt, "|", "" ) ).."\n"))
	end
	
	/*
	if ply:IsPrivileged() then
		if string.lower(txt) == "thegathering" then 
			gmod.BroadcastLua("surface.PlaySound('weapons/physcannon/energy_disintegrate'..math.random(4,5)..'.wav')")
			gmod.BroadcastLua("surface.PlaySound('physics/metal/sawblade_stick'..math.random(1,3)..'.wav')")
			for _, pl in pairs(player.GetAll()) do
				pl:AddResource("_food", 200 / (#alliances[ply] + 1))
				pl:AddResource("_iron", 200 / (#alliances[ply] + 1))
			end
			ply:ChatPrint( "Cheat Enabled" )
			return ""
		end
		if string.lower(txt) == "operationcwal" then
			gmod.BroadcastLua("surface.PlaySound('weapons/physcannon/energy_disintegrate'..math.random(4,5)..'.wav')")
			gmod.BroadcastLua("surface.PlaySound('physics/metal/sawblade_stick'..math.random(1,3)..'.wav')")
			if !FLYMODE then
				for _, pl in pairs(player.GetAll()) do
					pl:SetMoveType(MOVETYPE_NOCLIP)
				end
				FLYMODE = true
			else
				for _, pl in pairs(player.GetAll()) do
					pl:SetMoveType(MOVETYPE_WALK)
				end
				FLYMODE = nil
			end
			ply:ChatPrint( "Cheat Enabled" )
			return ""
		end
		if string.lower(txt) == "foodforthought" then
			gmod.BroadcastLua("surface.PlaySound('weapons/physcannon/energy_disintegrate'..math.random(4,5)..'.wav')")
			gmod.BroadcastLua("surface.PlaySound('physics/metal/sawblade_stick'..math.random(1,3)..'.wav')")
			for _, pl in pairs( player.GetAll() ) do
				if pl.SetupMine then
					pl.SetupFarm = false
					pl.SetupMine = false
				end
				pl:Give("resource_staff")
				pl:SelectWeapon("resource_staff")
			end
			ply:ChatPrint( "Cheat Enabled" )
			return ""
		end
	end
	*/

	local text =  string.gsub(txt,"[^%a]","")
	local length = string.len( text )
	local Upped = string.upper( text )
	local relevance = 0
	for i=1, length do
		if string.sub( Upped, i, i ) == string.sub( text, i, i ) then
			relevance = relevance + 1
		end
	end
	if relevance/length > 0.7 and length > 5 then
		ply:ChatPrint( "Shouting is not cool." )
		return ""
	end

	if ply:GetNWBool("muted") == true then
		ply:ChatPrint("You are muted")
		return ""
	elseif !team then
		txt = FormatString(txt)
		txt = string.gsub( txt, "\\n", "" )
		txt = string.gsub( txt, "\\", "\\\\" )
		txt = string.gsub( txt, "\'", "\\'" )
		txt = FormatString(txt)
		if txt == "" then return "" end
		ply:SendLua( "AddHistory( "..ply:UserID()..", '"..txt.."', 2 )" )
		for _, pl in pairs( player.GetAll() ) do
			if ply:GetNWBool("Ally "..pl:UserID()) then
				pl:SendLua( "AddHistory( "..ply:UserID()..", '"..txt.."', 2 )" )
			end
		end
		return ""
	else
 		return FormatString(txt)
	end

end

function GM:KeyPress(pl, key) return end

function GM:UpdateScoreboard()
	
	if SinglePlayer() then return end
	if !START or ENDROUND then return end
	if !SERVERID then return end
	
	local players = player.GetAll()
	table.sort(players, function( a, b ) return math.Round(a:GetNWInt("_gold")) > math.Round(b:GetNWInt("_gold")) end)
	
	//Send the scoreboard information to the lobby
	local info = [[LEADERBOARD:]]..SERVERID..[[|SCORES = {]]
	for _, pl in pairs(players) do
		if ValidEntity(pl) and pl:IsPlayer() and pl.MyColor then
			info = info..[[{]]
			info = info..[[n="]]..tmysql.escape(string.gsub( pl:GetName(), "|", "" ))..[[",]]
			info = info..[[c={r=]]..pl.MyColor[1].r..[[,g=]]..pl.MyColor[1].g..[[,b=]]..pl.MyColor[1].b..[[},]]
			info = info..[[g=]]..math.Round(pl:GetNWInt("_gold"))..[[,]]
			info = info..[[f=]]..math.Round(pl:GetNWInt("_food"))..[[,]]
			info = info..[[i=]]..math.Round(pl:GetNWInt("_iron"))..[[,]]
			info = info..[[ci=]]..math.Round(pl:GetNWInt("_cities"))..[[,]]
			info = info..[[cr=]]..math.Round(pl:GetNWInt("_spirits"))..[[,]]
			info = info..[[s=]]..math.Round(pl:GetNWInt("_shrines"))..[[,]]
			info = info..[[fa=]]..math.Round(pl:GetNWInt("_farms"))..[[,]]
			info = info..[[mi=]]..math.Round(pl:GetNWInt("_mines"))..[[,]]
			info = info..[[u=]]..pl:GetNWInt("_soldiers")
			if _ == #players then info = info..[[}]] else info = info..[[},]] end
		end
	end
	info = info..[[}]]
	tcpSend(LOBBYIP,DATAPORT,info.."\n","Scoreboard Updated")
	
end

function GM:UpdateMinimapBuildings()
	
	if SinglePlayer() then return end
	if !START or ENDROUND then return end
	if !SERVERID then return end
	
	if !MINIMAPS then return end
	if MINIMAPS[game.GetMap()] then
		local map = MINIMAPS[game.GetMap()]
		local info = [[MINIMAP:]]..SERVERID..[[|bldg|DATA = {]]
		local bldgs = ents.FindByClass("bldg_*")
		for _, ent in pairs(bldgs) do
			local r,g,b,a = ent:GetColor()
			ent.lastAttacked = ent.lastAttacked == 1 and 1 or 0
			info = info..[[{]]
			info = info..[[i=]]..ent:EntIndex()..[[,]]
			info = info..[[s="]]..math.ceil(ent:OBBMaxs().x*map.Scale)..[[",]]
			info = info..[[c={r=]]..r..[[,g=]]..g..[[,b=]]..b..[[,a=]]..a..[[},]]
			info = info..[[a=]]..ent.lastAttacked..[[,]]
			info = info..[[x=]]..math.Round((ent:GetPos().x-map.Origin.x)*map.Scale)..[[,]]
			info = info..[[y=]]..math.Round((map.Origin.y-ent:GetPos().y)*map.Scale)
			if _ == #bldgs then info = info..[[}]] else info = info..[[},]] end
			ent.lastAttacked = 0
		end
		info = info..[[}]]
		tcpSend(LOBBYIP,DATAPORT,info.."\n","Minimap Buildings Updated")
	end
end

function GM:UpdateMinimapUnits()
	
	if SinglePlayer() then return end
	if !START or ENDROUND then return end
	if !SERVERID then return end
	
	if !MINIMAPS then return end
	if MINIMAPS[game.GetMap()] then
		local map = MINIMAPS[game.GetMap()]
		local info = [[MINIMAP:]]..SERVERID..[[|unit|DATA = {]]
		local units = ents.FindByClass("unit_*")
		for _, ent in pairs(units) do
			if ent:GetOverlord() and ent:GetOverlord():IsPlayer() then
				local r,g,b,a = ent:GetOverlord():GetColor()
				local pos = ent:GetPos()
				ent.lastAttacked = ent.lastAttacked == 1 and 1 or 0
				ent.lastPos = ent.lastPos or {x=pos.x,y=pos.y}
				info = info..[[{]]
				info = info..[[i=]]..ent:EntIndex()..[[,]]
				info = info..[[s="]]..math.ceil(ent:OBBMaxs().x*map.Scale)..[[",]]
				info = info..[[c={r=]]..r..[[,g=]]..g..[[,b=]]..b..[[,a=]]..a..[[},]]
				info = info..[[a=]]..ent.lastAttacked..[[,]]
				info = info..[[px=]]..math.Round((ent.lastPos.x-map.Origin.x)*map.Scale)..[[,]]
				info = info..[[py=]]..math.Round((map.Origin.y-ent.lastPos.y)*map.Scale)..[[,]]
				info = info..[[x=]]..math.Round((pos.x-map.Origin.x)*map.Scale)..[[,]]
				info = info..[[y=]]..math.Round((map.Origin.y-pos.y)*map.Scale)
				if _ == #units then info = info..[[}]] else info = info..[[},]] end
				ent.lastAttacked = 0
				ent.lastPos = {x=pos.x,y=pos.y}
			end
		end
		info = info..[[}]]
		tcpSend(LOBBYIP,DATAPORT,info.."\n","Minimap Units Updated")
	end
end

function GM:StartGame()
	
	if START then return end
	START = true
	
	for _, ticket in pairs( TICKETS ) do
		ticket.used = true
	end
	local playercount = 0
	for _, pl in pairs( player.GetAll() ) do
		if pl.valid then
			playercount = playercount + 1
			pl:SendLua("waitScreen:Remove()")
			pl:SendLua("START=true")
			pl:UnLock()
			pl:Spawn()
		end
	end
	
	if playercount <= 3 then
		ALLIANCES = false
	elseif playercount <= 5 then
		ally_limit = 1
	end
	
	umsg.Start("startGame", player.GetAll() )
		umsg.Bool( ALLIANCES )
		umsg.Short( ally_limit )
	umsg.End()
	
	if SinglePlayer() then return end
	if !MINIMAPS then return end
	if MINIMAPS[game.GetMap()] then
		timer.Create("MiniMapUpdate_bldg",minimap_tick,0,self.UpdateMinimapBuildings,self)
		timer.Create("MiniMapUpdate_unit",minimap_tick,0,self.UpdateMinimapUnits,self)
	end
	
end

function GM:RestartGame(NEXTMAP)
	
	if SinglePlayer() then return end
	local info = [[RETURNINGPLAYERS:]]..SERVERID..[[|TICKETS = {]]
	for _, pl in pairs(player.GetAll()) do 
		SaveData(pl)
		local tid = 0
		for _, ticket in pairs( TICKETS ) do
			if ticket.ip == pl:IPAddress() then
				tid = ticket.team
			end
		end
		info = info..[[{]]
		info = info..[[name = "]]..tmysql.escape(string.gsub( pl:GetName(), "|", "" ))..[[",]]
		info = info..[[ip = "]]..pl:IPAddress()..[[",]]
		info = info..[[team = ]]..tid
		if _ == #player.GetAll() then info = info..[[}]] else info = info..[[},]] end
		pl:SendLua([[LocalPlayer():ConCommand('connect ]]..LOBBYIP..[[:]]..LOBBYPORT..[[;password testingrofl')]])
	end
	info = info..[[}]]
	tcpSend(LOBBYIP,DATAPORT,info.."\n")
	ResetPassword()
	if !NEXTMAP then
		NEXTMAP = MAPS.GetNextMap()
	end
	if !(NEXTMAP and NEXTMAP != "") then
		NEXTMAP = game.GetMap()
	end
	
	timer.Simple( 1, function( level )
		for _, pl in pairs( player.GetAll() ) do
			game.ConsoleCommand( "kickid "..pl:UserID() )
			game.ConsoleCommand( "kickid "..pl:UserID() )
		end
		game.ConsoleCommand( "changelevel "..level.."\n" )
	end, NEXTMAP )
	
end

function GM:Think()

	if !self.setup then return end
	if ENDROUND then return end

	if !START then
		if self.StartTime and CurTime() > self.StartTime then
			self:StartGame()
		end
		if self.FailSafeTimer then
			if self.StartTime and self.FailSafeTimer < self.StartTime then
				self.FailSafeTimer = self.StartTime + 20
			elseif CurTime() > self.FailSafeTimer then
				local count = 0
				for _, pl in pairs( player.GetAll() ) do
					if pl:IsPlayer() and pl:Alive() then
						count = count + 1
					end
				end
				if count == 0 then
					RunConsoleCommand("changelevel",game.GetMap())
					self.FailSafeTimer = nil
				end
			end	
		end
		return	
	end
	
	self.ScoreboardTick = self.ScoreboardTick or CurTime() + scoreboard_tick

	if CurTime() > self.ScoreboardTick then
		self:UpdateScoreboard()
		self.ScoreboardTick = CurTime() + scoreboard_tick
	end
	
	if resourceTick then
		resourceTick = false
		timer.Simple(resource_tick, resetResourceTick)

		for k, ply in pairs(player.GetAll()) do
			
			local ap = ALLIEDRESOURCES and 1 / (ply:GetNWInt( "Allies" ) + 1) or 1
			local cities = ply:GetNWInt("_cities")

			local mines = ply:GetNWInt("_mines")
			local irona = mines * iron_tick
			irona = math.Round(irona+iron_income*ap)
			if cities == 0 and mines == 0 and ply:GetNWInt("_iron") >= BUILDINGS[1].iron then
				irona = 0
			else
				ply:AddResource("_iron", irona)
			end
			
			local farms = ply:GetNWInt("_farms")
			local fooda = farms * food_tick
			fooda = math.Round(fooda+food_income*ap)
			if cities == 0 and farms == 0 and ply:GetNWInt("_food") >= BUILDINGS[1].food then
				fooda = 0
			else
				ply:AddResource("_food", fooda)
			end

			local gold = ply:GetNWInt("_gold")
			local golda = ply:GetNWInt("_cities")
			if gold < BUILDINGS[1].gold and golda == 0 then
				golda = 1
			end
			golda = gold + math.Round(golda)
			ply:SetNWInt("_gold", golda )
			ply:SetFrags( golda )

			if ply.killcashbonus then
				if ply.killcashbonus >= BONUSPOINTCOUNT then
					ply.killcashbonus = ply.killcashbonus - BONUSPOINTCOUNT
					ply:AddMoney( BONUSCASH, true )
				end
			end

			PreviousPlayers[ply:SteamID()] = PreviousPlayers[ply:SteamID()] or {}
			PreviousPlayers[ply:SteamID()].food = ply:GetNWInt("_food")
			PreviousPlayers[ply:SteamID()].gold = ply:GetNWInt("_gold")
			PreviousPlayers[ply:SteamID()].iron = ply:GetNWInt("_iron")

		end
		if SinglePlayer() then return end
		local temp, enemies = {}
		for k, ply in pairs(player.GetAll()) do
			if ply.ITEMS then
				table.insert( temp, ply )
			end
			local amount = ply:GetNWInt("_gold")
			if(amount >= victory_limit) then
				GameOver(ply)
			elseif(amount >= victory_goal) then	--We need to make sure that player is winning by 200
				local canWin = true
				for _, pl in pairs(player.GetAll()) do
					local compare = pl:GetNWInt("_gold")
					if pl ~= ply and amount - compare < victory_lead and alliances[pl] and !table.HasValue(alliances[pl], ply) then
						canWin = false
					end
				end
				if canWin then
					GameOver(ply)	--If the for loop fails then the player has won
					return
				end
			elseif !enemies then
				for _, pl in pairs(player.GetAll()) do
					if pl ~= ply and pl.ITEMS then
						if !(table.HasValue(alliances[ply] or {},pl) and table.HasValue(alliances[pl] or {},ply)) then
							enemies = true
							break
						end
					end
				end
			end
			ply:CleanupAlliances()
		end
		if table.Count( temp ) == 1 || !enemies then
			GameOver(temp[1])
			return
		end

	end

end

function resetResourceTick()
	resourceTick = true
end

function SetupColors()
	local Colors = {
		{90, 90, 90},		--Grey
		{200, 0, 0},		--Red
		{0, 200, 0},		--Green
		{0, 0, 200},		--Blue
		{200, 0, 200},		--Magenta
		{200, 200, 0},		--Yellow
		{0, 200, 200},		--Cyan
		{255, 140, 50},		--Orange
		{100, 0, 200},		--Purple
		{0, 128, 128},		--Teal
		{144, 92, 0},		--Brown
		{128, 200, 0},		--Olive
		{180, 200, 170},	--Green-Gray
		{155, 166, 200},	--Light Purple
		{0, 144, 200},		--Sky blue
		{200, 150, 160}		--Pink
	}
	PlayerColors = {}
	for _, col in rpairs( Colors ) do
		table.insert( PlayerColors, col )
	end
	Colors = nil
end

function ChooseColor(ply)
	local col = PlayerColors[#PlayerColors]
	if col then
		ply:SetColor( col[1], col[2], col[3], 255 )
		ply.MyColor = {Color( ply:GetColor() ), col}
		table.remove( PlayerColors, #PlayerColors )
	else
		ply:ChatPrint("No More Player Colors are available!")
	end
end

function GameOver( ply )
	
	if ply == sass then return end
	if ENDROUND then return end
	ENDROUND = true
	
	/*
	for _, bldg in pairs( ents.FindByClass("bldg_*") ) do
		bldg:Raze("cleanup")
	end

	for _, x in pairs(ents.FindByClass("farm")) do
		x:RemoveControl()
	end
	
	for _, x in pairs(ents.FindByClass("iron_mine")) do
		x:RemoveControl()
	end
	
	for _, unit in pairs( UNITS ) do 
		for _, x in pairs(ents.FindByClass("unit_"..string.lower(unit.name))) do
			x:Disband("cleanup")
		end
	end
	*/
	
	local cashout, allies = ply:GetNWInt( "_gold" ), 1
	for _, pl in pairs( alliances[ply] ) do
		if pl != ply then
			cashout = cashout+pl:GetNWInt("_gold")
			allies = allies + 1
		end
	end
	cashout = math.Round( cashout/allies )
	
	ply:AddWin()
	ply:AddMoney( cashout, true )
	ply:SendLua("GAMEOVER.winner = true")

	local gods = ply:Nick()
	local godcount = 1
	for _, pl in pairs(player.GetAll()) do
		pl:Lock()
		PreviousPlayers[pl:SteamID()].food = default_food
		PreviousPlayers[pl:SteamID()].gold = default_gold
		PreviousPlayers[pl:SteamID()].iron = default_iron
		if ply != pl and table.HasValue( alliances[ply], pl ) then
			gods = gods.."^"..pl:Nick()
			godcount = godcount + 1
			pl:AddMoney( cashout, true )
			pl:AddWin()
			pl:SendLua("GAMEOVER.winner = true")
		else
			local pot = pl:CalcPot()
			pl:AddMoney( pot, true )
			pl:SendLua( "GAMEOVER.cashout = "..tostring( pot ) )
		end
		pl:SaveData()
	end
	gods = string.gsub( gods, "'", "" )
	
	local godmore = godcount
	local godless = #player.GetAll() - godcount
	local unique1 = math.random(1, #Titles)
	local unique2 = math.random(1, #Description)
	
	GAMEINFO = {}
	GAMEINFO.arg1 = unique1
	GAMEINFO.arg2 = unique2
	GAMEINFO.arg3 = godless
	GAMEINFO.arg4 = godmore
	GAMEINFO.arg5 = gods
	GAMEINFO.arg6 = cashout
	
	gmod.BroadcastLua("victoryScreen( '"..GAMEINFO.arg1.."', '"..GAMEINFO.arg2.."', '"..GAMEINFO.arg3.."', '"..GAMEINFO.arg4.."', '"..GAMEINFO.arg5.."', '"..GAMEINFO.arg6.."' )")

	--if PLAYEDROUNDS >= ROUNDCHANGELIMIT then
		ENDTIME = math.floor( CurTime() + INTERMISSION )
		NEXTMAP = MAPS.GetNextMap()
		gmod.BroadcastLua("ChangeScreen( '"..ENDTIME.."', '"..NEXTMAP.."')")
		timer.Simple(INTERMISSION, GAMEMODE.RestartGame, GAMEMODE, NEXTMAP)
		return
	--else
	--	timer.Simple(20, unlockPlayers)
	--	ROUNDSLEFT = ROUNDCHANGELIMIT - PLAYEDROUNDS
	--	gmod.BroadcastLua("RoundsScreen( '"..ROUNDSLEFT.."')")
	--end
	--PLAYEDROUNDS = PLAYEDROUNDS + 1

end

function unlockPlayers()
	ENDROUND = false
	for k, plyr in pairs(player.GetAll()) do

		plyr:UnLock()
	
		plyr:SetNWInt("_food", default_food)
		plyr:SetNWInt("_gold", default_gold)
		plyr:SetNWInt("_iron", default_iron)
		PreviousPlayers[plyr:SteamID()].food = default_food
		PreviousPlayers[plyr:SteamID()].gold = default_gold
		PreviousPlayers[plyr:SteamID()].iron = default_iron
		for _, pl in pairs( player.GetAll() ) do
			plyr:SetNWBool( "Ally "..pl:UserID(), false )
		end
		alliances[plyr] = {}
		plyr:SetNWInt( "Allies", 0 )
		plyr:SetNWInt("_cities", 0)
		plyr:SetNWInt("_workshops", 0)
		plyr:SetNWInt("_shrines", 0)
		plyr:SetNWInt("_spirits", 0)
		plyr:SetNWInt("_soldiers", 0)
		plyr:SetNWInt("_mines", 0)
		plyr:SetNWInt("_farms", 0)
		plyr.Units = {}
		plyr.SelectedUnits = 0
		plyr:SetFrags(0)

		plyr:SendLua("resetVS()")

	end
end