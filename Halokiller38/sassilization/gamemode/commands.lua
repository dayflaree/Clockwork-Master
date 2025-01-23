function PlayerReady( pl, cmd, args )
	
	if pl.validated then return end
	pl.validated = true
	
	local lastplayer = pl:ValidateTicket()
	
	if lastplayer == "invalid" then return end
	
	if !GAMEMODE.StartTime then
		GAMEMODE.StartTime = CurTime() + STARTDELAY
	end
	
	Msg("Initializing resources for " .. pl:Nick() .. "\n")
	
	pl:SetNWString( "steamid", pl:SteamID() )
	
	pl:SendLua("victory_limit = "..victory_limit)
	
	if !lastplayer then
		if !START then
			pl:Lock()
			umsg.Start("startScreen" )
				umsg.Short( GAMEMODE.StartTime )
				umsg.Short( CurTime() )
				umsg.Short( GAMEMODE.waitscreen )
			umsg.End()
			umsg.Start("recvTICKET")
				for _, ticket in pairs( TICKETS ) do
					if !ticket.used then
 						umsg.String( ticket.name )
					end
				end
			umsg.End()
		end
		if ENDROUND then
			pl:SendLua("victoryScreen( '"..GAMEINFO.arg1.."', '"..GAMEINFO.arg2.."', '"..GAMEINFO.arg3.."', '"..GAMEINFO.arg4.."', '"..GAMEINFO.arg5.."', '"..GAMEINFO.arg6.."' )")
			if PLAYEDROUNDS >= ROUNDCHANGELIMIT then
				pl:SendLua("ChangeScreen( '"..ENDTIME.."', '"..NEXTMAP.."')")
			else
				pl:SendLua("RoundsScreen( '"..ROUNDSLEFT.."')")
			end
		end
	end
	
	SendData( pl )
	
end
concommand.Add("cl_ready",PlayerReady)

function GetMatches( pl, name )
	if !(name and type(name)=="string") then
		pl:ChatPrint("Incorrect Syntax")
		return false
	end
	local matches = {}
	for i,v in pairs(player.GetAll()) do
		if string.lower(v:Nick()) == string.lower(name) then
			return v
		elseif string.find(string.lower(v:Nick()),string.lower(name)) then
			table.insert(matches,v)
		end
	end
	if #matches > 1 then
		pl:ChatPrint("Too many player's names contain "..name)
		return false
	elseif matches[1] and matches[1]:IsPlayer() then
		if matches[1]:Nick() == pl:Nick() then
			pl:ChatPrint("You cannot do this to yourself")
			return false
		end
		return matches[1]
	else
		pl:ChatPrint("No player's names contain "..name)
		return false
	end
end

function Givemoney_cc( pl, command, args )
	if !(ValidEntity( pl ) and pl:IsPlayer()) then return end
	pl.NextGiveMoney = pl.NextGiveMoney or CurTime()
	if pl.NextGiveMoney > CurTime() then return end
	pl.NextGiveMoney = CurTime() + 2
	local badsyntax = false
	local AMOUNT = string.gsub( string.gsub( args[1] or "", "k", "000" ), ',', "" )
	local taker = args[2]
	if !AMOUNT || !taker then badsyntax = true end
	if badsyntax then pl:ChatPrint("The syntax is givemoney amount playername") return end
	if !tonumber(AMOUNT) then 
		pl:ChatPrint("That is not a valid number.")
	elseif tonumber(AMOUNT) < 10 then 
		pl:ChatPrint("That number is too low.")
	elseif tonumber(AMOUNT) ~= math.Round(tonumber(AMOUNT)) then
		pl:ChatPrint("Whole numbers only.")
	elseif tonumber(AMOUNT) > pl:GetMoney() then
		pl:ChatPrint("You do not have enough to do that.")
	elseif tonumber(AMOUNT) >= 10 then
		AMOUNT = tonumber(AMOUNT)
		local match = GetMatches( pl, taker )
		if match then
			pl:DeductMoney(AMOUNT)
			pl:SaveProfile()
			match:AddMoney(AMOUNT)
			match:SaveProfile()
			pl:ChatPrint("You have given "..match:Nick().." $"..AMOUNT)
			match:ChatPrint(pl:Nick().." has given you $"..AMOUNT)
			return
		else
			return
		end
	end
end
concommand.Add( "givemoney", Givemoney_cc )

function Mute_cc( ply, command, args )
	if !args[1] then return end
	local target = GetMatches( ply, args[1] )
	if !target then return end
	if target:IsAdmin() || target:IsSuperAdmin() then
		ply:ChatPrint("Cannot mute admins")
		return
	end
	local status = !ply:GetNWBool( "muted "..target:UserID() )
	ply:SendLua( "IgnorePlayer( "..target:UserID()..", "..tostring(status).." )" )
	ply:SetNWBool("muted "..target:UserID(), status)
	if status then
		ply:ChatPrint( "You have personally muted "..target:Nick() )
	else
		ply:ChatPrint( "You have personally unmuted "..target:Nick() )
	end
end
concommand.Add( "mute", Mute_cc )

function MuteAll_ac()
	local list = {}
	for _, pl in pairs( player.GetAll() ) do
		table.insert( list, pl:Nick() )
	end
	return list
end

function MuteAll_cc( ply, command, args )
	if !(ply:IsAdmin() || ply:IsSuperAdmin() || ply:IsUserGroup("epic")) then return end
	if !args[1] then
		if !GAMEMODE.Mute then
			for _, pl in pairs( player.GetAll() ) do
				pl:ChatPrint( "(ADMIN) "..ply:GetName().." has muted everyone" )
				if !pl:IsAdmin() and !pl:IsSuperAdmin() then
					pl:SetNWBool("muted", true)
					pl:Mute( true )
				end
			end
			GAMEMODE.Mute = true
		else
			for _, pl in pairs( player.GetAll() ) do
				pl:ChatPrint( "(ADMIN) "..ply:GetName().." has unmuted everyone" )
				pl:SetNWBool("muted", false)
				pl:Mute( false )
			end
			GAMEMODE.Mute = false
		end
		return
	end
	local target = GetMatches( ply, args[1] )
	if !target then return end
	if target:IsAdmin() || target:IsSuperAdmin() then
		ply:ChatPrint("Cannot mute admins")
		return
	end
	local status = !target:GetNWBool( "muted" )
	target:SetNWBool("muted", status)
	target:Mute( status )
	if status then
		for _, pl in pairs( player.GetAll() ) do
			pl:ChatPrint( "(ADMIN) "..ply:GetName().." has muted "..target:Nick() )
		end
	else
		for _, pl in pairs( player.GetAll() ) do
			pl:ChatPrint( "(ADMIN) "..ply:GetName().." has unmuted "..target:Nick() )
		end
	end
