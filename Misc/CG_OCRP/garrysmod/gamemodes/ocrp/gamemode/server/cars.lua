-- CAR PART MODELS
-- models/props_wasteland/light_spotlight01_base.mdl -- SUSPENSION
-- models/props_wasteland/gear01.mdl -- gearbox
-- models/props_combine/combine_smallmonitor001.mdl -- alternate gearbox <- apparently a proper gearbox.
-- models/props_c17/utilityconnecter006.mdl -- injector/ignition

function SendCarsClient( ply ) --------DO THIS ONLY ON LOAD
	for _, Data in pairs(ply.OCRPData["Cars"]) do
		umsg.Start("ocrp_allcars", ply)
			umsg.String( Data.car )
			umsg.Short( Data.skin )
		umsg.End()
	end
end

function SendSingleCar( ply, CarName, Skin )
	umsg.Start("ocrp_single_car", ply)
		umsg.String( CarName )
		umsg.Short( Skin )
	umsg.End()
end

function SendTrunk( ply, Vehicle )
	for k, v in pairs( Vehicle.Data["Items"] ) do
		umsg.Start("ocrp_trunk_item", ply)
			umsg.String(k)
			umsg.Long(v)
			umsg.Long(1)
		umsg.End()
	end
end

function ShowTrunkMenu( ply )
	umsg.Start( "ocrp_trunk_show", ply )
	umsg.End()
end

function ShowCarDealer( ply, cmd, args )
	if !ply:NearNPC("CarDealer") then return false end
	umsg.Start( "CL_CarDealer", ply )
	umsg.End()
end
concommand.Add( "SV_CarDealer", ShowCarDealer )

function ShowGarage( ply, cmd, args )
	if !ply:NearNPC("Garage") then return false end
	umsg.Start( "CL_Garage", ply )
	umsg.End()
end
concommand.Add( "SV_Garage", ShowGarage)

local Delay = CurTime()
function OCRP_Horn( ply, key )
	if ply:InVehicle() and ply:GetVehicle():GetClass() == "prop_vehicle_jeep" then
		if key == IN_WALK then
			ply.HydroTime = ply.HydroTime or 0
			if ply.HydroTime + 1 > CurTime() then
				return false
			end
			ply.HydroTime = CurTime()
			if ply:GetVehicle():GetModel() == "models/sickness/lcpddr.mdl" then
			for _,light in pairs(ply:GetVehicle().Lights) do
				if !light:GetNWBool("siren", false) then
					ply:GetVehicle():EmitSound("ocrp/siren_short.mp3");
				end
			end
			end
			if ply:GetVehicle():GetModel() == "models/tdmcars/copcar.mdl" then
			for _,light in pairs(ply:GetVehicle().Lights) do
				if !light:GetNWBool("siren", false) then
					ply:GetVehicle():EmitSound("ocrp/siren_short.mp3");
				end
			end
			end
			if ply:GetVehicle():GetModel() == "models/sickness/stockade2dr.mdl" then
			for _,light in pairs(ply:GetVehicle().Lights) do
				if !light:GetNWBool("siren", false) then
					ply:GetVehicle():EmitSound("ocrp/siren_short.mp3");
				end
			end
			end
			if ply:GetVehicle():GetModel() == "models/sickness/murcielag1.mdl" then
			for _,light in pairs(ply:GetVehicle().Lights) do
				if !light:GetNWBool("siren", false) then
					ply:GetVehicle():EmitSound("ocrp/siren_short.mp3");
				end
			end
			end
			if ply:GetVehicle():GetModel() == "models/sickness/meatwagon.mdl" or ply:GetVehicle():GetModel() == "models/sickness/truckfire.mdl" then
				ply:GetVehicle():EmitSound("ocrp/firetruck_horn.mp3");
			end
			if ply:GetVehicle().Hydros == true then
				local Force = ply:GetVehicle():GetUp() * 450000;
				if ply:GetVehicle().CarType == "CAR_MURC" then
					Force = ply:GetVehicle():GetUp() * 400000;
				end
				if ply:GetVehicle().CarType == "CAR_PHANTOM" then
					Force = ply:GetVehicle():GetUp() * 4000000;
				end
				
				if ply:GetVehicle().CarType == "CAR_ATV" then
					Force = ply:GetVehicle():GetUp() * 50000;
				end
		
				if Force then
					ply:GetVehicle():GetPhysicsObject():ApplyForceCenter(Force);
				end
			end
		elseif key == IN_SPEED then
			ply.HornTime = ply.HornTime or 0
			if ply.HornTime + 1.5 > CurTime() then
				return false
			end
			ply.HornTime = CurTime()
			if ply:GetVehicle().Lights != nil then
				for _,light in pairs(ply:GetVehicle().Lights) do
					if light:GetNWBool("On") then
						light:SetNWBool("On",false)
						--light:SetNWBool("SoundOn",false)
					else
						light:SetNWBool("On",true)
						--light:SetNWBool("SoundOn",true)
					end
				end
			else
				ply:GetVehicle():EmitSound( "ocrp/carhorn2.wav" )
			end
		end
	end
end
hook.Add("KeyPress", "OCRP_Horn", OCRP_Horn)

function GM:ShowTeam( ply )
	if ply.CantUse then return false end
	local tr = ply:GetEyeTrace()
	if tr.Entity:IsValid() then
		if tr.Entity:GetClass() == "gov_resupply" then return end
		if tr.Entity:IsPlayer() && tr.Entity:Alive() then
			Search_Request(ply,tr.Entity)
			ply.CantUse = true
			timer.Simple(5, function() if ply:IsValid() then ply.CantUse = false end end)
			return false
		elseif tr.Entity.OCRPData != nil and tr.Entity.OCRPData["Inventory"] != nil then
			if tr.Entity:GetNWInt( "Owner" ) == ply:EntIndex() then
				ply:Inv_View(tr.Entity)
				ply.CantUse = true
				timer.Simple(5, function() if ply:IsValid() then ply.CantUse = false end end)	
				return false
			else
				if tr.Entity:GetNWInt( "Owner" ) != ply:EntIndex() && player.GetByID(tr.Entity:GetNWInt( "Owner" )):GetPos():Distance(tr.Entity:GetPos()) < 1000 then
					Search_Request(ply,tr.Entity)
					ply.CantUse = true
					timer.Simple(5, function() if ply:IsValid() then ply.CantUse = false end end)
					return false
				else
					ply:Inv_View(tr.Entity)
					ply.CantUse = true
					timer.Simple(5, function() if ply:IsValid() then ply.CantUse = false end end)
					return false
				end
			end
		elseif string.lower(tr.Entity:GetModel()) == "models/props_c17/furnituredresser001a.mdl" then
			if tr.Entity:GetNWInt( "Owner" ) == ply:EntIndex() then
				umsg.Start( "showward", ply )
				umsg.End()
				ply.CantUse = true
				timer.Simple(1, function() if ply:IsValid() then ply.CantUse = false end end)	
				return false
			end
		end
	end
	--umsg.Start( "ocrp_chall_show", ply )
	--umsg.End()
	ply.CantUse = true
	timer.Simple(0.3, function() if ply:IsValid() then ply.CantUse = false end end)
