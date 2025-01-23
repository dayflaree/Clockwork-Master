 if ( SERVER ) then 
   
 	AddCSLuaFile( "shared.lua" ) 
 	SWEP.HoldType = "pistol";
 
 end 

 
 SWEP.Base = "ts2_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= false 
   


SWEP.WorldModel = "models/weapons/w_pistol.mdl";
SWEP.ViewModel = "models/weapons/v_pistol.mdl";

SWEP.PrintName = "Map Editing";
SWEP.TS2Desc = "Left click - Edit target door\nRight click - Copy settings from target door\nReload - Apply copied settings to target door";

 SWEP.Primary.Recoil			= .8
 SWEP.Primary.RecoilAdd			= .06
 SWEP.Primary.RecoilMin = .8
 SWEP.Primary.RecoilMax = 1.9
 SWEP.Primary.RecoverTime = .4

 SWEP.Primary.Sound = Sound( "weapons/pistol/pistol_fire3.wav" );

 SWEP.Primary.Damage			= 40 
 SWEP.Primary.NumShots		= 1 
 SWEP.Primary.ClipSize = 16;
 SWEP.Primary.DefaultClip = 32;
 SWEP.Primary.Ammo = "pistol";
 SWEP.Primary.Delay = .08;
 
 SWEP.TS2HoldType = "PISTOL";

 SWEP.Primary.SpreadCone = Vector( .04, .04, .04 );

 SWEP.Primary.IronSightPos = Vector( -5.4, 4.5, -2.0 );
 SWEP.Primary.IronSightAng = Vector( 0.0, 0.0, 0.0 );
 
   
SWEP.Primary.HolsteredPos = Vector( -6.4, -5.5, -12.0 );
   
   
SWEP.IconCamPos = Vector( 50, 139, 0 ) 
SWEP.IconLookAt = Vector( 1, 4, -1 ) 
SWEP.IconFOV = 6

function SWEP:SecondaryAttack()


	if( SERVER ) then
	
		local trace = { }
		trace.start = self.Owner:EyePos();
		trace.endpos = trace.start + self.Owner:GetAimVector() * 1024;
		trace.filter = self.Owner;
		
		local tr = util.TraceLine( trace );
		
		if( tr.Entity and tr.Entity:IsValid() and tr.Entity:IsDoor() ) then
		
			self.Owner.MEDoorEntity = tr.Entity;
			self.Owner.MEDoorName = tr.Entity.DoorName or "";
			self.Owner.MEDoorPrice = tr.Entity.DoorPrice or 0;
			self.Owner.MEDoorFlags = tr.Entity.DoorFlags or "";
			self.Owner.MEPropertyFamily = tr.Entity.PropertyFamily or "";
			self.Owner.MEStorageWidth = tr.Entity.StorageWidth or 0;
			self.Owner.MEStorageHeight = tr.Entity.StorageHeight or 0;
			
			umsg.Start( "CDS", self.Owner );
				umsg.String( self.Owner.MEDoorName );
				umsg.Short( self.Owner.MEDoorPrice );
				umsg.String( self.Owner.MEDoorFlags );
				umsg.String( self.Owner.MEPropertyFamily );
			umsg.End();

		end
		
	end

end

function SWEP:PrimaryAttack()

	if( SERVER ) then
	
		local trace = { }
		trace.start = self.Owner:EyePos();
		trace.endpos = trace.start + self.Owner:GetAimVector() * 1024;
		trace.filter = self.Owner;
		
		local tr = util.TraceLine( trace );
		
		if( tr.Entity and tr.Entity:IsValid() and tr.Entity:IsDoor() ) then
		
			umsg.Start( "MEED", self.Owner );
				umsg.Entity( tr.Entity );
				umsg.String( tr.Entity.DoorName or "" );
				umsg.Short( tr.Entity.DoorPrice or 0 );
				umsg.String( tr.Entity.DoorFlags or "" );
				umsg.String( tr.Entity.PropertyFamily or "" );
				umsg.Short( tr.Entity.StorageWidth or 0 );
				umsg.Short( tr.Entity.StorageHeight or 0 );
			umsg.End();
		
		end
		
	end

end

