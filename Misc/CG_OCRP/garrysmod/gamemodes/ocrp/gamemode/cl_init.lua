RunConsoleCommand("gm_clearfonts")

include( 'shared.lua' )

--include('client/hints.lua')
-- if string.lower(game.GetMap()) == "rp_evocity_v2d" then
-- include('client/weather.lua')
-- end
include('shared/sh_cars.lua')
--include('shared/sh_challenges.lua')
include('shared/sh_config.lua')
include('shared/sh_crafting.lua')
include('shared/sh_items.lua')
include('shared/sh_mayor_events.lua')
include('shared/sh_mayor_items.lua')
include('shared/sh_chief_items.lua')
include('shared/sh_models.lua')
include('shared/sh_shops.lua')
include('shared/sh_skills.lua')
include('client/buddies.lua')
include('client/cars.lua')
--include('client/challenges.lua')
include('client/panels.lua')
include('client/chatbox.lua')
include('client/crafting.lua')
include('client/hud.lua')
include('client/voice.lua')
include('client/identification.lua')
include('client/intro.lua')
include('client/inventory.lua')
include('client/mainmenu.lua')
include('client/mayor.lua')
--include('client/notifications.lua')
include('client/npc_talk.lua')
include('client/orgs.lua')
include('client/professions.lua')
include('client/property.lua')
include('client/rp_main.lua')
include('client/rp_start.lua')
include('client/shops.lua')
include('client/skills.lua')
include('client/trading.lua')
include('client/searching.lua')
include('client/looting.lua')
include('client/chief.lua')
include('client/disguise.lua')

--AutoAdd_LuaFiles()

OCRP_Inventory = {WeightData = {Cur = 0,Max = 50}}
OCRP_IdentifiedPlayers = {}
OCRP_Professions = {}
GM.Orgs = {}
OCRP_MyCars = {}
OCRP_PLAYER = {}
OCRP_PLAYER["TRUNK"] = {}
OCRP_PLAYER["TRUNK"]["Items"] = {}
OCRP_PLAYER["Wardrobe"] = {}
OCRP_PLAYER["Weight"] = 0

OCRP_Skills = {Points = 20,}
for skill,_ in pairs(GM.OCRP_Skills) do
	OCRP_Skills[skill] = 0
end

OCRP_CurBroadcast = {}

OCRP_TradingInfo = {Money = 0,Items = {}}

OCRP_Options = {Color = Color(210,120,30,155)}--Color(210,120,30,155}

OCRP_DeathInfo = {}

function OCRP_GetMoney_CL( um )
	local wallet = um:ReadLong()
	local bank = um:ReadLong()
	print(wallet)
	LocalPlayer().Wallet = wallet
	LocalPlayer().Bank = bank
end
usermessage.Hook("ocrp_money", OCRP_GetMoney_CL)

function GM.KuhBewm( UMsg )
	local Entity = UMsg:ReadEntity();
	
	if !Entity or !Entity:IsValid() then return false; end
	
	local effectdata = EffectData()
		effectdata:SetOrigin( Entity:GetPos() )
	util.Effect( "kuhbewm", effectdata )
								
	local effectdata = EffectData()
		effectdata:SetOrigin( Entity:GetPos() )
	util.Effect( "Explosion", effectdata, true, true )
end
usermessage.Hook('KuhBEWMIE', GM.KuhBewm);

