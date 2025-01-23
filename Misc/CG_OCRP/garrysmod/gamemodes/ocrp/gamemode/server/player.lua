GM.PlayerTable = {}
function GM:PlayerInitialSpawn(ply)
	ply.Speeds = {Sprint = 300,Run = 100}
	ply.OCRPData = {}

	ply.OCRPData["Inventory"] = {WeightData = {Cur = 0,Max = 50}} -- Just makes the table	
	ply.OCRPData["Buddies"] = {} -- Buddies table
	ply.OCRPData["Blacklists"] = {}
	ply.OCRPData["Cars"] = {}
	ply.OCRPData["Wardrobe"] = {}
	ply.OCRPData["Money"] = {}
	ply.OCRPData["Storage"] = {}
	ply.OCRPData["JobCoolDown"] = {Police = false, Medic = false, Mayor = false}
	
	ply.OCRPData["Challenges"] = {}
	for k, v in pairs( GAMEMODE.Challenges ) do
		ply.OCRPData["Challenges"][v.Other] = {}
		ply.OCRPData["Challenges"][v.Other].Num = 0
		ply.OCRPData["Challenges"][v.Other].CanDo = true
		ply.OCRPData["Challenges"][v.Other].Complete = false
	end
	
	ply.GasSave = {}
	
	--for _, data in pairs( GAMEMODE.Challenges ) do
	--	OCRP_Challenge_UMSG( ply, data.Other, true )
	--end
	
	ply.OCRPData["Skills"] = {Points = 20} -- Another
	
	ply.RechargeTime  = .05
	ply.SprintDecay = .05
		
	--ply:SetNoCollideWithTeammates( true )
	
	ply.VisibleWeps = {}
	
	ply:SetTeam( CLASS_CITIZEN )
--	if SinglePlayer then return end
	ply:SetModel("models/player/Group01/male_07.mdl")
	
	timer.Simple(10, function() SMEXY_LOL( ply ) end)
	
	timer.Simple(40,function() 
						if !ply:IsValid() then return end
						for _,ent in pairs(ents.FindByClass("item_base")) do
							if ent.price != nil then
								local amt = 0
								if ent.Amount != nil && tonumber(ent.Amount) > 1 then
									amt = ent.Amount
								else
									amt = 1
								end		
								umsg.Start("CL_PriceItem", ply)
									umsg.Bool(false)
									umsg.Entity(ent)
									umsg.Long(tonumber(ent.price))
									umsg.String(tostring(ent.desc))	
									umsg.Long(amt)		
								umsg.End()
							end
						end
					end)

	timer.Simple(5,function()	
				if !ply:IsValid() then return end
				tmysql.query("SELECT `storage` FROM `ocrp_users` WHERE `STEAM_ID` = '".. ply:SteamID() .."'",
				function( Res )
					if Res and Res[1] and Res[1][1] and Res[1][1] != "None" then
						ply:UnCompileString("storage", Res[1][1])
					end
				end)
				GAMEMODE:LoadSQL( ply ) 
				ply:Hint("All of your weapons are hidden for 3 minutes, Some items may be illegal.")
				ply:Hint("In order to conceal contraband store your items in boxes.")
			
					for i = 1, 5 do
						ply:Hint("If you see errors, get the content pack(s) at www.catalyst-gaming.net")
					end
				timer.Simple(30,function() 
								if !ply:IsValid() then return end
								--[[if ply.VisibleWeps != nil then
									for _,obj in pairs(ply.VisibleWeps) do
										if obj:IsValid() then 
											obj:SetNoDraw(true) 
										end
									end
								end]]
							end)
				timer.Simple(210,function() 
			
					if ply:IsValid() then
						--[[for _,obj in pairs(ply.VisibleWeps) do
							if obj:IsValid() then 
								obj:SetNoDraw(false) 
							end
						end]]
						ply:Hint("Your weapons now display.")
					end
				end)
	end)
	
	timer.Simple(15,function()
						if !ply:IsValid() then return end
						if ply:GetLevel() <= 4 then
							ply:Give("weapon_physgun")
						end
						if ply:GetLevel() <= 2 then
							ply:Give("god_stick")
						end
					end)
	
	OCRPWelcome( ply )
	
	ply.Wounds = {}
	ply.Inhibitors = {ForceWalk =  false,BrokenArm = false,GravGuning = false,}
	timer.Simple(60, function()
						if !ply:IsValid() then return end
						for _,ply1 in pairs(player.GetAll()) do
							if ply1.Loaded then
								for item,data in pairs(GAMEMODE.OCRP_Items) do
									if data.Weapondata != nil && !data.Weapondata.DontDisplay then
										--[[for _,obj in pairs(ply1.VisibleWeps) do
											if data.Weapondata.Weapon == obj.Weapon then
												umsg.Start("OCRP_UpdateWeapon",ply)
													umsg.String(item)
													umsg.Long(ply1:EntIndex())
													umsg.Long(obj:EntIndex())
												umsg.End()
											end
										end]]
									end
								end
							end
						end
					end)
	timer.Simple(90, function()
							if !ply:IsValid() then return end
							for _,ent in pairs(ents.GetAll()) do
								if ent:IsDoor() then
									if ent.Propertykey != nil then
										if ent:GetNWInt("Owner") > 0 then
											if ply:IsValid() then
												umsg.Start("OCRP_UpdateOwnerShip", ply)
													umsg.Long(ent:GetNWInt("Owner"))
													umsg.String(GAMEMODE.Properties[string.lower(game.GetMap())][ent.Propertykey].Name)
												umsg.End()	
											end
										end
									end
								end
							end
						end)	
	timer.Simple(20, function()
							if !ply:IsValid() then return end
							for _,ent in pairs(ents.FindByClass("item_base")) do
								if ent.Drug != nil && ent:IsValid() then
									for _,ply in pairs(player.GetAll()) do
										if ply:IsValid() then
											umsg.Start("OCRP_CreateWeed",ply)
												umsg.Entity(ent)
											umsg.End()
										end
									end
								end
							end	
						end)
	--OCRP_SetModelUpdate( ply,math.random(1,5),true)
