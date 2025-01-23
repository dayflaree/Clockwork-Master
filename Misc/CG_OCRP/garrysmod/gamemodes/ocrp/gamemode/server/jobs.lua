function OCRP_Job_Join( ply ,Job)
   --	ply.OCRPData["MyModel"] = ply:GetModel()
	if ply:Team() != CLASS_CITIZEN then
		return
	end
	if Job == CLASS_Mayor and !ply.Mayor then
		return false
	end
	if Job == CLASS_POLICE and !ply:NearNPC( "Cop" ) then
		return false
	end
	if Job == CLASS_MEDIC and !ply:NearNPC( "Medic" ) then
		return false
	end
	if Job == CLASS_FIREMAN and !ply:NearNPC( "Fireman" ) then
		return false
	end
	if Job == CLASS_CHIEF and !ply.DueToBeChief then
		return false
	end
	if Job == CLASS_SWAT and !ply.DueToBeSWAT then
		return false
	end
	if Job == CLASS_POLICE && ply.OCRPData["JobCoolDown"].Police then
		ply:Hint("You can't run as a cop yet")
		return
	elseif Job == CLASS_MEDIC && ply.OCRPData["JobCoolDown"].Medic then
		ply:Hint("You can't run as a medic yet")
		return 
	elseif Job == CLASS_FIREMAN && ply.OCRPData["JobCoolDown"].Fireman then
		ply:Hint("You can't run as a medic yet")
		return 
	end
	if ply:IsBlacklisted(Job) then
		ply:Hint( "You have been blacklisted from this job. Go to the forums to appeal." )
		return
	end
	if OCRPCfg[Job].Condition != nil then
		OCRPCfg[Job].Condition(ply)
	end
	if !ply:HasItem("item_policeradio") then
		ply:GiveItem("item_policeradio")
	end
	if Job == CLASS_SWAT then
		ply:BodyArmor(5)
	end
	if ply:GetWarrented() < 1 then
		for _,weapon in pairs(OCRPCfg[Job].Weapons) do
			ply:Give(weapon)
		end
		ply:SetTeam( Job )
	--	for k, v in pairs( ply.OCRPData["Wardrobe"] ) do
		--	if tostring(v.Choice) == tostring(true) then
			--	thekey = v.Key
		--		break
	--		end
