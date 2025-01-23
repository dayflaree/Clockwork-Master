

AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( "shared.lua" );

function ENT:Initialize()

	self.Entity:PhysicsInit( SOLID_VPHYSICS );
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS );
	self.Entity:SetSolid( SOLID_NONE );

	local phys = self.Entity:GetPhysicsObject();
   
	if( phys:IsValid() ) then
		phys:Wake();
	end
    
    self:StartMotionController();

end

function ENT:SetPlayer( ply )

	self.Player = ply;

end

function ENT:SetTarget( ent )

	self.EntTarget = ent;
	
	ent.PickupParent = self;
	
end

function ENT:OnRemove()

	if( self.EntTarget and self.EntTarget:IsValid() ) then
		self.EntTarget:GetPhysicsObject():Wake();
	end
	
end

function ENT:PhysicsSimulate( phys, delta )

	if( not self.Player or not self.Player:IsValid() ) then
		self:Remove();
		return;
	end

	if( not self.Player:Alive() ) then
		self:Remove();
		return;
	end
	
	if( not self.EntTarget or not self.EntTarget:IsValid() ) then
		self:Remove();
		return;
	end


	--wiki copy pasta
	phys:Wake()
   
   	self.ShadowParams={}
   	self.ShadowParams.secondstoarrive = .1 // How long it takes to move to pos and rotate accordingly - only if it _could_ move as fast as it want - damping and maxspeed/angular will make this invalid
   	self.ShadowParams.pos = ( self.Player:EyePos() + self.Player:GetAimVector() * 40 ); // Where you want to move to
   	self.ShadowParams.ang = Angle( 0, 0, 0 ) // Angle you want to move to
  self.ShadowParams.maxangular = 5000 //What should be the maximal angular force applied
   self.ShadowParams.maxangulardamp = 100000 // At which force/speed should it start damping the rotation
   if( self.EntTarget:GetClass() == "prop_ragdoll" ) then
   		self.ShadowParams.pos = ( self.Player:EyePos() + self.Player:GetAngles():Forward() * 5 ); 
  	 	self.ShadowParams.maxspeed = 5000 // Maximal linear force applied
	  	self.ShadowParams.maxspeeddamp = 10000// Maximal linear force/speed before damping
   else
	  	self.ShadowParams.maxspeed = 200 // Maximal linear force applied
	  	self.ShadowParams.maxspeeddamp = 200// Maximal linear force/speed before damping
   end
    
   self.ShadowParams.dampfactor = 1 // The percentage it should damp the linear/angular force if it reachs it's max ammount
   self.ShadowParams.teleportdistance = 45 // If it's further away than this it'll teleport (Set to 0 to not teleport)
   self.ShadowParams.deltatime = deltatime // The deltatime it should use - just use the PhysicsSimulate one
    
   	phys:ComputeShadowControl(self.ShadowParams) 
   	
   	if( self.EntTarget and self.EntTarget:IsValid() ) then
   	--	self.EntTarget:SetPos( self:GetPos() );
   	--	self.EntTarget:SetAngles( Angle( 0, 0, 0 ) );
   	else
   		self:Remove();
   	end


end

function ENT:Think()


end