--[[for _,ply1 in pairs(player.GetAll()) do
		for _,weapon in pairs(ply1.VisibleWeps) do
			umsg.Start("OCRP_UpdateWeapon",ply)
				print(item)
				umsg.String(item)
				umsg.Long(self:EntIndex())
				umsg.Long(weapon:EntIndex())
			umsg.End()	
		end		
	end	]]--		
end

function GM:PlayerSpawn( ply )
	ply:SetParent(nil)
	if GAMEMODE.Maps[string.lower(game.GetMap())] != nil then
		if GAMEMODE.Maps[string.lower(game.GetMap())].SpawnsCitizen != nil then
			local free = true
			local data = table.Random(GAMEMODE.Maps[string.lower(game.GetMap())].SpawnsCitizen)
				for _,objs in pairs(ents.FindInSphere(data.Position,32)) do
					if objs:IsPlayer() then
						local free = false
						break
					end
				end
			if free then
				ply:SetPos(data.Position + Vector(0,0,10))
				ply:SetAngles(data.Ang)
			else
				for _,data in pairs(GAMEMODE.Maps[string.lower(game.GetMap())].SpawnsCitizen) do
					free = true
					for _,objs in pairs(ents.FindInSphere(data.Position,32)) do
						if objs:IsPlayer() then
							local free = false
							break
						end
					end
					if free then
						ply:SetPos(data.Position + Vector(0,0,10))
						ply:SetAngles(data.Ang)
						break
					end
				end	
			end
		end
	end	
	
	if ply:GetRagdoll() then 
		ply:GetRagdoll():Remove() 
		ply.Ragdoll = nil
	end
	for _,wound in pairs(ply.Wounds) do
		if wound:IsValid() then
			wound:Remove()
		end
	end
	
	--[[for _,weapon in pairs(ply.VisibleWeps) do 
		if weapon:IsValid() then
			weapon:SetNoDraw(false)
		end
	end	]]
	
	--- Energy ----
	ply.Energy = 100
	ply.ChargeInt = 0 
	umsg.Start("spawning_energy", ply)
		umsg.Long(100)
	umsg.End()
	---------------
	
	ply.KOInfo = {}
	ply:Give("weapon_keys_ocrp")
	ply:Give("weapon_idle_hands_ocrp")
	ply:Give("weapon_physcannon")
	ply:SelectWeapon("weapon_idle_hands_ocrp")
	
	if ply.Stank != nil then
		ply.Stank.obj:Remove()
		ply:SetColor(255,255,255,255)
	end 
	
	GAMEMODE.SetPlayerSpeed(ply,ply,ply.Speeds.Run,ply.Speeds.Sprint)
	
	if ply:Team() > 1 then
		for _,weapon in pairs(OCRPCfg[ply:Team()].Weapons) do
			ply:Give(weapon)
		end
	end
	
	ply:SetNWInt("Warrent",0)
	
	for item,amount in pairs(ply.OCRPData["Inventory"]) do
		if item != "WeightData" && GAMEMODE.OCRP_Items[item].Weapondata != nil && amount > 0 then
			ply:Give(GAMEMODE.OCRP_Items[item].Weapondata.Weapon)
		end	
	end
	for skill,level in pairs(ply.OCRPData["Skills"]) do
		if skill != "Points" && GAMEMODE.OCRP_Skills[skill].Function != nil then
			GAMEMODE.OCRP_Skills[skill].Function(ply,skill)
		end
	end
	ply:StripAmmo()
	ply:UpdateAmmoCount()
	
	if ply:GetLevel() <= 4 then
		ply:Give("weapon_physgun")
	end
	if ply:GetLevel() <= 2 then
		ply:Give("god_stick")
	end