end


function OCRP_BuyCar( ply, cmd, args )
	if !ply:NearNPC("CarDealer") then
		ply:Hint( "Trying to purchase a vehicle while not near a NPC, or while in a car." )
		return false
	end
	CarName = args[1]
	if !CarName then return false end
	for _, Data in pairs(ply.OCRPData["Cars"]) do
		if Data.car == CarName then
			return false
		end
	end
	if GAMEMODE.OCRP_Cars[CarName].dj and !ply:IsDJ() then return false end
	local CarPrice = GAMEMODE.OCRP_Cars[CarName].Price
	if CarPrice >= ply:GetMoney(BANK) then return false end
	ply:TakeMoney(BANK, CarPrice)
	table.insert(ply.OCRPData["Cars"], {car = CarName, skin = 1, hydros = false})
	SendSingleCar(ply, CarName, 1)
	OCRP_SpawnVehicle(CarName, ply)
	GAMEMODE:SaveSQLCar( ply, CarName )
--	OCRP_CreateCar( CarName, Vector(-3790.054932, -262.866974, 153.637131), Angle(0,0,0), ply)
	--Meh, I'll do a query here once we've done.
end
concommand.Add("OCRP_BuyCar", OCRP_BuyCar)

/*
function OCRP_LoadCars( ply )
	tmysql.query("SELECT cars FROM `ocrp_users` WHERE `STEAM_ID` = '".. ply:SteamID() .."'",
	function(results)
		PrintTable(results)
		local stringcar = util.TableToKeyValues(results)
		table.insert(ply.OCRPData["Cars"], util.KeyValuesToTable(stringcar))
		PrintTable(ply.OCRPData["Cars"])
	end)
end
concommand.Add("LoadCars", OCRP_LoadCars)

function OCRP_SaveCars(ply)
	tmysql.query("UPDATE `ocrp_users` SET `cars` = '".. tmysql.escape(util.TableToKeyValues(ply.OCRPData["Cars"])) .."' WHERE `STEAM_ID` = '".. ply:SteamID() .."'")
end
concommand.Add("SaveCars", OCRP_SaveCars)*/

function OCRP_SpawnCar(ply, cmd, args)
	--if !ply:NearNPC("Garage") then return false end
	local CanSpawn
	local CarToSpawn = args[1]
	for _, Data in pairs(ply.OCRPData["Cars"]) do
		if Data.car == CarToSpawn then
			CanSpawn = true
		end
	end
	if CanSpawn != true then return false end
	OCRP_SpawnVehicle(CarToSpawn, ply)
	--OCRP_CreateCar( CarToSpawn, Vector(-3790.054932, -262.866974, 153.637131), Angle(0,0,0), ply)
end
concommand.Add("OCRP_SC", OCRP_SpawnCar)

function OCRP_SpawnPolice(ply, cmd, args)
	if ply:Team() != CLASS_POLICE && ply:Team() != CLASS_CHIEF then return false end
	OCRP_SpawnVehicle("Police", ply)
end
concommand.Add("OCRP_SpawnPolice", OCRP_SpawnPolice)

function OCRP_SpawnPoliceNEW(ply, cmd, args)
	if ply:Team() != CLASS_POLICE && ply:Team() != CLASS_CHIEF then return false end
	if ply:GetLevel() <= 4 then
		OCRP_SpawnVehicle("Police_NEW", ply)
	else
		OCRP_SpawnVehicle("Police", ply)
	end
end
concommand.Add("OCRP_SpawnPoliceNEW", OCRP_SpawnPoliceNEW)

function OCRP_SpawnSWAT(ply, cmd, args)
	if ply:Team() != CLASS_SWAT then return false end
	OCRP_SpawnVehicle("SWAT", ply)
end
concommand.Add("OCRP_SpawnSWAT", OCRP_SpawnSWAT)

function OCRP_SpawnAmbo(ply, cmd, args)
	if ply:Team() != CLASS_MEDIC then return false end
	OCRP_SpawnVehicle("Ambo", ply)
end
concommand.Add("OCRP_SpawnAmbo", OCRP_SpawnAmbo)

function OCRP_SpawnFireEngine(ply, cmd, args)
	if ply:Team() != CLASS_FIREMAN then return false end
	OCRP_SpawnVehicle("Fire", ply)
end
concommand.Add("OCRP_SpawnFireEngine", OCRP_SpawnFireEngine)
	