end
concommand.Add( "muteall", MuteAll_cc, MuteAll_ac )

function KickName_cc( ply, command, args )
	if !(ply:IsAdmin() || ply:IsSuperAdmin()) then return end
	local target = GetMatches( ply, args[1] )
	if !target then return end
	if ply:GetRank() <= target:GetRank() then
		ply:ChatPrint("This person is more important than you.")
		return
	end
	local reason = table.Copy(args)
	table.remove( reason, 1 )
	reason = string.Implode( " ", reason )
	game.ConsoleCommand( Format( "kickid %i %s\n", target:UserID(), reason ) )
	for _, pl in pairs( player.GetAll() ) do
		pl:ChatPrint( "(ADMIN) "..ply:GetName().." kicked "..target:Nick().." :: "..reason )
	end
end
concommand.Add( "kickname", KickName_cc )

function KickUID_cc( ply, command, args )
	if !(ply:IsAdmin() || ply:IsSuperAdmin()) then return end
	local target = player.GetByUID( tostring(args[1]) )
	if !target then
		ply:ChatPrint("Cannot find player with UserID: "..tostring(args[1] or ""))
		return
	end
	if ply:GetRank() <= target:GetRank() then
		ply:ChatPrint("This person is more important than you.")
		return
	end
	local reason = table.Copy(args)
	table.remove( reason, 1 )
	reason = string.Implode( " ", reason )
	game.ConsoleCommand( Format( "kickid %i %s\n", target:UserID(), reason ) )
	for _, pl in pairs( player.GetAll() ) do
		pl:ChatPrint( "(ADMIN) "..ply:GetName().." kicked "..target:Nick().." :: "..reason )
	end
end
concommand.Add( "kickuid", KickUID_cc )

function Restart_cc( ply, command, args )
	if !(ply:IsAdmin() || ply:IsSuperAdmin() || ply:IsUserGroup("epic")) then return end
	print( "(ADMIN) "..ply:GetName().." has restarted the map." )
	for _, pl in pairs( player.GetAll() ) do 
		pl:ChatPrint( "(ADMIN) "..ply:GetName().." has restarted the map." )
		pl:SaveProfile()	
	end
	timer.Simple( 1, game.ConsoleCommand, "changelevel "..game.GetMap().."\n" )
end
concommand.Add( "sa_restart", Restart_cc)

function KillServer_cc( ply, command, args )
	if !(ply:IsSuperAdmin()) then return end
	game.ConsoleCommand("killserver\n")
end
concommand.Add( "sa_killserver", KillServer_cc)

function ChangeMap_cc( ply, command, args )
	if !(ply:IsSuperAdmin()) then return end
	for _, pl in pairs( player.GetAll() ) do 
		pl:ChatPrint( ply:GetName().." has changed the map to "..args[1] )
		pl:SaveProfile()	
	end
	timer.Simple( 1, game.ConsoleCommand, "changelevel "..args[1].."\n" )
end
concommand.Add( "sa_changemap", ChangeMap_cc)
concommand.Add( "sa_changelevel", ChangeMap_cc)







function ManualReset(ply, command, args)

	if ENDROUND then return end

	if !ply:IsAdmin() then return end
	Msg(ply:Nick() .. " is resetting the match\n" )
	
	for _, unit in pairs( UNITS ) do 
		for _, x in pairs(ents.FindByClass("unit_"..string.lower(unit.name))) do
			x:Disband("cleanup")
		end
	end

	for _, bldg in pairs( ents.FindByClass("bldg_*") ) do
		bldg:Raze("cleanup")
	end

	for _, x in pairs(ents.FindByClass("farm")) do
		x:RemoveControl()
	end
	
	for _, x in pairs(ents.FindByClass("iron_mine")) do
		x:RemoveControl()
	end

	PreviousPlayers = {}

	for k, plyr in pairs(player.GetAll()) do
	
		plyr:ChatPrint( ply:Nick().." is resetting the match" )
		plyr:ChatPrint( "MATCH RESET! Resetting all resources, armies, cities, and players" )
		plyr:SetNWInt("_food", default_food)
		plyr:SetNWInt("_gold", default_gold)
		plyr:SetNWInt("_iron", default_iron)
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
		plyr:SetDeaths(0)
		CVAR.Save( ply )
		plyr:Kill()	
		GAMEMODE:PlayerInitialSpawn(plyr)

	end

end
concommand.Add( "sa_reset", ManualReset)


local function ValidateConnectedWall( wall, conn )
	
	if !ValidEntity(conn) then return end
	if !conn:GetClass() == "bldg_wall" then return end
	if conn:IsDead() then return end
	if string.lower(conn:GetModel()) == "models/jaanus/tower.mdl" then
		local yaw = math.Round((wall:GetPos()-conn:GetPos()):Angle().y)
		local wyaw =  math.Round(wall:GetAngles().y)
		if (	yaw+90 == wyaw	||
			yaw-90 == wyaw	||
			yaw-270 == wyaw	||
			yaw+270 == wyaw	) then
			return true
		else return end
	elseif wall:GetAngles().y != conn:GetAngles().y then return end
	return true
	
end

