

AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( "shared.lua" );

function ENT:Initialize()

	self.Entity:PhysicsInit( SOLID_VPHYSICS );
	self.Entity:SetMoveType( MOVETYPE_NONE );
	self.Entity:SetSolid( SOLID_NONE );

	local phys = self.Entity:GetPhysicsObject();
   
	if( phys:IsValid() ) then
		phys:Sleep();
	end

    self.PosOffset = self.PosOffset or Vector( 0, 0, 0 );
    self.AngleOffset = self.AngleOffset or Angle( 0, 0, 0 );
    
    self.KeepAfterDeath = false;
    
    self.NextThinkTick = 0;
	
	self:DrawShadow( false );

end

function ENT:SetRemoveFunc( func )

	self.RemoveFunc = func;

end

function ENT:SetPlayer( ply, attachment )

	self.Player = ply;
	self.Attachment = attachment;
	
	self:SetParent( ply );
	self:SetOwner( ply );
	
	self:SetPos( ply:GetPos() );
	self.LastPos = ply:EyePos();

end

function ENT:OnRemove()

	if( self.RemoveFunc ) then
		self.RemoveFunc( self.AttachmentPos, self.AttachmentAng );
	end

end

function ENT:PhysicsSimulate( phys, delta )

	
end

function ENT:Think()

	if( not self.Player or not self.Player:IsValid() ) then
		self:Remove();
		return;
	end

	if( not self.Player:Alive() ) then
		
		if( not self.KeepAfterDeath ) then
		
			self:Remove();
			return;
			
		else
		
			self:SetNoDraw( true );
		
		end
		
	else
	
		if( not self.Player:GetTable().Invisible and not self.Player:GetTable().ObserveMode and self.KeepAfterDeath ) then
		
			self:SetNoDraw( false );
		
		end
	
	end

	if( CurTime() >= self.NextThinkTick ) then
		
		self.NextThinkTick = CurTime() + 1;
		
	end

end


