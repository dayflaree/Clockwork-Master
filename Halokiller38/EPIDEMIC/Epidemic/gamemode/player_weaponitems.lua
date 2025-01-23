
local meta = FindMetaTable( "Player" );

local types = {

	"Heavy",
	"Light",

};

for k, v in pairs( types ) do
	
	meta["Set" .. v .. "Weapon"] = function( self, itemdata )
	
		self:GetTable()[v .. "Weapon"] =
		{
			
			Data = itemdata
			
		}
		
		if( k == 1 ) then
		
			umsg.Start( "HWEAP", self );
				umsg.String( itemdata.ID );
			umsg.End();		
			
			self:sqlUpdateField( "HeavyWeaponry", itemdata.ID, true );
		
		else
		
			umsg.Start( "LWEAP", self );
				umsg.String( itemdata.ID );
			umsg.End();
			
			self:sqlUpdateField( "LightWeaponry", itemdata.ID, true );
			
		end
		
		self:SendItemData( itemdata );
		
		self:Give( itemdata.ID );
		
		local weap = self:GetWeapon( itemdata.ID );
	
		timer.Simple( .1, self["Set" .. v .. "WeaponAmmo"], self, itemdata.AmmoCurrentClip );
		timer.Simple( .3, self["Set" .. v .. "WeaponHealthAmt"], self, self:GetTable()[ v .. "Weapon"].Data.HealthAmt );
		
		self["Attach" .. v .. "WeaponModel"]( self );
		
	end
	
	meta["Set" .. v .. "WeaponHealthAmt"] = function( self, amt )
	
		local weap = self:GetWeapon( self:GetTable()[ v .. "Weapon"].Data.ID );
		
		if( not weap or not weap:IsValid() ) then return; end
		
		weap:GetTable().HealthAmt = amt;
		
		umsg.Start( "SWH", self );
			umsg.String( self:GetTable()[ v .. "Weapon"].Data.ID );
			umsg.Short( weap:GetTable().HealthAmt );
		umsg.End();
		
	end
	
	meta["Drop" .. v .. "Weapon"] = function( self )
	
		if( self:GetTable()[v .. "Weapon"] ) then
		
			local item = self:DropItemProp( self:GetTable()[v .. "Weapon"].Data );	
			local weap = self:GetWeapon( self:GetTable()[ v .. "Weapon"].Data.ID );
			
			if( weap and weap:IsValid() ) then
			
				item:GetTable().ItemData.AmmoCurrentClip = weap:GetTable().Primary.CurrentClip;
				item:GetTable().ItemData.HealthAmt = weap:GetTable().HealthAmt;
				
				self:StripWeapon( self:GetTable()[v .. "Weapon"].Data.ID );
				
				if( self:HasWeapon( "ep_hands" ) ) then
					
					self:SelectWeapon( "ep_hands" );
				
				elseif( self:HasWeapon( "ep_zhands" ) ) then
				
					self:SelectWeapon( "ep_zhands" );
				
				end
			
			end
			
			if( k == 1 ) then
			
				self:sqlUpdateField( "HeavyWeaponry", "", true );
			
			else
			
				self:sqlUpdateField( "LightWeaponry", "", true );
			
			end
			
			self["Remove" .. v .. "Weapon"]( self );
		
		end
	
	end
	
	meta["Set" .. v .. "WeaponAmmo"] = function( self, amt )
	
		local weap = self:GetWeapon( self:GetTable()[ v .. "Weapon"].Data.ID );
	
		if( not weap or not weap:IsValid() ) then return; end
	
		weap:GetTable().Primary.CurrentClip = amt;

		if( k == 1 ) then
		
			self:SetPlayerHWAmmo( amt );
		
		else
		
			self:SetPlayerLWAmmo( amt );
		
		end
		
		umsg.Start( "SAMM", self );
			umsg.String( self:GetTable()[v .."Weapon"].Data.ID );
			umsg.Short( amt );
		umsg.End();
	
	end
	
	meta["TakeAmmoTo" .. v .. "Weapon"] = function( self, inv, x, y )
	
		if( self:GetTable()[v .. "Weapon"] and self:ValidInventoryItem( inv, x, y ) ) then
		
			local itemdata = self:GetTable().InventoryGrid[inv][x][y].ItemData;
		
			if( not itemdata ) then
			
				return;
			
			end		
			
			if( itemdata.AmmoType == self:GetTable()[v .. "Weapon"].Data.WeaponData.Primary.AmmoType ) then
			
				local amt = math.Clamp( self:GetTable()[v .. "Weapon"].Data.WeaponData.Primary.MaxAmmoClip - self:GetWeapon( self:GetTable()[v .. "Weapon"].Data.ID ):GetTable().Primary.CurrentClip, 0, self:GetTable().InventoryGrid[inv][x][y].ItemData.Amount );
			
				local reloadcb = function()
	
					if( not self:GetTable().InventoryGrid[inv][x][y].ItemData ) then return; end
			
					self:GetTable().InventoryGrid[inv][x][y].ItemData.Amount = self:GetTable().InventoryGrid[inv][x][y].ItemData.Amount - amt;
					
					umsg.Start( "CIIA", self );
						umsg.Short( inv );
						umsg.Short( x );
						umsg.Short( y );
						umsg.Short( self:GetTable().InventoryGrid[inv][x][y].ItemData.Amount );
					umsg.End();
					
					self:sqlUpdateAmount( inv, x, y, self:GetTable().InventoryGrid[inv][x][y].ItemData.Amount );
					
					self["Set" .. v .. "WeaponAmmo"]( self, self:GetWeapon( self:GetTable()[v .. "Weapon"].Data.ID ):GetTable().Primary.CurrentClip + amt );
				
					if( self:GetTable().InventoryGrid[inv][x][y].ItemData.Amount <= 0 ) then
						
						self:GetTable().InventoryGrid[inv][x][y].ItemData.Amount = 0;
						
						self:RemoveFromInventory( inv, x, y );
					
					end
					
				end
				
				local weap = self:GetWeapon( self:GetTable()[v .. "Weapon"].Data.ID );
				
				if( self:GetActiveWeapon():IsValid() and self:GetActiveWeapon():GetClass() == self:GetTable()[v .. "Weapon"].Data.ID ) then
				
					weap:GetTable().Primary.ReloadingAmount = amt;
					weap:GetTable().ReloadCB = reloadcb;
					weap:OnReload();
					
				else
				
					reloadcb();
				
				end
					
			end
		
		end	
	
	end
	
	
	meta["Unload" .. v .. "Weapon"] = function( self, inv, x, y )
	
		if( self:GetTable()[v .. "Weapon"] ) then
			
			local weap = self:GetWeapon( self:GetTable()[v .. "Weapon"].Data.ID );
			
			local amt = math.Clamp( weap:GetTable().Primary.CurrentClip, 0, 30 );
			
			local unloadcb = function()
				
				local invs = self:GetAvailableInventories();
				
				local availinv = { }
			
				for k, v in pairs( invs ) do
				
					if( self:HasInventorySpace( v, 1, 1 ) ) then
						
						table.insert( availinv, v );
						
					end
					
				end
				
				if( #availinv == 0 ) then
					
					self:NoticePlainWhite( "You do not have enough inventory space." );
					return;
				
				end
				
				local itemid = nil;
				
				for _, i in pairs( ItemsData ) do
					
					if( i.AmmoType == self:GetTable()[v .. "Weapon"].Data.WeaponData.Primary.AmmoType ) then
						
						itemid = i.ID;
						
					end
					
				end
				
				if( itemid and availinv[1] and self:GiveItem( itemid, availinv[1], amt ) ) then
					
					self["Set" .. v .. "WeaponAmmo"]( self, weap:GetTable().Primary.CurrentClip - amt );
					
				end
				
			end
			
			if( amt > 0 ) then
				
				if( self:GetActiveWeapon():IsValid() and self:GetActiveWeapon():GetClass() == self:GetTable()[v .. "Weapon"].Data.ID ) then
					
					weap:GetTable().UnloadCB = unloadcb;
					weap:OnUnload();
					
				else
				
					unloadcb();
				
				end
				
			end
		
		end
	
	end
	
	
	meta["TakeKitTo" .. v .. "Weapon"] = function( self, inv, x, y )
	
		if( self:GetTable()[v .. "Weapon"] and self:ValidInventoryItem( inv, x, y ) ) then
		
			local itemdata = self:GetTable().InventoryGrid[inv][x][y].ItemData;
		
			if( not itemdata ) then
			
				return;
			
			end
			
			if( itemdata[v .. "Weight"]  == self:GetTable()[v .. "Weapon"].Data.WeaponData[v .. "Weight"] ) then
				
				local function think() end
				
				local function done()
					
					local weapent = self:GetWeapon( self:GetTable()[v .. "Weapon"].Data.ID );
					
					local amt = math.Clamp( self:GetTable()[v .. "Weapon"].Data.WeaponData.HealthAmt + itemdata.Amt, 0, 100 );
					
					if( weapent and weapent:IsValid() ) then
						
						amt = math.Clamp( ( weapent.HealthAmt or 100 ) + itemdata.Amt, 0, 100 );
						
					end
					
					if( not self:GetTable().InventoryGrid[inv][x][y].ItemData ) then return; end
					
					self:GetTable().InventoryGrid[inv][x][y].ItemData.Amount = self:GetTable().InventoryGrid[inv][x][y].ItemData.Amount - amt;
					
					self["Set" .. v .. "WeaponHealthAmt"]( self, amt );
					self:RemoveFromInventory( inv, x, y );
					
					if( self:Alive() and weapent and weapent:IsValid() ) then
						
						weapent.Jammed = false;
						weapent.Broken = false;
						
						if( v == "Heavy" ) then
							self:sqlUpdateField( "HWDeg", weapent.HealthAmt, true );
						else
							self:sqlUpdateField( "LWDeg", weapent.HealthAmt, true );
						end
						
						umsg.Start( "UJW", self );
							umsg.Entity( weapent );
						umsg.End();
						
					end
					
					self:Freeze( false );
					
					return true;
					
				end
				
				self:Freeze( true );
				self:CreateProgressBar( "repairweapon", "Repairing weapon", 30, 15, think, done );
				
			end
		
		end	
	
	end
	
	meta["SetItemTo" .. v .. "Weapon"] = function( self, inv, x, y )
	
		if( self:ValidInventoryItem( inv, x, y ) ) then
		
			local itemdata = self:GetTable().InventoryGrid[inv][x][y].ItemData;
			
			if( not itemdata ) then
			
				return;
			
			end
			
			if( itemdata[v .. "Weight"] ) then
				
				self["Drop" .. v .. "Weapon"]( self );
				self:RemoveFromInventory( inv, x, y );
				timer.Simple( .6, self["Set" .. v .. "Weapon"], self, itemdata ); 
			
			end
			
		end
	
	end
	
	meta["Remove" .. v .. "Weapon"] = function( self )
	
		if( k == 1 ) then
			self:CallEvent( "RMHWEAP" );
		else
			self:CallEvent( "RMLWEAP" );
		end
			
		self["Remove" .. v .. "WeaponAttachment"]( self );
			
		self:GetTable()[v .. "Weapon"] = nil;
	
	end
	
	meta["Move" .. v .. "WeaponToInventory"] = function( self, inv, x, y )
	
		local itemdata = self:GetTable()[v .. "Weapon"].Data;
				
		if( self:AttemptToPutInInventoryAt( itemdata, inv, x, y ) ) then
	
			local _x = self:GetTable().InventoryGrid[inv][x][y].sx;
			local _y = self:GetTable().InventoryGrid[inv][x][y].sy;
			
			local weap = self:GetWeapon( self:GetTable()[v .. "Weapon"].Data.ID );
			
			local heal = 100;
			local cl = 0;
			
			if( weap and weap:IsValid() ) then
				
				heal = weap:GetTable().HealthAmt;
				cl = weap:GetTable().Primary.CurrentClip;
				
			else
				
				local rec = RecipientFilter();
				local msg = self:RPNick() .. "(" .. self:SteamID() .. ") may be attempting to duplicate a weapon!!";
				
				for k, v in pairs( player.GetAll() ) do
				
					if( v:HasAnyAdminFlags() ) then
					
						rec:AddPlayer( v );
						v:PrintMessage( 2, msg );
					
					end
				
				end
				
				umsg.Start( "ac", rec );
					umsg.String( "" );
					umsg.String( msg );
				umsg.End();
				
			end
			
			if( self:GetTable().InventoryGrid[inv][_x] and self:GetTable().InventoryGrid[inv][_x][_y] ) then
			
				self:GetTable().InventoryGrid[inv][_x][_y].ItemData.HealthAmt = heal;		
				self:GetTable().InventoryGrid[inv][_x][_y].ItemData.AmmoCurrentClip = cl;		
	
			end
	
			if( k == 1 ) then
			
				self:sqlUpdateField( "HeavyWeaponry", "", true );
			
			else
			
				self:sqlUpdateField( "LightWeaponry", "", true );
			
			end
	
			self:StripWeapon( self:GetTable()[v .. "Weapon"].Data.ID );
			if( self:HasWeapon( "ep_hands" ) ) then
				
				self:SelectWeapon( "ep_hands" );
			
			elseif( self:HasWeapon( "ep_zhands" ) ) then
			
				self:SelectWeapon( "ep_zhands" );
			
			end
			self["Remove" .. v .. "Weapon"]( self );
	
		end	
	
	end
	
	meta["Attach" .. v .. "WeaponModel"] = function( self )
	
		if( self:GetTable()[v .. "Weapon"] and not self:GetTable()[v .. "WeaponAttachment"] and not self:GetTable()[ v .. "Weapon"].Data.WeaponData.Melee ) then
			
			self:GetTable()[v .. "WeaponAttachment"] = self:AttachProp( self:GetTable()[ v .. "Weapon"].Data.WeaponData.ItemModel or self:GetTable()[ v .. "Weapon"].Data.WeaponData.WorldModel, "chest", true );
			self:GetTable()[v .. "WeaponAttachment"]:SetNWBool( "Back", true );
			
		end
		
	end
	
	meta["Remove" .. v .. "WeaponAttachment"] = function( self )
	
		if( self:GetTable()[v .. "WeaponAttachment"] ) then
			
			if( self:GetTable()[v .. "WeaponAttachment"]:IsValid() ) then
			
				self:GetTable()[v .. "WeaponAttachment"]:Remove();
			
			end
					
			self:GetTable()[v .. "WeaponAttachment"] = nil;
					
		end
					
	end
	
end

function meta:CarryWeapon( ent )

	if( ent:GetTable().ItemData.IsWeapon ) then
	
		local type = "Light";
	
		if( ent:GetTable().ItemData.WeaponData.HeavyWeight ) then
		
			type = "Heavy";

		end
		
		self["Drop" .. type .. "Weapon"]( self );
		self["Set" .. type .. "Weapon"]( self, ent:GetTable().ItemData );
		
		ent:Remove();
	
	end

end