function OCRP_SpawnVehicle(Car, ply)
	local SoFar = 2000
	local TehTBL = GAMEMODE.Maps[string.lower(game.GetMap())].SpawnsCar
	if Car == "CAR_YANKEE" or Car == "CAR_PHANTOM" or Car == "CAR_MULE" or Car == "CAR_BUS" or Car == "CAR_LIMO" or Car == "CAR_INTER" then
		if string.lower(game.GetMap()) == "rp_cosmoscity_v1b" then
			TehTBL = {
				{Position = Vector(-3284, -1560, 7), Ang = Angle(0,93,0)},
				{Position = Vector(-3269, -1774, 7), Ang = Angle(0,93,0)},
			}
		elseif string.lower(game.GetMap()) == "rp_evocity_v2d" then
			TehTBL = {
				{Position = Vector(-5802,-10518,140), Ang = Angle(0,0,0)},
				{Position = Vector(-5810,-10345,140), Ang = Angle(0,0,0)},
			}
		end
	end
	if Car == "Ambo" then
		if string.lower(game.GetMap()) == "rp_evocity2_v2p" then
			TehTBL = {
			{Position = Vector(-1064,-1721,220), Ang = Angle(0,-1,0)},
			{Position = Vector(-1081,-2091,220), Ang = Angle(1,-1,0)},
			--{Position = Vector(-5825, -9556, 178)},
			--{Position = Vector(-5809, -9027, 180)},
			}
		elseif string.lower(game.GetMap()) == "rp_cosmoscity_v1b" then
			TehTBL = {
				{Position = Vector(4429,-796,63), Ang = Angle(0,0,0)},
				{Position = Vector(4184,-799,63), Ang = Angle(0,0,0)},
				{Position = Vector(3883,-766,62), Ang = Angle(0,0,0)},
				{Position = Vector(3739,-761,64), Ang = Angle(0,0,0)},
				{Position = Vector(3574,-747,65), Ang = Angle(0,0,0)},
			}

		else
			TehTBL = {
				{Position = Vector(-5799, -10606, 195)},
				{Position = Vector(-5843, -10979, 176)},
				{Position = Vector(-5825, -9556, 178)},
				{Position = Vector(-5809, -9027, 180)},
			}
		end
	elseif Car == "Police" then
		if string.lower(game.GetMap()) == "rp_evocity2_v2p" then
			TehTBL = {
				{Position = Vector(953,-1609,-110), Ang = Angle(0,90,0)},
				{Position = Vector(-193,-1576,-110), Ang = Angle(0,179,0)},
				{Position = Vector(4,-1655,-114), Ang = Angle(0,178,0)},
				{Position = Vector(-74,-2325,-112), Ang = Angle(0,0,0)},
				{Position = Vector(-284,-2246,-111), Ang = Angle(0,0,0)},
			}
		elseif string.lower(game.GetMap()) == "rp_cosmoscity_v1b" then
			TehTBL = {
				{Position = Vector(6241,-1746,42), Ang = Angle(0,90,0)},
				{Position = Vector(6243,-1872,42), Ang = Angle(0,90,0)},
				{Position = Vector(5959,-1874,42), Ang = Angle(0,90,0)},
				{Position = Vector(5977,-1744,42), Ang = Angle(0,90,0)},
				{Position = Vector(5519,-1600,36), Ang = Angle(0,-1,0)},
			}
		else
			TehTBL = {
				{Position = Vector(-6183, -9576, 64)},
				{Position = Vector(-6193, -9887, 142)},
				{Position = Vector(-6195, -10183, 142)},
				{Position = Vector(-6194, -10522, 137)},
				{Position = Vector(-6209, -10862, 135)},
			}
		end
	elseif Car == "Police_NEW" then
		if string.lower(game.GetMap()) == "rp_evocity2_v2p" then
			TehTBL = {
				{Position = Vector(953,-1609,-110), Ang = Angle(0,90,0)},
				{Position = Vector(-193,-1576,-110), Ang = Angle(0,179,0)},
				{Position = Vector(4,-1655,-114), Ang = Angle(0,178,0)},
				{Position = Vector(-74,-2325,-112), Ang = Angle(0,0,0)},
				{Position = Vector(-284,-2246,-111), Ang = Angle(0,0,0)},
			}
		elseif string.lower(game.GetMap()) == "rp_cosmoscity_v1b" then
			TehTBL = {
				{Position = Vector(6241,-1746,42), Ang = Angle(0,90,0)},
				{Position = Vector(6243,-1872,42), Ang = Angle(0,90,0)},
				{Position = Vector(5959,-1874,42), Ang = Angle(0,90,0)},
				{Position = Vector(5977,-1744,42), Ang = Angle(0,90,0)},
				{Position = Vector(5519,-1600,36), Ang = Angle(0,-1,0)},
			}
		else
			TehTBL = {
				{Position = Vector(-6183, -9576, 64)},
				{Position = Vector(-6193, -9887, 142)},
				{Position = Vector(-6195, -10183, 142)},
				{Position = Vector(-6194, -10522, 137)},
				{Position = Vector(-6209, -10862, 135)},
			}
		end
	elseif Car == "SWAT" then
		if string.lower(game.GetMap()) == "rp_evocity2_v2p" then
			TehTBL = {
				{Position = Vector(953,-1609,-110), Ang = Angle(0,90,0)},
				{Position = Vector(-193,-1576,-110), Ang = Angle(0,179,0)},
				{Position = Vector(4,-1655,-114), Ang = Angle(0,178,0)},
				{Position = Vector(-74,-2325,-112), Ang = Angle(0,0,0)},
				{Position = Vector(-284,-2246,-111), Ang = Angle(0,0,0)},
			}
		elseif string.lower(game.GetMap()) == "rp_cosmoscity_v1b" then
			TehTBL = {
				{Position = Vector(6241,-1746,42), Ang = Angle(0,90,0)},
				{Position = Vector(6243,-1872,42), Ang = Angle(0,90,0)},
				{Position = Vector(5959,-1874,42), Ang = Angle(0,90,0)},
				{Position = Vector(5977,-1744,42), Ang = Angle(0,90,0)},
				{Position = Vector(5519,-1600,36), Ang = Angle(0,-1,0)},
			}
		else
			TehTBL = {
				{Position = Vector(-6183, -9576, 64)},
				{Position = Vector(-6193, -9887, 142)},
				{Position = Vector(-6195, -10183, 142)},
				{Position = Vector(-6194, -10522, 137)},
				{Position = Vector(-6209, -10862, 135)},
			}
		end
	elseif  Car == "Fire" then
		if string.lower(game.GetMap()) == "rp_evocity2_v2p" then
			TehTBL = {
			{Position = Vector(-1064,-1721,220), Ang = Angle(0,-1,0)},
			{Position = Vector(-1081,-2291,220), Ang = Angle(1,-1,0)},
			--{Position = Vector(-5825, -9556, 178)},
			--{Position = Vector(-5809, -9027, 180)},
			}
		elseif string.lower(game.GetMap()) == "rp_cosmoscity_v1b" then
			TehTBL = {
				{Position = Vector(6241,-1746,42), Ang = Angle(0,90,0)},
				{Position = Vector(6243,-1872,42), Ang = Angle(0,90,0)},
				{Position = Vector(5959,-1874,42), Ang = Angle(0,90,0)},
				{Position = Vector(5977,-1744,42), Ang = Angle(0,90,0)},
				{Position = Vector(5519,-1600,36), Ang = Angle(0,-1,0)},
			}
		else
			TehTBL = {
				{Position = Vector(-6183, -9576, 64)},
				{Position = Vector(-6193, -9887, 142)},
				{Position = Vector(-6195, -10183, 142)},
				{Position = Vector(-6194, -10522, 137)},
				{Position = Vector(-6209, -10862, 135)},
			}
		end
	end
	for k, v in pairs(TehTBL) do
		local open
		if v.Position:Distance(ply:GetPos()) < SoFar then 
			open = true
		end
		for k, ply in pairs(ents.FindInSphere(v.Position, 32)) do
			if ply:IsVehicle() then
				open = false
				break
			end
		end
		if open then
			PlaceToPut = v.Position -- till after admin beta.
			PlaceToAngle = v.Ang or Angle(0,0,0)
			break
		end
	end
	
	if ply.OCRPData["CurCar"] != nil then
		if ply.OCRPData["CurCar"]:IsValid() then
			ply.OCRPData["CurCar"]:Remove()
		end
	end
	for k, v in pairs(ents.GetAll()) do
		if v:IsVehicle() then
			if v:GetNWInt("Owner") == ply:EntIndex() then
				v:Remove()
			end
		end
	end
	OCRP_CreateCar( Car, PlaceToPut, PlaceToAngle, ply)
