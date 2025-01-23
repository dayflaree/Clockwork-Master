require( "tmysql" )

nextcheck = 0

function ResetPassword()
	
	local pass = GeneratePassword()
	print("Changing the server's Password to: "..pass)
	tmysql.query("UPDATE sa_servers SET password=\'"..pass.."\' WHERE sid="..SERVERID)
	RunConsoleCommand("sv_password",pass)
	
end

function ResetServerStatus()
	
	for i,v in pairs(player.GetAll()) do
		v:ConCommand("connect "..LOBBYIP.. ":"..LOBBYPORT)
	end
	
	UpdateOnlinePlayers()
	ResetPassword()
	tmysql.query("UPDATE sa_servers SET map=\'"..game.GetMap().."\', status=\'ready\' WHERE sid="..SERVERID)
	tcpSend(LOBBYIP,DATAPORT,tostring("UPDATESTATUS:"..SERVERID.."|ready|"..game.GetMap().."\n"))
	
end

hook.Add("Initialize","DBCONNECT",function()
	
	tmysql.initialize("localhost", "root", "5a55111z4710n", "main", 3306, 3, 2)
	UpdateBans()
	InitServerList()
	
end)

function GeneratePassword()
	local str = "";
	while string.len(str) < 6 do
		local int = math.random(97,122); --lowercase alphabet chars plox
		local stradd = string.char(int);
		str = str .. stradd;
	end
	str = "~_~"..str;
	GAMEMODE.password = str;
	return str;
end

local META = FindMetaTable( "Player" )
if (!META) then return end

function META:SetSetting( key, value )
	
	if !self.settings then return end
	
	self.settings[key] = value
	return self.settings[key]
	
end

function META:GetSetting( key, default )
	
	if !self.settings then return end
	
	if self.settings[ key ] then
		return self.settings[ key ]
	elseif default then
		return self:SetSetting( key, default )
	else return end
	
end

local function ProfileLoaded( pl, steamid, name, info, status, error)
	
	if !ValidEntity( pl ) and pl:IsPlayer() then return end
	if pl.loaded then return end
	
	/*if status == 0 then
		
		print( "Cannot connect to "..name.."'s profile, sending him back to the lobby" )
		pl:Reject()
		Error( error )
		
	elseif error != 0 then
		
		timer.Simple( 5, function( pl )
			if ValidEntity( pl ) and pl:IsPlayer() then
				pl:LoadProfile()
			end
		end, pl )
		Error( error )
		
	end
	
	if info[1] then
		
		pl:SetNWInt(	"money",	tonumber(info[1][1]))
		
		pl:SetNWInt(	"rank", 	tonumber(info[1][2]))
		pl:SetNWInt(	"playtime",	tonumber(info[1][3]))
		pl.logins = tonumber(info[1][4])
		
		pl.settings = table.unserialize( tostring( info[1][5] ) )
		
		pl.initplaytime = CurTime()
		pl.initmoney = tonumber(info[1][1])
		tmysql.query("UPDATE sa_misc SET playername=\'"..name.."\',logins=logins, lastlogin="..os.time()..", online=1,lastserver="..SERVERID.." WHERE steamid=\'"..steamid.."\'")
		
	elseif !info[1] then
		
		print( "Cannot connect to "..name.."'s profile, sending him back to the lobby" )
		pl:Reject()
		return
		
	end
	*/
	pl.ITEMS = pl.ITEMS or {}
	
	pl.loaded = true
	if GAMEMODE.PlayerProfileLoaded then
		GAMEMODE:PlayerProfileLoaded( pl )
	end
	
	pl:LoadSassItems(steamid)
	
end

function META:LoadProfile()
	
	local steamid = self:SteamID()
	local name = tmysql.escape(self:GetName())
	print( "Connecting to "..name.."'s ("..steamid..") profile" )
	tmysql.query("SELECT money_temp,rank,playtime,logins,settings from sa_misc WHERE steamid=\'"..steamid.."\'",
		function( res, stat, err )
			ProfileLoaded(self,steamid,name,res,stat,err)
		end )

end

local function SassItemsLoaded( pl, steamid, info, status, error)
	
	if info[1] then
		local singles = {"shrine","gate","monolith","blast","plummet"}
		local bldg, unit, swep, miracle, item, name, amount
		if info[1][1] then
			local buildings = string.Explode(";",info[1][1])
			for _, bldg in pairs( buildings ) do
				item = string.Explode( "=", bldg )
				name, amount = item[1], item[2]
				if (name and name != "") then
					if table.HasValue( singles, name ) then
						pl.ITEMS[name] = tonumber( amount ) == 1 and true or false
					else
						pl.ITEMS[name] = tonumber( amount )
					end
				end
			end
		end
		if info[1][2] then
			local units = string.Explode(";",info[1][2])
			for _, unit in pairs( units ) do
				item = string.Explode( "=", unit )
				name, amount = item[1], item[2]
				if (name and name != "") then
					pl.ITEMS[name] = tonumber( amount ) == 1 and true or false
				end
			end
		end
		if info[1][3] then
			local sweps = string.Explode(";",info[1][3])
			for _, swep in pairs( sweps ) do
				item = string.Explode( "=", swep )
				name, amount = item[1], item[2]
				if (name and name != "") then
					pl.ITEMS[name] = tonumber( amount )
				end
			end
		end
		if info[1][4] then
			local miracles = string.Explode(";",info[1][4])
			for _, miracle in pairs( miracles ) do
				item = string.Explode( "=", miracle )
				name, amount = item[1], item[2]
				if (name and name != "") then
					if table.HasValue( singles, name ) then
						pl.ITEMS[name] = tonumber( amount ) == 1 and true or false
					else
						pl.ITEMS[name] = tonumber( amount )
					end
				end
			end
		end
	end
	
	SendData( pl )
	
