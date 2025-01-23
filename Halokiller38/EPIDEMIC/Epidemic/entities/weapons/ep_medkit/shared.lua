if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" ) 
 
 end 

 SWEP.HoldType = "pistol";
 
 SWEP.Base = "ep_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= false 
   


SWEP.Primary.Sound = Sound( "Weapon_SMG1.Single" );

SWEP.ViewModel = Model( "models/weapons/v_healthkit.mdl" );
SWEP.WorldModel = Model( "models/weapons/w_fists.mdl" );
SWEP.ItemModel = Model( "models/items/healthkit.mdl" );

SWEP.Degrades = false;

SWEP.PrintName = "Medical Kit";
SWEP.EpiDesc = "Contains splints and bandages";

SWEP.HolsteredAtStart = true;

SWEP.EpiHoldType = "SMG"; 

SWEP.Primary.HolsteredPos = Vector( -2.4, -4, -18.0 );

SWEP.ItemWidth = 2;
SWEP.ItemHeight = 2;

SWEP.HUDWidth = 100;
SWEP.HUDHeight = 100;

SWEP.IconCamPos = Vector( 5, 5, 50 )
SWEP.IconLookAt = Vector( 6, -17, -139 ) 
SWEP.IconFOV = 33

SWEP.NicePhrase = "a medkit";
SWEP.LightWeight = true;


local Limbs = {

	"LLeg",
	"RLeg",
	"RArm",
	"LArm",

}

function SWEP:PrimaryAttack()

	if( CLIENT ) then return; end

	if( self.Owner:GetTable().IsHealing ) then return; end

	if( CurTime() < self.NextPrimaryAttack ) then return; end

	self.NextPrimaryAttack = CurTime() + 1;

	local trace;
	local tr = { };
	
	if( not self.Owner:KeyDown( IN_RELOAD ) ) then
	
		trace = { }
		trace.start = self.Owner:EyePos();
		trace.endpos = trace.start + self.Owner:GetAimVector() * 35;
		trace.filter = self.Owner;
		
		tr = util.TraceLine( trace );
		
	else
	
		tr.Entity = self.Owner;
	
	end

	if( tr.Entity:IsValid() and tr.Entity:IsPlayer() ) then

		local think = function()

			if( not self.Owner:IsValid() or not tr.Entity:IsValid() ) then
			
				return false;
			
			end
			
			if( not self.Owner:KeyDown( IN_ATTACK ) ) then
			
				return false;					
			
			end
		
			if( tr.Entity ~= self.Owner ) then
		
				if( self.Owner:GetTable().HealPos ~= self.Owner:GetPos() or
					tr.Entity:GetTable().HealPos ~= tr.Entity:GetPos() ) then
				
					return false;
					
				end	
				
			else
			
				if( self.Owner:GetTable().HealPos ~= self.Owner:GetPos() ) then
				
					return false;
					
				end				
			
			end
			
			if( not self.Owner:Alive() or not tr.Entity:Alive() ) then
			
				return false;
			
			end
			
		end
		
		local function done()
		
			if( think() == false ) then
			
				return true;
			
			end
			
			for k, v in pairs( Limbs ) do
			
				local val = tr.Entity["GetPlayer" .. v .. "HP"]( tr.Entity );
			
				if( val < 70 ) then
				
					tr.Entity["SetPlayer" .. v .. "HP"]( tr.Entity, val + 15 );
					tr.Entity:GetTable().HealingLimbs[v] = CurTime() + 6;
				
				end
			
			end
		
			return true;
		
		end
		
		local function remove()
		
			self.Owner:GetTable().IsHealing = false;
			tr.Entity:GetTable().IsHealing = false;
			
		end
	
		local healstr = "Applying splints to self";

		local time = 0;
		
		for k, v in pairs( Limbs ) do
		
			if( tr.Entity["GetPlayer" .. v .. "HP"]( tr.Entity ) < 70 and
				not tr.Entity:GetTable().HealingLimbs[v] ) then
			
				time = time + 2;
			
			end
		
		end
		
		if( time == 0 ) then
		
			if( tr.Entity ~= self.Owner ) then
			
				self.Owner:NoticePlainWhite( "This person doesn't need splints." );
				
			else
			
				self.Owner:NoticePlainWhite( "You don't need splints." );
			
			end
			
			return;
		
		end

		if( tr.Entity ~= self.Owner ) then
		
			tr.Entity:CreateProgressBar( "healingby" .. self.Owner:UserID(), "Having splints applied by " .. self.Owner:RPNick(), time, .5, think, done, remove );
		
			healstr = "Applying splints to " .. tr.Entity:RPNick();
	
		end
		
		self.Owner:GetTable().IsHealing = true;
		tr.Entity:GetTable().IsHealing = true;
		
		tr.Entity:GetTable().HealPos = tr.Entity:GetPos();
		self.Owner:GetTable().HealPos = self.Owner:GetPos();
		
		self.Owner:CreateProgressBar( "healing" .. tr.Entity:UserID(), healstr, time, .5, think, done, remove );
		
		self.Owner:GetTable().HealPos = self.Owner:GetPos();

	end

