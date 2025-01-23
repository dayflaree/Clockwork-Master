
local meta = FindMetaTable( "Player" );

function meta:HandlePropInteraction( ent )

	if( not ent:IsOwnedBy( self ) ) then return; end

	self:NewActionMenu( ent );
	
	self:ActionMenuOption( "Set Description", "#DescProp" );
	self:ActionMenuOption( "Add Prop Admin", "#AddPropAdmin" );
	
	for k, v in pairs( ent:GetTable().Owners ) do
	
		if( not v:IsValid() ) then 
		
			ent:GetTable().Owners[k] = nil;
		
		end
	
	end
	
	if( #ent:GetTable().Owners >= 1 ) then
	
		self:ActionMenuCategory( "Remove Prop Admins.." );
		
		for k, v in pairs( ent:GetTable().Owners ) do
		
			self:ActionMenuOption( v:RPNick(), "rp_am_rempropadm " .. k );
		
		end
	
	end
	
	self:ActionMenuSend();
	
end

function meta:HandleItemInteraction( ent )

	if( self:GetPlayerIsInfected() ) then return; end

	local invs = self:GetAvailableInventories();
	local itemdata = ent:GetTable().ItemData;
	
	if( not itemdata ) then return; end
	
	self:NewActionMenu( ent );
	
	if( string.find( itemdata.Flags, "i" ) ) then
	
		if( self:GetTable().AddableInvs[itemdata.ID] and not self:HasItemInventory( itemdata.ID ) ) then
	
			self:ActionMenuOption( "Put on", "rp_am_useent" );
			
		end
		
	end
	
	if( string.find( itemdata.Flags, "e" ) ) then
	
		self:ActionMenuOption( "Eat", "rp_am_useent" );
		
	end
	
	if( string.find( itemdata.Flags, "d" ) ) then
	
		self:ActionMenuOption( "Drink", "rp_am_useent" );
		
	end
	
	if( string.find( itemdata.Flags, "u" ) and !itemdata.InventoryUse ) then
	
		self:ActionMenuOption( "Use", "rp_am_useent" );
		
	end
	
	if( string.find( itemdata.Flags, "x" ) ) then
	
		self:ActionMenuOption( "Examine", "rp_am_examineent" );
	
	end
	
	if( string.find( itemdata.Flags, "w" ) or string.find( itemdata.Flags, "v" ) ) then
	
		self:ActionMenuOption( "Carry as weapon", "rp_am_carryweap" );
		
	end 
	
	if( not string.find( itemdata.Flags, "p" ) ) then
	
		if( #invs == 0 ) then
		
			self:ActionMenuCategory( "No room in inventory" );
		
		else
		
			local availinv = { }
			
			for k, v in pairs( invs ) do
			
				if( self:HasInventorySpace( v, itemdata.Width, itemdata.Height ) ) then
				
					table.insert( availinv, v );
				
				end
				
			end
			
			if( #availinv == 0 ) then
			
				self:ActionMenuCategory( "No room in inventory" );
			
			else
			
				self:ActionMenuCategory( "Put in . ." );
				
				for k, v in pairs( availinv ) do
				
					local name = self:GetTable().InventoryGrid[v].name;
				
					self:ActionMenuOption( name, "rp_am_entitytoinv " .. v );
				
				end
				
			end
			
		end
		
	end
	
	self:ActionMenuSend();

end
