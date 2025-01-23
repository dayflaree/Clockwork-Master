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

function SWEP:Deploy()
	self.Owner:DrawWorldModel(false)
	if self.Owner.SetupFarm then
		self.Weapon:SetNWBool( "check", true )
	end
end

function SWEP:PrimaryAttack()

	local trace = utilx.GetPlayerTrace( self.Owner, vec ) 
	trace.mask = MASK_SOLID_BRUSHONLY
 	local tr = util.TraceLine( trace )

	trace.mask = MASK_WATER

	local traceline = util.TraceLine(trace)

	if traceline.Hit then
		if self.Owner:WaterLevel() > 0 then return end
		if tr.Fraction > traceline.Fraction then return end
	end

	if !tr.Hit or tr.HitSky then return end
 	if !tr.HitWorld then return end

	if !(tr.HitNormal:Angle().p <= 300 and tr.HitNormal:Angle().p >= 240) then
		self.Owner:ChatPrint("Sorry, this must be on flat ground")
		return
	end

	local nodes = {}
	for _, ent in pairs( ents.FindInSphere(tr.HitPos, 25) ) do
		if(ent:GetClass() == "farm" or ent:GetClass() == "iron_mine") then
			table.insert( nodes, ent )
		end
	end
	if #nodes <= 0 then
		inSupply = true
	end

	if !inSupply then
		self.Owner:ChatPrint("Cannot be created this close to an existing resource node.")
		return
	end
	

	if inSupply then
		local ent = ents.Create( self.node )
		ent:SetPos( tr.HitPos + tr.HitNormal * 16 )
		ent:SetAngles(tr.HitNormal:Angle() + Angle( 90, 0, 0 ))
		ent:Spawn()
		ent:Activate()
		local weld = constraint.Weld( ent, tr.Entity, 0, tr.PhysicsBone, 0, 0, true ) 
 		tr.Entity:DeleteOnRemove( weld ) 
 		ent:DeleteOnRemove( weld ) 
		if self.node == "farm" then
			self.Owner.SetupFarm = true
			self.Weapon:SetNWBool( "check", true )
		elseif self.node == "iron_mine" then
			self.Owner.SetupMine = true
		end
		if self.Owner.SetupFarm and self.Owner.SetupMine then
			self:ReleaseGhostEntity()
			self.Owner.Setup = true
			self.Owner:SetNWBool( "_isready", true )
			PreviousPlayers[self.Owner:UniqueID()] = {}
			self.Weapon:SetNWBool( "setup", true )
			GAMEMODE:PlayerLoadout( self.Owner )
		end
	end
	
	inSupply = false
end


function SWEP:SecondaryAttack() end

function SWEP:Reload() end