end

function PMETA:CreateWound(pos,time)
--[[
	local wound = ents.Create("bleed_obj")
	wound:SetPos(pos)
	wound:SetParent(self)
	wound:Spawn()
	wound:DrawShadow( false )
	
	table.insert(self.Wounds,wound)
	timer.Simple(60,function() if wound:IsValid() then wound:Remove() end end)]]

end

function PMETA:BodyArmor(grade)
	if self.BArmor != nil && self.BArmor:IsValid() then
		if grade == 0 then
			self.BArmor:Remove()
			self.BArmor = nil
		else
			self.BArmor.Grade = grade
			self.BArmor.Health = 50
		end
	else
		if grade == 0 then
			self.BArmor = nil
			return
		end
		self.BArmor = ents.Create("body_armor")
		self.BArmor.Grade = grade
		self.BArmor.Health = 50
		self.BArmor:SetPos(self:GetPos() + Vector(0,0,40)) 
		self.BArmor:SetNWInt("Owner",self:EntIndex()) 
		self.BArmor:SetAngles(self:GetAngles())
		self.BArmor:SetParent(self)
		self.BArmor:Spawn()
	end
	self:Hint("You are wearing body armor")
end

function GM:SetPlayerSpeed( ply, run, sprint )

	ply:SetWalkSpeed( run )
	ply:SetRunSpeed( sprint )
	
end

function SV_GetEnergy( ply )
	return ply.Energy or 100
end

function SV_SetEnergy( ply, ZeAmt )
	ply.Energy = ZeAmt
end

--[[function InvisibilityCheck ( ply )
	local r, g, b, a = Player:GetColor();
	if ply:IsValid() & a == 0 then
		for _,obj in pairs(ply.VisibleWeps) do
			if obj:IsValid() then 
				obj:SetNoDraw(true) 
			end
			ply:Hint("Your weapons are hidden")
		end
	elseif ply:IsValid() & a == 255 then
		for _,obj in pairs(ply.VisibleWeps) do
			if obj:IsValid() then 
				obj:SetNoDraw(false)
			end
			ply:Hint("Your weapons are now on display")
		end
	end
end]]