end

function META:LoadSassItems(steamid)
	
	steamid = steamid or self:SteamID()
	tmysql.query("SELECT buildings,units,sweps,miracles from sa_misc WHERE steamid=\'"..steamid.."\'",
		function( res, stat, err )
			SassItemsLoaded(self,steamid,res,stat,err)
		end )
	
end

function UpdateOnlinePlayers()
	tmysql.query("SELECT steamid FROM sa_misc WHERE online=1 AND lastserver="..SERVERID, function( checkonline, status, error )
		if error != 0 then Error( error ) end
		str = {}
		for i=1,#checkonline do
			if !(GetBySteamID(checkonline[i][1])) then
				table.insert(str,"steamid=\'"..checkonline[i][1].."\'")
			end
		end
		str = table.concat(str," OR ")
		if str == "" then return end
		tmysql.query("UPDATE sa_misc SET online=0 WHERE "..str,1)
	end )
end

function GetBySteamID( steamid )
	for k,v in pairs(player.GetAll()) do
		if v:SteamID() == steamid then
			return v
		end
	end
end

function UpdateAll()
	local str = {}
	for i,v in ipairs(player.GetAll()) do
		local steamid = v:SteamID()
		table.insert(str,"steamid = \'"..steamid.."\'")
	end
	str = table.concat(str," OR ")
	if str != "" then
		tmysql.query("UPDATE sa_misc SET online=1 WHERE "..str)
	end
	UpdateOnlinePlayers()
end
timer.Create("updatetimer",60,0,UpdateAll)

hook.Add("PlayerDisconnected","TimerRemover", function (ply)
	
	if timer.IsTimer("pendingreload"..ply:UserID()) then
		timer.Remove("pendingreload"..ply:UserID())
		return
	end
	SaveData(ply)
	timer.Simple(3,UpdateOnlinePlayers)
	
end )

function META:AddMoney( amount, vipbonus )
	if vipbonus and self:IsVIP() then amount = math.Round(amount*VIPBONUS) end
	self:SetNWInt("money",self:GetNWInt("money")+amount)
end

function META:SubtractMoney(amount)
	self:SetNWInt("money",self:GetMoney() - amount)

end

hook.Add("PlayerInitialSpawn", "Playerinitspawn", function (ply)
	CheckBans(ply)
	ply.ITEMS = ply.ITEMS or {}
	ply:LoadProfile()
end )

function META:AddWin()
	AddWin(self)
end

function AddWin(ply)
	local steamid = ply:SteamID()
	local name = tmysql.escape(ply:GetName())
	tmysql.query("UPDATE sa_misc SET playername=\'"..name.."\',sa_wins=sa_wins+1,weekly_wins=weekly_wins+1 WHERE steamid=\'"..steamid.."\'")
end

function META:SaveData()
	SaveData(self)
end

function SaveData(ply)
	if !ply.loaded then return end
	local steamid = ply:SteamID()
	local playtime =  math.Round(CurTime() - ply.initplaytime)
	tmysql.query("UPDATE sa_misc SET money_temp=money_temp+"..(ply:GetMoney() - ply.initmoney)..", playtime=playtime+"..playtime.." WHERE steamid = \'"..steamid.."\'")
	ply.initmoney = ply:GetMoney()
	ply.initplaytime = CurTime()
	ply:PrintMessage(3,"Your Profile has been saved!")
end

function SaveAll()
	for i,v in ipairs(player.GetAll()) do
		if v.loaded then
			local steamid= v:SteamID()
			local playtime =  math.Round(CurTime() - v.initplaytime)
			tmysql.query("UPDATE sa_misc SET money_temp=money_temp+"..(v:GetMoney() - v.initmoney)..",playtime=playtime+"..playtime.." WHERE steamid = \'"..steamid.."\'")
			v.initmoney = v:GetMoney()
			v.initplaytime = CurTime()
			v:PrintMessage(3,"Your Profile has been saved!")
		end
	end
end
timer.Create("savetimer",300,0,SaveAll)