local function ValidateGateWall( pl, wall )
	
	if wall:IsDead() then return end
	if string.lower(wall:GetModel()) != "models/jaanus/wall.mdl" then return end
	
	local owner = wall:GetOwner()
	if !ValidEntity( owner ) then return end
	if !(owner==pl || owner:GetNWBool( "Ally "..pl:UserID() )) then return end
	
	local towerleft, towerright, outerleft, innerleft, innerright, outerright
	local trace, walls, guards = {}, {}, {}
	trace.start = wall:LocalToWorld(wall:OBBCenter())
	trace.endpos = trace.start + wall:GetRight() * wall_spacing
	trace.filter = {wall}
	local tr = util.TraceLine( trace )
	if ValidateConnectedWall( wall, tr.Entity ) then
		innerright = tr.Entity
		trace.start = innerright:LocalToWorld(innerright:OBBCenter())
		trace.endpos = trace.start + innerright:GetRight() * wall_spacing
		table.insert( trace.filter, innerright )
		tr = util.TraceLine( trace )
		if ValidateConnectedWall( wall, tr.Entity ) then
			outerright = tr.Entity
			trace.start = outerright:LocalToWorld(outerright:OBBCenter())
			trace.endpos = trace.start + outerright:GetRight() * wall_spacing
			table.insert( trace.filter, outerright )
			tr = util.TraceLine( trace )
			if ValidateConnectedWall( wall, tr.Entity ) then
				towerright = tr.Entity
			else return end
		else return end
	else return end
	trace.start = wall:LocalToWorld(wall:OBBCenter())
	trace.endpos = trace.start + wall:GetRight() * -wall_spacing
	tr = util.TraceLine( trace )
	if ValidateConnectedWall( wall, tr.Entity ) then
		innerleft = tr.Entity
		trace.start = innerleft:LocalToWorld(innerleft:OBBCenter())
		trace.endpos = trace.start + innerleft:GetRight() * -wall_spacing
		table.insert( trace.filter, innerleft )
		tr = util.TraceLine( trace )
		if ValidateConnectedWall( wall, tr.Entity ) then
			outerleft = tr.Entity
			trace.start = outerleft:LocalToWorld(outerleft:OBBCenter())
			trace.endpos = trace.start + outerleft:GetRight() * -wall_spacing
			table.insert( trace.filter, outerleft )
			tr = util.TraceLine( trace )
			if ValidateConnectedWall( wall, tr.Entity ) then
				towerleft = tr.Entity
			else return end
		else return end
	else return end
	local walls = {outerleft, innerleft, innerright, outerright}
	local guards = {towerleft, towerright}
	local all, lastz = {wall}
	all = table.Add( all, walls )
	all = table.Add( all, guards )
	for k, v in pairs( all ) do
		if lastz and math.abs( v:GetPos().z - lastz ) > gate_maxvary then
			return
		end
		lastz = v:GetPos().z
	end
	return true, walls, guards
	
end

function ProvidesTerritory( ent, pos )
	if (ent:GetClass() == "bldg_city" /*|| ent:GetClass() == "bldg_residence"*/ || ent:GetClass() == "bldg_workshop" || ent:GetClass() == "bldg_shrine") then
		if ent:GetPos():Distance( pos ) <= ent.TRad then
			return true
		else
			return false
		end
	else
		return false
	end
end

local ItemTranslate = {}
ItemTranslate["workshop"] = "workshop"
ItemTranslate["gate"] = "gate"
ItemTranslate["tower"] = "archertowers"
ItemTranslate["shrine"] = "shrine"
ItemTranslate["archer"] = "archer"
ItemTranslate["scallyWag"] = "scallywag"
ItemTranslate["galleon"] = "galleon"
ItemTranslate["catapult"] = "catapult"
ItemTranslate["ballista"] = "ballista"
ItemTranslate["shieldmono"] = "monolith"