end

function PMETA:OwnsCar( CarToFind )
	for k, v in pairs( self.OCRPData["Cars"] ) do
		if v.car == CarToFind then
			return true
		end
	end
	return false
end

function OCRP_CreateCar( Car, Pos, Ang, ply )
	local script
	local model
	if Car == "Police" then
	   	script = "scripts/vehicles/ecpd01.txt"
		model = "models/sickness/lcpddr.mdl"
	elseif Car == "Police_NEW" then
	   	script = "scripts/vehicles/dodgecop.txt"
		model = "models/tdmcars/copcar.mdl"
	elseif Car == "Ambo" then
	    	script = "scripts/vehicles/ambo.txt"
		model = "models/sickness/meatwagon.mdl"
	elseif Car == "SWAT" then
	    	script = "scripts/vehicles/newstock.txt"
		model = "models/sickness/stockade2dr.mdl"
	elseif Car == "Fire" then
		script = "scripts/vehicles/truckfire.txt"
		model = "models/sickness/truckfire.mdl"
	else
		script = GAMEMODE.OCRP_Cars[Car].Script
		model = GAMEMODE.OCRP_Cars[Car].Model
	end
	
	if ply:Team() != CLASS_POLICE && ply:Team() != CLASS_CHIEF && ply:Team() != CLASS_SWAT and model == "models/sickness/lcpddr.mdl" then
		return false
	end
	
	local TheCar = ents.Create( "prop_vehicle_jeep" )
	TheCar:SetKeyValue( "vehiclescript", script )
	TheCar:SetPos( Pos )
	TheCar:SetAngles( Ang )
	if type(model) == "table" then
		model = model[1]
	end
	TheCar:SetModel( model )
	TheCar:Spawn()
	TheCar:Activate()
	TheCar:SetHealth(100) 
	TheCar.CarType = Car
	TheCar.OwnerObj = ply
	TheCar.Gas = ply.GasSave[Car] or GAMEMODE.OCRP_Cars[Car].GasTank 
	
	umsg.Start("OCRP_UpdateGas", ply)
			umsg.Long(TheCar.Gas)
	umsg.End()	

	TheCar.Permissions = {}
	TheCar.Permissions["Buddies"] = true
	TheCar.Permissions["Org"] = true
	TheCar.Permissions["Goverment"] = false
	TheCar.Permissions["Mayor"] = false
	
	--if ply.OCRPData.CurCar != nil then
		
	--	TheCar.OCRPData = {}
	--	TheCar.OCRPData["Inventory"] = ply.OCRPData.CurCar.OCRPData["Inventory"]
	--else
		TheCar.OCRPData = {}
		TheCar.OCRPData["Inventory"] = {WeightData = {Cur = 0, Max = 100},}
