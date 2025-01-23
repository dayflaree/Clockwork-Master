

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

	if( not TS.ItemsData[item] ) then return; end

	self.Entity:SetModel( TS.ItemsData[item].Model );
	self.Entity.ItemID = item;
	
	self.Entity.ItemData = { }
	
	self.Entity.ItemData.ItemEntity = self.Entity;
	
	for k, v in pairs( TS.ItemsData[item] ) do
	
		self.Entity.ItemData[k] = TS.ItemsData[item][k];
	
	end
	
end

function ENT:ConvertToStorage()

	if( self.Entity.ItemData ) then

		TS.ItemToContainer( self.Entity.ItemData )

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
	
	if( ply:IsTied() ) then return; end 
	
	if( CurTime() - ply.LastItemUse < .5 ) then
		return;
	end

	ply.LastItemUse = CurTime();

	self.CanUse = false;
	self.User = ply;

	--Special weapons only code
	if( string.find( self.Entity.ItemData.Flags, "w" ) ) then
	
		for k, v in pairs( ply.Inventories ) do
			if( v.Name ~= "" ) then
				if( ply:CanItemFitInInventory( k, self.Entity.ItemID ) ) then
					
					local pickupitemthink = function( ply, done )

						local ent = self.Entity;
						
						if( not ent or not ent:IsValid() ) then
						
							DestroyProcessBar( "pickupitem", ply );
							return;
						
						end
						
						if( done ) then
						
							ply:GiveInventoryItem( k, ent.ItemID );
							DestroyProcessBar( "pickupitem", ply );
							ent:Remove();
							
							ply:SaveItems();
							return;			
						
						end
						
						local crntdist = ( ent:GetPos() - ply:GetPos() ):Length();
						
						if( crntdist > 90 ) then
						
							DestroyProcessBar( "pickupitem", ply );
							return;
						
						end
					
					end
						
					CreateProcessBar( "pickupitem", "Picking up item", ply );
						SetEstimatedTime( self.Entity.ItemData.PickupDelay, ply );
						SetThinkDelay( .1, ply );
						SetThink( pickupitemthink, ply );
					EndProcessBar( ply );
					
					return;
					
				end
			end
		end
		
		ply:GiveTempWeapon( self.Entity.ItemData.ID );
		ply:HandleWeaponChangeTo( self.Entity.ItemData.ID );
		self.Entity:Remove();
		return;
		
	end

	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 90;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	
	if( self.Entity ~= tr.Entity ) then return; end
	
	if( not self.Entity.ItemData ) then return; end
	
	CreateActionMenu( self.Entity.ItemData.Name, ply, self.Entity:GetPos() );
	
		SetActionMenuEntity( self.Entity );
		
		if( string.find( self.Entity.ItemData.Flags, "c" ) ) then
			if( not ply:HasContainer( self.Entity.ItemData.Name ) and
				not string.find( self.Entity.ItemData.Flags, "!" ) ) then
				AddActionOption( "Put on", "eng_ampickupcontainer", k );
			end
			AddActionOption( "Look inside", "eng_amlookinsidecontainer", k );
		end
		
		if( ply:IsCitizen() ) then
		
			if( string.find( self.Entity.ItemData.Flags, "W" ) ) then
				AddActionOption( "Wear", "eng_amwearitem", k );
				AddActionOption( "Look inside", "eng_amlookinsidecontainer", k );
			end
			
		end
		
		if( ply:IsCitizen() ) then
		
			if( string.find( self.Entity.ItemData.Flags, "e" ) ) then
				AddActionOption( "Eat", "eng_amuseitem", k );
			end
			
		end

		if( string.find( self.Entity.ItemData.Flags, "l" ) ) then
			AddActionOption( "Read", "eng_amreaditem", k );
		end

		if( not string.find( self.Entity.ItemData.Flags, "!" ) and not string.find( self.Entity.ItemData.Flags, "c" ) and not self.Entity:IsConstrained() ) then
			for k, v in pairs( ply.Inventories ) do
				if( not string.find( self.Entity.ItemData.Flags, "s" ) or ( string.find( self.Entity.ItemData.Flags, "s" ) and not v.IsClothes ) ) then
					if( v.Name ~= "" ) then
						if( ply:CanItemFitInInventory( k, self.Entity.ItemID ) ) then
							AddActionOption( "Put into " .. string.lower( v.Name ), "eng_pickupitem", k );
						end
					end
				end
			end
		end
		
		AddActionOption( "Examine", "eng_examineitem", 1 );
		
	EndActionMenu();

end