--		end
		for _,item in pairs(GAMEMODE.OCRP_Items) do
			if item.Weapondata != nil && ply:HasItem(_) && item.Weapondata.Weapon != "weapon_physgun" && ply:HasWeapon(item.Weapondata.Weapon) then
				for _,wep in pairs(ply:GetWeapons()) do
					if wep:GetClass() == item.Weapondata.Weapon then
						if wep:Clip1() > 0 then
							wep:EmptyClip()
						end
					end
				end
				ply:StripWeapon(item.Weapondata.Weapon)
			end
		end 
		local rad = math.random(1,5)
		if Job == CLASS_POLICE then
			SV_PrintToAdmin( ply, "JOB-JOIN-POLICE", ply:Nick() .." just became a Police Officer" )
			ply:StripAmmo()
			ply:GiveItem("item_ammo_cop",32)
			ply:UpdateAmmoCount()
			if ply:GetSex() == "Male" then
				ply:ModelSet(GAMEMODE.OCRP_Gov_Models["Police"][rad])
			else
				ply:ModelSet(GAMEMODE.OCRP_Gov_Models["Police"][rad])
			end
		elseif Job == CLASS_SWAT then
			SV_PrintToAdmin( ply, "JOB-JOIN-SWAT", ply:Nick() .." just became a SWAT member" )
			ply:ModelSet("models/player/swat.mdl")
			ply:StripAmmo()
			ply:GiveItem("item_ammo_cop",32)
			ply:UpdateAmmoCount()
		elseif Job == CLASS_CHIEF then
			SV_PrintToAdmin( ply, "JOB-JOIN-CHIEF", ply:Nick() .." just became a chief of the police force" )
			if ply:GetSex() == "Male" then
				ply:ModelSet(GAMEMODE.OCRP_Gov_Models["Police"][rad])
			else
				ply:ModelSet(GAMEMODE.OCRP_Gov_Models["Police"][rad])
			end
			ply:StripAmmo()
			ply:GiveItem("item_ammo_cop",32)
			ply:UpdateAmmoCount()
		elseif Job == CLASS_MEDIC then
			SV_PrintToAdmin( ply, "JOB-JOIN-MEDIC", ply:Nick() .." just became a medic" )
			print("Random: ".. rad .." MDL: ".. GAMEMODE.OCRP_Gov_Models["Medic"][rad])
			if ply:GetSex() == "Male" then
				ply:ModelSet(GAMEMODE.OCRP_Gov_Models["Medic"][rad])
			else
				ply:ModelSet(GAMEMODE.OCRP_Gov_Models["Medic"][rad])
			end
		elseif Job == CLASS_FIREMAN then
			local rad2 = math.random( 1, 3 )
			NUMBER_FIREMEN = NUMBER_FIREMEN + 1
			SV_PrintToAdmin( ply, "JOB-JOIN-FIREMAN", ply:Nick() .." just became a fireman" )
			print("Random: ".. rad2 .." MDL: ".. GAMEMODE.OCRP_Gov_Models["Fireman"][rad2])
			if ply:GetSex() == "Male" then
				ply:ModelSet(GAMEMODE.OCRP_Gov_Models["Fireman"][rad2])
			else
				ply:ModelSet(GAMEMODE.OCRP_Gov_Models["Fireman"][rad2])
			end
		elseif Job == CLASS_Mayor then
			SV_PrintToAdmin( ply, "JOB-JOIN-MAYOR", ply:Nick() .." just became the mayor" )
			if ply:GetSex() == "Male" then
				ply:ModelSet("models/player/breen.mdl")
			else
				ply:ModelSet("models/player/mossman.mdl")
			end
		end
	else
		ply:StripAmmo()
		ply:UpdateAmmoCount()
		return
	end
	ply:StripAmmo()
	ply:UpdateAmmoCount()
end

concommand.Add("OCRP_Job_Join",function(ply,cmd,args) OCRP_Job_Join( ply ,math.Round(args[1])) end)

function PMETA:DoJobCoolDown()
	if self:Team() == CLASS_CITIZEN then return end
	if self:Team() == CLASS_POLICE then 
		self.OCRPData["JobCoolDown"].Police = true
		timer.Simple(300,function() if self:IsValid() then self.OCRPData["JobCoolDown"].Police = false end end) 
		self:Hint("You may not be a cop for 5 minutes")
	elseif self:Team() == CLASS_MEDIC then 
		self.OCRPData["JobCoolDown"].Medic = true
		timer.Simple(300,function() if self:IsValid() then self.OCRPData["JobCoolDown"].Medic = false end end) 
		self:Hint("You may not be a medic for 5 minutes")
	elseif self:Team() == CLASS_Mayor then 
		self.OCRPData["JobCoolDown"].Mayor = true
		self:Hint("You may not run as mayor in the next election")
	end
end

function PMETA:Resupply()
	if self:Team() != CLASS_CITIZEN then
		if !self:HasItem("item_policeradio") then
			self:GiveItem("item_policeradio")
		end
		self:Hint("You have resupplied")
	else
		self:Hint("Government officals can resupply here")
	end
end