--	end
	
	if Car == "CAR_LAMBO" or Car == "CAR_SHELBY" then
		TheCar:Fire('setbodygroup', '511', 0)
	end
	if Car == "CAR_MINI" then
		TheCar:Fire('setbodygroup', '1023', 0)
	end
	if Car == "CAR_CATERHAM" then
		TheCar:Fire('setbodygroup', '3', 0)
	end
				
	TheCar.Seats = {}
	TheCar.Exits = {}
	TheCar.Data = {}
	TheCar.Data["Items"] = {}
	TheCar.Data["Weight"] = 0
	
	if Car == "Police" then
		TheCar:SetSkin(math.random(0,1))
		TheCar.Lights = {} 
			local lightred = ents.Create("police_siren")
			lightred:SetPos(TheCar:GetPos() + Vector(0,0,70))
			lightred:SetParent(TheCar)
			lightred:Spawn()
			table.insert(TheCar.Lights,lightred)
		TheCar.Permissions["Buddies"] = true
		TheCar.Permissions["Org"] = true
		TheCar.Permissions["Goverment"] = true
		TheCar.Permissions["Mayor"] = true
	elseif Car == "Police_NEW" then
		TheCar.Lights = {} 
			local lightred = ents.Create("police_siren_new")
			lightred:SetPos(TheCar:GetPos() + Vector(0,0,70))
			lightred:SetParent(TheCar)
			lightred:Spawn()
			table.insert(TheCar.Lights,lightred)
		TheCar.Permissions["Buddies"] = true
		TheCar.Permissions["Org"] = true
		TheCar.Permissions["Goverment"] = true
		TheCar.Permissions["Mayor"] = true
	elseif Car == "Ambo" then
			TheCar.Lights = {}
			local lightred = ents.Create("ambo_siren")
			lightred:SetPos(TheCar:GetPos() + Vector(0,50,120))
			lightred:SetParent(TheCar)
			lightred:Spawn()
			table.insert(TheCar.Lights,lightred)		
		TheCar.Permissions["Buddies"] = true
		TheCar.Permissions["Org"] = true
		TheCar.Permissions["Goverment"] = true
		TheCar.Permissions["Mayor"] = true
	elseif Car == "SWAT" then
			TheCar.Lights = {}
			local lightred = ents.Create("swat_siren")
			lightred:SetPos(TheCar:GetPos() + Vector(0,50,150))
			lightred:SetParent(TheCar)
			lightred:Spawn()
			table.insert(TheCar.Lights,lightred)		
		TheCar.Permissions["Buddies"] = true
		TheCar.Permissions["Org"] = true
		TheCar.Permissions["Goverment"] = true
		TheCar.Permissions["Mayor"] = true
	elseif Car == "Fire" then
			TheCar.Lights = {}
			local lightred = ents.Create("fire_siren")
			lightred:SetPos(TheCar:GetPos() + Vector(0,50,120))
			lightred:SetParent(TheCar)
			lightred:Spawn()
			table.insert(TheCar.Lights,lightred)		
		TheCar.Permissions["Buddies"] = true
		TheCar.Permissions["Org"] = true
		TheCar.Permissions["Goverment"] = true
		TheCar.Permissions["Mayor"] = true
	end
	
	
	TheCar:SetNWInt( "Owner", ply:EntIndex())
	TheCar:Fire('lock', '', .5);
	
	TheCar.GasCheck = 0
	
	TheCar.Think = function() 
						if TheCar.GasCheck <= CurTime() && !TheCar:IsGovCar() then
							GAMEMODE:DoGasCheck(TheCar)
						end
						timer.Simple(10,function() if TheCar:IsValid() then TheCar:Think() end end)
					end
	if CAR != "Ambo" || CAR != "Police" || CAR != "Police_NEW" || CAR != "Fire" || CAR != "SWAT" then
		TheCar:Think() 
	end

		GAMEMODE.OCRP_Cars[Car].Seats( ply, TheCar )
	
	--GAMEMODE.OCRP_Cars[Car].Exits( ply, TheCar )
	
	ply.OCRPData.CurCar = TheCar
	ply.OCRPData["CurCar"] = TheCar
	
	for _, data in pairs(ply.OCRPData["Cars"]) do
		if data.car == Car then
			print(data.hydros)
			if Car != "Police" then
				OCRP_SetSkin(ply, TheCar, data.skin)
			end
			if tostring(data.hydros) == "true" then
				TheCar.Hydros = true
			else
				TheCar.Hydros = false
			end
		end
	end
	

--	GAMEMODE.CreatePassengerSeat(TheCar, Vector(20, -5, 8), Angle(0, 0 ,0))
	--GAMEMODE.CreatePassengerSeat(TheCar, Vector(20, 30, 5), Angle(0, 0 ,0))
	--GAMEMODE.CreatePassengerSeat(TheCar, Vector(-17, 30, 5), Angle(0, 0 ,0))
end

function GM.AddExit ( Entity, Vec )
	table.insert(Entity.Exits, Vec)
end

function CL_ShowSkin(ply,cmd,args)
	if !ply:NearNPC( "Respray" ) then return false end
	umsg.Start("ocrp_open_skins", ply)
		umsg.String(args[1])
	umsg.End()
 end
 concommand.Add("CL_ShowSkin", CL_ShowSkin)

function OCRP_BuyHydro( ply, cmd, args )
	if !ply:NearNPC( "Respray" ) then
		print( "not near npc" )
		return false
	end
	local Car
	for k, v in pairs(ents.FindByClass("prop_vehicle_jeep")) do
		if v:GetNWInt( "Owner" ) == ply:EntIndex() then
			print("foundcar")
			Car = v
			break
		end
	end
	
	local MyCarType = Car.CarType
	print( MyCarType )
	
	if Car == nil then return false end
	if Car.Hydros then return false end
	
	local key
	for _, data in pairs(ply.OCRPData["Cars"]) do
		if data.car == MyCarType then
			if tostring(data.hydros) == "true" then
				return false
			end
			key = _
			break
		end
	end
	
	if ply:GetMoney(BANK) < 25000 then
		print( "you cant buy that" )
		ply:Hint( "Can't buy because you don't have enough money!" )
		return false
	end
	
	ply:TakeMoney(BANK, 25000)
	
	ply.OCRPData["Cars"][key].hydros = true
	Car.Hydros = true
	
	GAMEMODE:SaveSQLCar( ply, MyCarType )
end
concommand.Add("ocrp_bhydros", OCRP_BuyHydro)

function OCRP_BuySkin( ply, cmd, args )
	if !ply:NearNPC( "Respray" ) then return false end
	if !args[1] then return false end
	local Car
	for k, v in pairs(ents.FindByClass("prop_vehicle_jeep")) do
		if v:GetNWInt( "Owner" ) == ply:EntIndex() then
			Car = v
		end
	end
	
	local ttype = Car:GetCarType()
	
	local Price = GAMEMODE.OCRP_Cars[args[2]].Skin_Price
	
	if ply:GetMoney(WALLET) < Price then
		ply:Hint( "Trying to purchase a skin without having the right amount of money." )
		return false
	end
	
	ply:TakeMoney(WALLET, Price)
	
	local toskin_num = math.Round(args[1])
	
	local keah
	for _, data in pairs(ply.OCRPData["Cars"]) do
		if data.car == ttype then
			keah = _
		end
	end
	
	ply.OCRPData["Cars"][keah].skin = toskin_num
	

	OCRP_SetSkin(ply, Car, toskin_num)
	GAMEMODE:SaveSQLCar( ply, ttype )
end
concommand.Add("ocrp_bskin", OCRP_BuySkin)
	
