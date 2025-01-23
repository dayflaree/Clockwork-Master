AddCSLuaFile ("cl_init.lua");
AddCSLuaFile ("shared.lua");

include ("shared.lua");

SWEP.Weight = 5;
SWEP.AutoSwitchTo = false;
SWEP.AutoSwitchFrom = false; 

//Thanks robbis, andy
local meta = FindMetaTable("Player")

function meta:GetEyeTrace()
	if ( self:GetTable().LastPlayertTrace == CurTime() ) then
		return self:GetTable().PlayerTrace
	end

	self:GetTable().PlayerTrace = util.TraceLine( util.GetPlayerTrace( self, self:GetCursorAimVector() ) )
	self:GetTable().LastPlayertTrace = CurTime()
       
	return self:GetTable().PlayerTrace
end

meta = nil

function SWEP:Initialize()
	self:SetColor(0,0,0,0)
	self.FirstPoint = false
	self.index = 1
end

function SWEP:Equip()
	self:SetColor(255,255,255,255)
end

function SWEP:Deploy()
	self.Owner:DrawWorldModel(false)
end

function SWEP:Think()
	
	if self.NextIdle and CurTime()>self.NextIdle then
		self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
		self.NextIdle = nil
	end
	
	if self.FirstPoint and !self.Owner:KeyDown( IN_ATTACK ) then

		if self.Point and self.Point:IsValid() then
			self.Point:Remove()
			self.Point = false
		end

		local p = self.FirstPoint
		self.FirstPoint = false

		local pos = self.Owner:GetShootPos()
		local ang = self.Owner:GetAimVector()
		local tracedata = {}
		tracedata.start = pos
		tracedata.endpos = pos+(ang*2048)
		tracedata.mask = MASK_WATERWORLD
		tracedata.filter = self.Owner
	
		local tr = util.TraceLine(tracedata)
	
		if !tr.Hit then return end
		if tr.HitSky then return end
		local q = tr.HitPos + tr.HitNormal * 10
		local center = ( p + q ) * 0.5
		local radius = p:Distance( q ) * 0.5
	
		local ents = ents.FindInSphere( center, radius )
		local units = {}
		if table.Count( ents ) > 0 then
			for _, ent in pairs( ents ) do
				if ValidEntity(ent) and ent:IsUnit() and ent:GetOwner() == self.Owner and !ent:IsSelected() and !ent:IsDead() then
					if self.Owner.SelectedUnits < select_limit then
						ent:Select( self.Owner )
						table.insert( units, ent )
					else
						break
					end
				end
			end
		end
		if #units > 0 then
			if !self.Owner.Hints[ "UnitSelect2" ] then
				umsg.Start( "SuppressHint", self.Owner )
					umsg.String( "UnitSelect1" )
				umsg.End()
				umsg.Start( "AddHint", self.Owner )
					umsg.String( "UnitSelect2" )
					umsg.Long( 3 )
				umsg.End()
				self.Owner.Hints[ "UnitSelect2" ] = true
			end
		end
		if #units == 1 then
			self.Owner:ChatPrint( "Unit Selected!")
			self.Owner:SendLua("playsound( 'sassilization/select.wav', -1 )")
		elseif #units > 1 then
			self.Owner:ChatPrint( #units .. " Units Selected!")
			self.Owner:SendLua("playsound( 'sassilization/select.wav', -1 )")
		else
			self.Owner:ChatPrint("No Units Found!")
			self.Owner:SendLua("playsound( 'sassilization/warnmessage.wav', -1 )")
		end
	end
end

function SWEP:PrimaryAttack()

	local pos = self.Owner:GetShootPos()
	local ang = self.Owner:GetAimVector()
	local tracedata = {}
	tracedata.start = pos
	tracedata.endpos = pos+(ang*2048)
	tracedata.mask = MASK_WATERWORLD
	tracedata.filter = self.Owner

	local tr = util.TraceLine(tracedata) 

	if !tr.Hit then return end
	if tr.HitSky then return end

	if !self.Owner:KeyDown( IN_SPEED ) and self.FirstPoint then

		if self.Point and self.Point:IsValid() then
			self.Point:Remove()
			self.Point = false
		end

		local p = self.FirstPoint
		local q = tr.HitPos + tr.HitNormal * 10
		local center = ( p + q ) * 0.5
		local radius = p:Distance( q ) * 0.5

		if radius > 80 then radius = 80 end

		local ents = ents.FindInSphere( center, radius )
		local units = {}
		if table.Count( ents ) > 0 then
			for _, ent in pairs( ents ) do
				if ValidEntity(ent) and ent:IsUnit() and ent:GetOwner() == self.Owner and !ent:IsSelected() and !ent:IsDead() then
					if self.Owner.SelectedUnits < select_limit then
						ent:Select( self.Owner )
						table.insert( units, ent )
					else
						break
					end
				end
			end
		end
		if #units > 0 then
			if !self.Owner.Hints[ "UnitSelect2" ] then
				umsg.Start( "SuppressHint", self.Owner )
					umsg.String( "UnitSelect1" )
				umsg.End()
				umsg.Start( "AddHint", self.Owner )
					umsg.String( "UnitSelect2" )
					umsg.Long( 3 )
				umsg.End()
				self.Owner.Hints[ "UnitSelect2" ] = true
			end
		end
		if #units == 1 then
			self.Owner:ChatPrint( "Unit Selected!")
			self.Owner:SendLua("playsound( 'sassilization/select.wav', -1 )")
		elseif #units > 1 then
			self.Owner:ChatPrint( #units .. " Units Selected!")
			self.Owner:SendLua("playsound( 'sassilization/select.wav', -1 )")
		else
			self.Owner:ChatPrint("No Units Found!")
			self.Owner:SendLua("playsound( 'sassilization/warnmessage.wav', -1 )")
		end
		self.FirstPoint = false

	end
	
	if self.Owner:KeyDown( IN_SPEED ) and !self.FirstPoint then

		self.FirstPoint = tr.HitPos + ( tr.HitNormal * 10 )

		if !self.Point then
			self.Point = ents.Create( "marker" )
			self.Point:SetPos( tr.HitPos + tr.HitNormal * 10 )
			self.Point:SetNWInt( "firstx", self.FirstPoint.x )
			self.Point:SetNWInt( "firsty", self.FirstPoint.y )
			self.Point:SetNWInt( "firstz", self.FirstPoint.z )
			self.Point:SetOwner( self.Owner )
			self.Point:Spawn()
			self.Point:Activate()
		end

		return

	elseif self.Owner:KeyDown( IN_SPEED ) and self.FirstPoint then

		local pos = self.Owner:GetShootPos()
		local ang = self.Owner:GetAimVector()
		local tracedata = {}
		tracedata.start = pos
		tracedata.endpos = pos+(ang*2048)
		tracedata.mask = MASK_WATERWORLD
		tracedata.filter = self.Owner

		local tr = util.TraceLine(tracedata) 

		if !tr.HitPos then return true end

		local p = self.FirstPoint
		local q = tr.HitPos + tr.HitNormal * 10
		local center = ( p + q ) * 0.5
		local radius = p:Distance( q ) * 0.5
		local diff = math.abs( p.z - q.z )
	
		if radius > 80 then return end

		if self.Point and self.Point:IsValid() then
			self.Point:SetPos( q )
		else
			self.Point = ents.Create( "marker" )
			self.Point:SetPos( tr.HitPos + tr.HitNormal * 10 )
			self.Point:SetNWInt( "firstx", p.x )
			self.Point:SetNWInt( "firsty", p.y )
			self.Point:SetNWInt( "firstz", p.z )
			self.Point:SetOwner( self.Owner )
			self.Point:Spawn()
			self.Point:Activate()
		end

		return
	end
end

function SWEP:SecondaryAttack()
	
	local pos = self.Owner:GetShootPos()
	local ang = self.Owner:GetAimVector()
	local tracedata = {}
	tracedata.start = pos
	tracedata.endpos = pos+(ang*2048)
	tracedata.filter = self.Owner
	local tr = util.TraceLine(tracedata) 

	if !tr.Hit or tr.HitSky then return end

	local target, enemy, ignore = false, false, false

	if self.Owner:KeyDown( IN_SPEED ) then
		ignore = true
	end

	if ignore and ValidEntity(tr.Entity) and (tr.Entity:IsUnit() || IsAttackable(tr.Entity)) and !tr.Entity:IsDead() and !(tr.Entity.Overlord == self.Owner || table.HasValue(alliances[self.Owner], tr.Entity.Overlord)) then
		enemy = tr.Entity
	else
		tracedata.mask = MASK_WATERWORLD
		tr = util.TraceLine(tracedata)
		if !tr.Hit or tr.HitSky then return end
		if !tr.HitWorld then return end
		target = tr.HitPos + tr.HitNormal
	end

	if table.Count(self.Owner.Units) > 0 then
	
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		self.NextIdle = CurTime()+1
		self.Weapon:SetNextSecondaryFire( CurTime() + 1 )
		
		for _, unit in pairs(self.Owner.Units) do
			if !unit:IsDead() then
				unit.Ordered = true
				if enemy then
					unit.Ignore = false
					unit.TargetEnemy = enemy
					local effectdata = EffectData()
						effectdata:SetEntity(enemy)
						effectdata:SetScale( self.Owner:UserID() )
					util.Effect( "order_attack", effectdata, true, true )
					target = enemy:GetPos()
				elseif ignore then
					unit.Ignore = true
					unit.combatant = false
					unit.TargetEnemy = false
					unit.LastEnemy = false
					gmod.BroadcastLua( "UNITS.targets["..unit:EntIndex().."]=nil" )
					umsg.Start( "UUT" )
						umsg.Short( unit:EntIndex() )
						umsg.Short( 0 )
					umsg.End()
				else
					unit.TargetEnemy = false
					unit.Ignore = false
				end
				unit.Target = target
				unit.Distance = 100
				unit.BlockClock = false
				unit.nextThink = CurTime()
			end
		end
		local rand = math.random(#UNITMOVESOUNDS)
		self.Owner:SendLua("playsound('"..UNITMOVESOUNDS[rand][1].."', "..UNITMOVESOUNDS[rand][2]..")")
	end

end

function SWEP:CanPrimaryAttack()
	return false
end

local function reloadEnt( ent, owner )
	
	if !ValidEntity(ent) then return end
	if !(ValidEntity(ent:GetOverlord()) and ent:GetOverlord() == owner) then return end
	if ent.OnFire || (ent.lastfire and ent.lastfire > CurTime()) then return end
	
	if ent:IsUnit() and !ent:IsDead() and (CurTime()-(ent.lastAttack or 0)) > 30  then
		local effectdata = EffectData()
			effectdata:SetEntity( ent )
		util.Effect( "burrow", effectdata, true, true )
		ent:Disband( "refund" )
	end
	
	if ent:GetClass() == "bldg_city" and ent:IsReady() then
		local effectdata = EffectData()
			effectdata:SetEntity( ent )
		util.Effect( "dissolve", effectdata, true, true )
		ent:Raze( "refund" )
		owner:SetNWInt("_food", owner:GetNWInt("_food") + (40*ent.health/ent.maxhealth))
		owner:SetNWInt("_iron", owner:GetNWInt("_iron") + (35*ent.health/ent.maxhealth))
	end
	
	if ent:GetClass() == "bldg_tower" and ent:IsReady() then
		local effectdata = EffectData()
			effectdata:SetEntity( ent )
		util.Effect( "dissolve", effectdata, true, true )
		ent:Raze( "refund" )
		owner:SetNWInt("_food", owner:GetNWInt("_food") + (6*ent.health/ent.maxhealth))
		owner:SetNWInt("_iron", owner:GetNWInt("_iron") + (9*ent.health/ent.maxhealth))
	end
	
	if ent:GetClass() == "bldg_wall" and !ent:IsDead() then
		local wall = ent
		local effectdata = EffectData()
			effectdata:SetEntity( wall )
		util.Effect( "dissolve", effectdata, true, true )
		wall:Raze( "refund" )
	end
	
end
function SWEP:Reload()
	
	self.Owner.lastDeselect = self.Owner.lastDeselect or CurTime()
	if self.Owner.lastDeselect > CurTime() then return end
	
	local tr = self.Owner:GetEyeTrace()
	
	if self.Owner:KeyDown( IN_SPEED ) then
		self.Owner.lastDeselect = CurTime() + 1
		if table.Count(self.Owner.Units) > 0 then
			for _, unit in pairs(self.Owner.Units) do
				if unit and unit.Deselect then
					unit:Deselect( self.Owner )
				end
			end
			self.Owner:ChatPrint("All Units Deselected")
			self.Owner:SendLua("playsound( 'sassilization/select.wav', -1 )")
		end
		return
	end
	
	local nearby = ents.FindInSphere( tr.HitPos, 4 )
	for _, ent in pairs( nearby ) do
		reloadEnt( ent, self.Owner )
	end
	
end