function OCRP_Job_Quit( ply )
	if ply:Team() == CLASS_CITIZEN then
		return
	end
	SV_PrintToAdmin( ply, "JOB-QUIT", ply:Nick() .." just quit his job" )
	ply:DoJobCoolDown()
	for _,weapon in pairs( OCRPCfg[ply:Team()].Weapons) do
		if ply:HasWeapon(weapon) then
			ply:StripWeapon(weapon)
		end
	end
	if ply:HasWeapon("swat_shotgun_ocrp") then
		ply:StripWeapon("swat_shotgun_ocrp")
	elseif ply:HasWeapon("swat_ump45_ocrp") then
		ply:StripWeapon("swat_ump45_ocrp")
	end
	if ply:HasItem("item_policeradio") then
		ply:RemoveItem("item_policeradio")
	end
		for _,item in pairs(GAMEMODE.OCRP_Items) do
			if item.Weapondata != nil && ply:HasItem(_) && item.Weapondata.Weapon != "weapon_physgun" then
				ply:Give(item.Weapondata.Weapon)
			end
		end 
	if ply:Team() == CLASS_POLICE || ply:Team() == CLASS_CHIEF  || ply:Team() == CLASS_SWAT then
		for _,ent in pairs(ents.FindByClass("gov_resupply")) do
			if ent:IsValid() then
				if ply:HasItem("item_ammo_cop") then
					ent:Inv_GiveItem("item_ammo_cop",ply.OCRPData["Inventory"]["item_ammo_cop"])
					ply:RemoveItem("item_ammo_cop",ply.OCRPData["Inventory"]["item_ammo_cop"])
				end
				if ply:HasItem("item_ammo_riot") then
					ent:Inv_GiveItem("item_ammo_riot",ply.OCRPData["Inventory"]["item_ammo_riot"])
					ply:RemoveItem("item_ammo_riot",ply.OCRPData["Inventory"]["item_ammo_riot"])
				end
				if ply:HasItem("item_ammo_ump") then
					ent:Inv_GiveItem("item_ammo_ump",ply.OCRPData["Inventory"]["item_ammo_ump"])
					ply:RemoveItem("item_ammo_ump",ply.OCRPData["Inventory"]["item_ammo_ump"])
				end
				if ply:HasItem("item_shotgun_cop") then
					ent:Inv_GiveItem("item_shotgun_cop",ply.OCRPData["Inventory"]["item__shotgun_cop"])
					ply:RemoveItem("item_shotgun_cop",ply.OCRPData["Inventory"]["item__shotgun_cop"])
				end
				break
			end
		end
	end
	if ply:Team() == CLASS_Mayor then
		for _, p in pairs(player.GetAll()) do
			umsg.Start("ocrp_ballot", p)
				umsg.Bool(false)
			umsg.End()
		end
	end
	if ply:Team() == CLASS_FIREMAN then
		NUMBER_FIREMEN = NUMBER_FIREMEN - 1
	end
	if ply.OCRPData.CurCar then
		if ply.OCRPData.CurCar:IsValid() then
			ply.OCRPData.CurCar:Remove()
			ply.OCRPData.CurCar = nil
		end
	end
	
	ply:SetTeam( CLASS_CITIZEN )
	ply:SetModel(ply.OCRPData["MyModel"])
	ply:StripAmmo()
	ply:UpdateAmmoCount()
end

concommand.Add("OCRP_Job_Quit",function(ply,cmd,args) OCRP_Job_Quit( ply ) end)

function OCRP_Job_Demote( ply, FromTeam, demoter  )
	if demoter:Team() != CLASS_Mayor || demoter:Team() != CLASS_CHIEF then
		if demoter:GetLevel() > 3 then 
			return
		end
	end
	local TheTeam
	if FromTeam == CLASS_CITIZEN then return end
	OCRP_Job_Quit(ply)
	if FromTeam == CLASS_POLICE then
		TheTeam = "Police Officer"
	elseif FromTeam == CLASS_CHIEF then
		TheTeam = "Police Chief"
	elseif FromTeam == CLASS_SWAT then
		TheTeam = "SWAT"	
	elseif FromTeam == CLASS_FIREMAN then
		TheTeam = "Fireman"
	elseif FromTeam == CLASS_MEDIC then
		TheTeam = "Paramedic"
	end
	ply:Hint("You have been demoted from being a ".. TheTeam ..".")
	ply:Hint("If you are unsure why, ask the mayor. Wait 5 minutes before going back to that job.")
end
concommand.Add("OCRP_DemotePlayer",function(ply,cmd,args)
									for _,v in pairs(player.GetAll()) do 
										if v:Nick() == tostring(args[1]) then 
											OCRP_Job_Demote(v,v:Team(),ply) ply:Hint("Demoted "..v:Nick()) 
										end 
									end 
 end)

