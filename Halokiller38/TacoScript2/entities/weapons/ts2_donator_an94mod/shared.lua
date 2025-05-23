if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" ) 

 end 
 
  	SWEP.HoldType = "pistol";

 SWEP.Base = "ts2_base";
   
SWEP.Spawnable			= false 
SWEP.AdminSpawnable		= true 
SWEP.ViewModelFlip		= false   

SWEP.Primary.Sound			= Sound( "Weapons/silenced.wav" )

SWEP.WorldModel = "models/weapons/w_an94.mdl";
SWEP.ViewModel = "models/weapons/v_an94.mdl";

SWEP.PrintName = "AN-94 MOD";
SWEP.TS2Desc = "Modified Assault Rifle";

SWEP.Price = 3800;

 SWEP.Primary.Recoil			= .1 
 SWEP.Primary.RecoilAdd			= .1
 SWEP.Primary.RecoilMin = .2
 SWEP.Primary.RecoilMax = .3
 
 SWEP.Primary.ViewPunchMul = .5;
 SWEP.Primary.Damage			= 10 
 SWEP.Primary.NumShots		= 1 
 
 SWEP.TS2HoldType = "RIFLE";

SWEP.Primary.ClipSize = 30;
SWEP.Primary.DefaultClip = 190;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = .09;
SWEP.Primary.Automatic = true;
SWEP.Primary.SpreadCone = Vector( 0.03, 0.03, 0.03 );

 SWEP.Primary.IronSightPos = Vector( -4.0631, 0.7662, -6.0598 );
 SWEP.Primary.IronSightAng = Vector( 0.0, 0.0, 0.0 );

SWEP.Primary.HolsteredPos = Vector( -5.0, 10.8, -2.0 );
SWEP.Primary.HolsteredAng = Vector( -5.0, 50.0, 0.0 );

SWEP.ItemWidth = 3;
SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 90, 0, 0 ) 
SWEP.IconLookAt = Vector( 0, 10, 2 ) 
SWEP.IconFOV = 15

function SWEP:HolsterToggle()

	self.Owner:ConCommand( "eng_seescope 0\n" );

end

if( CLIENT ) then

	SeeSniperScope = false;
	local ScopeTexture = surface.GetTextureID( "crosshair" );

	function SWEP:DrawHUD()

		if( math.floor( self.Primary.PositionMode ) == 1 and math.floor( self.Primary.PositionMul ) == 1 ) then 

			if( not SeeSniperScope ) then
			
				RunConsoleCommand( "eng_seescope", "1" );
				SeeSniperScope = true;

			end

			local x = ( ScrW() - 1024 ) * .5;
			local y = ( ScrH() - 1024 ) * .5;
			local w = 1024;
			if( w < ScrW() ) then x = 0; w = ScrW(); end
			local h = 1024;
			if( h < ScrH() ) then y = 0; h = ScrH(); end
			
			surface.SetTexture( ScopeTexture );
			surface.SetDrawColor( 255, 255, 255, 255 );
			surface.DrawTexturedRect( x, y, w, h );	
			
			
		
		end
		
		
	end

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
   