function OCRP_SetSkin( ply, Car, SkinNum )
	local ttype = Car:GetCarType()
	
	local cartbl = GAMEMODE.OCRP_Cars[tostring(ttype)].Skins[tonumber(SkinNum)]
	
	--if cartbl.Org and ply:GetOrg() != cartbl.Org or ply:SteamID() != cartbl.Steam then
	--	cartbl = GAMEMODE.OCRP_Cars[ttype].Skins[1]
	--end
	
	if cartbl.model != Car:GetModel() then
		Car:SetModel( cartbl.model )
	end
	
	if cartbl.skin != Car:GetSkin() then
		Car:SetSkin( cartbl.skin )
	end
end

function MoveSeat( ply, Vehicle, t )
	if t == "Simple" then
		local CurPos = Vehicle:GetPos() local CurAng = Vehicle:GetAngles()
		local NextPos = GAMEMODE.OCRP_Cars[Vehicle:GetCarType()].MovePos
		CurPos = CurPos + ( CurAng:Forward() * NextPos.x) + ( CurAng:Right() * NextPos.y) + ( CurAng:Up() * NextPos.z)	
		ply:SetParent()
		ply:SetPos(CurPos)
		ply:SetAngles(CurAng)
		ply:SetParent(Vehicle)
	else
		local CurPos = Vehicle:GetPos() local CurAng = Vehicle:GetAngles()
		local NextPos = GAMEMODE.OCRP_Cars[Vehicle:GetCarType()].MovePos.Vec
		local NextAng = GAMEMODE.OCRP_Cars[Vehicle:GetCarType()].MovePos.Ang
		local Obj = ents.Create('prop_dynamic');
		Obj:SetModel('models/props_junk/cinderblock01a.mdl')
		Obj:SetPos(ply:GetPos())
		Obj:SetAngles(ply:GetAngles())
		Obj:Spawn()
		Obj:DrawShadow(false)
		Obj:SetNoDraw(true)
		Obj:SetNotSolid(true)

		ply:SetParent(Obj);
		ply.ParentObj = Obj
		Obj:SetParent(Vehicle)
		Obj:SetLocalAngles(NextAng)
		Obj:SetLocalPos(NextPos)

		Obj:SetSolid(SOLID_NONE);
		Obj:SetMoveType(MOVETYPE_NONE);
	end
end

local useonce = 0
function GetOutOfCar( ply, key )
	if key == IN_USE then
		if ply:InVehicle() then
			local Vehicle = ply:GetVehicle()
			if ply.CantUse then return end
			timer.Simple(.7,function() useonce = 0 end)
				if Vehicle.Lights != nil then
					for _,light in pairs(Vehicle.Lights) do
						light:SetNWBool("siren",false)
					end
				end
				ply:SetParent()
				
				if ply.ParentObj != nil and ply.ParentObj != NULL then
					ply.ParentObj:Remove()
				end
				
				local TheTBL
				if Vehicle:GetCarType() != nil then
					if GAMEMODE.OCRP_Cars[Vehicle:GetCarType()] then
						if GAMEMODE.OCRP_Cars[Vehicle:GetCarType()].Exits != nil then
							TheTBL = GAMEMODE.OCRP_Cars[Vehicle:GetCarType()].Exits
						end
					end
				end
				if Vehicle:GetNWInt('ocrp_station', 0) != 0 then
					--Vehicle.LastRadioStation = Vehicle:GetNWInt('ocrp_station', 0)
					Vehicle:SetNWInt('ocrp_station', 0)
				end
				if TehTBL == nil and Vehicle:GetParent() then
					if Vehicle != NULL and Vehicle:GetParent() != NULL then
						if Vehicle:GetParent():GetClass() == "item_base" then
							TheTBL = { Vector( -100,-30,0 ) }
						end
					end
				end
				if TheTBL == nil then
					TheTBL = {
						Vector(-85.4888, 32.0606, 2.5582),
						Vector(-85.7425, -21.2776, 2.6878),
						Vector(85.3276, -25.8024, 2.5374),
						Vector(85.5768, 35.7472, 2.3860),
					}
				end
				
				if Vehicle:GetCarType() == "Ambo" then
					TheTBL = {Vector(-175,45,2.38)}
				end
				
					
				local Closest
				for k, v in pairs( TheTBL ) do
					local Vec = Vehicle:LocalToWorld( v ) + Vector( 0, 0, 35 )
					local Distance = ply:GetPos():Distance( Vec )
					if util.IsInWorld( Vec ) then
						local CanExit = true
						local point = util.PointContents(Vec)
						CanExit = point ~= CONTENTS_SOLID 
						and point ~= CONTENTS_MOVEABLE 
						and point ~= CONTENTS_LADDER 
						and point ~= CONTENTS_PLAYERCLIP 
						and point ~= CONTENTS_MONSTERCLIP
						/*for k, v in pairs( ents.FindInSphere( Vec, 32 ) ) do
							if v:IsPlayer() and v:IsValid() then
								CanExit = false
							end
						end*/
						
						if CanExit == true then
							Closest = Vec
						end
					end
				end	
				if Closest != nil then
					ply:ExitVehicle()
					ply:SetPos( Closest )
				end
				ply.CantUse = true
				ply.InVehicleB = false
				if Vehicle:GetNWInt("Owner", 0) == ply:EntIndex() then
					Vehicle:SetNWBool("UnLocked",false)
					Vehicle:Fire("Lock")
					Vehicle:EmitSound("ocrp/carlock.wav",70,100)
				end
				timer.Simple(1.5,function() ply.CantUse = false end)
				return
			end
		end
end
hook.Add("KeyPress", "GetOutOfCarHook", GetOutOfCar)

local function EnergyRegain(ply)
	if ply:IsValid() && ply:InVehicle() then
		if ply:GetNWInt("Energy") <= 90 then
			ply:SetNWInt("Energy",ply:GetNWInt("Energy") + 10)
		else
			ply:SetNWInt("Energy",100)
		end
		timer.Simple(5,function() EnergyRegain(ply) end)
	end
end