GM.Maps = {}
GM.Maps["rp_cosmoscity_v1b"] = {
	RemoveVectors = {},
	ActUnOwnable = {},
	UnOwnable = {
				Vector(-1586,690,123),Vector(-1815,845,132),-- Bank
				Vector(6446,990,63),Vector(6600,1358,63),Vector(6660,1358,63),--  Cosmos FM 
				Vector(-2216,166,-364),-- Sewer entrance
				Vector(-3824,32,-2),Vector(-3824,-4160,-2),-- Man Holes
	},
	Public = {Vector(2296,-399,58),Vector(2296,-432,58),Vector(2632,-432,58),Vector(2632,-399,58),-- Modern Apartment doors
			Vector(-2624,-354,61),Vector(-2693,-354,61), -- First Car dealer
			Vector(-5232,-355,62),Vector(-4804,-355,62),Vector(-5062,-1190,72),Vector(-4974,-1190,72),Vector(-4806,-1196,62),Vector(-5230,-1196,62), -- Single floor apartments
			Vector(-1897,464,91),-- bANK
			Vector(5811,-432,84),Vector(5777,-467,84),-- Police Station
			Vector(-7000,-6000,53),Vector(-7000,-5952,53),-- Art museum
			Vector(4640,-674,60),Vector(4504,-1026,60),Vector(4520,-1110,60),Vector(4420,-578,79),Vector(4188,-578,79), -- medic
			Vector(6257,2615,64),Vector(6257,2665,64),-- Gas Station
			Vector(-2715,488,60),Vector(-2646,488,60),Vector(389,2848,65),Vector(6165,426,68),

	},
	Police = {
			Vector(6616,-1312,79),Vector(6619,-1455,79),Vector(6440,-1032,79),Vector(6296,-1032,79),Vector(6152,-1032,79),Vector(6008,-1032,79),Vector(5888,-1112,79),Vector(5888,-1256,79),
			Vector(5888,-1400,79),Vector(5888,-1544,79),Vector(6084,-1592,79),Vector(6385,-1592,79),Vector(6619,-1455,79),Vector(6707,-696,84),Vector(6203,-713,84),Vector(6040,-708,84),Vector(6448,-1660,84),
			--police dep
	},
}