function CreateBuilding( ply, command, args )
	
	if !START then return end
	if ENDROUND then return end
	
	if #args ~= 4 then return end
	local i = tonumber( args[1] )
	if i == 0 then return end
	local name = string.lower( BUILDINGS[i].name )
	
	local id = ItemTranslate[name]
	
	if id then
		if (!ply.ITEMS[id] || ply.ITEMS[id] == false || (ply.ITEMS[id] == 0 and id != "archertowers")) and !ALLOWALL then
			return
		end
	end
	
	local food = BUILDINGS[i].food
	local iron = BUILDINGS[i].iron
	local gold = BUILDINGS[i].gold
	local supply = BUILDINGS[i].supply
	local upright = BUILDINGS[i].upright
	local off = BUILDINGS[i].angOff
	local min = BUILDINGS[i].OBBMins
	local max = BUILDINGS[i].OBBMaxs
	local vec = Vector( 0,0,0 )
	vec.x = tonumber( args[2] )
	vec.y = tonumber( args[3] )
	vec.z = tonumber( args[4] )
	
	if supply and ply:GetNWInt("_supplied") + supply > ply:GetNWInt("_supply") then
		ply:ChatPrint( "You cannot supply this structure" )
		ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
		return
	end
	
	local allowed = true
	if name ~= "city" and ply:GetNWInt( "_cities" ) < 1 then
		allowed = false
	end
	if name == "shrine" then
		if ply:GetNWInt( "_workshops" ) < 1 then
			allowed = false
		end
	end
	if name == "horsie" then
		allowed = false
		if ply:GetNWInt( "_workshops" ) >= 100 then
			local allowees = {"UNKNOWN", "10499372", "12454744", "5220505"}
			for _, id in pairs( allowees ) do
				if string.find( ply:SteamID(), id ) then
					allowed = true
					break
				end
			end
		end
	end
	if !allowed then return end
	
	
	local trace	= utilx.GetPlayerTrace( ply, vec )
 	local tr 	= util.TraceLine( trace )
	
	if (!tr.Hit or tr.HitSky or tr.HitNoDraw) then return end
	
	trace.mask = MASK_WATER
	
	local traceline = util.TraceLine(trace)
	
	if traceline.Hit then
		if ply:WaterLevel() >= 2 then return end
		if tr.Fraction > traceline.Fraction then return end
	end
	
	trace.mask = MASK_NPCSOLID
	local check = util.TraceLine( trace )
	if check.HitPos != tr.HitPos then
		local check = {}
		check.start = tr.HitPos + tr.HitNormal
		check.endpos = ply:EyePos()
		check.mask = MASK_NPCSOLID_BRUSHONLY
		check = util.TraceLine( check )
		if(check.HitNormal == Vector(0,0,0)) then
			return
		end
	end
	
	if ply:GetNWInt("_gold") < -50 then
		ply:ChatPrint("You have acquired too much debt." )
		ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
		return
	end
	if ply:GetNWInt("_gold") < gold and name == "city" then
		ply:ChatPrint("You need more gold." )
		ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
		return
	end
	if ply:GetNWInt("_food") < food || ply:GetNWInt("_iron") < iron then
		ply:ChatPrint("You don't have enough resources: Need "..food.." food, "..iron.." iron, and "..gold.." gold." )
		ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
		return
	end

	local enemyTerritory = false
	local inSupply = false

	if tr.Entity and tr.Entity.Overlord and !tr.Entity:IsDead() then

		local ent = tr.Entity
		if ent:GetClass() == "bldg_tower" and name == "tower" and (ent:GetOverlord() == ply || (ALLIEDTERRITORIES and ply:IsAllied(ent:GetOverlord()))) then
			if ent.level == 1 and ply.ITEMS.archertowers < 1 and !ALLOWALL then
				ply:ChatPrint("You must purchase this upgrade from the store in the Lounge")
				ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
				return
			end
			if ent.level == 2 and ply.ITEMS.archertowers < 2 and !ALLOWALL then
				ply:ChatPrint("You must purchase this upgrade from the store in the Lounge")
				ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
				return
			end
			if !ent:IsUpgraded() then
				if ply:GetNWInt( "_workshops" ) > 0 then
					ent:Upgrade()
					ply:ChatPrint("Archer tower upgraded!")
				else
					ply:ChatPrint("You need a workshop to upgrade.")
					ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
				end
			else
				ply:ChatPrint("Cannot be further upgraded.")
				ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
			end
			return
		end
		if ent:GetClass() == "bldg_workshop" and name == "workshop" and ent:GetOverlord() == ply then
			if ent:IsReady() then
				if ply.ITEMS.workshop < 2 and !ALLOWALL then
					ply:ChatPrint("You must purchase this upgrade from the store in the Lounge")
					ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
					return
				end
				if !ent:IsUpgraded() then
					ent:Upgrade()
					ply:ChatPrint("Workshop upgraded!")
				else
					ply:ChatPrint("Cannot be further upgraded.")
					ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
				end
			else
				ply:ChatPrint("This workshop is not complete.")
				ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
			end
			return
		end
		if ent:GetClass() == "bldg_wall" and name == "gate" then
			local lastwall = false
			local valid, walls, guards = ValidateGateWall( ply, ent )
			if valid then
				ent:Upgrade("gate", walls, guards)
				return
			end
		end
		return

	elseif tr.HitWorld then

		if name == "gate" then return end

		if not ( tr.HitNormal:Angle().p <= 300 and tr.HitNormal:Angle().p >= 240 ) then return end

		for _, ent in pairs( ents.FindInSphere(tr.HitPos, 200) ) do
			local dir = ((ent:GetPos() + Vector( 0, 0, 5 )) - (tr.HitPos + Vector( 0, 0, 5 ))):Normalize()
			trace.mask = MASK_SOLID_BRUSHONLY
			trace.start = tr.HitPos
			trace.endpos = trace.start + (Vector( dir.x, dir.y, 0 ):Normalize() * 8 )
			local check = util.TraceLine( trace )
			trace.start = check.HitPos
			trace.endpos = ent:GetPos() + Vector( 0, 0, 8 )
			check = util.TraceLine( trace )
			if !check.HitWorld then
	
				if (	(ValidEntity( ent ))							&&
					(ent:GetClass() == "bldg_city")						||
					(ent:GetClass() == "bldg_residence")					||
					(ent:GetClass() == "bldg_tower")					||
					(ent:GetClass() == "bldg_wall" and ent:GetOverlord() and !ent.filler)	||
					(ent:GetClass() == "bldg_workshop")					||
					(ent:GetClass() == "bldg_shrine")					||
					(ent:IsUnit())								) then
	
					local dis = tr.HitPos:Distance( ent:GetPos() )
					if dis <= 20 then
						if ent:GetClass() == "bldg_tower" and name == "tower" and (ent:GetOverlord() == ply || (ALLIEDTERRITORIES and ply:IsAllied(ent:GetOverlord()))) then
							if ent.level == 1 and ply.ITEMS.archertowers < 1 and !ALLOWALL then
								ply:ChatPrint("You must purchase this upgrade from the store in the Lounge.")
								ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
								return
							end
							if ent.level == 2 and ply.ITEMS.archertowers < 2 and !ALLOWALL then
								ply:ChatPrint("You must purchase this upgrade from the store in the Lounge.")
								ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
								return
							end
							if !ent:IsUpgraded() then
								if ply:GetNWInt( "_workshops" ) > 0 then
									ent:Upgrade()
									ply:ChatPrint("Archer tower upgraded!")
								else
									ply:ChatPrint("You need a workshop to upgrade.")
									ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
								end
							else
								ply:ChatPrint("Cannot be further upgraded.")
								ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
							end
							return
						end
					end
					if dis <= 50 then
						if ent:GetClass() == "bldg_workshop" and name == "workshop" and ent:GetOverlord() == ply then
							if ent:IsReady() then
								if ply.ITEMS.workshop < 2 and !ALLOWALL then
									ply:ChatPrint("You must purchase this upgrade from the store in the Lounge.")
									ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
									return
								end
								if !ent:IsUpgraded() then
									ent:Upgrade()
									ply:ChatPrint("Workshop upgraded!")
								else
									ply:ChatPrint("Cannot be further upgraded.")
									ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
								end
							else
								ply:ChatPrint("This workshop is not complete.")
								ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
							end
							return
						end
						if ent:GetClass() == "bldg_wall" and name == "wall" and ply:KeyDown(IN_SPEED) then
							ply:ChatPrint("Too close for a new wall.")
							ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
							return
						end
					end
					if dis <= 90 then
						if ent:GetClass() == "bldg_city" and name == "city" then
							ply:ChatPrint("Sorry, this is too close to another city")
							ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
							return
						end
					end
					if dis <= 60 then
						if ent:IsUnit() and ent:GetOverlord() ~= ply and !ply:IsAllied(ent:GetOverlord()) and ent:IsReady() and (name == "wall" || name == "tower") then
							enemyTerritory = true
						end
					end
					if dis <= 140 then
						if ent:GetOverlord() ~= ply and !ply:IsAllied(ent:GetOverlord()) and ent:IsReady() and name ~= "wall" and ProvidesTerritory( ent, tr.HitPos ) then
							enemyTerritory = true
						end
						if name == "wall" and (ent:GetOverlord() == ply || (ALLIEDTERRITORIES and ply:IsAllied(ent:GetOverlord()))) and ent:IsReady() and ProvidesTerritory( ent, tr.HitPos ) then
							inSupply = true
						end
					end
					if dis < 100 then
						if (ent:GetOverlord() == ply || (ALLIEDTERRITORIES and ply:IsAllied(ent:GetOverlord()))) and ent:IsReady() and ProvidesTerritory( ent, tr.HitPos ) then
							inSupply = true
						end
					end
				end
			end
		end
	else return end
	
	if enemyTerritory and !GAMEMODE.Allbuild then
		ply:ChatPrint("Cannot create buildings near enemy lines")
		ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
		return
	end
	if !inSupply and BUILDINGS[i].needSupply then
		ply:ChatPrint("Too far from your Sassilization")
		ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
		return
	end

	local pos = tr.HitPos - tr.HitNormal * min.z
	local ang = tr.HitNormal:Angle() + off
	ang.p = ang.p + 90
	
	
	--Does it fit?!
	local trace = {}
	trace.mask = MASK_SOLID
	trace.start = pos
	trace.endpos = pos + (ang:Forward() * min.x) + (ang:Right() * min.y)
	local tr1 = util.TraceLine( trace )
	trace.mask = MASK_NPCSOLID
	local check = util.TraceLine( trace )
	if (check.HitPos != tr1.HitPos) then
		ply:ChatPrint("It doesn't fit here")
		ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
		return
	end
	trace.mask = MASK_SOLID
	trace.endpos = pos + (ang:Forward() * min.x) + (ang:Right() * max.y)
	local tr2 = util.TraceLine( trace )
	trace.mask = MASK_NPCSOLID
	local check = util.TraceLine( trace )
	if (check.HitPos != tr2.HitPos) then
		ply:ChatPrint("It doesn't fit here")
		ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
		return
	end
	trace.mask = MASK_SOLID
	trace.endpos = pos + (ang:Forward() * max.x) + (ang:Right() * min.y)
	local tr3 = util.TraceLine( trace )
	trace.mask = MASK_NPCSOLID
	local check = util.TraceLine( trace )
	if (check.HitPos != tr3.HitPos) then
		ply:ChatPrint("It doesn't fit here")
		ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
		return
	end
	trace.mask = MASK_SOLID
	trace.endpos = pos + (ang:Forward() * max.x) + (ang:Right() * max.y)
	local tr4 = util.TraceLine( trace )
	trace.mask = MASK_NPCSOLID
	local check = util.TraceLine( trace )
	if (check.HitPos != tr4.HitPos) then
		ply:ChatPrint("It doesn't fit here")
		ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
		return
	end
	trace.mask = MASK_SOLID
	
	if 
	(name ~= "wall" and name ~= "tower") &&
	(	tr1.Fraction < .8 || !ConfirmBoundary( tr1.HitPos ) ||
		tr2.Fraction < .8 || !ConfirmBoundary( tr2.HitPos ) ||
		tr3.Fraction < .8 || !ConfirmBoundary( tr3.HitPos ) ||
		tr4.Fraction < .8 || !ConfirmBoundary( tr4.HitPos ) ) then
		ent = nil
		ply:ChatPrint("It doesn't fit here")
		ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
		return
	else
		trace.start = pos + (ang:Forward() * min.x) + (ang:Right() * min.y)
		trace.endpos = trace.start + Vector( 0, 0, -6 )
		local tr1 = util.TraceLine( trace )
		trace.start = pos + (ang:Forward() * min.x) + (ang:Right() * max.y)
		trace.endpos = trace.start + Vector( 0, 0, -6 )
		local tr2 = util.TraceLine( trace )
		trace.start = pos + (ang:Forward() * max.x) + (ang:Right() * min.y)
		trace.endpos = trace.start + Vector( 0, 0, -6 )
		local tr3 = util.TraceLine( trace )
		trace.start = pos + (ang:Forward() * max.x) + (ang:Right() * max.y)
		trace.endpos = trace.start + Vector( 0, 0, -6 )
		local tr4 = util.TraceLine( trace )
		if (	tr1.Fraction == 1 || !ConfirmBoundary( tr1.HitPos ) ||
			tr2.Fraction == 1 || !ConfirmBoundary( tr2.HitPos ) ||
			tr3.Fraction == 1 || !ConfirmBoundary( tr3.HitPos ) ||
			tr4.Fraction == 1 || !ConfirmBoundary( tr4.HitPos ) ) then
			ent = nil
			ply:ChatPrint("It doesn't fit here")
			ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
			return
		end
	end
	
	local ent = ents.Create( "bldg_"..name )
	ent:SetPos( pos )
	ent.index = i
	ent.type = BUILDINGS
	ent.nocolor = name == "horsie"
	ent:Spawn()
	ent:Activate()
	ent:SetSpawner(ply)
	ent:SetAngles( upright and Angle( 0, 0, 0 ) or ang )
	
	ply:DeductResource("_food", food)
	ply:DeductResource("_iron", iron)
	ply:SetNWInt("_gold", ply:GetNWInt("_gold") - gold)
	
	ply:SendLua("playsound( 'sassilization/buildascend.wav', 1 )")
	SendData( ply )

	if !ply.Hints[ "BuildTip1" ] and name == "wall" then
		umsg.Start( "AddHint", ply )
			umsg.String( "BuildTip1" )
			umsg.Long( 3 )
		umsg.End()
		ply.Hints[ "BuildTip1" ] = true
	end
	if !ply.Hints[ "Upgrade" ] and (name == "workshop" || name == "tower") then
		umsg.Start( "AddHint", ply )
			umsg.String( "Upgrade" )
			umsg.Long( 3 )
		umsg.End()
		ply.Hints[ "Upgrade" ] = true
	end

