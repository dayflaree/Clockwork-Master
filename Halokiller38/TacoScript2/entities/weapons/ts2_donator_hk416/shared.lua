
if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" ) 
 
 end 
 
  	SWEP.HoldType = "pistol";

if( CLIENT ) then

	SWEP.CSMuzzleFlashes	= true
	SWEP.ViewModelFlip		= true	
	SWEP.DrawCrosshair = false;

end
 
 SWEP.Base = "ts2_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= true 
   
SWEP.Primary.Sound = Sound( "Weapons/silenced.wav" );

SWEP.ViewModel			= "models/weapons/v_snip_hk416.mdl"
SWEP.WorldModel			= "models/weapons/w_snip_hk416.mdl"

SWEP.PrintName = "HK 416 - Silenced";
SWEP.TS2Desc = "Donator weapon";

SWEP.Price = 14000;

 SWEP.Primary.Recoil			= .1 
 SWEP.Primary.RecoilAdd			= .3
 SWEP.Primary.RecoilMin = .3
 SWEP.Primary.RecoilMax = .4
 
 SWEP.Primary.ViewPunchMul = 2;
 SWEP.Primary.Damage			= 20
 SWEP.Primary.NumShots		= 1 
 
 SWEP.TS2HoldType = "RIFLE";

SWEP.Primary.DoorBreach = false;
SWEP.Primary.HighPowered = true;
SWEP.Primary.ClipSize = 20;
SWEP.Primary.DefaultClip = 200;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = .09;
SWEP.Primary.Automatic = false;
SWEP.Primary.SpreadCone = Vector( .01, .01, .01 );
SWEP.Primary.ReloadDelay = 2.3;
 
SWEP.Primary.IronSightPos = Vector( 4.0191, 1.1928, -10.5826 );
SWEP.Primary.IronSightAng = Vector( 0, 0, 0 ); 
 
SWEP.Primary.HolsteredPos = Vector( -0.7542, -3.7717, -1.986 );
SWEP.Primary.HolsteredAng = Vector( 18.5181, -56.0109, -11.822 );

 SWEP.ItemWidth = 4;
 SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 3, -45, -10 ) 
SWEP.IconLookAt = Vector( 1, -7, -2 )
SWEP.IconFOV = 20;

SWEP.ReloadSound = "";

function SWEP:HolsterToggle()

	self.Owner:ConCommand( "eng_seescope 0\n" );

end

if( CLIENT ) then

	SeeSniperScope = false;

	function SWEP:DrawHUD()

		if( math.floor( self.Primary.PositionMode ) == 1 and math.floor( self.Primary.PositionMul ) == 1 ) then 

			if( not SeeSniperScope ) then
			
				RunConsoleCommand( "eng_seescope", "1" );
				SeeSniperScope = true;

			end
			
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("jaanus/ep2snip_parascope"))
			surface.DrawTexturedRect(self.ParaScopeTable.x,self.ParaScopeTable.y,self.ParaScopeTable.w,self.ParaScopeTable.h)
			
			-- Draw the lens
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("overlays/scope_lens"))
			surface.DrawTexturedRect(self.LensTable.x,self.LensTable.y,self.LensTable.w,self.LensTable.h)

			-- Draw the scope
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("jaanus/sniper_corner"))
			surface.DrawTexturedRectRotated(self.ScopeTable.x1,self.ScopeTable.y1,self.ScopeTable.l,self.ScopeTable.l,270)
			surface.DrawTexturedRectRotated(self.ScopeTable.x2,self.ScopeTable.y2,self.ScopeTable.l,self.ScopeTable.l,180)
			surface.DrawTexturedRectRotated(self.ScopeTable.x3,self.ScopeTable.y3,self.ScopeTable.l,self.ScopeTable.l,90)
			surface.DrawTexturedRectRotated(self.ScopeTable.x4,self.ScopeTable.y4,self.ScopeTable.l,self.ScopeTable.l,0)

			-- Fill in everything else
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawRect(self.QuadTable.x1,self.QuadTable.y1,self.QuadTable.w1,self.QuadTable.h1)
			surface.DrawRect(self.QuadTable.x2,self.QuadTable.y2,self.QuadTable.w2,self.QuadTable.h2)
			surface.DrawRect(self.QuadTable.x3,self.QuadTable.y3,self.QuadTable.w3,self.QuadTable.h3)
			surface.DrawRect(self.QuadTable.x4,self.QuadTable.y4,self.QuadTable.w4,self.QuadTable.h4)
			
			local rotatick = CurTime()*90/5
			surface.SetTexture(surface.GetTextureID("jaanus/rotatingthing"))
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawTexturedRectRotated(ScrW()/2, ScrH()/2,self.LensTable.w * 1.2, self.LensTable.h * 1.2, rotatick)
		
		else
		
			if( SeeSniperScope ) then
			
				RunConsoleCommand( "eng_seescope", "0" );
				SeeSniperScope = false;
				
			end
			
		end
		
	end
	
end
   