end

function SWEP:SecondaryAttack()


	if( CLIENT ) then return; end

	if( self.Owner:GetTable().IsHealing ) then return; end

	if( CurTime() < self.NextPrimaryAttack ) then return; end

	self.NextPrimaryAttack = CurTime() + 1;

	local trace;
	local tr = { };
	
	if( not self.Owner:KeyDown( IN_RELOAD ) ) then
	
		trace = { }
		trace.start = self.Owner:EyePos();
		trace.endpos = trace.start + self.Owner:GetAimVector() * 35;
		trace.filter = self.Owner;
		
		tr = util.TraceLine( trace );
		
	else
	
		tr.Entity = self.Owner;
	
	end

	if( tr.Entity:IsValid() and tr.Entity:IsPlayer() ) then

		local think = function()

			if( not self.Owner:IsValid() or not tr.Entity:IsValid() ) then
			
				return false;
			
			end
			
			if( not self.Owner:KeyDown( IN_ATTACK2 ) ) then
			
				return false;					
			
			end
		
			if( tr.Entity ~= self.Owner ) then
		
				if( self.Owner:GetTable().HealPos ~= self.Owner:GetPos() or
					tr.Entity:GetTable().HealPos ~= tr.Entity:GetPos() ) then
				
					return false;
					
				end	
				
			else
			
				if( self.Owner:GetTable().HealPos ~= self.Owner:GetPos() ) then
				
					return false;
					
				end				
			
			end
			
			if( not self.Owner:Alive() or not tr.Entity:Alive() ) then
			
				return false;
			
			end
			
		end
		
		local function done()
		
			if( think() == false ) then
			
				return true;
			
			end
			
			tr.Entity:SetPlayerBleedingAmount( 0 );
			
			return true;
		
		end
		
		local function remove()
		
			self.Owner:GetTable().IsHealing = false;
			tr.Entity:GetTable().IsHealing = false;
			
		end
	
		local healstr = "Applying bandages to self";

		local time = math.ceil( tr.Entity:GetPlayerBleedingAmount() * 4 );
		
		if( time == 0 ) then
		
			if( tr.Entity ~= self.Owner ) then
			
				self.Owner:NoticePlainWhite( "This person doesn't need to be bandaged." );
				
			else
			
				self.Owner:NoticePlainWhite( "You don't need to be bandaged." );
			
			end
			
			return;
		
		end

		if( tr.Entity ~= self.Owner ) then
		
			tr.Entity:CreateProgressBar( "healingby" .. self.Owner:UserID(), "Having bandages applied by " .. self.Owner:RPNick(), time, .5, think, done, remove );
		
			healstr = "Applying bandages to " .. tr.Entity:RPNick();
	
		end
		
		self.Owner:GetTable().IsHealing = true;
		tr.Entity:GetTable().IsHealing = true;
		
		tr.Entity:GetTable().HealPos = tr.Entity:GetPos();
		self.Owner:GetTable().HealPos = self.Owner:GetPos();
		
		self.Owner:CreateProgressBar( "healing" .. tr.Entity:UserID(), healstr, time, .5, think, done, remove );
		
		self.Owner:GetTable().HealPos = self.Owner:GetPos();

	end
	
end

function SWEP:OnRemove()

	if( self.WorldEnt and self.WorldEnt:IsValid() ) then
	
		self.WorldEnt:Remove();
	
	end

	return true;

end

function SWEP:Holster()

	if( self.WorldEnt and self.WorldEnt:IsValid() ) then
	
		self.WorldEnt:Remove();
	
	end

	return true;

end

function SWEP:Deploy()
	
	if( SERVER and self.Degrades ) then
		
		if( self.HeavyWeight ) then
			
			self.Owner:sqlUpdateField( "HWDeg", self.HealthAmt, true );
			
		else
			
			self.Owner:sqlUpdateField( "LWDeg", self.HealthAmt, true );
			
		end
		
	end
	
	if( self.WorldEnt and self.WorldEnt:IsValid() ) then
	
		self.WorldEnt:Remove();
	
	end
	
	self.WorldEnt = self.Owner:AttachProp( self.ItemModel, "anim_attachment_LH", false );
	
	return true;

end

if( CLIENT ) then

	function SWEP:DrawHUD()
	
	end

end

