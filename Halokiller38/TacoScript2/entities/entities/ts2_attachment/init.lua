

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

end

function ENT:SetRemoveFunc( func )

	self.RemoveFunc = func;

end

function ENT:SetPlayer( ply, attachment )

	self.Player = ply;
	self.Attachment = attachment;
	
	self:SetParent( ply );
	self:SetOwner( ply );
	
	self:SetPos( ply:EyePos() );

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
		self:Remove();
		return;
	end
	
	if( self.Player.InCloak or
		self.Player.ObserveMode ) then
		
		self:SetNoDraw( true );

	else
	
		self:SetNoDraw( false );
	
	end

	local attachment = self.Player:LookupAttachment( "anim_attachment_RH" );
	attachment = self.Player:GetAttachment( attachment );
	
	if( not attachment ) then return; end
	
	self.AttachmentPos = attachment.Pos;
	self.AttachmentAng = attachment.Ang;

end