function SprintDecay(ply, data)
	if ply:KeyPressed(IN_JUMP) && ply:OnGround() then
		if  SV_GetEnergy(ply) > 10 then
			if ply:HasSkill("skill_acro") then
				ply:SetJumpPower(240)
			else
				ply:SetJumpPower(160)
			end
			if ply:HasSkill("skill_acro",2) then
				SV_SetEnergy(ply, SV_GetEnergy(ply) - 5)
			else
				SV_SetEnergy(ply, SV_GetEnergy(ply) - 10)
			end
		else
			ply:SetJumpPower(115)
			SV_SetEnergy(ply,0)
		end
	end
	if ply.Inhibitors.ForceWalk || ply.Inhibitors.GravGuning then
		return
	end
	if ply:KeyDown(IN_SPEED) && ply:OnGround() && !ply.Inhibitors.ForceWalk then
		if math.abs(data:GetForwardSpeed()) > 0 || math.abs(data:GetSideSpeed()) > 0 then
			data:SetMoveAngles(data:GetMoveAngles())
			data:SetSideSpeed(data:GetSideSpeed()* 0.1)
			data:SetForwardSpeed(data:GetForwardSpeed())
			if SV_GetEnergy(ply) > 0 && ply.ChargeInt <= CurTime()  then
				SV_SetEnergy(ply, SV_GetEnergy(ply) - 1)
				ply.ChargeInt = CurTime() + 0.05
			end
		end
	else
		if SV_GetEnergy(ply) < 100 && ply.ChargeInt <= CurTime() then
			SV_SetEnergy(ply, SV_GetEnergy(ply) + 1)
			ply.ChargeInt = CurTime() + 1
		end
	end
	if SV_GetEnergy(ply) > 0 && !ply.CanSprint then
		ply:SetRunSpeed(ply.Speeds.Sprint)
		ply.CanSprint = true
	elseif SV_GetEnergy(ply) <= 0 && ply.CanSprint  then
		ply:SetRunSpeed(ply.Speeds.Run)
		ply.CanSprint = false
		ply.ChargeInt = CurTime() + 5
	end
	--print("SERVER: ".. SV_GetEnergy(ply))
end
hook.Add("Move", " SprintDecay",  SprintDecay)


function GM:EntityTakeDamage( ent, inflictor, attacker, amount,dmginfo )
	if ent:IsNPC() then
		amount = 0
		dmginfo:SetDamage(0)
	end
	if !ent:IsVehicle() && ent.Seats != nil then
		for _,seat in pairs(ent.Seats) do
			if seat:IsValid() && seat:GetDriver():IsPlayer() then
				seat:GetDriver():TakeDamage(amount)
			end
		end
	end
	if ent:IsPlayer() && inflictor:IsVehicle() && attacker:IsPlayer() then
		ent:TakeDamage(amount*1.65)
	end
	if ent:GetClass() == "prop_ragdoll" && ent.player != nil  then
		if  dmginfo:IsBulletDamage() || dmginfo:IsExplosionDamage() then
			OCRP_Job_Quit(ent.player)
			ent.Inhibitors = {ForceWalk =  false,BrokenArm = false,GravGuning = false,}
			umsg.Start("inhib_forcewalk")
				umsg.Bool( false )
			umsg.End()
			ent.player.Ragdoll = nil
			ent.player:Spawn()
			ent.player:SetNWBool("Handcuffed",false)
			umsg.Start("SpawningDeath", ent.player)
			umsg.End()
			Rag_Decay(ent)
			return
		end
	end
	if ent:IsPlayer() then
		if ent.Damage then
			dmginfo:ScaleDamage(ent.Damage)	
			ent.Damage = nil
		end
	end
--[[if ent:IsPlayer() then
		if dmginfo:GetAttacker():IsValid() then
			if dmginfo:GetAttacker():IsPlayer() && dmginfo:GetAttacker():GetActiveWeapon():GetClass() == "weapon_knife_ocrp" && dmginfo:GetAttacker():Crouching() then
				print(math.Round(ent:GetAngles():Forward().y) - math.Round(dmginfo:GetAttacker():GetAngles():Forward().y))
				if math.Round(ent:GetAngles():Forward().y) - math.Round(dmginfo:GetAttacker():GetAngles():Forward().y) <= 1 then
					dmginfo:ScaleDamage( 5 )
				end
			end
		end
	end]]
	
	if ( ent:GetClass() == "prop_vehicle_jeep" ) then
		ent:SetHealth(ent:Health() - (dmginfo:GetDamage() * 10000))
		if ent:Health() <= 0 then
			GAMEMODE.DoBreakdown( ent, true )
			local Shroom = ents.Create('prop_fire')
			Shroom:SetPos(ent:GetPos())
			Shroom:Spawn()
			if ent:GetDriver():IsPlayer() and ent:GetDriver():IsValid() then
				ent:GetDriver():ExitVehicle()
			end
		elseif ent:Health() <= 25 then
			GAMEMODE.DoBreakdown( ent, false )
		end
	end
 
	if ( ent:IsDoor() )  then
		if ent.PadLock && ent.PadLock != nil then
			ent.PadLock:TakeDamage(dmginfo:GetDamage(),dmginfo:GetAttacker(),dmginfo:GetAttacker())
		end
	end