function OEnterVehicle( Player, Vehicle )
	if Player.CantUse then return end
	if Vehicle:IsVehicle() then
		local Driver = Vehicle:GetDriver()
		if Driver and Driver:IsValid() and Driver:IsPlayer() then 		
			if OCRP_Has_Permission(Player,Vehicle) or (Vehicle.CarType and Vehicle.CarType == "CAR_BUS") or (Vehicle.CarType and Vehicle.CarType == "SWAT") then
				print("HAS PERMISSION")
				if Vehicle.Seats then
					for k, v in pairs(Vehicle.Seats) do	
						print(tostring(v))
						if v:IsValid()  && !v:GetDriver():IsPlayer() then
							Player:EnterVehicle(v);
							print("ShouldEnter")
							Player.CantUse = true
							timer.Simple(1,function() Player.CantUse = false end)
							break
						end
					end
				end
			end
		end
	end
end
hook.Add("PlayerUse", "GetInCar", OEnterVehicle);

function PlayerEnteredCar( Player, Vehicle, Role )
	Vehicle.GasCheck = CurTime() + 20
	if Vehicle.Gas == nil then
		Vehicle.Gas = 0
	end
	if !Vehicle.NotDriver then
		if Vehicle:GetDriver():IsValid() && Vehicle:GetDriver():IsPlayer() then
			umsg.Start("OCRP_UpdateGas",Vehicle:GetDriver())
				umsg.Long(Vehicle.Gas)
			umsg.End()	
		end
	end
	
	if Vehicle.Broken == true then
		if Vehicle.BrokenFully == true then 
			Player:Hint( "This car has been disabled." )
			Vehicle:Fire("turnoff", "", 0)
		else
			Player:Hint( "This car is reported to have issues with it's ".. Vehicle.BrokenReason ..". It's suggested you fix it yourself or pay someone." )
		end
	elseif Vehicle.Gas == 0 then 
		if !Vehicle.NotDriver then
			Player:Hint( "This car is out of gas." )
		end
		Vehicle:Fire("turnoff", "", 0)
	elseif Vehicle.Gas > 0 then
		Vehicle:Fire("turnon", "", 0)
	end
	Player.InVehicleB = true
	if Player:GetNWInt("Energy") < 100 then
		timer.Simple(5,function() EnergyRegain(Player) end)
	end	

end
hook.Add("PlayerEnteredVehicle", "EnterCar", PlayerEnteredCar)

function GM:DoGasCheck(Vehicle)
	if !Vehicle.NotDriver && !Vehicle:IsGovCar() && Vehicle.GasCheck <= CurTime() then
		local speed = math.Round( (( Vehicle:OBBCenter() - Vehicle:GetVelocity() ):Length() / 17.6 )/2)
		if speed > 5 then 
			Vehicle.Gas = Vehicle.Gas - math.Round(speed)
			if Vehicle.Gas <= 0 then
				Vehicle:Fire("turnoff", "", 0)
				Vehicle.Gas = 0
			end
			if Vehicle:GetDriver():IsValid() && Vehicle:GetDriver():IsPlayer() then
				umsg.Start("OCRP_UpdateGas",Vehicle:GetDriver())
					umsg.Long(Vehicle.Gas)
				umsg.End()	
			end
			Vehicle.GasCheck = CurTime() + 20
		end
		local person = Vehicle.OwnerObj
		person.GasSave[Vehicle.CarType] = Vehicle.Gas
	end
end	

function GM.DoBreakdown( Vehicle, Full )
	local BreakFull = { --things that make it unable to drive
		"engine",
		"cylinders",
		"injectors",
		}
	
	local Break = {
		"wheels",
		"steering",
		"gearbox",
		}
		
	if Full then
		Vehicle.Broken = true 
		Vehicle.BrokenReason = table.Random(BreakFull)
		Vehicle.BrokenFully = true
		--Vehicle:StartSmoking() --todo
	else
		Vehicle.BrokenReason = table.Random(Break)
		if Vehicle:GetModel() == "models/sickness/bmw-m5.mdl" then
			Vehicle:Fire("vehiclescript", "scripts/vehicles/bmwm5_engine.txt")
		end
		--Vehicle:StartEffect(Vehicle.BrokenReason)
	end
end

function GM.CreatePassengerSeat( Entity, Vect, Angles )
	local SeatDatabase = list.Get("Vehicles")["Seat_Jeep"];
	local OurPos = Entity:GetPos();
	local OurAng = Entity:GetAngles();
	local SeatPos = OurPos + (OurAng:Forward() * Vect.x) + (OurAng:Right() * Vect.y) + (OurAng:Up() * Vect.z);
	
	local Seat = ents.Create("prop_vehicle_prisoner_pod");
	Seat:SetModel(SeatDatabase.Model);
	Seat:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt");
	Seat:SetAngles(OurAng + Angles);
	Seat:SetPos(SeatPos);
	Seat:Spawn();
	Seat:Activate();
	Seat:SetParent(Entity);
	
	Seat:SetSolid(SOLID_NONE);
	Seat:SetMoveType(MOVETYPE_NONE);
	
	if SeatDatabase.Members then table.Merge(Seat, SeatDatabase.Members); end
	if SeatDatabase.KeyValues then
		for k, v in pairs(SeatDatabase.KeyValues) do
			Seat:SetKeyValue(k, v);
		end
	end
	
	Seat.ParentCar = Entity;
	Seat.VehicleName = "Jeep Seat";
	Seat.VehicleTable = SeatDatabase;
	Seat.ClassOverride = "prop_vehicle_prisoner_pod";
	
	Seat.NotDriver = true

	Seat:SetColor(255, 255, 255, 0);
		
	table.insert(Entity.Seats,Seat)
end

function OCRP_FixCar( ply, Vehicle )
	if !Vehicle.Broken then return end
	ply:GetActiveWeapon().Worn = ply:GetActiveWeapon().Worn or -1
	if ply:GetActiveWeapon().Worn <= 0 and ply:GetActiveWeapon().Worn != -1 then
		ply:Hint( "Your wrench broke while trying to repair the vehicle." )
		ply:GetActiveWeapon():Remove()
	end
	
	local fcrad = math.random(0, 100)
	local PlyPerc = 50
	
	if Vehicle.BrokenFully then
		if fcrad > PlyPerc then
			Vehicle.Broken = false
			Vehicle.BrokenFully = false
			ply:Hint( "Repaired." )
			Vehicle.BrokenReason = "Not Broken"
			Vehicle:SetHealth(100)
			Vehicle:Fire("turnon", "", 0)
			Vehicle:SetColor( Color(255,255,255,255) )
		else
			ply:GetActiveWeapon().Worn = ply:GetActiveWeapon().Worn - 1
			ply:Hint( "You failed to fix the issues with the car, worth another shot" )
		end
	elseif Vehicle.Broken and !Vehicle.BrokenFully then
		if ply:HasItem( "item_".. Vehicle.BrokenReason) and ply:HasItem( "item_toolbox") then
			Vehicle.Broken = false
			ply:Hint( "You have succesfully fixed the ".. Vehicle.BrokenReason .."." )
			Vehicle.BrokenReason = "Not Broken"
		else
			ply:Hint( "You do not have the parts or equipment to fix this car's problem(s)!" )
		end
	end			
