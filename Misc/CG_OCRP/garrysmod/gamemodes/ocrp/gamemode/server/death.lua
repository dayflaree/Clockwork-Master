function OCRP_PlyDeath( victim, weapon, killer )
	if weapon:GetClass() == "prop_vehicle_jeep" then
		if weapon:GetDriver() == nil then
			SV_PrintToAdmin( victim, "DEATH-VEHICLE", victim:Nick() .." was killed by a vehicle, the driver is UNKNOWN/ERROR" )
		else
			SV_PrintToAdmin( victim, "DEATH-VEHICLE", victim:Nick() .." was killed by a vehicle, the driver is ".. weapon:GetDriver():Nick() )
		end
	end
end
hook.Add( "PlayerDeath", "OCRP_PlayerDeath", OCRP_PlyDeath )

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	ply.Ragdoll = ents.Create("prop_ragdoll")
	ply.Ragdoll:SetModel(ply:GetModel())
	ply.Ragdoll:SetPos(ply:GetPos())
	ply.Ragdoll:SetAngles(ply:GetAngles());
	ply.Ragdoll:Spawn()
	ply.Ragdoll:Activate()
	ply.Ragdoll:SetCollisionGroup(COLLISION_GROUP_WORLD)
	ply.Ragdoll:GetPhysicsObject():ApplyForceCenter(dmginfo:GetDamageForce() * dmginfo:GetDamage()/5);
	ply.Ragdoll.player = ply
	ply.Ragdoll.Lootable = false
	
	ply:GetRagdoll().Zaps = 0
	ply:GetRagdoll().Decay = 0 

	ply:AddDeaths( 1 )
	
	ply:BodyArmor(0)
	
	if attacker:IsPlayer() && attacker:GetActiveWeapon() && attacker:GetActiveWeapon():GetClass() then
		SV_PrintToAdmin( ply, "DEATH-WEAPON", ply:Nick() .." was killed by " .. attacker:Nick() .. ". Using " .. attacker:GetActiveWeapon():GetClass() )
	end
	
	--[[for _,weapon in pairs(ply.VisibleWeps) do 
		if weapon:IsValid() then
			weapon:SetNoDraw(true)
		end
	end]]--
	local tim3r = 0 
	if attacker:GetClass() == "env_explosion" then
		ply.KOInfo = {Wait = CurTime() + 120, Death = true,}
	elseif attacker:GetClass() == "prop_vehicle_jeep" then
		ply.KOInfo = {Wait = CurTime() + 10, Death = false,}
	elseif attacker:IsPlayer() && attacker:Alive() then
		if attacker:GetActiveWeapon():GetClass() != "weapon_idle_hands_ocrp" && attacker:GetActiveWeapon():GetClass() != "weapon_bat_ocrp" && attacker:GetActiveWeapon():GetClass() != "police_baton" then
			ply.KOInfo = {Wait = CurTime() + 60, Death = true,}
			ply.Ragdoll.Lootable = true
		else
			ply.KOInfo = {Wait = CurTime() + 30, Death = false,}
		end
	elseif dmginfo:IsFallDamage() then
		ply.KOInfo = {Wait = CurTime() + 120, Death = true,}
	elseif dmginfo:IsExplosionDamage( ) then
		ply.KOInfo = {Wait = CurTime() + 120, Death = true,}
		ply.Ragdoll.Lootable = true 
	else
		ply.KOInfo = {Wait = CurTime() + 180, Death = true,}
	end
	
 	umsg.Start("OCRP_DeathTime", ply)
	umsg.Long(ply.KOInfo.Wait)
	umsg.Bool(ply.KOInfo.Death)
	umsg.End()
 
 	if ply:HasItem("item_life_alert") then
		for _,py in pairs(team.GetPlayers(CLASS_MEDIC)) do
			umsg.Start("OCRP_LifeAlert", py)
			umsg.Long( math.Round(ply.Ragdoll:GetPos().x) )
			umsg.Long( math.Round(ply.Ragdoll:GetPos().y) )
			umsg.Long( math.Round(ply.Ragdoll:GetPos().z) )
			umsg.End()
		end
	end
 
	if ( attacker:IsValid() && attacker:IsPlayer() ) then
 
		if ( attacker == ply ) then
			attacker:AddFrags( -1 )
		else
			attacker:AddFrags( 1 )
		end
 
	end
 	for item,data in pairs(GAMEMODE.OCRP_Items) do
		if data.Weapondata != nil then
			if ply:GetActiveWeapon() != nil && data.Weapondata.Weapon == ply:GetActiveWeapon():GetClass() && ply:HasItem(item) && ply:Team() == CLASS_CITIZEN && !data.Weapondata.DontDrop then
				ply:DropItem(item)
				break
			end
		end
	end
end
function GM:PlayerDeathThink( ply )

	if (  ply.KOInfo.Wait != nil && ply.KOInfo.Wait > CurTime() ) then return end
	if !ply:Alive() then
		if ply.KOInfo.Death then 
			--if ply:Team() == CLASS_Mayor then
				OCRP_Job_Quit(ply)
			--end
			
			ply.Inhibitors = {ForceWalk =  false,BrokenArm = false,GravGuning = false,}
			umsg.Start("inhib_forcewalk")
				umsg.Bool( false )
			umsg.End()
			Rag_Decay(ply.Ragdoll)
			ply.Ragdoll = nil
			ply:Spawn()
			ply:SetNWBool("Handcuffed",false)
			umsg.Start("SpawningDeath", ply)
			umsg.End()
		else
			local pos = ply:GetRagdoll():GetPos()
			ply:Spawn()
			ply:SetHealth(math.random(10,50))
			ply:SetPos(pos)	
			umsg.Start("SpawningDeath", ply)
			umsg.End()
		end
	end

end

function Rag_Decay(self) 
	if self:GetClass() != "prop_ragdoll" then
		return
	end
	local decay = self.Decay
	local pos = self:GetPos()
	local angles = self:GetAngles()
	self:Remove()

	self = ents.Create("prop_ragdoll")
	self.Decay = decay + 1
	if self.Decay  >= 1 then
		self:SetModel("models/humans/corpse1.mdl")
		if self.Decay >= 2 then
			self:SetModel("models/humans/Charple01.mdl")
			if self.Decay >= 3 then
				self:Remove()
				return
			end
		end
	end
	self:SetPos(pos)
	self:SetAngles(angles);
	self:Spawn()
	self:Activate()
	self:SetCollisionGroup( 1 )
	
	timer.Simple(180,function() if self:IsValid() then Rag_Decay(self) end end)
end