GM.Maps["rp_evocity_v2d"] = {
	UnOwnable = {Vector(-7992,-8929,2542),Vector(-7880,-9163,2541),Vector(-7640,-9163,2541),Vector(-6862,-9479,2542),Vector(-6830,-8915,2670),
	Vector(-5084,-9417,126),Vector(-6693,-7899,126),Vector(-6809,-7605,128),},
	ActUnOwnable = {},
	Public = {Vector(-6485,-7663,135),Vector(-6485,-7727,135),Vector(-5598,-6866,126),Vector(-5598,-6228,126),
				Vector(-7039,-6062,135),Vector(-7039,-6002,135),Vector(-6956,-4459,135),Vector(-7020,-4459,135),Vector(-5445,-4762,135),
				Vector(-5445,-4702,135),Vector(-5445,-4514,135),Vector(-5445,-4454,135),Vector(-5539,-9255,135),Vector(-5539,-9315,135),
				Vector(10602,-12424,-995),Vector(10474,-12424,-995),Vector(-6748,-8653,136),Vector(-7004,-8653,136),Vector(-7676,-8685,168),
				Vector(-7580,-8427,-280),Vector(-7232,-9489,126),Vector(-6928,-9489,-74),Vector(-4656,-7001,254),
				Vector(-4777,-9263,134),Vector(-4777,-9307,134),Vector(-4771,-9307,289),Vector(-4771,-9263,461),Vector(-8992,-9769,130),Vector(-8992,-9985,130),Vector(-9120,-9041,190),
				Vector(5784,-4373,126),Vector(4239,-4174,135),Vector(4117,-4174,135),Vector(4854,-3719,135),Vector(-4777,-9307,1670),Vector(-4777,-9263,1670),
				Vector(-3849,-6370,261),Vector(-3849,-6430,261), -- Flea market
			},


	Police = {Vector(-6560,-9185,895),Vector(-7704,-9210,894),Vector(-7704,-9104,894),Vector(-7872,-9210,894),Vector(-7872,-9104,894),Vector(-7682,-8529,-322),
			Vector(-7490,-8389,-2136),Vector(-7388,-8389,-2138),Vector(-6812,-8461,-2138),Vector(-6584,-8461,-2138),Vector(-7196,-8205,-2138),Vector(-7252,-8205,-2138),
			Vector(-7838,-7869,-2162),Vector(-7838,-8049,-2161),Vector(-6942,-7997,-2138),Vector(-6528,-7783,-2138),
			Vector(-8040,-9210,894),Vector(-8040,-9104,894),Vector(-8097,-9153,894),Vector(-6485,-7663,135),Vector(-7800,-8961,1788),Vector(-7936,-8781,1790),
			Vector(-7449,-7782,-2156), 
			},
}
GM.Maps["rp_evocity2_v2p"] = {
	UnOwnable = {Vector(1366,7,202),
	Vector(-316,-2230,522),Vector(-316,-1678,522),Vector(72,-1220,532),Vector(-61,-1220,532), // Floor one nexus offices
	Vector(-409,-2124,1802),Vector(-487,-2124,1802),Vector(-487,-1752,1802),Vector(-409,-1752,1802), // Floor two nexus offices
	Vector(-9,-1452,3849),Vector(-103,-1452,3849),Vector(-384,-1929,3849),Vector(-384,-1977,3849), // Floor three nexus offices
				},
				
	ActUnOwnable = {Vector(120,-2124,134),Vector(82,-2124,139),Vector(87,-2115,121),Vector(133,-2115,119),Vector(120,-2122,514),Vector(68,-2122,510),Vector(123,-2122,1797),Vector(82,-2122,1792),Vector(123,-2122,3838),Vector(84,-2122,3832), // Nexus Elevator doors
					Vector(3974,-2233,265),Vector(3783,-2383,275),Vector(3823,-1769,377),Vector(4069,-2223,531),Vector(4085,-2639,315), // Showers
					Vector(-296,1057,130),Vector(-295,1062,129),Vector(-233,1057,129),Vector(-233,1062,129),Vector(-255,1058,552),Vector(-279,1058,553),Vector(-251,1058,906),Vector(-281,1058,898), // sintek elevator
					Vector(359,-2174,-368),Vector(884,-2171,-368),Vector(-232,-1719,-368), // big jail doors
					Vector(462,-2073,-377),Vector(590,-2073,-377),Vector(718,-2073,-377),Vector(846,-2073,-377),Vector(846,-2272,-377),Vector(718,-2272,-377),Vector(590,-2272,-377),Vector(462,-2272,-377), // Jail cells
					Vector(930,-2474,-86), // Cop garage door
					Vector(-636,3026,148), // BK Drivethru door
					Vector(-2776,3484,42),Vector(-2552,3484,42), // Midas car lifts
					Vector(2714,858,-1704),Vector(2714,932,-1708),Vector(2247,935,-1704),Vector(2247,871,-1704), // Underground train doors
					},
	
	Public = {Vector(2037,-51,202),Vector(1975,-51,202),Vector(1911,-51,202),Vector(1849,-51,202), //Train station upper
	Vector(3740,-2146,132),Vector(3740,-2086,132), // apartments front
	Vector(2580,-1568,138),Vector(2580,-1632,138), // car dealer
	Vector(3739,427,130),Vector(4147,634,583), // old casino building from perp
	Vector(3795,2436,194), // Slums entrance
	Vector(4,2860,139),Vector(4,2796,139),Vector(-255,3434,130), // Burger King
	Vector(-711,610,139),Vector(-711,670,139), // Sintek
	Vector(-748,-1452,138),Vector(-700,-1452,138),Vector(-468,-1452,138),Vector(-420,-1452,138), // GC Main entrance
	Vector(-2412,1052,139),Vector(-2412,988,139),Vector(-2514,892,139),Vector(-2450,892,139),Vector(-2412,760,130),Vector(-2690,756,130),Vector(-2814,388,139),Vector(-2705,532,130),Vector(-2705,484,130),Vector(-2862,756,130),// Hospital
	Vector(-2882,-1028,130), // Ace Hardware
	Vector(-2438,-1653,139),Vector(-2498,-1653,139),Vector(-2786,-1376,130), // Clothes store
	Vector(7962,7150,133),Vector(7962,7210,133),Vector(8304,7930,133),Vector(8373,7930,133), // Train station @ cubs
	Vector(-7388,1246,202),Vector(-7395,866,203),Vector(-7395,1038,203), // Sinclair Gas
	Vector(1784,108,203),Vector(1784,156,203), // Bank
	Vector(-7139,13637,252), // bar
	Vector(1057,962,139),Vector(1057,1022,139), // City Building
	Vector(3893,-1925,128),Vector(3869,-2307,126), // Furniture/bookstore
	},

	--[[Vector(4854,-3719,135),Vector(-4777,-9307,1670),Vector(-4777,-9263,1670),
	Vector(-3849,-6370,261),Vector(-3849,-6430,261), -- Flea market ]]--


	Police = {Vector(-522,-1460,-374),Vector(-570,-1460,-374),Vector(-600,-1530,-374),Vector(-664,-1817,-374),Vector(-213,-2104,-374),Vector(340,-2687,-374),Vector(340,-2735,-374),Vector(1006,-1941,-377),Vector(-187,-2082,-369),},
}