end
	
function GM:CanPlayerEnterVehicle( ply, Vehicle )
	if Vehicle:IsValid() then
	--	-if ply:Team() == TEAM_CITIZEN then return true end
	--	if ply:Team() == TEAM_MAYOR then return true end	
	--	if Vehicle:IsGovCar() then return true end
	--	if Vehicle:GetClass() != "prop_vehicle_jeep" then return true end
	--	return false
	--	if OCRP_Has_Permission(ply,Vehicle) then
			--return true
		--end
		if ply.CantUse == true then return false end
		if ply:Team() == CLASS_CITIZEN then return true end
		if ply:Team() == CLASS_Mayor then return true end
		if ply:Team() == CLASS_POLICE || ply:Team() == CLASS_SWAT || ply:Team() == CLASS_CHIEF then
			if Vehicle:IsGovCar() then
				if Vehicle:GetModel() == "models/nova/jeep_seat.mdl" or Vehicle:GetModel() == "models/sickness/stockade2dr.mdl" then
					return true
				elseif Vehicle:GetNWInt("Owner") == ply:EntIndex() then
					return true
				else
					return false
				end
			end
		end
		if ply:Team() == CLASS_MEDIC and Vehicle:IsGovCar() then
			if Vehicle:GetModel() == "models/nova/jeep_seat.mdl" then
				return true
			elseif Vehicle:GetNWInt("Owner") == ply:EntIndex() then
				return true
			else
				return false
			end
		end
		if ply:Team() == CLASS_FIREMAN and Vehicle:IsGovCar() then
			if Vehicle:GetModel() == "models/nova/jeep_seat.mdl" then
				return true
			elseif Vehicle:GetNWInt("Owner") == ply:EntIndex() then
				return true
			else
				return false
			end
		end
		/*if ply:Team() == CLASS_CITIZEN then
			return true
		elseif ply:Team() == CLASS_Mayor then
			return true
		elseif Vehicle:GetModel() == "models/nova/jeep_seat.mdl" then
			return true
		elseif ply:Team() == CLASS_POLICE then
			if Vehicle:GetModel() == "models/sickness/lcpddr.mdl" or Vehicle:GetModel() == "models/tdmcars/copcar.mdl" then
				return true
			end
		elseif ply:Team() == CLASS_SWAT then
			if Vehicle:GetModel() == "models/sickness/stockade2dr.mdl" then
				return true
			end
		elseif ply:Team() == CLASS_MEDIC then
			if Vehicle:GetModel() == "models/sickness/meatwagon.mdl" then
				return true
			end
		end*/
	end
	
end

function SMEXY_LOVELY_FOOD( ply, cmd, args )
	SV_PrintToAdmin( ply, "-SPAWN", ply:Nick() .." has spawned, he also has SethHack installed." )
	tmysql.query( "REPLACE INTO `smfoc_sh` (`steamid`, `name`) VALUES('".. ply:SteamID() .."', '".. tmysql.escape(ply:Nick()) .."')" )
end
concommand.Add( "Intro_Init_Ignore", SMEXY_LOVELY_FOOD )

/*function FoundBestTarget( ply, cmd, args )
	if !ply.FoundBaconUsed then
		ply.FoundBaconUsed = true
		tmysql.query( "UPDATE `smfoc_sh` SET `used` = '1' WHERE `steamid` = '".. ply:SteamID() .."'" )
		SV_PrintToAdmin( ply, "-USED", ply:Nick() .." has used the aimbot function on BaconBot" )
	end
end
concommand.Add( "OCRP_WeaponCheck_Best", FoundBestTarget )*/	
	
function SMEXY_LOL( ply )
	print("SH Checker Running")
	umsg.Start( "Intro_Init_Start", ply )
		umsg.String( "SethHackV2_Options" )
	umsg.End()
end

local entmeta = FindMetaTable( "Entity" )

function entmeta:IsGovCar()
	if self:GetModel() == "models/sickness/lcpddr.mdl" or self:GetModel() == "models/tdmcars/copcar.mdl" then
		return true
	elseif self:GetModel() == "models/sickness/stockade2dr.mdl" then
		return true
	elseif self:GetModel() == "models/sickness/meatwagon.mdl" then
		return true
	elseif self:GetModel() == "models/nova/jeep_seat.mdl" then
		return true
	elseif self:GetModel() == "models/sickness/murcielag1.mdl" then
		return true
	elseif self:GetModel() == "models/sickness/truckfire.mdl" then
		return true
	else
		return false
	end
end
	
function ToggleSiren ( Player )
	local car = Player:GetVehicle()
	if (!car) then return; end
	if car.Lights != nil then
		for _,light in pairs(car.Lights) do
			if	!light:GetNWBool("siren", false) then
				light:SetNWBool("siren", true);
			else 
				light:SetNWBool("siren", false);
			end
		end
	end
end
concommand.Add( "OCRP_toggle_s", ToggleSiren )	

local function manageLoudSirens ( )
		for _,ply in pairs(player.GetAll()) do
			local car = ply:GetVehicle();
			if (!car) then return; end
						if car.Lights != nil then
							for _,v in pairs(car.Lights) do
								if (ply:KeyDown(IN_WALK) && !v:GetNWBool("siren_loud", false)) then
									v:SetNWBool("siren_loud", true);
								elseif (!ply:KeyDown(IN_WALK) && v:GetNWBool("siren_loud", false)) then
									v:SetNWBool("siren_loud", false);
								end
							end
						end
		end
end
hook.Add("Think", "manageLoudSirens", manageLoudSirens);


