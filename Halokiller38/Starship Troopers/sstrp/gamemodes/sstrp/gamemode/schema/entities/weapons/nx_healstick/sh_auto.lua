
if (SERVER) then
	AddCSLuaFile("sh_auto.lua")
end

if (CLIENT) then
	SWEP.PrintName 		= "Healstick"
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "z"
	SWEP.ViewModelFlip	= false
end

SWEP.Instructions 		= "Left click to Heal players. Right click to heal yourself."

SWEP.Spawnable      = true
SWEP.AdminSpawnable          = true

SWEP.Sound = Sound( "items/smallmedkit1.wav" );
 
SWEP.NextStrike = 0;
  
SWEP.ViewModel = "models/weapons/v_pistol.mdl" 
SWEP.WorldModel =  "models/weapons/w_pistol.mdl" 
 
SWEP.Primary.ClipSize      = -1                                   // Size of a clip
SWEP.Primary.DefaultClip        = -1                    // Default number of bullets in a clip
SWEP.Primary.Automatic    = false            // Automatic/Semi Auto
SWEP.Primary.Ammo                     = ""
 
SWEP.Secondary.ClipSize  = -1                    // Size of a clip
SWEP.Secondary.DefaultClip      = -1            // Default number of bullets in a clip
SWEP.Secondary.Automatic        = false    // Automatic/Semi Auto
SWEP.Secondary.Ammo               = ""
 
/*---------------------------------------------------------
   Name: SWEP:Initialize( )
   Desc: Called when the weapon is first loaded
---------------------------------------------------------*/
function SWEP:Initialize()
	self:SetWeaponHoldType( "melee" );
end
 
/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/
  function SWEP:PrimaryAttack()
  
        if( CurTime() < self.NextStrike ) then return; end
 
        self.NextStrike = ( CurTime() + .3 );
        
        if( CLIENT ) then return; end
 
        local trace = self.Owner:GetEyeTrace();
 
        if( not trace.Entity:IsValid() ) then
               return;
        end
        
        if( self.Owner:EyePos():Distance( trace.Entity:GetPos() ) > 100 ) then
                return;
        end
        
        if( SERVER ) then 
        
                local hp = trace.Entity:Health();
                if( hp >= 100 ) then return; end
                if( hp >= 75 ) then hp = 100 end
                if( hp <= 75 ) then hp = hp + 25 end
                
                self.Owner:EmitSound( self.Sound );

                trace.Entity:SetHealth( hp );
                
        end
 
 
  end
 
  /*---------------------------------------------------------
   Name: SWEP:SecondaryAttack( )
   Desc: +attack2 has been pressed
  ---------------------------------------------------------*/
  function SWEP:SecondaryAttack()
 
        if( CurTime() < self.NextStrike ) then return; end
 
        self.NextStrike = ( CurTime() + .3 );
        
        if( CLIENT ) then return; end
        
        if( SERVER ) then 
        
                local hpp = self.Owner:Health();
                if( hpp >= 100 ) then return; end
                if( hpp >= 75 ) then hpp = 100 end
                if( hpp <= 75 ) then hpp = hpp + 25 end
                
                self.Owner:EmitSound( self.Sound );
                
                self.Owner:SetHealth( hpp );
                
        end
 
  end 