end
concommand.Add( "sa_build", CreateBuilding)

function CreateUnit( ply, command, args )

	if !START then return end
	if ENDROUND then return end
	
	if #args ~= 4 then return end
	local i = tonumber( args[1] )
	if i == 0 then return end
	
	local id = ItemTranslate[name]
	
	if id then
		if (!ply.ITEMS[id] || ply.ITEMS[id] == false || ply.ITEMS[id] == 0) and !ALLOWALL then
			return
		end
	end
	
	local name = string.lower( UNITS[i].name )
	local food = UNITS[i].food
	local iron = UNITS[i].iron
	local gold = UNITS[i].gold
	local supply = UNITS[i].supply
	local min = UNITS[i].OBBMins
	local max = UNITS[i].OBBMaxs
	local size = UNITS[i].size
	local upright = UNITS[i].upright
	local vec = Vector( 0,0,0 )
	local waterbase = UNITS[i].waterbase
	local water = false
	vec.x = tonumber( args[2] )
	vec.y = tonumber( args[3] )
	vec.z = tonumber( args[4] )
	
	if ply:GetNWInt("_supplied") + supply > math.Min( ply:GetNWInt("_supply"), unit_limit ) then
		ply:ChatPrint( "You cannot supply this unit" )
		ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
		return
	end

	local allowed = true
	if ply:GetNWInt( "_cities" ) < 1 then
		allowed = false
	end
	if name == "archer" then
		if ply:GetNWInt( "_workshops" ) < 1 then
			allowed = false
		end
	end
	if name == "scallywag" then
		if ply:GetNWInt( "_workshops" ) < 1 then
			allowed = false
		end
	end
	if name == "galleon" then
		if ply:GetNWInt( "_workshops" ) < 1 then
			allowed = false
		end
	end
	if name == "catapult" then
		if ply:GetNWInt( "_workshops" ) < 100 then
			allowed = false
		end
	end
	if name == "ballista" then
		if ply:GetNWInt( "_workshops" ) < 100 then
			allowed = false
		end
	end
	if name == "horsie" then
		allowed = false
	end
	if !allowed then return end
	
	local trace 	= utilx.GetPlayerTrace( ply, vec ) 
 	local tr 	= util.TraceLine( trace )
	
	if tr.HitNoDraw then return end
	
	trace.mask = MASK_NPCSOLID
	local check = util.TraceLine( trace )
	if check.HitPos != tr.HitPos then
		local check = {}
		check.start = tr.HitPos + tr.HitNormal
		check.endpos = ply:EyePos()
		check.mask = MASK_NPCSOLID_BRUSHONLY
		check = util.TraceLine( check )
		if(check.HitNormal == Vector(0,0,0)) then
			return
		end
	end

	trace.mask = MASK_WATER

	local traceline = util.TraceLine(trace)

	if traceline.Hit then
		if ply:WaterLevel() >= 2 then return end
		if tr.Fraction > traceline.Fraction then
			if !waterbase then
				return
			else
				water = true
			end
		elseif tr.Fraction <= traceline.Fraction then
			if waterbase then
				return
			else
				water = false
			end
		end
	end
	
	if !waterbase then
		if !tr.Hit or tr.HitSky then return end
 		if !tr.HitWorld then return end
	elseif water then
		tr = table.Copy( traceline )
	else
		return
	end

	if not ( tr.HitNormal:Angle().p <= 300 and tr.HitNormal:Angle().p >= 240 ) then return end

	if ply:GetNWInt("_food") < food || ply:GetNWInt("_iron") < iron then
		ply:ChatPrint("You don't have enough resources: Need "..food.." food, "..iron.." iron, and "..gold.." gold." )
		ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
		return
	end
	
	local enemyTerritory = false
	local inSupply = false
	for _, ent in pairs( ents.FindInSphere(tr.HitPos, 200) ) do
		local dir = ((ent:GetPos() + Vector( 0, 0, 5 )) - (tr.HitPos + Vector( 0, 0, 5 ))):Normalize()
		trace.start = tr.HitPos
		trace.endpos = tr.HitPos + Vector(0, 0, 10 )
		trace.mask = (SOLID)
		local check = util.TraceLine( trace )
		trace.start = check.HitPos
		trace.endpos = ent:GetPos() + Vector( 0, 0, 2 )
		check = util.TraceLine( trace )
		if !check.HitWorld then

			if (	(ValidEntity( ent ))								&&
				(ent:GetClass() == "bldg_city")							||
				(ent:GetClass() == "bldg_residence")						||
				(ent:GetClass() == "bldg_workshop")						||
				(ent:GetClass() == "bldg_shrine")						||
				(ent:GetClass() == "bldg_tower")						) then
				
				if  ProvidesTerritory( ent, tr.HitPos ) and ent:IsReady() then
					if (ent:GetOverlord() == ply || (ALLIEDTERRITORIES and ply:IsAllied(ent:GetOverlord()))) then
						inSupply = true
					elseif !ply:IsAllied(ent:GetOverlord()) then
						enemyTerritory = true
					end
				end
			end
		end
	end
	if enemyTerritory and !GAMEMODE.Allbuild then
		ply:ChatPrint("Cannot create units near enemy lines.")
		ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
		return
	end
	if !inSupply then
		ply:ChatPrint("Too far from civilization!")
		ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
		return
	end
	
	local pos = tr.HitPos - tr.HitNormal * min.z
	local ang = tr.HitNormal:Angle()
	ang.p = ang.p + 90
	local trace = {}
	trace.mask = MASK_SOLID
	trace.start = pos
	trace.endpos = pos + (ang:Forward() * min.x) + (ang:Right() * min.y)
	local tr1 = util.TraceLine( trace )
	trace.mask = MASK_NPCSOLID
	local check = util.TraceLine( trace )
	if (check.HitPos != tr1.HitPos) then
		ply:ChatPrint("It doesn't fit here")
		ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
		return
	end
	trace.mask = MASK_SOLID
	trace.endpos = pos + (ang:Forward() * min.x) + (ang:Right() * max.y)
	local tr2 = util.TraceLine( trace )
	trace.mask = MASK_NPCSOLID
	local check = util.TraceLine( trace )
	if (check.HitPos != tr2.HitPos) then
		ply:ChatPrint("It doesn't fit here")
		ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
		return
	end
	trace.mask = MASK_SOLID
	trace.endpos = pos + (ang:Forward() * max.x) + (ang:Right() * min.y)
	local tr3 = util.TraceLine( trace )
	trace.mask = MASK_NPCSOLID
	local check = util.TraceLine( trace )
	if (check.HitPos != tr3.HitPos) then
		ply:ChatPrint("It doesn't fit here")
		ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
		return
	end
	trace.mask = MASK_SOLID
	trace.endpos = pos + (ang:Forward() * max.x) + (ang:Right() * max.y)
	local tr4 = util.TraceLine( trace )
	trace.mask = MASK_NPCSOLID
	local check = util.TraceLine( trace )
	if (check.HitPos != tr4.HitPos) then
		ply:ChatPrint("It doesn't fit here")
		ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
		return
	end
	trace.mask = MASK_SOLID
	
	if (	tr1.Hit and (tr1.HitNormal:Angle().p > 300 || tr1.HitNormal:Angle().p < 240) || !ConfirmBoundary( tr1.HitPos ) ||
		tr2.Hit and (tr2.HitNormal:Angle().p > 300 || tr2.HitNormal:Angle().p < 240) || !ConfirmBoundary( tr2.HitPos ) ||
		tr3.Hit and (tr3.HitNormal:Angle().p > 300 || tr3.HitNormal:Angle().p < 240) || !ConfirmBoundary( tr3.HitPos ) ||
		tr4.Hit and (tr4.HitNormal:Angle().p > 300 || tr4.HitNormal:Angle().p < 240) || !ConfirmBoundary( tr4.HitPos ) ) then
		ent = nil
		ply:ChatPrint("It doesn't fit here")
		ply:SendLua("playsound( 'sassilization/warnmessage.wav', 1 )")
		return
	end
	
	if size then
		local blocked = false
		local units = ents.FindByClass( "unit_*" )
		for _, ent in pairs( units ) do
			if ValidEntity( ent ) and ent:IsUnit() and !ent:IsDead() then
				if ent:GetPos():Distance( pos ) <= size then
					blocked = true
					break
				end
			end
		end
		if blocked then
			ply:ChatPrint("It doesn't fit here")
			return
		end
	end

	local ent = ents.Create( "unit_"..name )
	local ang = tr.HitNormal:Angle()
	ang.p = ang.p + 90
	if upright then
		ent:SetAngles( Angle( 0, 0, 0 ) )
	else
		ent:SetAngles( ang )
	end
	ent:SetPos( pos )
	ent.waterbase = waterbase
	ent.spawnpos = pos
	ent.index = i
	ent:Spawn()
	ent:Activate()
	ent:GetPhysicsObject():SetMaterial( "sass_slide" )
	ent:SetSpawner(ply)

	ply:DeductResource("_food", food)
	ply:DeductResource("_iron", iron)
	ply:SetNWInt("_gold", ply:GetNWInt("_gold") - gold)

	if !ply.Hints[ "UnitSelect1" ] then
		umsg.Start( "AddHint", ply )
			umsg.String( "UnitSelect1" )
			umsg.Long( 3 )
		umsg.End()
		ply.Hints[ "UnitSelect1" ] = true
	end