function OCRP_DEMOTE( ply, ply2 )
	if !ply:IsAdmin() then return false end
	ply:Hint("You have demoted ".. ply2:Nick() ..".")
	ply2:Hint("You have been demoted from your job by an Admin.")
	ply2:Hint("If you are unsure why, ask an Admin.")
	OCRP_Job_Quit(ply2)
end	

function PMETA:GetWarrented(  ) -- placeholder
	if self:GetNWInt("Warrent") > 0 then
		return self:GetNWInt("Warrent")
	end
	return 0
end

function PMETA:SetWarrented( warrent ) -- placeholder
	self:SetNWInt("Warrent",warrent)
	self:Hint("You have been warrented")
end
concommand.Add("OCRP_WarrentPlayer",function(ply,cmd,args) 
	if ply:Team() == CLASS_Mayor || ply:Team() == CLASS_CHIEF then  
		for _,v in pairs(player.GetAll()) do 
			if v:Nick() == tostring(args[1]) then 
				v:SetWarrented(math.Round(args[2])) 
				if math.Round(args[2]) > 0 then 
					ply:Hint("Warrented "..v:Nick()) 
				else 
					ply:Hint("UnWarrented "..v:Nick()) 
				end 
			end  
		end 
	end 
end)

function PMETA:Blacklist( ply, FromTeam )
	local TehTxt
	FromTeam = math.Round(FromTeam)
	print("blacklisting")
	if !self:IsAdmin() then 	print("blacklisting1") return false end
	if FromTeam == CLASS_POLICE then
		print("blacklisting2")
		TehTxt = "Police Officer"
		ply.OCRPData["Blacklists"].Cop = true
		tmysql.query("UPDATE `ocrp_users` SET `bl_police` = 'true' WHERE `STEAM_ID` = '".. ply:SteamID() .."'")
		self:Hint( "You have blacklisted ".. ply:Nick() .." from being a ".. TehTxt .."." )
		ply:Hint( "You have been blacklisted from being a ".. TehTxt .."." )
	else
		print("blacklisting3")
		TehTxt = "Paramedic"
		ply.OCRPData["Blacklists"].Medic = true
		tmysql.query("UPDATE `ocrp_users` SET `bl_medic` = 'true' WHERE `STEAM_ID` = '".. ply:SteamID() .."'")
		self:Hint( "You have blacklisted ".. ply:Nick() .." from being a ".. TehTxt .."." )
		ply:Hint( "You have been blacklisted from being a ".. TehTxt .."." )		
	end
	if ply:Team() == FromTeam then
		OCRP_Job_Quit( ply )
	end
end

function PMETA:IsBlacklisted( job )
	if job == CLASS_POLICE then
		if self.OCRPData["Blacklists"].Cop == true then
			return true
		else
			return false
		end
	elseif job == CLASS_MEDIC then
		if self.OCRPData["Blacklists"].Medic == true then
			return true
		else
			return false
		end
	end
	return false
end

function PMETA:UnBlacklist( ply, Team )
	local TheTxt
	if !self:IsAdmin() then return false end
	if Team == CLASS_POLICE then
		TheTxt = "Police Officer"
		ply.OCRPData["Blacklists"].Cop = false
		tmysql.query("UPDATE `ocrp_users` SET `bl_police` = 'false' WHERE `STEAM_ID` = '".. ply:SteamID() .."'")
		self:Hint( "You have unblackliisted".. ply:Nick() .."." )
		ply:Hint( "You have been unblacklisted from ".. TheTxt .."." )
	else
		TheTxt = "Paramedic"
		ply.OCRPData["Blacklists"].Medic = false
		tmysql.query("UPDATE `ocrp_users` SET `bl_medic` = 'false' WHERE `STEAM_ID` = '".. ply:SteamID() .."'")
		self:Hint( "You have unblackliisted".. ply:Nick() .."." )
		ply:Hint( "You have been unblacklisted from ".. TheTxt .."." )
	end
end
		