GM.Maps["rp_cosmoscity"] = {
	UnOwnable = {},
	Public = {},
	Police = {},
}
function GM:InitPostEntity() 

GLOBAL_EMITTER = ParticleEmitter(Vector(0, 0, -5000));
end

-- function SprintDecay(ply, data)
	-- if ply:KeyDown(IN_SPEED) && ply:OnGround() then
		-- if math.abs(data:GetForwardSpeed()) > 0 || math.abs(data:GetSideSpeed()) > 0 then
			-- data:SetMoveAngles(data:GetMoveAngles())
			-- data:SetSideSpeed(data:GetSideSpeed()* 0.1)
			-- data:SetForwardSpeed(data:GetForwardSpeed())
		-- end
	-- end
-- end
-- hook.Add("Move", "SprintDecay1",  SprintDecay)

function GM:Initialize()
	FireEmitter = ParticleEmitter(Vector(0, 0, 0));
	SmokeEmitter = ParticleEmitter(Vector(0, 0, 0));
	SmokeEmitter:SetNearClip(50, 200);
	timer.Simple(5,function() 
		if GAMEMODE.Maps[string.lower(game.GetMap())] != nil then
				--[[for key,vector in pairs(GAMEMODE.Maps[string.lower(tostring(game.GetMap()))].UnOwnable) do
					for _,removeobj in pairs(ents.FindInSphere(vector,5)) do
						if removeobj:IsValid() then
							removeobj.UnOwnable = -1
							break
						end
					end
				end
				for key,vector in pairs(GAMEMODE.Maps[string.lower(tostring(game.GetMap()))].Police) do
					for _,removeobj in pairs(ents.FindInSphere(vector,5)) do
						if removeobj:IsValid() then
							removeobj.UnOwnable = -2
							break
						end
					end
				end
				for key,vector in pairs(GAMEMODE.Maps[string.lower(tostring(game.GetMap()))].Public) do
					for _,removeobj in pairs(ents.FindInSphere(vector,5)) do
						if removeobj:IsValid() then
							removeobj.UnOwnable = -3
							break
						end
					end
				end
			if GAMEMODE.Properties[string.lower(tostring(game.GetMap()))] != nil then
				for key,data in pairs(GAMEMODE.Properties[string.lower(tostring(game.GetMap()))]) do
					for _,vector in pairs(data.PropVectors) do
						for _,entity in pairs(ents.FindInSphere(vector,5)) do
							if entity:IsValid() then
								entity.Propertykey = key
								break
							end
						end
					end
				end
			end]]
		end
	end)
	if !file.Exists("OCRP/Intro.txt") then
		INTRO = true
		GAMEMODE:Intro_Start()
	end
--[[	for i=1,9 do
		for _,v in pairs(GAMEMODE.OCRP_Models["Males"][i]) do
			util.PrecacheModel(v)
		end
	end
	for i=1,4 do
		for _,v in pairs(GAMEMODE.OCRP_Models["Females"][i]) do
			util.PrecacheModel(v)
		end
	end]]--
	ChatBoxInit()
end

local mat_OC_BlurScreen = Material( "pp/blurscreen" )
function Draw_OCRP_BackgroundBlur( panel )
	local Fraction = 1

	if ( starttime ) then
			Fraction = math.Clamp( (SysTime() - starttime) / 1, 0, 1 )
	end

	local x, y = panel:LocalToScreen( 0, 0 )

	DisableClipping( true )
   
	surface.SetMaterial( mat_OC_BlurScreen )   
	surface.SetDrawColor( 255, 255, 255, 255 )
		   
	for i=0.33, 1, 0.33 do
			mat_OC_BlurScreen:SetMaterialFloat( "$blur", Fraction * 5 * i )
			if ( render ) then render.UpdateScreenEffectTexture() end // Todo: Make this available to menu Lua
			surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
	end
   
	surface.SetDrawColor( 10, 10, 10, 200 * Fraction )
	surface.DrawRect( x * -1, y * -1, ScrW(), ScrH() )
   
	DisableClipping( false )
end