function SWEP:Reload()

	if( SERVER ) then
	
		local trace = { }
		trace.start = self.Owner:EyePos();
		trace.endpos = trace.start + self.Owner:GetAimVector() * 1024;
		trace.filter = self.Owner;
		
		local tr = util.TraceLine( trace );
		
		if( tr.Entity and tr.Entity:IsValid() and tr.Entity:IsDoor() ) then
		
			local doorent = tr.Entity;
		
			doorent.DoorName = self.Owner.MEDoorName;
			doorent.DoorPrice = self.Owner.MEDoorPrice;
			doorent.DoorFlags = self.Owner.MEDoorFlags;
			doorent.PropertyFamily = self.Owner.MEPropertyFamily;
			doorent.StorageWidth = self.Owner.MEStorageWidth;
			doorent.StorageHeight = self.Owner.MEStorageHeight;
			
			if( not table.HasValueWithField( TS.MapDoors, "Door", doorent ) ) then
			
				table.insert( TS.MapDoors, { Door = doorent, Name = doorent.DoorName, Price = doorent.DoorPrice, Flags = doorent.DoorFlags, PropertyFamily = doorent.PropertyFamily, StorageWidth = doorent.StorageWidth, StorageHeight = doorent.StorageHeight  } );
			
			else
			
				for k, v in pairs( TS.MapDoors ) do
				
					if( v.Door == doorent ) then
					
						v.Name = doorent.DoorName;
						v.Price = doorent.DoorPrice;
						v.Flags = doorent.DoorFlags;
						v.PropertyFamily = doorent.PropertyFamily;
						v.StorageWidth = doorent.StorageWidth;
						v.StorageHeight = doorent.StorageHeight;
						
					end
				
				end
			
			end
			
			TS.BindPropertyAndDoor( doorent );
			TS.BindContainerAndDoor( doorent );
			
			local rec = RecipientFilter();
			
			for k, v in pairs( TS.MapEditors ) do
			
				rec:AddPlayer( v );
			
			end
			
			umsg.Start( "MEUD", rec );
				umsg.Entity( doorent );
				umsg.String( doorent.DoorName or "" );
				umsg.Short( doorent.DoorPrice or 0 );
				umsg.String( doorent.DoorFlags or "" );
				umsg.String( doorent.PropertyFamily or "" );
				umsg.Short( doorent.StorageWidth or 0 );
				umsg.Short( doorent.StorageHeight or 0 );
			umsg.End();
				
		end
		
	end

end


if( CLIENT ) then

	MEDoorName = "";
	MEDoorPrice = 0;
	MEDoorFlags = "";
	MEPropertyFamily = "";

	function SWEP:DrawHUD()
	
		local parent = "";
		local child = "";
		
		if( string.find( MEPropertyFamily, ":" ) ) then
		
			parent = string.sub( MEPropertyFamily, 1, string.find( MEPropertyFamily, ":" ) - 1 );
			child = string.sub( MEPropertyFamily, string.find( MEPropertyFamily, ":" ) + 1 );
			
		end
	
		draw.RoundedBox( 0, 10, ScrH() * .2 - 20, 200, 105, Color( 0, 0, 0, 200 ) );
		draw.DrawText( "Copied door settings", "NewChatFont", 14, ScrH() * .2 - 10, Color( 255, 100, 100, 200 ) );
		draw.DrawText( "Door name: " .. MEDoorName .. "\nDoor price: " .. MEDoorPrice .. "\nDoor flags: " .. MEDoorFlags .. "\nParent: " .. parent .. "\nChild: " .. child, "NewChatFont", 14, ScrH() * .2 + 5, Color( 255, 255, 255, 200 ) );
	
		local trace = { }
		trace.start = self.Owner:EyePos();
		trace.endpos = trace.start + self.Owner:GetAimVector() * 1024;
		trace.filter = self.Owner;
		
		local tr = util.TraceLine( trace );
		
		if( tr.Entity and tr.Entity:IsValid() ) then
		
			if( tr.Entity:IsDoor() ) then
				draw.DrawText( "o", "TargetID", ScrW() / 2, ScrH() / 2, Color( 255, 100, 100, 255 ), 1, 1 );
			else
				draw.DrawText( "x", "TargetID", ScrW() / 2, ScrH() / 2, Color( 255, 255, 255, 255 ), 1, 1 );
			end
			
		else
			draw.DrawText( "x", "TargetID", ScrW() / 2, ScrH() / 2, Color( 255, 255, 255, 255 ), 1, 1 );
		end
		
	end
	
	local function CopyDoorSettings( msg )
	
		MEDoorName = msg:ReadString();
		MEDoorPrice = msg:ReadShort();
		MEDoorFlags = msg:ReadString();
		MEPropertyFamily = msg:ReadString();
	
	end
	usermessage.Hook( "CDS", CopyDoorSettings );
	
end
	

   