end


function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )
	if dmginfo:IsFallDamage() then
		dmginfo:ScaleDamage( .25 )
		ply.Damage = .25
	end
	if ( hitgroup == HITGROUP_HEAD ) then
		dmginfo:ScaleDamage( 2 )
		ply.Damage = 4
	end
	if ( hitgroup == HITGROUP_LEFTLEG ) || (hitgroup == HITGROUP_RIGHTLEG) then
		ply.Inhibitors.ForceWalk = true
		umsg.Start("inhib_forcewalk", ply)
			umsg.Bool( true )
		umsg.End()
		ply:SetRunSpeed(ply.Speeds.Run)
		ply:Hint("Your leg is broken")
	end
	if ( hitgroup == HITGROUP_LEFTARM ) || (hitgroup == HITGROUP_RIGHTARM) then
		if math.random(1,2) == 1 then
			ply.Inhibitors.BrokenArm = true
			ply:Hint("Your Arm is broken, only pistols may be used")
		end
	end	
	if ( hitgroup == HITGROUP_STOMACH ) ||  ( hitgroup == HITGROUP_CHEST ) && ply.BArmor != nil then
		if dmginfo:IsBulletDamage() then
			if dmginfo:GetAttacker():GetActiveWeapon().Peircing  != nil then 
				if dmginfo:GetAttacker():GetActiveWeapon().Peircing < ply.BArmor.Grade then
					dmginfo:SetDamage(0)
					ply:SetVelocity(dmginfo:GetDamageForce()/8)
					ply.Damage = 0
				elseif dmginfo:GetAttacker():GetActiveWeapon().Peircing == ply.BArmor.Grade then
					if math.random(1,2) == 1 then
						dmginfo:ScaleDamage( .5 )
						ply:SetVelocity(dmginfo:GetDamageForce()/6 )
						ply.Damage = .5
					else
						dmginfo:ScaleDamage( 0 )
						ply:SetVelocity(dmginfo:GetDamageForce()/6 )
						ply.Damage = 0
					end		
				else
					ply:SetVelocity(dmginfo:GetDamageForce() /4 )
					ply.Damage = .75
				end
			end
		end
	end
 	if ply:HasSkill("skill_str",2) then
		dmginfo:ScaleDamage( 0.75 )
		ply.Damage = .75
	end
	
end


function PMETA:IsBlacklisted(class)
	if class == CLASS_POLICE then
		if self.OCRPData["Blacklists"].Cop == true then
			return true
		end
	elseif class == CLASS_MEDIC then
		if self.OCRPData["Blacklists"].Medic == true then
			return true
		end
	else
		return false
	end
end

function DisableNoclip( ply )
	return ply:GetLevel() < 2
end
hook.Add("PlayerNoClip", "DisableNoclip", DisableNoclip)

function GM:CleanUp()
	for _,ent in pairs(ents.GetAll()) do
		if ent:GetClass() == "item_base"  then
			if ent:GetNWInt("Owner") > 0 && !player.GetByID(ent:GetNWInt("Owner")):IsValid() then
				if ent:GetNWInt("Class") != "item_pot" then
					ent:Remove()
					if ent.Ladder != nil then
						ent.Ladder:Remove()
					end
				elseif ent:GetNWInt("Class") == "item_pot" then
						ent:Remove()
				end	
			end
		elseif ent:IsVehicle() then
			if ent:GetNWInt("Owner") > 0 && !player.GetByID(ent:GetNWInt("Owner")):IsValid() then
				ent:Remove()
			end
		elseif ent:IsDoor() && ent:GetClass() != "prop_vehicle_jeep" then
			if ent:GetNWInt("Owner") > 0 && !player.GetByID(ent:GetNWInt("Owner")):IsValid() then
				ent:SetNWInt("Owner",nil)
				ent.Permissions = {}
				ent.Permissions["Buddies"] = false
				ent.Permissions["Org"] = false
				ent.Permissions["Goverment"] = true
				ent.Permissions["Mayor"] = true
			end
		elseif ent:GetClass() == "prop_ragdoll" then
			if ent.player != nil && !ent.player:IsValid() then
				ent:Remove()
			end
		end
	end