function BallotCL(um)
	local bool = um:ReadBool()
	if bool == true then
		LocalPlayer().InBallot = true
	else
		LocalPlayer().InBallot = false
	end
end
usermessage.Hook("ocrp_ballot", BallotCL)

require("bass");

local emeta = FindMetaTable( "Entity" )

function emeta:IsRadioOn()
	if self:GetNWInt( "ocrp_station", 0 ) != 0 then
		return true
	end
	return false
end
 
MaxRadiosConVar = CreateClientConVar("ocrp_max_radios", "5", true, false);
local MaxDistance = 1000
local RadioStreams = {};
local RadioStations = {};

function AddRadio( Name, URL )
	table.insert(RadioStations, {Name, URL});
end

local function DestroyStreamTable ( Table )
	for k, v in pairs(RadioStreams) do
		if v == Table then
			v = nil;
			RadioStreams[k] = nil;
			return true;
		end
	end
	
	return false;
end

local function OCRP_DoStation( Table, NewStation, NewChannel )
	if !RadioStations[NewStation][2] then DestroyStreamTable(Table) return false; end
	
	Table[3] = NewStation;
	
	BASS.StreamFileURL(RadioStations[NewStation][2], 0, 
		function( BassChannel, Err)
			if !BassChannel then		
				if !SurpressError then
					if Err == 40 || Err == 2 then
						LocalPlayer():PrintMessage(HUD_PRINTTALK, "Error initializing music stream. Your client timed out.");
					elseif Err == 41 then
						LocalPlayer():PrintMessage(HUD_PRINTTALK, "Error initializing music stream. Unsupported file type.");
					elseif Err == 8 then
						LocalPlayer():PrintMessage(HUD_PRINTTALK, "Error initializing music stream. BASS module initialization failure.");
					else
						LocalPlayer():PrintMessage(HUD_PRINTTALK, "Error initializing music stream. Unknown error " .. tostring(Err) .. ".");
					end
					
					SurpressError = true;
				end
				
				DestroyStreamTable(Table);
				
				return;
			end

			if Table and Table[3] == NewStation and IsValid(Table[2]) then
				Table[1] = BassChannel
				Table[1]:set3dposition(Table[2]:GetPos(), Vector(0,0,0), Vector(0,0,0))
				Table[1]:play()
				Table[1]:setvolume(70)
			else
				BassChannel:stop();
				BassChannel = nil;
			end
		end
	);
end

surface.CreateFont("Arista 2.0", 30, 400, true, false, "A30")