function UpdateBans()
	tmysql.query("SELECT * FROM bans WHERE uniqueid != \"\"", function(bans,status,error)
		if error != 0 then Error( error ) end
		if !(bans and bans[1]) then return end
		for _, banned in pairs( bans ) do
			local time = tonumber(banned[5])
			local uniqueid = banned[3]
			if uniqueid and uniqueid != "" then
				if time == 0 then
					game.ConsoleCommand("banid 0 "..uniqueid.."\n")
				elseif time > 0 then
					game.ConsoleCommand("banid "..math.Round((time-os.time())/60).." "..uniqueid.."\n")
				end
			end
		end
	end )
end

function CheckBans(ply)
	tmysql.query("SELECT steamid,uniqueid,expiretime,message,admin FROM bans WHERE steamid=\'"..ply:SteamID().."\'", function( bans, status, error )
		if error != 0 then Error( error ) end
		if !(bans and bans[1]) then return end
		local steamid, uniqueid, expiretime, message, admin = bans[1][1], bans[1][2], bans[1][3], bans[1][4], bans[1][5]
		if uniqueid == "" then tmysql.query("UPDATE bans SET uniqueid=\'"..ply:UniqueID().."\',lastserver="..SERVERID.." WHERE steamid=\'"..steamid.."\'") end
		if tonumber(expiretime) == 0 then
			game.ConsoleCommand("banid 0 "..ply:UniqueID().."\n")
			game.ConsoleCommand("kickid "..ply:UserID().." Banned Until: NEVER For: ( "..message.." ) By: "..admin.."\n")
		elseif tonumber(expiretime) > 0 then
			game.ConsoleCommand("banid "..math.Round((tonumber(expiretime)-os.time())/60).." "..ply:UniqueID().."\n")
			game.ConsoleCommand("kickid "..ply:UserID().." Banned Until: "..os.date("%c", tonumber(expiretime)).." For: ( "..message.." ) By: "..admin.."\n")
		end
		return true
	end )
end

local function ban( ply, target, playername, steamid, days, args, reasonstart )
	
	days = days * 86400
	local message = table.concat(args," ",reasonstart)
	if message == "" then message = "Breaking Rules" end
	message = tmysql.escape(message)
	playername = tmysql.escape(playername)
	local unixtime = os.time()
	local unbantime = unixtime + days
	tmysql.query("INSERT INTO bans (steamid,playername,expiretime,message,admin) VALUES (\'"..steamid.."\', \'"..(playername or "Unknown").."\',  \'"..(days == 0 and 0 or unbantime).."\', \'"..message.."\', \'"..(ply.SendLua and ply:GetName() or "Console").."\')")
	if target then game.ConsoleCommand("kickid "..target:UserID().." Banned Until: "..(days == 0 and "NEVER" or os.date("%c", unbantime)).." For: "..message.."\n") end
	for _, pl in pairs( player.GetAll() ) do
		pl:ChatPrint( "(ADMIN) "..(ply.SendLua and ply:GetName() or "Console").." has banned "..(playername or "Unknown").." until: "..(days == 0 and "NEVER" or os.date("%c", unbantime)).." For: "..message )
	end
	
end

function BanUser(ply,command,args)
	if ply.SendLua and (!ply:IsAdmin() || !ply:IsSuperAdmin()) then return end
	local reasonstart = 3
	if args[2] == "STEAM_0" then
		reasonstart = 7
		args[2] = table.concat( args,"",2,6 )
		print( "STEAM: "..args[2] )
	end
	if !tonumber(args[1]) then ply:ChatPrint("It is:   ban days userid/steamid") return end
	if !args[2] then ply:ChatPrint("It is:   ban days userid/steamid") return end
	local days = tonumber(args[1])
	local steamid, target, vip, playername = tostring(args[2])
	if tonumber(args[2]) then
		args[2] = tonumber( args[2] )
		ply:ChatPrint( "Attempting to ban "..args[2])
		for _, pl in pairs( player.GetAll() ) do
			if pl:UserID() == args[2] then
				steamid = pl:SteamID()
				target = pl
				break
			end
		end
		if !target then
			ply:ChatPrint( "Player not found" )
			return
		end
	else
		ply:ChatPrint( "Attempting to ban "..args[2])
		for _, pl in pairs( player.GetAll() ) do
			if pl:SteamID() == steamid then
				target = pl
				break
			end
		end
	end
	for _, id in pairs{"12454744"} do
		if string.find(steamid, id) then
			ply:ChatPrint( "This person has ban immunity!")
			return
		end
	end
	if !(target and target:IsPlayer()) then
		tmysql.query("SELECT playername,rank from sa_misc WHERE steamid=\'"..steamid.."\'",
			function( res, stat, err )
				if res[1] then
					days = tonumber(res[1][2]) >= 1 and 1 or days
					playername = tostring(res[1][1]) or nil
					ban( ply, target, playername, steamid, days, args, reasonstart )
				end
			end )
	elseif target and target:IsPlayer() then
		if target:IsVIP() then days = 1 end
		playername = target:Nick()
		ban( ply, target, playername, steamid, days, args, reasonstart )
	end
end
concommand.Add( "ban", BanUser )