end

function Player_Disconnect( ply )
	timer.Simple(0.5,function() GAMEMODE:CleanUp() end)
	--[[if !ply:Alive() then
		if ply:GetRagdoll():IsValid() then
			if type(ply:GetRagdoll()) != "boolean" then
				ply:GetRagdoll():Remove()
			end
		end
	end
	if GAMEMODE.MayorBallot != nil then
		for _,py in pairs(GAMEMODE.MayorBallot) do
			if ply == py then
				Mayor_RemoveBallot(py)
				break
			end
		end
	end
	for k, v in pairs(ents.GetAll()) do
		if v:GetClass() == "item_base"  then
			if v:GetNWInt("Owner")  == ply:EntIndex() then
				if v:GetNWInt("Class") != "item_pot" then
					v:Remove()
					if v.Ladder != nil then
						if v.Ladder:IsValid() then
							v.Ladder:Remove()
						end
					end
				elseif v:GetNWInt("Class") == "item_pot" then
					if v.Drug != nil then
						v:SetNWInt("Owner",nil)
					else
						v:Remove()
					end
				end
			end
		end
		if v:IsVehicle() then
			if v:GetNWInt("Owner") == ply:EntIndex() then
				v:Remove()
			end
		end
		if v:IsDoor() && v:GetNWInt("Owner") == ply:EntIndex() then

		end
	end
	if ply.OCRPData["CurCar"] != nil then
		if ply.OCRPData["CurCar"]:IsValid() then
			ply.OCRPData["CurCar"]:Remove()
		end
	end]]
end
hook.Add( "PlayerDisconnected", "playerdisconnected", Player_Disconnect ) // Add PlayerDisconnected hook that calls our function.

function GM:CanPlayerSuicide( ply )
	return false
end

function GM:GravGunPunt( ply, Target )
	return false 
end 

function GM:GravGunPickupAllowed( ply, ent )
	if ent:IsValid() then
		if (ent:GetClass() != "item_base") then
			return false 
		end
	end
	return true 
end

function ScaleDamage( npc, hitgroup, dmginfo )
	npc:SetHealth(9999)
	dmginfo:ScaleDamage( 0 )
	dmginfo:SetDamage( 0 )
end
 
hook.Add("ScaleNPCDamage","ScaleDamage",ScaleDamage)

concommand.Add("OCRP_EmptyCurWeapon",function(ply,cmd,args) if ply:GetActiveWeapon().Primary.ClipSize > 0 && ply:GetActiveWeapon():Clip1() > 0 then ply:GetActiveWeapon():EmptyClip() end end)
	
function PMETA:GetRagdoll()
	if self.Ragdoll != nil && self.Ragdoll:IsValid() then
		return self.Ragdoll
	end
	return false
end

function GM:OnPhysgunReload( weapon, ply )
	return false
end

function PhysgunFreezing(weapon, physobj, ent, ply)
	if SERVER then
		ply.CantUse = true
		timer.Simple(1.5,function() ply.CantUse = false end)
	end
end
hook.Add("OnPhysgunFreeze", "PhysgunFreezing", PhysgunFreezing)

function NoPhysgunReload( weapon, ply )
	return
end
hook.Add("OnPhysgunReload", "NoPhysgunReloadForYou", NoPhysgunReload)

function GravPickup( ply, ent )
	if (ent:GetClass() == "item_base") && ent.DropTime + 60 < CurTime() then
		return false 
	end
	ply.Inhibitors.GravGuning = true
	ply:SetRunSpeed(ply.Speeds.Run)
	return true 
end
hook.Add("GravGunOnPickedUp", "GravPickup", GravPickup);

function gravDrop(ply,ent)
	ply.Inhibitors.GravGuning = false
	ply:SetRunSpeed(ply.Speeds.Sprint)
end
 
hook.Add( "GravGunOnDropped", "firyLaunch", gravDrop)

function GM:OnPhysgunReload(wep,ply)
	return false
end
hook.Add("OnPhysgunReload", "OnPhysgunReloadIgnite",NEDM)
