--Include shared lua files
include( 'shared.lua' )
--include( 'gatekeeper.lua' )
AddCSLuaFile( "cl_init.lua" )


AddCSLuaFile( "shared.lua" )

	--[[	for _, file in pairs(file.Find('../gamemodes/' .. GM.Path .. '/gamemode/client/*') || {} ) do
			if string.find(file,".lua") then
				AddCSLuaFile('client/'..file)
			end
		end
		for _, file in pairs(file.Find('../gamemodes/' .. GM.Path .. '/gamemode/shared/*') || {}) do
			if string.find(file,".lua") then
				AddCSLuaFile('shared/'..file)
				print(include('shared/'..file)
			end
		end
		for _, file in pairs(file.Find('../gamemodes/' .. GM.Path .. '/gamemode/server/*') || {} ) do
			if string.find(file,".lua") then
				include('server/'..file)
			end
		end]]

--AutoAdd_LuaFiles()
AddCSLuaFile('client/voice.lua')
-- if string.lower(game.GetMap()) == "rp_evocity_v2d" then
-- AddCSLuaFile('client/weather.lua')
-- end
AddCSLuaFile('client/hints.lua')
AddCSLuaFile('client/buddies.lua')
AddCSLuaFile('client/cars.lua')
--AddCSLuaFile('client/challenges.lua')
AddCSLuaFile('client/panels.lua')
AddCSLuaFile('client/chatbox.lua')
AddCSLuaFile('client/crafting.lua')
AddCSLuaFile('client/hud.lua')
AddCSLuaFile('client/identification.lua')
AddCSLuaFile('client/intro.lua')
AddCSLuaFile('client/inventory.lua')
AddCSLuaFile('client/mainmenu.lua')
AddCSLuaFile('client/mayor.lua')
AddCSLuaFile('client/npc_talk.lua')
AddCSLuaFile('client/orgs.lua')
AddCSLuaFile('client/professions.lua')
AddCSLuaFile('client/property.lua')
AddCSLuaFile('client/rp_main.lua')
AddCSLuaFile('client/rp_start.lua')
AddCSLuaFile('client/scoreboard.lua')
AddCSLuaFile('client/shops.lua')
AddCSLuaFile('client/skills.lua')
AddCSLuaFile('client/searching.lua')
AddCSLuaFile('client/trading.lua')
AddCSLuaFile('client/looting.lua')
AddCSLuaFile('client/chief.lua')
AddCSLuaFile('client/disguise.lua')
AddCSLuaFile('shared/sh_cars.lua')
include('shared/sh_cars.lua')
--AddCSLuaFile('shared/sh_challenges.lua')
--include('shared/sh_challenges.lua')
AddCSLuaFile('shared/sh_config.lua')
include('shared/sh_config.lua')
AddCSLuaFile('shared/sh_crafting.lua')
include('shared/sh_crafting.lua')
AddCSLuaFile('shared/sh_items.lua')
include('shared/sh_items.lua')
AddCSLuaFile('shared/sh_mayor_events.lua')
include('shared/sh_mayor_events.lua')
AddCSLuaFile('shared/sh_chief_items.lua')
include('shared/sh_chief_items.lua')
AddCSLuaFile('shared/sh_mayor_items.lua')
include('shared/sh_mayor_items.lua')
AddCSLuaFile('shared/sh_models.lua')
include('shared/sh_models.lua')
AddCSLuaFile('shared/sh_shops.lua')
include('shared/sh_shops.lua')
AddCSLuaFile('shared/sh_skills.lua')
include('shared/sh_skills.lua')
include('server/Storage.lua')
include('server/buddies.lua')
include('server/cars.lua')
--include('server/challenges.lua')
include('server/chat.lua')
include('server/blacklist.lua')
include('server/crafting.lua')
--include('server/weather.lua')
--include('server/time.lua')
include('server/database.lua')
include('server/death.lua')
include('server/inventory.lua')
include('server/jobs.lua')
include('server/searching.lua')
include('server/loading.lua')
include('server/map.lua')
include('server/mayor_events.lua')
include('server/chief.lua')
include('server/messages.lua')
include('server/money.lua')
include('server/newuser.lua')
include('server/npcs.lua')
include('server/orgs.lua')
include('server/player.lua')
include('server/player_models.lua')
include('server/professions.lua')
include('server/property.lua')
include('server/saving.lua')
include('server/shops.lua')
include('server/skills.lua')
include('server/trading.lua')
include('server/afkmanagement.lua')
include('server/looting.lua')
include('server/disguise.lua')
--include('server/day_night.lua')

function Map_Initialize()

timer.Simple(0.01, function()
		for _,obj in pairs(ents.FindByClass("item_healthcharger")) do
			obj:Remove()
		end
		for _,obj in pairs(ents.FindByClass("prop_physics*")) do
			obj:Remove()
		end
		for _,obj in pairs(ents.FindByClass("func_brush")) do
			obj:Remove()
		end
		---------------- DONT EVEN LOOK AT THIS CODE IT MESSES UP WAAAAY TO EASY
		if GAMEMODE.Maps[string.lower(tostring(game.GetMap()))] !=  nil then
			for key,data in pairs(GAMEMODE.Maps[string.lower(tostring(game.GetMap()))].AddObjs) do
				local obj = ents.Create(data.Class)
				if obj == NULL then break; end
				if data.Model then
					obj:SetModel(data.Model)
				end
				if data.Skin then
					obj:SetSkin(data.Skin)
				end
				obj:SetPos(data.Pos)
				obj:SetAngles(data.Angles)
				obj:Spawn()
				if data.Activate then
					obj:Activate() -- enables physics
				end
			end
			for _,entity in pairs(ents.FindByClass("prop_door_rotating")) do
					entity:SetNWBool("UnLocked",true)
					entity.Permissions = {}
					entity.Permissions["Buddies"] = false
					entity.Permissions["Org"] = false
					entity.Permissions["Goverment"] = true
					entity.Permissions["Mayor"] = true
					entity.PadLock = nil
			end
			for _,entity in pairs(ents.FindByClass("func_door")) do
					entity:SetNWBool("UnLocked",true)
					entity.Permissions = {}
					entity.Permissions["Buddies"] = false
					entity.Permissions["Org"] = false
					entity.Permissions["Goverment"] = true
					entity.Permissions["Mayor"] = true
					entity.PadLock = nil
			end	
			for _,entity in pairs(ents.FindByClass("func_door_rotating")) do
					entity:SetNWBool("UnLocked",true)
					entity.Permissions = {}
					entity.Permissions["Buddies"] = false
					entity.Permissions["Org"] = false
					entity.Permissions["Goverment"] = true
					entity.Permissions["Mayor"] = true
					entity.PadLock = nil
			end					
			for key,vector in pairs(GAMEMODE.Maps[string.lower(tostring(game.GetMap()))].RemoveVectors) do
				for _,removeobj in pairs(ents.FindInSphere(vector,5)) do
					if removeobj:IsValid() then
						removeobj:Remove()
						break
					end
				end
			end		
			for key,vector in pairs(GAMEMODE.Maps[string.lower(tostring(game.GetMap()))].UnOwnable) do
				for _,removeobj in pairs(ents.FindInSphere(vector,5)) do
					if removeobj:IsValid() then
						removeobj.UnOwnable = -1
						removeobj.Permissions = {}
						removeobj.Permissions["Buddies"] = false
						removeobj.Permissions["Org"] = false
						removeobj.Permissions["Goverment"] = true
						removeobj.Permissions["Mayor"] = true
						break
					end
				end
			end
			for key,vector in pairs(GAMEMODE.Maps[string.lower(tostring(game.GetMap()))].ActUnOwnable) do
				for _,removeobj in pairs(ents.FindInSphere(vector,5)) do
					if removeobj:IsValid() then
						removeobj.UnOwnable = -4
						removeobj.Permissions = {}
						removeobj.Permissions["Buddies"] = false
						removeobj.Permissions["Org"] = false
						removeobj.Permissions["Goverment"] = false
						removeobj.Permissions["Mayor"] = false
						break
					end
				end
			end
			for key,vector in pairs(GAMEMODE.Maps[string.lower(tostring(game.GetMap()))].Police) do
				for _,removeobj in pairs(ents.FindInSphere(vector,5)) do
					if removeobj:IsValid() then
						removeobj.UnOwnable = -2
						removeobj.Permissions = {}
						removeobj.Permissions["Buddies"] = false
						removeobj.Permissions["Org"] = false
						removeobj.Permissions["Goverment"] = true
						removeobj.Permissions["Mayor"] = true
						break
					end
				end
			end
			for key,vector in pairs(GAMEMODE.Maps[string.lower(tostring(game.GetMap()))].Public) do
				for _,removeobj in pairs(ents.FindInSphere(vector,5)) do
					if removeobj:IsValid() then
						removeobj.UnOwnable = -3
						removeobj.Permissions = {}
						removeobj.Permissions["Buddies"] = false
						removeobj.Permissions["Org"] = false
						removeobj.Permissions["Goverment"] = false
						removeobj.Permissions["Mayor"] = false
						break
					end
				end
			end
			for key,vector in pairs(GAMEMODE.Maps[string.lower(tostring(game.GetMap()))].Locked) do
				for _,removeobj in pairs(ents.FindInSphere(vector,5)) do
					if removeobj:IsValid() then
						removeobj:SetNWBool("UnLocked",false)
						removeobj:Fire("Lock")
						break
					end
				end
			end
			if GAMEMODE.Maps[string.lower(tostring(game.GetMap()))].Function != nil then
				GAMEMODE.Maps[string.lower(tostring(game.GetMap()))].Function()
			end	
		end		
		if GAMEMODE.Properties[string.lower(tostring(game.GetMap()))] != nil then
			for key,data in pairs(GAMEMODE.Properties[string.lower(tostring(game.GetMap()))]) do
				for _,vector in pairs(data.PropVectors) do
					for _,entity in pairs(ents.FindInSphere(vector,5)) do
						if entity:IsValid() && entity:IsDoor() then
							entity.Propertykey = key
							break
						end
					end
				end
			end
		end
		game.ConsoleCommand("ai_ignoreplayers 1")
		game.ConsoleCommand("mp_falldamage 1")
		end)
end
hook.Add( "Initialize", "Map_Initialize", Map_Initialize );
if !SinglePlayer then
		GM.Jails = GM.Maps[string.lower(tostring(game.GetMap()))].Jails

		GM.SpawnsPolice = GM.Maps[string.lower(tostring(game.GetMap()))].SpawnsPolice

		GM.SpawnsMedic = GM.Maps[string.lower(tostring(game.GetMap()))].SpawnsMedic

		GM.SpawnsCitizen = GM.Maps[string.lower(tostring(game.GetMap()))].SpawnsCitizen

		--[[		GM.SpawnsUnJail = {
			{Position = Vector(-7391, -6681, 136), Ang = Angle(0, -179, 0)},	
			{Position = Vector(-7391, -6568, 136), Ang = Angle(0, -179, 0)},	
			{Position = Vector(-7892, -6455, 136), Ang = Angle(0, -179, 0)},	
			{Position = Vector(-7893, -6331, 136), Ang = Angle(0, -179, 0)},
		}]]--
		
		GM.SpawnsCar = GM.Maps[string.lower(tostring(game.GetMap()))].SpawnsCar
end

local ClientResources = 0;
local function ProcessFolder ( Location )
	for k, v in pairs(file.Find(Location .. '*')) do
			if file.IsDir(Location .. v) then
				ProcessFolder(Location .. v .. '/')
			else
				local OurLocation = string.gsub(Location .. v, '../gamemodes/' .. GM.Path .. '/content/', '')
				if !string.find(Location, '.db') then			
					ClientResources = ClientResources + 1;
					resource.AddFile(OurLocation);
				end
			end
	end
end

if !SinglePlayer() then
	ProcessFolder('../gamemodes/' .. GM.Path .. '/content/models/');
	ProcessFolder('../gamemodes/' .. GM.Path .. '/content/materials/');
	ProcessFolder('../gamemodes/' .. GM.Path .. '/content/sound/');
	ProcessFolder('../gamemodes/' .. GM.Path .. '/content/resource/');
end

/*timer.Simple(5, function()
	if string.lower(game.GetMap()) == "rp_evocity2_v2p" then
		local newsent = ents.Create("news")
		newsent:SetPos( Vector(-567,-2448,182) )
		newsent:SetAngles( Angle( 0, 90, 0 ) )
		newsent:Spawn()
		
		local ocrplogoent = ents.Create("ocrp_logo")
		ocrplogoent:SetPos( Vector(-714,555,247) )
		ocrplogoent:SetAngles( Angle( 0, 0, 0 ) )
		ocrplogoent:Spawn()
	elseif string.lower(game.GetMap()) == "rp_cosmoscity_v1b" then
	--[[	local newsent = ents.Create("news")
		newsent:SetPos( Vector(-567,-2448,182) )
		newsent:SetAngles( Angle( 0, 90, 0 ) )
		newsent:Spawn() ]]--
		
		local ocrplogoent = ents.Create("ocrp_logo")
		ocrplogoent:SetPos( Vector(5, -5, 372) )
		ocrplogoent:SetAngles( Angle( 0, 0, 0 ) )
		ocrplogoent:Spawn()	
		
		local ocrplogoent1 = ents.Create("ocrp_logo")
		ocrplogoent1:SetPos( Vector(5, -5, 372) )
		ocrplogoent1:SetAngles( Angle( 0, 180, 0 ) )
		ocrplogoent1:Spawn()	
	else
		local newsent = ents.Create("news")
		newsent:SetPos( Vector(-7189, -9231, 240) )
		newsent:SetAngles( Angle( 0, 90, 0 ) )
		newsent:Spawn()

		local ocrplogoent = ents.Create("ocrp_logo")
		ocrplogoent:SetPos( Vector(-3575, -6487, 362 ) )
		ocrplogoent:SetAngles( Angle( 0, 0, 0 ) )
		ocrplogoent:Spawn()
	end
end)*/
include( "shared/sh_challenges.lua" )

local RadioStations = {};

function AddRadio( Name, URL )
	table.insert(RadioStations, {Name, URL})
end

function ChangeRadio( ply )
	local Radio
		
	if ply:InVehicle() then

		if ply:GetVehicle().NotDriver then
			return false
		end
	
		Radio = ply:GetVehicle()
	end
	
	if !Radio then
		local EyeTrace = ply:GetEyeTrace();
		
		if !IsValid(EyeTrace.Entity) then
			ply:Hint("Look at a radio to change the station.")
			return false;
		end
		
		if EyeTrace.Entity:GetModel() != 'models/props/cs_office/radio.mdl' then
			ply:Hint("This is not a radio.")
			return false;
		end
		
		if EyeTrace.HitPos:Distance(ply:GetShootPos()) >= 200 then
			ply:Hint("You need to be closer to change the station.")
			return false;
		end
		
		if ply != player.GetByID(EyeTrace.Entity:GetNWInt("Owner")) then
			ply:Hint("You need to be the owner of this radio to change station.")	
			return false
		end
		
		Radio = EyeTrace.Entity;
	end
	 
	local CurStation = Radio:GetNetworkedInt('ocrp_station', 0);
	
	local NewStation = CurStation + 1;
	if NewStation > table.Count(RadioStations) then NewStation = 0; end
	
	if NewStation == 0 then
		umsg.Start('ocrp_radio', ply);
			umsg.String('Off');
		umsg.End();
	else
		umsg.Start('ocrp_radio', ply);
			umsg.String(RadioStations[NewStation][1]);
		umsg.End();
	end
	
	Radio:SetNetworkedInt('ocrp_station', NewStation);
end

AddRadio('92.1 Buzz', 'http://scfire-mtc-aa05.stream.aol.com:80/stream/1022');
AddRadio("94.5 JazzNation", "http://sj128.hnux.com");
AddRadio('97.7 Hitz', 'http://scfire-dtc-aa02.stream.aol.com:80/stream/1074');
AddRadio('98.5 Dubstep FM', 'http://www.dubstep.fm/listen.pls');
AddRadio('100.1 Top 100 Germany', 'http://188.72.209.72:80'); 
AddRadio("102.6 GoldSkool 50-60", 'http://208.53.158.48:8362');
AddRadio('103.4 Cosmos FM', 'http://208.115.201.98:9988');
AddRadio("105.1 Super 90's", 'http://uplink.duplexfx.com:8012/');
AddRadio("106.4 BoomJah FM", "http://174.37.61.231:8098");
AddRadio("107.2 Reggae Roots", 'http://91.121.150.156:7002/');
AddRadio('108.1 Hot Jamz', 'http://scfire-mtc-aa02.stream.aol.com:80/stream/1071');
GM.SnowOnGround = true;
