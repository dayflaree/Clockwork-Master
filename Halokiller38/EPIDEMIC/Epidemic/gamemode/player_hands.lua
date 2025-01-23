
local meta = FindMetaTable( "Player" );

function meta:RemoveHandPickUp()

	self:GetTable().HandPickUpSent:Remove();
	self:GetTable().HandPickUpSent = nil;

end

function meta:HandPickUp( ent, bone )

	if( self:GetTable().HandPickUpSent and self:GetTable().HandPickUpSent:IsValid() ) then
		self:RemoveHandPickUp();
	end

	self:GetTable().HandPickUpSent = ents.Create( "ep_pickup" );
	self:GetTable().HandPickUpSent:SetPos( ent:GetPos() );
	self:GetTable().HandPickUpSent:SetModel( "models/props_junk/popcan01a.mdl" );
	self:GetTable().HandPickUpSent:SetPlayer( self );
	self:GetTable().HandPickUpSent:SetTarget( ent );
	self:GetTable().HandPickUpSent:Spawn();
	self:GetTable().HandPickUpTarget = ent;
	constraint.Weld( self:GetTable().HandPickUpSent, ent, 0, bone, 9999 );	

end