end
concommand.Add( "sa_spawn", CreateUnit)

function privateAlliance( sender, command, args )
	
	if !ALLIANCES then return end
	if !args[2] then return end
	local receiver = nil
	local status = args[2]
	if status == "true" then
		status = true
	elseif status == "false" then
		status = false
	else
		return
	end
	
	if !alliances[sender] then return end
	sender:SetNWInt("Allies", #alliances[sender])

	if status and #alliances[sender] >= ally_limit then
		sender:ChatPrint("You can't make this many alliances")
		return
	end

	for k, v in pairs(player.GetAll()) do
		if v:UserID() == tonumber(args[1]) and ValidEntity(v) then
			receiver = v
		end
	end

	if receiver == sender then return end
	if !receiver then return end

	local ral = #alliances[receiver]
	local sal = #alliances[sender]

	if receiver:GetNWBool("Ally "..sender:UserID()) == true then ral = ral - 1 end

	if status and sal + ral >= ally_limit then
		sender:ChatPrint("An alliance this big is not permitted.")
		return
	end

	local function Align( p1, p2 )
		if p1 == p2 then return end
		if ValidEntity( p1 ) && ValidEntity( p2 ) then
			p1:SetNWBool("Ally "..p2:UserID(), true)
			p2:SetNWBool("Ally "..p1:UserID(), true)
			if !table.HasValue( alliances[p1] or {}, p2 ) then
				table.insert( alliances[p1], p2 )
			end
			if !table.HasValue( alliances[p2] or {}, p1 ) then
				table.insert( alliances[p2], p1 )
			end
			p1:SetNWInt( "Allies", #alliances[p1] )
			p1:SendLua( "AddHistory( 0, 'An Alliance has been formed', 4 )" )
		end
	end
	local function Unalign( p1, p2 )
		if p1 == p2 then return end
		if ValidEntity( p1 ) && ValidEntity( p2 ) then
			p1:SetNWBool("Ally "..p2:UserID(), false)
			p2:SetNWBool("Ally "..p1:UserID(), false)
		end
		for k, pl in pairs(alliances[p1] or {}) do
			if pl == p2 then
				table.remove( alliances[p1], k )
				break
			end
		end
		for k, pl in pairs(alliances[p2] or {}) do
			if pl == p1 then
				table.remove( alliances[p2], i )
				break
			end
		end
		p1:SetNWInt( "Allies", #alliances[p1] )
		p1:SendLua( "AddHistory( 0, 'An Alliance has been broken', 4 )" )
	end

	local Group = {}
	Group.players = {}
	Group.balance = {}
	Group.balance.food = 0
	Group.balance.iron = 0

	function Group:Add( pl )
		if !table.HasValue( self.players, pl ) then
			table.insert( self.players, pl )
		end
	end

	if status and !table.HasValue( alliances[sender], receiver ) then
		if table.HasValue( alliances[receiver], sender ) then --If the receiver is already allied
			if ral > 0 then --If the receiver has other allies
				for _, pl in pairs( alliances[receiver] ) do
					if table.HasValue( alliances[pl], receiver ) then
						Align( pl, sender )
						Group:Add( pl )
					else
					end
				end
			end
			if sal > 0 then
				for _, pl in pairs( alliances[sender] ) do
					if table.HasValue( alliances[pl], sender ) then
						Align( pl, receiver )
						Group:Add( pl )
					else
					end
				end
			end
			Align( receiver, sender )
			Group:Add( sender )
			Group:Add( receiver )
			sender:SetNWInt("Allies", #alliances[sender])
		else
			sender:SendLua( "AddHistory( 0, 'You have offered an alliance', 4 )" )
			receiver:SendLua( "AddHistory( 0, 'You have been offered an alliance', 4 )" )
			sender:SetNWBool("Ally "..receiver:UserID(), true)
			table.insert( alliances[sender], receiver )
			sender:SetNWInt("Allies", #alliances[sender])
			return
		end
	elseif !status and table.HasValue( alliances[sender], receiver ) then
		if table.HasValue( alliances[receiver], sender ) then --If the receiver was allied
			for _, pl in pairs( alliances[receiver] ) do
				Unalign( pl, sender )
				Group:Add( pl )
			end
			Unalign( receiver, sender )
			Group:Add( sender )
			Group:Add( receiver )
			sender:SetNWInt("Allies", #alliances[sender])
		else
			sender:ChatPrint("You have broke an alliance")
			sender:SetNWBool("Ally "..receiver:UserID(), false)
			for i=1, #alliances[sender] do
				if alliances[sender][i] == receiver then
					table.remove( alliances[sender], i )
					break
				end
			end
			sender:SetNWInt("Allies", #alliances[sender])
			return
		end
	end
	
	if !ALLIEDRESOURCES then return end
	
	for _, ply in pairs( Group.players ) do
		if ply and ply:IsPlayer() then
			Group.balance.food = Group.balance.food + ply:GetNWInt("_food")
			Group.balance.iron = Group.balance.iron + ply:GetNWInt("_iron")
		end
	end

	Group.balance.food = Group.balance.food / #Group.players
	Group.balance.iron = Group.balance.iron / #Group.players

	for _, ply in pairs( Group.players ) do
		if ply and ply:IsPlayer() then
			ply:SendLua( "AddHistory( 0, 'Balanced Resources', 3 )" )
			ply:SetResource("_food", Group.balance.food )
			ply:SetResource("_iron", Group.balance.iron )
		end
	end
	
end
concommand.Add( "sa_pally", privateAlliance)



function SendData( ply, command, args )
	if !(ValidEntity(ply) and ply:IsPlayer()) then return end
	ply.ITEMS = ply.ITEMS or {}
	ply.ITEMS.archertowers = ply.ITEMS.archertowers or 0
	ply.ITEMS.workshop = ply.ITEMS.workshop or 0
	ply.ITEMS.hotgroups = ply.ITEMS.hotgroups or 0
	ply.ITEMS.gravitate = ply.ITEMS.gravitate or 0
	ply.ITEMS.bombard = ply.ITEMS.bombard or 0
	ply.ITEMS.heal = ply.ITEMS.heal or 0
	ply.ITEMS.decimation = ply.ITEMS.decimation or 0
	ply.ITEMS.paralysis = ply.ITEMS.paralysis or 0
	umsg.Start( "itemData", ply )
		umsg.Short( ply.ITEMS.hotgroups )
		umsg.Short( ply.ITEMS.archertowers )
		umsg.Short( ply.ITEMS.workshop )
		umsg.Bool( ply.ITEMS.monolith )
		umsg.Bool( ply.ITEMS.shrine )
		umsg.Bool( ply.ITEMS.gate )
		umsg.Bool( ply.ITEMS.archer )
		umsg.Bool( ply.ITEMS.catapult )
		umsg.Bool( ply.ITEMS.ballista )
		umsg.Bool( ply.ITEMS.scallywag )
		umsg.Bool( ply.ITEMS.galleon )
		umsg.Short( ply.ITEMS.gravitate )
		umsg.Short( ply.ITEMS.bombard )
		umsg.Short( ply.ITEMS.heal )
		umsg.Short( ply.ITEMS.decimation )
		umsg.Bool( ply.ITEMS.blast )
		umsg.Short( ply.ITEMS.paralysis )
		umsg.Bool( ply.ITEMS.plummet )
	umsg.End()
end
concommand.Add( "sa_~_retrieve", SendData)

function Select_cc( ply, command, args )
	if #args ~= 1 then return end
	local index = tonumber( args[1] )
	local allowed = true
	if UNITS[index].name == "Archer" then
		if ply:GetNWInt( "_workshops" ) < 1 or !ply.ITEMS.archer then
			allowed = false
		end
	end
	if UNITS[index].name == "Catapult" then
		if ply:GetNWInt( "_workshops" ) < 100 or !ply.ITEMS.catapult then
			allowed = false
		end
	end
	if allowed then
		ply:SetNWInt( "_uid", index )
	end
end
concommand.Add( "sa_selectunit", Select_cc)

function Status_cc( ply, command, args )
	ply:PrintMessage(2, "Sassilization Player Stats")
	for _, pl in pairs( player.GetAll() ) do
		ply:PrintMessage(2, "Player: "..pl:Nick() )
		ply:PrintMessage(2, "Food: "..pl:GetNWInt("_food") )
		ply:PrintMessage(2, "Iron: "..pl:GetNWInt("_iron") )
		ply:PrintMessage(2, "Gold: "..pl:GetNWInt("_gold") )
	end
end
concommand.Add( "sa_status", Status_cc)

function GetStats_cc( ply, command, args )
	if !args || !args[1] then return end
	local user = ply
	for k, v in pairs(player.GetAll()) do
		if(v:UserID() == tonumber(args[1])) then
			user = v
		end
	end
	if user == ply then return end
	umsg.Start( "sendData", ply )
		umsg.Short( user:UserID() )
		umsg.Long( user:GetNWInt("_food") )
		umsg.Long( user:GetNWInt("_iron") )
		umsg.Long( user:GetNWInt("_soldiers") )
		umsg.Long( user:GetMoney() )
	umsg.End()
end
concommand.Add( "sa_getstats", GetStats_cc)

function ToggleHints_cc( pl, command, args )
	local show = pl:GetNWInt("showhelp")
	if show == 0 then
		pl:SetNWInt("showhelp", 1)
	else
		pl:SetNWInt("showhelp", 0)
	end
end
concommand.Add( "togglehints", ToggleHints_cc )

function ToggleTitle_cc( pl, command, args )
	pl:SetNWBool("hidetitle", !pl:GetNWBool("hidetitle"))
end
concommand.Add( "sa_disguise", ToggleTitle_cc )