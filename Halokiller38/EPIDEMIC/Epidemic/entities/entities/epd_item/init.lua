
--Taken and modded from TS2

AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( "shared.lua" );

function ENT:Initialize()

	self.Entity:PhysicsInit( SOLID_VPHYSICS );
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS );
	self.Entity:SetSolid( SOLID_VPHYSICS );

	local phys = self.Entity:GetPhysicsObject();
   
	if( phys:IsValid() ) then
		phys:Wake();
	end

	self.CanUse = true;
	self.User = nil;

end

function ENT:AttachItem( item )

	self.Entity:SetModel( item.Model );
	self.Entity:GetTable().ItemID = item.ID;
	
	self.Entity:GetTable().ItemData = { }
	
	self.Entity:GetTable().ItemData.ItemEntity = self.Entity;
	
	for k, v in pairs( item ) do
	
		self.Entity:GetTable().ItemData[k] = item[k];
	
	end
	
end

function ENT:Think()

	if( not self.CanUse ) then
		if( self.User and self.User:IsValid() ) then
			if( not self.User:KeyDown( IN_USE ) ) then
				self.CanUse = true;
			end
		else
			self.CanUse = true;
		end
	end

end

function ENT:Use( ply )

	if( not self.CanUse ) then return; end
	
	--if( ply:IsTied() ) then return; end 

	if( CurTime() < ply:GetTable().CanPickUpItemTime ) then
		return;
	end
	
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 90;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	
	if( tr.Entity ~= self.Entity ) then
		return;
	end

	ply:GetTable().CanPickUpItemTime = CurTime() + .4;

	self.CanUse = false;
	self.User = ply;

	ply:HandleItemInteraction( self.Entity );
	
end

function ENT:OnTakeDamage( dmg )
	
	self:TakePhysicsDamage( dmg );
	
end