function PMETA:JailPlayer( Time, Bail, Arrester )
	if Arrester:Team() != CLASS_POLICE && Arrester:Team() != CLASS_CHIEF then return false end
	if Arrester:GetPos():Distance(self:GetPos()) > 100 then return false end
	self.Arrested = true
	self.Bail = Bail
	if self:GetWarrented() == 2 then Time = Time * 3 end
	umsg.Start("OCRP_Arrest", self) -- Send the arrest to the player
		umsg.Long( CurTime() + Time )
		umsg.Long( Bail )
	umsg.End()
	if GAMEMODE.Maps[string.lower(game.GetMap())].Jails != nil then
		local free = true
		local data = table.Random(GAMEMODE.Maps[string.lower(game.GetMap())].Jails)
			for _,objs in pairs(ents.FindInSphere(data.Position,32)) do
				if objs:IsPlayer() then
					local free = false
					break
				end
			end
		if free then
			self:SetPos(data.Position + Vector(0,0,10))
			self:SetAngles(data.Ang)
		else
			for _,data in pairs(GAMEMODE.Maps[string.lower(game.GetMap())].Jails) do
				free = true
				for _,objs in pairs(ents.FindInSphere(data.Position,32)) do
					if objs:IsPlayer() then
						local free = false
						break
					end
				end
				if free then
					self:SetPos(data.Position + Vector(0,0,10))
					self:SetAngles(data.Ang)
					break
				end
			end	
		end
	end
	SV_PrintToAdmin( self, "ARREST", self:Nick() .." was arrested by ".. Arrester:Nick() )
	self:StripWeapons()
	
	for illitem,bool in pairs(GAMEMODE.IllegalItems) do
		if self:HasItem(illitem) then
			Arrester:AddMoney(100)
			Arrester:Hint("You have gained $100 for arresting someone carrying Illegal weapons")
			break
		end
	end
	
	if !self:GetNWBool("Handcuffed") then
		self:SetNWBool("Handcuffed",true)
	end
		if self:GetWarrented() >= 2 then
			Arrester:AddMoney(1000)
			Arrester:Hint("You have gained $1000 for arresting a warrented criminal")
			for illitem,bool in pairs(GAMEMODE.IllegalItems) do
				if self:HasItem(illitem) then
					self:RemoveItem(item)
				end
			end
		end
	
	--timer.Simple(Time, function() if self.Arrested then self:UnJail() end end)
	timer.Simple(Time, function ( )
		if self.Arrested then
			self:UnJail()
		end
	end);
	
	self:SetNWInt("Warrent",0)
end

concommand.Add("OCRP_Arrest_Player",function(ply1,cmd,args) local ply = player.GetByID(args[3]) ply:JailPlayer(args[1],math.Round(args[2]),ply1) end)

concommand.Add("OCRP_Handcuffplayer",function(ply,cmd,args) 
	if ply:Team() == CLASS_POLICE || ply:Team() == CLASS_CHIEF then 
		local player = player.GetByID(args[1]) 
		ply:Hint("You Handcuffed "..player:Nick()) 
		player:SelectWeapon("weapon_idle_hands_ocrp") 
		player:SetNWBool("Handcuffed", true ) 
		SV_PrintToAdmin( player, "HANDCUFF", player:Nick() .." was handcuffed by ".. ply:Nick() )
	end 
end)

function PMETA:UnJail()
	self:Hint("You have been released from jail.")
	self.Arrested = false
	self:Spawn()
	self:SetNWBool("Handcuffed",false)
end

concommand.Add("OCRP_Pay_Bail", function(ply,cmd,args) 
										ply:AddMoney(WALLET,ply.Bail*-1)
										Mayor_SpawnMoney(ply.Bail)
										ply:UnJail()
										ply.Bail = 0
									end)
	
concommand.Add("OCRP_IllegalizeItem", function(ply,cmd,args) 
										if ply:Team() == CLASS_Mayor then
											for _,item in pairs(GAMEMODE.IllegalItems) do
												if item == tostring(args[1]) then
													return
												end
											end
											GAMEMODE.IllegalItems[tostring(args[1])] = tobool(args[2])
										end
									end)
						
									

		