local function RadiosA()

	if !BASS then
		LocalPlayer():A( "Unfortunatly you do not have the BASS module, please download from our website to listen to radios." )
		hook.Remove( "Think", "RadiosCL" )
		return false
	end

	local ShootPos = LocalPlayer():GetShootPos()
	local EyePosition = LocalPlayer():EyePos();
	local Velocity = LocalPlayer():GetVelocity();
	local EyeAngs = LocalPlayer():GetAimVector():Angle();
	EyeAngs.p = math.Clamp(EyeAngs.p, -89, 88.9);
	local Forwards = EyeAngs:Forward()
	local Ups = EyeAngs:Up() * -1
	BASS.SetPosition(EyePosition, Velocity * 0.005, Forwards, Ups)
	local Objs = {}
	
	for k, v in pairs(ents.FindByClass( "item_base" )) do
		local Distance = v:GetPos():Distance( LocalPlayer():GetShootPos() )
		if v:GetModel() == "models/props/cs_office/radio.mdl" then
			if v:IsRadioOn() then
				if Distance <= 1000 then
					table.insert( Objs, {v, Distance} )
				end
			end
		end
	end
	
	for k, v in pairs(ents.FindByClass( "prop_vehicle_jeep" )) do
		local Distance = v:GetPos():Distance( LocalPlayer():GetShootPos() )
		if v:IsRadioOn() then
			if Distance <= 1000 then
				table.insert( Objs, {v, Distance} )
			end
		end
	end
	
	local ObjsB = {}
	local RadioCount = table.Count( Objs )
	local MaxRadios = math.Clamp( RadioCount, 0, MaxRadiosConVar:GetInt() )
	
	if RadioCount != 0 and RadioCount != nil then
		for i = 1, MaxRadios do
			local NearestRadioID = nil
			local NearestRadio = nil
			local NearestDistance = nil
			for k, obj in pairs( Objs ) do
				if obj[2] <= 1000 then
					NearestRadioID = k
					NearestRadio = obj[1]
					NearestDistance = obj[2]
				end
			end
			if NearestRadio then
				table.insert( ObjsB, NearestRadio )
				Objs[NearestRadioID] = nil
			end
		end
	end
	
	for k, stream in pairs( RadioStreams ) do
		local IsVALID = false
		
		for _, p in pairs( ObjsB ) do
			if p == stream[2] then
				IsVALID = true
				ObjsB[_] = nil
			end
		end
		
		if !IsVALID then
			if stream[1] then
				stream[1]:stop()
				stream[1] = nil
			end
			RadioStreams[k] = nil
			stream = nil
		else
			if !stream[2]:IsRadioOn() then
				stream[1]:stop()
				stream[1] = nil
				RadioStreams[k] = nil
			elseif stream[3] != stream[2]:GetNWInt( "ocrp_station", 0 ) then
				if stream[1] then
					stream[1]:stop()
					stream[1] = nil
				end
				OCRP_DoStation( stream, stream[2]:GetNWInt( "ocrp_station", 0 ), false )
			elseif stream[1] and stream[1].set3dposition then
				stream[1]:set3dposition( stream[2]:GetPos(), Vector( 0, 0, 0 ), Vector( 0, 0, 0 ) )
				stream[1]:setvolume(70)
			end
		end
	end
	
	if table.Count( ObjsB ) == 0 then
		return
	end
	
	local FreeRadios = MaxRadios - table.Count( RadioStreams )
	if FreeRadios == 0 then
		return
	end

	while FreeRadios > 0 do
		for k, v in pairs( ObjsB ) do
			table.insert( RadioStreams, {nil, v, 0} )
			OCRP_DoStation( {nil, v, 0}, v:GetNWInt( "ocrp_station", 0 ), true )
			FreeRadios = FreeRadios - 1
			ObjsB[k] = nil
		end
	end
end		
hook.Add( "Think", "RadiosCL", RadiosA )

local function RadioIncome( umsg )
	Station = umsg:ReadString()
	StationTime = CurTime()
end
usermessage.Hook('ocrp_radio', RadioIncome);

local function RadioDrawing( um )
	if Station and StationTime + 3 > CurTime() then
		if !BASS then
			Station = nil
			StationTime = nil
			return
		end
		surface.SetFont("A30")
		local x, y = surface.GetTextSize(Station)
		draw.RoundedBox( 8, (ScrW() / 2) - (x / 2) - 5, (ScrH() / 2) - 25, (x + 38), 50, Color( 255, 140, 0, 180) )
--		surface.SetDrawColor( 128, 140, 0, 180 )
--		surface.DrawOutlinedRect( (ScrW() / 2) - ( x /2 ) - 5, ScrH() / 2 - 25, (x+38), 50)
--		surface.SetDrawColor( 255, 165, 0, 180 )
--		surface.DrawRect( (ScrW() / 2) - ( x /2 ) - 5, ScrH() / 2 - 25, (x+38), 50)	
		surface.SetMaterial(Material("gui/OCRP/OCRP_Orange"))
		surface.SetDrawColor(255,255,255,255)
		surface.DrawTexturedRect((ScrW() / 2) - (x/2) - 40,(ScrH() / 2) - 30,60,60)

		draw.SimpleText(Station, 'A30', (ScrW() / 2) + 23, ScrH() / 2, Color(255, 255, 255, 255), 1, 1);
		
	end
end
hook.Add('HUDPaint', 'RadioDrawSomeShit', RadioDrawing);
function GM:PlayerFootstep( ply, pos, foot, sound, volume, rf ) 
	if (ply:IsInside()) then return; end

	local randSound = math.random(1, 6)
	ply.lastFootSound = self.lastFootSound or 1;
	
	while (randSound == ply.lastFootSound) do
		randSound = math.random(1, 6);
	end
	
	ply.lastFootSound = randSound;
	
	if (GAMEMODE.SnowOnGround) then
		WorldSound(Sound("player/footsteps/snow" .. randSound .. ".wav"), pos, 65);
		return true
	end
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
