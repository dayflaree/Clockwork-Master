function ShowSpare1Fix( ply )

	ply:ConCommand( "gm_showspare1\n" );

end
concommand.Add( "gm_spare1", ShowSpare1Fix );

function ShowSpare2Fix( ply )

	ply:ConCommand( "gm_showspare2\n" );

end
concommand.Add( "gm_spare2", ShowSpare2Fix );

function CCSetName( ply, cmd, args )

	if( not ply.CharacterMenu ) then
		return;
	end

	if( #args < 1 or string.len( args[1] ) < 3 or
		string.len( args[1] ) > 30 or 
		string.gsub( args[1], " ", "" ) == "" ) then
	
		return;
	
	end
	
	local fmtname = string.gsub( args[1], "\n", "" );
	
	ply.CCName = fmtname;
	
end
concommand.Add( "eng_ccsetname", CCSetName );

function CCSetAge( ply, cmd, args )

	if( not ply.CharacterMenu ) then
		return;
	end

	if( #args < 1 or not tonumber( args[1] ) 
		or tonumber( args[1] ) < 18
		or tonumber( args[1] ) > 80 ) then
		
		return;				
		
	end

	ply.CCAge = tonumber( args[1] );
	

end
concommand.Add( "eng_ccsetage", CCSetAge );

function CCSetModel( ply, cmd, args )

	if( not ply.CharacterMenu ) then
		return;
	end
	
	if( #args < 1 or args[1] == "" 
		or not table.HasValue( TS.SelectablePlayerModels, args[1] ) ) then
		
		return;				
	
	end

	ply.CCModel = args[1];
	
end
concommand.Add( "eng_ccsetmodel", CCSetModel );

function CCSetStats( ply, cmd, args )

	if( not ply.CharacterMenu ) then
		return;
	end
	
	if( tonumber( args[1] ) >= 61 or 
		tonumber( args[2] ) >= 61 or
		tonumber( args[3] ) >= 61 or
		tonumber( args[4] ) >= 61 ) then
		
		return;				
		
	end

	ply.CCStrength = tonumber( args[1] );
	ply.CCEndurance = tonumber( args[2] );
	ply.CCSpeed = tonumber( args[3] );
	ply.CCAim = tonumber( args[4] );

end
concommand.Add( "eng_ccsetstats", CCSetStats );

function ccCreateCharacter( ply, cmd, args )

	if( CurTime() - ply.LastCharCreation < 3 ) then
		return;
	end

	if( not ply.CCName or
		not ply.CCModel or
		not ply.CCAge ) then
		
		return;
		
	end
	
	local ID = ply:GetSQLData( "uid" );
	
	local query = "SELECT `userID`, `charName` FROM `tb_characters` WHERE `userID` = '" .. ID .. "'";
	TS.AsyncQuery(query, function(q)
		local results = q:getData()
		local saves = #results
		--Max char check
		if(saves >= MAX_CHARACTERS ) then

			umsg.Start( "MC", ply );
			umsg.End();
			return;
			
		end

		for k,v in pairs(results) do
			--Already has character
			if v.charName:lower() == ply.CCName:lower() then

				umsg.Start( "DC", ply );
				umsg.End();
				return;
			
			end
		end

		ply:SetNWString( "RPName", ply.CCName );	
		ply.CitizenModel = ply.CCModel;
		ply:SetPlayerAge( ply.CCAge );

		if( ply.CCStrength and
			ply.CCEndurance and
			ply.CCSpeed and
			ply.CCAim ) then

			ply:SetPlayerStrength( ply.CCStrength );
			ply:SetPlayerSpeed( ply.CCSpeed);
			ply:SetPlayerEndurance( ply.CCEndurance );
			ply:SetPlayerAim( ply.CCAim );
			
		end

		ply.CombineFlags = "";
		ply.PlayerFlags = "";
		ply.Frequency = 0;
		ply.Tokens = 100;
		ply.CID = "";
		ply.Away = nil
		ply.LastTitleUpdate = CurTime()

		if( not ply.HasSeenMOTD ) then

			ply.CanInitialize = true;
			ply:PromptMOTD();

		else
			ply:SendSessionEnd()
			ply:CharacterInitialize();
			timer.Simple(1, ply.SendSessionStart, ply)
		end

		ply:RemoveCharacterMenu();

		ply.CharacterMenu = false;
		ply.LastCharCreation = CurTime();
	end)
end
concommand.Add( "eng_createcharacter", ccCreateCharacter );

function CCSelectCharacter( ply, cmd, args )

	if( #args < 1 ) then return; end
	
	if( CurTime() - ply.LastCharSelection < 2 ) then
		return;
	end

	local ID = ply:GetSQLData( "uid" );

	local query = "SELECT `userID` FROM `tb_characters` WHERE `userID` = '" .. ID .. "' AND `charName` = '"..TS.Escape(args[1]).."'";
	TS.AsyncQuery(query, function(q)
		local results = q:getData()
		local saves = #results
		if saves > 0 then
			ply.CCModel = "models/odessa.mdl"
			ply:SetNWString( "RPName", args[1] );
			ply.CitizenModel = ply.CCModel;
			
			if( not ply.HasSeenMOTD ) then
		
				ply.CanInitialize = true;
				ply:PromptMOTD();
			else
				
				ply:SendSessionEnd()
				ply:CharacterInitialize();
				timer.Simple(1, ply.SendSessionStart, ply)
			end
			
			ply:RemoveCharacterMenu();
			ply.CharacterMenu = false;

		end

		ply.LastCharSelection = CurTime();
	end)

end
concommand.Add( "eng_selectchar", CCSelectCharacter );

function CloseMOTD( ply, cmd, arg )

	if( not ply.Initialized and
		ply.CanInitialize ) then
	
		umsg.Start( "FIFO", ply );
			umsg.Float( 4 );
		umsg.End();
		
		timer.Simple( 1, ply.CharacterInitialize, ply );
		timer.Simple( 1.5, ply.SendSessionStart, ply)
	end
	
end
concommand.Add( "rp_closemotd", CloseMOTD );

function ccIsTyping( ply, cmd, arg )
	
	ply:SetNWBool( "IsTyping", true );

end
concommand.Add( "eng_istyping", ccIsTyping );

function ccIsNotTyping( ply, cmd, arg )
	
	ply:SetNWBool( "IsTyping", false );

end
concommand.Add( "eng_isnottyping", ccIsNotTyping );

function ccReceiveItemInfo( ply, cmd, arg )

	if( not arg[1] or not tonumber( arg[1] ) ) then
		ply:Disconnect();
		return;
	end

	local ent = ents.GetByIndex( tonumber( arg[1] ) );

	if( not ent or not ent:IsValid() ) then return; end

	if( not ent.ItemID ) then return; end	
	
	if( ply.SendItemNames[ent:EntIndex()] ) then
	
		if( ply.SendItemNames[ent:EntIndex()].id == ent.ItemID and
			ply.SendItemNames[ent:EntIndex()].fid == ent.IFID ) then
			return;
		end
		
	end
	
	ply.SendItemNames[ent:EntIndex()] = { id = ent.ItemID, fid = ent.IFID };
	
	umsg.Start( "RIHI", ply );
		umsg.Short( tonumber( arg[1] ) );
		umsg.String( TS.ItemsData[ent.ItemID].Name or "" );
	umsg.End();

end
concommand.Add( "eng_reciteminfo",  ccReceiveItemInfo );

function ccInventoryDropItem( ply, cmd, arg )

	if( not arg[1] or not tonumber( arg[2] ) or not tonumber( arg[3] ) or not tonumber( arg[4] ) ) then
		return;
	end
	
	if( ply:IsTied() ) then return; end 

	local id = arg[1];
	local iid = tonumber( arg[2] );
	local x = tonumber( arg[3] );
	local y = tonumber( arg[4] );
	
	if( id == "radio" ) then ply.Frequency = 0; end
	
	if( not ply.InventoryGrid[iid][x][y].Filled ) then return; end
	
	local dropitemthink = function( ply, done )
		
		if( done ) then
			
			if( not ply.InventoryGrid[iid][x][y].Filled ) then return; end
			if( not ply.InventoryGrid[iid][x][y].ItemData ) then return; end

			ply.InventoryGrid[iid][x][y].ItemData.Owner = ply;
			ply.InventoryGrid[iid][x][y].ItemData.Drop( ply.InventoryGrid[iid][x][y].ItemData );

			local data = { }
			
			for k, v in pairs( ply.InventoryGrid[iid][x][y].ItemData ) do
			
				data[k] = v;
			
			end
	
			DestroyProcessBar( "dropitem", ply );
			ply:TakeItemAt( iid, x, y );
			
			local ent = ply:DropItemProp( id );
			ent.ItemData = data;
			
			ply:SaveItems();
			return;			
		
		end
	
	end
	
	CreateProcessBar( "dropitem", "Dropping item", ply );
		SetEstimatedTime( .5, ply );
		SetThinkDelay( .25, ply );
		SetThink( dropitemthink, ply );
	EndProcessBar( ply );		

end
concommand.Add( "eng_invdropitem", ccInventoryDropItem );

function ccInventoryTakeInventoryStorageItem( ply, cmd, arg )

	if( #arg ~= 7 ) then
		return;
	end
	
	if( ply:IsTied() ) then return; end 

	local id = arg[1];
	local iid = tonumber( arg[2] );
	local x = tonumber( arg[3] );
	local y = tonumber( arg[4] );
	local i_id = arg[5];
	local i_x = tonumber( arg[6] );
	local i_y = tonumber( arg[7] );

	if( not ply.InventoryGrid[iid][x][y].Filled ) then return; end
	if( ply.InventoryGrid[iid][x][y].ItemData.ID ~= id ) then return; end
	if( not ply.InventoryGrid[iid][x][y].ItemData:IsContainer() ) then return; end
	
	if( ply:CanItemFitInAnyInventory( i_id ) ) then
	
		ply.InventoryGrid[iid][x][y].ItemData:RemoveItemAt( i_x, i_y, ply );
		ply:GiveAnyInventoryItem( i_id );
		
		ply:SaveItems();

	end

end
concommand.Add( "eng_invtakeinvstoritem", ccInventoryTakeInventoryStorageItem );

function ccInventoryTakeStorageItem( ply, cmd, arg )

	if( not arg[1] or not tonumber( arg[2] ) or not tonumber( arg[3] ) ) then
		return;
	end
	
	if( ply:IsTied() ) then return; end 
	
	local id = arg[1];
	local x = tonumber( arg[2] );
	local y = tonumber( arg[3] );
	
	local ent = ply.StorageEntity;
	
	if( not ent or not ent:IsValid() ) then
		return;
	end
	
	if( ( ent:GetPos() - ply:GetPos() ):Length() > 90 ) then
		ply.StorageEntity = nil;
		return;
	end

	local takeitemthink = function( ply, done )
		
		if( done ) then
			
			if( ply.StorageEntity and
				ply.StorageEntity:IsValid() ) then
				
				local ent = ply.StorageEntity;

				if( ent.ItemData.InventoryGrid[x][y].ItemData and ent.ItemData.InventoryGrid[x][y].ItemData.ID == id  and 
					ply:CanItemFitInAnyInventory( id ) ) then			
					
					ply:GiveAnyInventoryItem( ent.ItemData.InventoryGrid[x][y].ItemData );
	
					ent.ItemData:RemoveItemAt( x, y );
					
					ply:SaveItems();

				end
				
			end
			
			DestroyProcessBar( "takeitem", ply );

			return;			
		
		end
	
	end
	
	CreateProcessBar( "takeitem", "Taking item", ply );
		SetEstimatedTime( .3, ply );
		SetThinkDelay( .3, ply );
		SetThink( takeitemthink, ply );
	EndProcessBar( ply );		


end
concommand.Add( "eng_invtakestorageitem", ccInventoryTakeStorageItem );

function ccInventoryAddStorageItem( ply, cmd, arg )

	if( not arg[1] or not tonumber( arg[2] ) or not tonumber( arg[3] ) or not tonumber( arg[4] ) ) then
		return;
	end
	
	if( ply:IsTied() ) then return; end 
	
	if( CurTime() - ply.LastStorageItemAdd < 1 ) then return; end

	ply.LastStorageItemAdd = CurTime();

	local id = arg[1];
	local iid = tonumber( arg[2] );
	local x = tonumber( arg[3] );
	local y = tonumber( arg[4] );
	
	local ent = ply.StorageEntity;
		
	if( not ent or not ent:IsValid() ) then
		return;
	end
	
	if( ( ent:GetPos() - ply:GetPos() ):Length() > 90 ) then
		ply.StorageEntity = nil;
		return;
	end
	
	if( not ent.ItemData:CanItemFitInInventory( id ) ) then
	
		umsg.Start( "NRIS", ply );
		umsg.End();
		return;
	
	end
	
	if( string.find( TS.ItemsData[id].Flags, "c" ) ) then
	
		return;
	
	end
	
	local additemthink = function( ply, done )
		
		if( done ) then

			if( ply.InventoryGrid[iid][x][y].ItemData and ply.InventoryGrid[iid][x][y].ItemData.ID == id ) then
			
				if( ent.ItemData:CanItemFitInInventory( id ) ) then

					ent.ItemData:GiveInventoryItem( ply.InventoryGrid[iid][x][y].ItemData );
					ply:TakeItemAt( iid, x, y );
					
					if( string.find( id, "ts2_" ) and id ~= "ts2_hands" and id ~= "ts2_keys" and not ply:HasItem( id ) ) then
						
						ply:StripWeapon( id );
						
					end

					ply:SaveItems();
			
				else
				
					umsg.Start( "NRIS", ply );
					umsg.End();
				
				end
			
			end

			DestroyProcessBar( "additem", ply );
			
			ply:SaveItems();

			return;			
		
		end
	
	end
	
	CreateProcessBar( "additem", "Adding item to storage", ply );
		SetEstimatedTime( .3, ply );
		SetThinkDelay( .3, ply );
		SetThink( additemthink, ply );
	EndProcessBar( ply );	

end
concommand.Add( "eng_invaddstorage", ccInventoryAddStorageItem );

function ccInventoryUseItemPortion( ply, cmd, arg )

	if( not arg[1] or not tonumber( arg[2] ) or not tonumber( arg[3] ) or not tonumber( arg[4] ) ) then
		return;
	end

	if( ply:IsTied() ) then return; end 

	local id = arg[1];
	local iid = tonumber( arg[2] );
	local x = tonumber( arg[3] );
	local y = tonumber( arg[4] );
	
	if( not ply.InventoryGrid[iid][x][y].Filled ) then return; end
	
	local useitemthink = function( ply, done )
		
		if( done ) then
			
			ply.InventoryGrid[iid][x][y].ItemData.Owner = ply;
			ply.InventoryGrid[iid][x][y].ItemData.Use( ply.InventoryGrid[iid][x][y].ItemData );
			ply.InventoryGrid[iid][x][y].ItemData.Amount = ply.InventoryGrid[iid][x][y].ItemData.Amount - 1;

			DestroyProcessBar( "useitem", ply );
	
			if( ply.InventoryGrid[iid][x][y].ItemData.Amount < 1 ) then
		
				if( ( not arg[5] or tonumber( arg[5] ) ~= 1 ) and ply.InventoryGrid[iid][x][y].ItemData.CanDrop( ply.InventoryGrid[iid][x][y].ItemData ) ) then
					ply:TakeItemAt( iid, x, y );
				end
				
			else
			
				umsg.Start( "UIA", ply );
					umsg.Short( iid );
					umsg.Short( x );
					umsg.Short( y );
					umsg.Short( ply.InventoryGrid[iid][x][y].ItemData.Amount );
				umsg.End();
			
			end
				
			return;			
		
		end
	
	end
	
	CreateProcessBar( "useitem", "Using item", ply );
		SetEstimatedTime( ply.InventoryGrid[iid][x][y].ItemData.UseDelay * .4, ply );
		SetThinkDelay( .05, ply );
		SetThink( useitemthink, ply );
	EndProcessBar( ply );		

end
concommand.Add( "eng_invuseitemportion", ccInventoryUseItemPortion );

function ccInventoryUseItem( ply, cmd, arg )

	if( not arg[1] or not tonumber( arg[2] ) or not tonumber( arg[3] ) or not tonumber( arg[4] ) ) then
		return;
	end

	if( ply:IsTied() ) then return; end 

	local id = arg[1];
	local iid = tonumber( arg[2] );
	local x = tonumber( arg[3] );
	local y = tonumber( arg[4] );
	
	if( not ply.InventoryGrid[iid][x][y].Filled ) then return; end
	
	local useitemthink = function( ply, done )
		
		if( done ) then
			
			ply.InventoryGrid[iid][x][y].ItemData.Owner = ply;
			ply.InventoryGrid[iid][x][y].ItemData.Use( ply.InventoryGrid[iid][x][y].ItemData );

			DestroyProcessBar( "useitem", ply );
	
			if( ( not arg[5] or tonumber( arg[5] ) ~= 1 ) and ply.InventoryGrid[iid][x][y].ItemData.CanDrop( ply.InventoryGrid[iid][x][y].ItemData ) ) then
				ply:TakeItemAt( iid, x, y );
			end
			
			ply:SaveItems();
			return;			
		
		end
	
	end
	
	CreateProcessBar( "useitem", "Using item", ply );
		SetEstimatedTime( ply.InventoryGrid[iid][x][y].ItemData.UseDelay, ply );
		SetThinkDelay( .3, ply );
		SetThink( useitemthink, ply );
	EndProcessBar( ply );		

end
concommand.Add( "eng_invuseitem", ccInventoryUseItem );

--Removed old one, used TacoScript 1's method for donation models
function ccInventoryPutOnStorage( ply, cmd, arg )

	if( not arg[1] ) then return; end
	
	if( ply:IsTied() ) then return; end
	
	local name = arg[1];
	
	if( not ply:HasInventory( name ) ) then return; end
	
	if( name == "Backpack" ) then
		return;
	end
	
	local iid = ply:GetInventoryIndex( name );
	
	if( ply.Inventories[iid].Permanent ) then
		return;
	end
	
	local putonstoragethink = function( ply, done )
	
		if( done ) then
		
			if( ply:HasInventory( name ) ) then
				
				if( name == "Rebel vest" ) then
				
					ply.HelmetHealth = 10;
					ply.BodyArmorHealth = 40;
				
					local model = string.lower( ply:GetModel() );
					model = string.gsub( model, "group03m", "group03" );
					model = string.gsub( model, "group02", "group03" );
					model = string.gsub( model, "group01", "group03" );
					
					ply:SetModel( model );
					
				elseif( name == "Rebel medic vest" ) then
				
					ply.HelmetHealth = 10;
					ply.BodyArmorHealth = 30;
				
					local model = string.lower( ply:GetModel() );
					model = string.gsub( model, "group03", "group03m" );
					model = string.gsub( model, "group02", "group03m" );
					model = string.gsub( model, "group01", "group03m" );
					
					ply:SetModel( model );
					
				end
				
			end
			
			DestroyProcessBar( "putonstorage", ply );
			return;		
		
		end
	
	end
	
	CreateProcessBar( "putonstorage", "Putting on", ply );
		SetEstimatedTime( 2, ply );
		SetThinkDelay( .25, ply );
		SetThink( putonstoragethink, ply );
	EndProcessBar( ply );	

end
concommand.Add( "eng_putonstorage", ccInventoryPutOnStorage );

function ccInventoryTakeOffStorage( ply, cmd, arg )

	if( not arg[1] ) then
		return;
	end
	
	if( ply:IsTied() ) then return; end
	
	local name = arg[1];
	
	if( name == "Backpack" ) then
		return;
	end
	
	if( not ply:HasInventory( name ) ) then return; end
	
	local iid = ply:GetInventoryIndex( name );
	
	if( ply.Inventories[iid].Permanent ) then
		return;
	end
	
	local takeoffstoragethink = function( ply, done )
	
		if( done ) then
		
			if( ply:HasInventory( name ) ) then
	
				ply:SetModel( ply.CitizenModel );
				ply.HelmetHealth = 0;
				ply.BodyArmorHealth = 0;
				
			end
			
			DestroyProcessBar( "takeoffstorage", ply );
			return;		
		
		end
	
	end
	
	CreateProcessBar( "takeoffstorage", "Undressing", ply );
		SetEstimatedTime( 2, ply );
		SetThinkDelay( .25, ply );
		SetThink( takeoffstoragethink, ply );
	EndProcessBar( ply );	

end
concommand.Add( "eng_takeoffstorage", ccInventoryTakeOffStorage );

function ccInventoryDropStorage( ply, cmd, arg )

	if( not arg[1] ) then
		return;
	end
	
	if( ply:IsTied() ) then return; end 

	local name = arg[1];
	
	if( not ply:HasInventory( name ) ) then return; end
	
	local iid = ply:GetInventoryIndex( name );
	
	if( ply.Inventories[iid].Permanent ) then
		return;
	end
	
	local dropstoragethink = function( ply, done )
		
		if( done ) then
		
			if( ply.Inventories[iid].IsClothes and ply.Inventories[iid].CanDrop ) then
			
				DestroyProcessBar( "dropstorage", ply );
				ply:DropClothes();
				ply:SetModel( ply.CitizenModel );
				ply:WearItem( "clothes_citizen" );
				ply.HelmetHealth = 0;
				ply.BodyArmorHealth = 0;
				
				return;
			
			end
		
			if( ply:HasInventory( name ) ) then
			
				local itemprop = ply:DropItemProp( ply.Inventories[iid].ID );
				itemprop = TS.ItemToContainer( itemprop.ItemData );
				
				local itemdata = TS.ItemsData[ply.Inventories[iid].ID];
				local inv = 0;
				
				local activeweapx = -1;
				local activeweapy = -1;
				
				for k = 0, itemdata.Height - 1 do
			
					for j = 0, itemdata.Width - 1 do
					
						local port = true;
					
						if( ply.InventoryGrid[iid][j][k].x == activeweapx and
							ply.InventoryGrid[iid][j][k].y == activeweapy ) then
							
							port = false;
							
						end
					
						if( ply.InventoryGrid[iid][j][k].ItemData and ply:GetActiveWeapon():IsValid() ) then
						
							if( ply.InventoryGrid[iid][j][k].ItemData.ID == ply:GetActiveWeapon():GetClass() ) then
							
								if( ply:HasWeaponOnlyFrom( ply.InventoryGrid[iid][j][k].ItemData.ID, iid ) ) then
								
									port = false;
									
									activeweapx = ply.InventoryGrid[iid][j][k].x;
									activeweapy = ply.InventoryGrid[iid][j][k].y;
									
									if( not ply:GiveAnyInventoryItemBut( ply.InventoryGrid[iid][j][k].ItemData.ID, iid ) ) then
									
										ply.HasTempWeapon = true;
										ply.TempWeaponClass = ply:GetActiveWeapon():GetClass();
										
										
									end
									
									ply.InventoryGrid[iid][j][k].ItemData = nil;
								
								end
							
							end
						
						end
					
						if( port ) then
					
							itemprop.InventoryGrid[j][k].Filled = ply.InventoryGrid[iid][j][k].Filled;
							itemprop.InventoryGrid[j][k].SX = ply.InventoryGrid[iid][j][k].x;
							itemprop.InventoryGrid[j][k].SY = ply.InventoryGrid[iid][j][k].y;
							itemprop.InventoryGrid[j][k].ItemData  = ply.InventoryGrid[iid][j][k].ItemData;

						else
						
							itemprop.InventoryGrid[j][k].Filled = false;
							itemprop.InventoryGrid[j][k].SX = -1;
							itemprop.InventoryGrid[j][k].SY = -1;
							itemprop.InventoryGrid[j][k].ItemData = nil;
							
						end

					end
				
				end
				
				ply:RemoveInventory( itemdata.Name );
				
			end
			
			DestroyProcessBar( "dropstorage", ply );
			
			return;			
		
		end
	
	end
	
	CreateProcessBar( "dropstorage", "Dropping storage item", ply );
		SetEstimatedTime( .7, ply );
		SetThinkDelay( .25, ply );
		SetThink( dropstoragethink, ply );
	EndProcessBar( ply );		

end
concommand.Add( "eng_invdropstorage", ccInventoryDropStorage );

function ccInventoryWriteItem( ply, cmd, arg )

	if( not tonumber( arg[1] ) or not tonumber( arg[2] ) or not tonumber( arg[3] ) ) then
		return;
	end
	
	if( ply:IsTied() ) then return; end 

	local id = "paper";
	local iid = tonumber( arg[1] );
	local x = tonumber( arg[2] );
	local y = tonumber( arg[3] );
	
	if( not ply.InventoryGrid[iid][x][y].Filled ) then return; end
	if( ply.InventoryGrid[iid][x][y].ItemData.ID ~= "paper" ) then return; end

	ply.SelectedPaper = { Inv = iid, x = x, y = y };

	umsg.Start( "LWP", ply );
		umsg.String( "" );
	umsg.End();

end
concommand.Add( "eng_invwriteitem", ccInventoryWriteItem );

function ccActionMenuPickupContainer( ply, cmd, arg )

	if( not arg[1] or not tonumber( arg[1] ) ) then
		return;
	end
	
	if( ply:IsTied() ) then return; end 

	local id = tonumber( arg[1] );
	
	local ent = ply.ActionMenuTarget;
	
	if( not ent or not ent:IsValid() ) then return; end
	
	ply.DistanceFromItem = ( ent:GetPos() - ply:GetPos() ):Length();

	if( ply.DistanceFromItem > 90 ) then
	
		return;
	
	end

	if( not string.find( ent.ItemData.Flags, "c" ) ) then return; end

	if( ply:HasContainer( ent.ItemData.Name ) ) then
	
		ply:PrintMessage( 3, "You already have one" );
		return;
	
	end

	local pickupitemthink = function( ply, done )
		
		if( not ent or not ent:IsValid() ) then
		
			DestroyProcessBar( "pickupitem", ply );
			return;
		
		end
		
		if( done ) then
		
			if( not ply:HasContainer( ent.ItemData.Name ) ) then
			
				if( ent.ItemData.ID == "backpack" ) then
					ply.BackEntity = ply:AttachProp( ent:GetModel(), "chest" );
				end
				
				ply:GiveContainerEntity( ent, false, true );
			
			end
		
			DestroyProcessBar( "pickupitem", ply );
			ent:Remove();
			return;			
		
		end
		
		local crntdist = ( ent:GetPos() - ply:GetPos() ):Length();
		
		if( crntdist > 90 ) then
		
			DestroyProcessBar( "pickupitem", ply );
			return;
		
		end
	
	end

	CreateProcessBar( "pickupitem", "Picking up item", ply );
		SetEstimatedTime( ent.ItemData.PickupDelay, ply );
		SetThinkDelay( .1, ply );
		SetThink( pickupitemthink, ply );
	EndProcessBar( ply );

end
concommand.Add( "eng_ampickupcontainer", ccActionMenuPickupContainer );

function ccActionMenuLookInsideContainer( ply, cmd, arg )

	if( not arg[1] or not tonumber( arg[1] ) ) then
		return;
	end

	if( ply:IsTied() ) then return; end 

	local id = tonumber( arg[1] );
	
	local ent = ply.ActionMenuTarget;
	
	if( not ent or not ent:IsValid() ) then return; end
	
	ply.DistanceFromItem = ( ent:GetPos() - ply:GetPos() ):Length();

	if( ply.DistanceFromItem > 90 ) then
	
		return;
	
	end

	if( not string.find( ent.ItemData.Flags, "c" ) and not string.find( ent.ItemData.Flags, "W" ) ) then return; end

	ply:OpenStorageMenu( ent );

end
concommand.Add( "eng_amlookinsidecontainer", ccActionMenuLookInsideContainer );

function ccInventoryLookInsideContainer( ply, cmd, arg )

	if( not arg[1] or not tonumber( arg[2] ) or not tonumber( arg[3] ) or not tonumber( arg[4] ) ) then
		return;
	end

	if( ply:IsTied() ) then return; end 

	local id = arg[1];
	local iid = tonumber( arg[2] );
	local x = tonumber( arg[3] );
	local y = tonumber( arg[4] );
	
	if( not ply.InventoryGrid[iid][x][y].Filled ) then return; end
	if( ply.InventoryGrid[iid][x][y].ItemData.ID ~= id ) then return; end
	
	if( not string.find( ply.InventoryGrid[iid][x][y].ItemData.Flags, "C" ) and not string.find( ply.InventoryGrid[iid][x][y].ItemData.Flags, "c" ) and not string.find( ply.InventoryGrid[iid][x][y].ItemData.Flags, "W" ) ) then return; end

	ply:OpenStorageMenu( ply.InventoryGrid[iid][x][y].ItemData );

end
concommand.Add( "eng_invlookinsidecontainer", ccInventoryLookInsideContainer );

function ccActionMenuReadItem( ply, cmd, arg )

	if( not arg[1] or not tonumber( arg[1] ) ) then
		return;
	end
	
	if( ply:IsTied() ) then return; end 

	local id = tonumber( arg[1] );
	
	local ent = ply.ActionMenuTarget;
	
	if( not ent or not ent:IsValid() ) then return; end
	
	ply.DistanceFromItem = ( ent:GetPos() - ply:GetPos() ):Length();

	if( ply.DistanceFromItem > 90 ) then
	
		return;
	
	end

	if( not string.find( ent.ItemData.Flags, "l" ) ) then return; end

	ent.ItemData.Owner = ply;
	ent.ItemData.Use( ent.ItemData );	
	
end
concommand.Add( "eng_amreaditem", ccActionMenuReadItem );

function ccActionMenuUseItem( ply, cmd, arg )

	if( not arg[1] or not tonumber( arg[1] ) ) then
		return;
	end
	
	if( ply:IsTied() ) then return; end 

	local id = tonumber( arg[1] );
	
	local ent = ply.ActionMenuTarget;
	
	if( not ent or not ent:IsValid() ) then return; end
	
	ply.DistanceFromItem = ( ent:GetPos() - ply:GetPos() ):Length();

	if( ply.DistanceFromItem > 90 ) then
	
		return;
	
	end

	local useitemthink = function( ply, done )

		local ent = ply.ActionMenuTarget;
		
		if( not ent or not ent:IsValid() ) then
		
			DestroyProcessBar( "useitem", ply );
			return;
		
		end
		
		if( done ) then
			
			ent.ItemData.Owner = ply;
			ent.ItemData.Use( ent.ItemData );

			DestroyProcessBar( "useitem", ply );
			ent:Remove();
			return;			
		
		end
		
		local crntdist = ( ent:GetPos() - ply:GetPos() ):Length();
		
		if( ply.DistanceFromItem < crntdist ) then
		
			DestroyProcessBar( "useitem", ply );
			return;
		
		end
	
	end
	
	CreateProcessBar( "useitem", "Using item", ply );
		SetEstimatedTime( ent.ItemData.UseDelay, ply );
		SetThinkDelay( .3, ply );
		SetThink( useitemthink, ply );
	EndProcessBar( ply );		

end
concommand.Add( "eng_amuseitem", ccActionMenuUseItem );


function ccActionMenuExamineItem( ply, cmd, arg )

	local ent = ply.ActionMenuTarget;
	
	if( not ent or not ent:IsValid() ) then return; end
	
	ply.DistanceFromItem = ( ent:GetPos() - ply:GetPos() ):Length();

	if( ply.DistanceFromItem > 90 ) then
	
		return;
	
	end

	ply:PrintMessage( 3, ent.ItemData.Name );
	ply:PrintMessage( 3, ent.ItemData.Description );

end
concommand.Add( "eng_examineitem", ccActionMenuExamineItem );

function ccActionMenuWearItem( ply, cmd, arg )

	if( not arg[1] or not tonumber( arg[1] ) ) then
		return;
	end
	
	if( ply:IsTied() ) then return; end 

	if( not ply:IsCitizen() ) then
		return;
	end

	local id = tonumber( arg[1] );
	
	local ent = ply.ActionMenuTarget;
	
	if( not ent or not ent:IsValid() ) then return; end
	
	ply.DistanceFromItem = ( ent:GetPos() - ply:GetPos() ):Length();

	if( ply.DistanceFromItem > 90 ) then
	
		return;
	
	end

	local wearitemthink = function( ply, done )

		local ent = ply.ActionMenuTarget;
		
		if( not ent or not ent:IsValid() ) then
		
			DestroyProcessBar( "wearitem", ply );
			return;
		
		end
		
		if( done ) then
			
			DestroyProcessBar( "wearitem", ply );
			
			ent.ItemData.Owner = ply;
			ent.ItemData.Use( ent.ItemData );
			
			ply:DropClothes();
			ply:WearItem( ent.ItemData );
			
			if( ent.ItemData.ID == "backpack" ) then
				ply.BackEntity = ply:AttachProp( ent:GetModel(), "chest" );
			end

			ent:Remove();
			return;			
		
		end
		
		if( not ply:IsCitizen() ) then
			DestroyProcessBar( "wearitem", ply );
			return;
		end
		
		local crntdist = ( ent:GetPos() - ply:GetPos() ):Length();
		
		if( ply.DistanceFromItem < crntdist ) then
		
			DestroyProcessBar( "wearitem", ply );
			return;
		
		end
	
	end
	
	CreateProcessBar( "wearitem", "Wearing item", ply );
		SetEstimatedTime( ent.ItemData.UseDelay, ply );
		SetThinkDelay( .3, ply );
		SetThink( wearitemthink, ply );
	EndProcessBar( ply );		

end
concommand.Add( "eng_amwearitem", ccActionMenuWearItem );

function ccPickupItem( ply, cmd, arg )

	if( not arg[1] or not tonumber( arg[1] ) ) then
		return;
	end
	
	if( ply:IsTied() ) then return; end 

	local id = tonumber( arg[1] );
	
	local ent = ply.ActionMenuTarget;
	
	if( not ent or not ent:IsValid() ) then return; end
	
	ply.DistanceFromItem = ( ent:GetPos() - ply:GetPos() ):Length();

	if( ply.DistanceFromItem > 90 ) then
	
		return;
	
	end
	
	local pickupitemthink = function( ply, done )

		local ent = ply.ActionMenuTarget;
		
		if( not ent or not ent:IsValid() ) then
		
			DestroyProcessBar( "pickupitem", ply );
			return;
		
		end
		
		if( done ) then
	
			ply:GiveInventoryItem( id, ent.ItemData );
			DestroyProcessBar( "pickupitem", ply );
			ent:Remove();
			
			ply:SaveItems();
			return;			
		
		end
		
		local crntdist = ( ent:GetPos() - ply:GetPos() ):Length();
		
		if( ply.DistanceFromItem < crntdist ) then
		
			DestroyProcessBar( "pickupitem", ply );
			return;
		
		end
	
	end
	
	local pickupdelay = ent.ItemData.PickupDelay;
	
	if( string.find( ent.ItemData.Flags, "w" ) ) then
	
		pickupdelay = .5;
	
	end
	
	CreateProcessBar( "pickupitem", "Picking up item", ply );
		SetEstimatedTime( pickupdelay, ply );
		SetThinkDelay( .1, ply );
		SetThink( pickupitemthink, ply );
	EndProcessBar( ply );

end
concommand.Add( "eng_pickupitem", ccPickupItem );

function ccHideViewModel( ply, cmd, arg )

	ply:DrawViewModel( false );

end
concommand.Add( "eng_hideviewmodel", ccHideViewModel );

function ccStartLetter( ply, cmd, arg )

	ply.LetterContent = "";

end
concommand.Add( "eng_sl", ccStartLetter );

function ccSendLetterPiece( ply, cmd, arg )

	if( not arg[1] ) then return; end
	
	if( string.len( ply.LetterContent ) >= 1024 ) then return; end

	ply.LetterContent = ply.LetterContent .. arg[1];

end
concommand.Add( "eng_slp", ccSendLetterPiece );

function ccEndLetter( ply, cmd, arg )
	
	if( ply:IsTied() ) then return; end 
	
	local inv = ply.SelectedPaper.Inv;
	local x = ply.SelectedPaper.x;
	local y = ply.SelectedPaper.y;
	
	if( not inv or not x or not y ) then return; end
	
	if( not ply.InventoryGrid[inv] or not ply.InventoryGrid[inv][x] or not ply.InventoryGrid[inv][x][y] or ply.InventoryGrid[inv][x][y].ItemData.ID ~= "paper" ) then
		return;
	end	

	ITEM = nil;
	ITEM = { }
	
	ITEM.ID = "letter" .. TS.LetterCount;
	ITEM.Flags = "l";
	ITEM.UseDelay = .1;
	ITEM.PickupDelay = .1;
	
	ITEM.Name = "Note";
	ITEM.Description = string.sub( string.gsub( ply.LetterContent, "@n", "" ), 1, 30 ) .. "...";
	ITEM.Model = TS.ItemsData["paper"].Model;
	ITEM.CamPos = TS.ItemsData["paper"].CamPos;
	ITEM.LookAt = TS.ItemsData["paper"].LookAt;
	ITEM.FOV = TS.ItemsData["paper"].FOV;
	ITEM.Width = 1;
	ITEM.Height = 1;
	ITEM.LetterContent = ply.LetterContent;
	
	ITEM.Pickup = function( self ) end
	
	ITEM.Drop = function( self ) end
	
	ITEM.Use = function( self ) 

		umsg.Start( "SL", self.Owner ); umsg.End();
		umsg.Start( "DL", self.Owner ); umsg.End();
		
		local parts = math.ceil( string.len( self.LetterContent ) / 200 );
		
		for n = 1, parts do
		
			local f = function()
			
				if( not self.Owner or not self.Owner:IsValid() ) then return; end
			
				umsg.Start( "SLP", self.Owner );
					umsg.String( string.sub( self.LetterContent, ( n - 1 ) * 200 + 1, n * 200 ) );
				umsg.End();
				
			end
			timer.Simple( n * .2, f );
			
		end
		
		
	end

	TS.ItemsData[ITEM.ID] = ITEM;
	
	ply:DropItemProp( "letter" .. TS.LetterCount );
	ply:TakeItemAt( inv, x, y );
	
	TS.LetterCount = TS.LetterCount + 1;

end
concommand.Add( "eng_el", ccEndLetter );

function ccUpdateTargetID( ply, cmd, arg )
	if( CurTime() - ply.LastTargetIDUpdate < 2 ) then
	
		return;
	
	end
	
	ply.LastTargetIDUpdate = CurTime();
	
	if( not tonumber( arg[1] ) ) then
	
		return;
	
	end
	
	local ent = ents.GetByIndex( ( tonumber( arg[1] ) ) );
	
	if( ent:IsDoor() ) then
	
		if( not arg[2] or not arg[3] or not arg[4] or not arg[5] or not arg[6]) then
			
			return;
			
		end
		
	elseif( ent:IsPlayer() ) then
	
		if( not arg[2] or not arg[3] ) then
		
			return;
		
		end
	
	elseif( ent:IsProp() ) then
	
		if( not arg[2] ) then
		
			return;
		
		end
		
	else
	
		return;
	
	end
	
	if( ent and ent:IsValid() ) then
	
		if( ent:IsPlayer() ) then
		
			local title = ent:GetPlayerTitle();
			local title2 = ent:GetPlayerTitle2();
			
			if( not title ) then
			
				title = "";
			
			end
			
			if( not title2 ) then
			
				title2 = "";
			
			end
			
			if( ent:IsTied() ) then
			
				title2 = title2 .. "\n(Tied)";
			
			end
			
			if( arg[2] ~= title ) then
			
				ent:SendTitle(ply)
				
			end
			
			if( arg[3] ~= title2 ) then
			
				ent:SendTitle2(ply)
			
			end
		
		elseif( ent:IsProp() ) then
			
			if( ent.Desc ) then

				if( ent.Desc ~= arg[2] ) then
			
					umsg.Start( "UPD", ply );
						umsg.Entity( ent );
						umsg.String( ent.Desc );
					umsg.End();
					
				end
			
			end
		
		elseif( ent:IsDoor() ) then
		
			if ent.MainOwner == nil then
				ent.Owned = false;
			else
				ent.Owned = true;
			end
	
			local propertyname = ent.PropertyName;
			local doorname = ent.DoorName;
			-- nil != true != false: We use that.
			local owned
			if ent.Owned == true then
				owned = "1"
			else
				owned = "0"
			end
			
			local combine = string.find( ent.DoorFlags or "", "o" )
			local nexus = string.find( ent.DoorFlags or "", "n")
			local price = tostring(ent.DoorPrice or 0);
			local desc = ent.DoorDesc or "";
			
			if( propertyname ~= arg[2] or doorname ~= arg[3] or owned ~= arg[4] or price ~= arg[5] or desc ~= arg[6]) then
			
				umsg.Start( "UDD", ply );
					umsg.Entity( ent );
					umsg.String( propertyname or "" );
					umsg.String( doorname or "" );
					umsg.Bool( ent.Owned == true );
					umsg.Bool( combine or false );
					umsg.Bool( nexus or false );
					umsg.Long( price or 0 );
					umsg.String( desc or "" );
				umsg.End();
			
			end
	
		end
	
	end
	
end
concommand.Add( "eng_uti", ccUpdateTargetID );

function ccLookInsideMapStorage( ply, cmd, arg )

	if( not arg[1] or not tonumber( arg[1] ) ) then
		return;
	end
	
	if( ply:IsTied() ) then return; end 

	local id = tonumber( arg[1] );
	
	local ent = ply.ActionMenuTarget;
	
	if( not ent or not ent:IsValid() ) then return; end
	
	ply.DistanceFromItem = ( ent:GetPos() - ply:GetPos() ):Length();

	if( ply.DistanceFromItem > 90 ) then
	
		return;
	
	end

end
concommand.Add( "eng_lookinsidemapstorage", ccLookInsideMapStorage );

function CreateNewAccount( ply, cmd, args )

	if( CurTime() - ply.LastRegister < 3 ) then
		return;
	end

	local query = "SELECT * FROM `tb_users` WHERE `STEAMID` = '" .. ply:SteamID() .. "'";
	TS.AsyncQuery(query, function(q)
		local tab = q:getData()
		if( not tab or #tab == 0 ) then
		
			local query = "INSERT INTO `tb_users` ( `UserName`, `STEAMID`, `groupID` ) VALUES ( '" ..TS.Escape(args[1]) .. "', '"..TS.Escape(ply:SteamID()) .. "', '1' )"
			TS.AsyncQuery(query, function(q)
				local query = "SELECT `uID` FROM `tb_users` WHERE `STEAMID` = '" ..TS.Escape(ply:SteamID()) .. "'";
				TS.AsyncQuery(query, function(q)
					local tab = TS.AsyncQuery(query, function(q)
						local tab = q:getData()
						ply:SetSQLData( "uid", tab[1].uID);
					
						ply:RemoveAccountMenu();
					
						ply:PromptCharacterMenu()
					end)
				end)
			end)
		else
		
			ply:RemoveAccountMenu();
			ply:HandleUID();

		end
		
		ply.LastRegister = CurTime();
	end)
end
concommand.Add( "eng_createaccount", CreateNewAccount );

function ccCharMenu( ply, cmd, arg )

	if( CurTime() - ply.LastCharMenu < 1 ) then
		return;
	end

	if( ply.CharacterMenu ) then return; end
	
	ply:CallEvent( "PlayerMenuOff" );
	ply:CallEvent( "HorseyMapViewOn" );
	ply:Lock();
	ply:MakeInvisible( true );
	
	if( ply.Initialized ) then
	
		ply:CharSave();
		
	end
	
	ply:RefreshChar();
	
	ply:PromptCharacterMenu();
	
	ply.LastCharMenu = CurTime();

end
concommand.Add( "eng_charmenu", ccCharMenu );

function ccCheckForRadio( ply, cmd, arg )

	if( not ply:HasItem( "radio" ) ) then
	
		ply:PrintMessage( 3, "You need a radio!" );
		return;
		
	end
	
	umsg.Start( "PRM", ply );
	umsg.End();

end
concommand.Add( "eng_checkforradio", ccCheckForRadio );

function ccScopeNoDraw( ply, cmd, arg )

	if( not ply:GetActiveWeapon():IsValid() ) then return; end
	
	ply:DrawViewModel( false );

end
concommand.Add( "eng_scopenodraw", ccScopeNoDraw );

function ccSeeScope( ply, cmd, arg )

	if( not tonumber( arg[1] ) ) then return; end
	
	local val = tonumber( arg[1] );
	
	local curweap = ply:GetActiveWeapon();
	
	local Weapons = {
	
		"ts2_emp",
		"ts2_30watt",
		"ts2_40watt",
		"ts2_50watt",
		"ts2_90watt",
		"ts2_donator_proto",
		"ts2_donator_f2000",
		"ts2_donator_xm8",
		"ts2_donator_la86",
		"ts2_donator_svd",
		"ts2_donator_stubgun",
		"ts2_donator_m82",
		"ts2_donator_r700",
		"ts2_donator_f2000",
		"ts2_donator_m14",
		"ts2_donator_m24",			
		"ts2_donator_hk416",		
		"ts2_donator_40wattsniper",
		"ts2_donator_as50",
		"ts2_donator_sbr",	
		"ts2_donator_an94mod",			
		"ts2_g3",
		"ts2_sigsniper",
		"ts2_styerscout",	
		"ts2_styeraug",	
		"ts2_donator_bizon",
		"ts2_styersniper",
		"ts2_donator_35wattrecon",

	}

	if( val == 1 ) then
	
		if( curweap and curweap:IsValid() ) then
		
			if( table.HasValue( Weapons, curweap:GetClass() ) ) then
			
				ply:DrawViewModel( false );
				ply:SetFOV( 20, 0 );
			
			end
			
			if( curweap:GetClass() == "ts2_rpg7" ) then
			
				ply:SetFOV( 60, 0 );
				
			end
		
		end
		
	else
	
		ply:DrawViewModel( true );	
		ply:SetFOV( 0, 0.3 );
	
	end

end
concommand.Add( "eng_seescope", ccSeeScope );

function ccCheckQuiz( ply, cmd, arg )

	if( CurTime() - ply.LastQuizCheck < 2 ) then
		return;
	end

	if( not arg[1] and
		not arg[2] and
		not arg[3] and
		not arg[4] and
		not arg[5] ) then
		
		return;
		
	end

	if( arg[1] == "Half-Life 2" and
		arg[2] == "Out-Of-Character" and
		arg[3] == "In-Character" and
		arg[4] == "No" and
		arg[5] == "No" ) then
	
		umsg.Start( "RQ", ply );
		umsg.End();
		
		timer.Simple( .5, ply.PromptAccountCreationMenu, ply );

	else
	
		game.ConsoleCommand( "banid 5 " .. ply:SteamID() .. "\n" );
		game.ConsoleCommand( "writeid\n" );
		
		game.ConsoleCommand( "kickid \"" .. ply:UserID() .. "\" \"Failed quiz - banned for five minutes.\"\n" );
	
	end
	
	ply.LastQuizCheck = CurTime();
	
end
concommand.Add( "eng_checkquiz", ccCheckQuiz );

function CCToggleHolster( ply, cmd, arg )

	if( CurTime() - ply.LastHolster < 1 ) then
		return;
	end

	local weap = ply:GetActiveWeapon();
	
	if( weap:IsValid() ) then
	
		local class = weap:GetClass();

		if( class == "weapon_physcannon" or
			class == "weapon_physgun" or
			class == "gmod_tool" or
			class == "ts2_zipties" or
			class == "ts2_ziptiecutters" ) then

			return; 
			
		end
		
		if( weap.HolsterToggle ) then
			weap.HolsterToggle( weap );
		end
		
	end

	ply:SetPlayerHolstered( !ply:GetPlayerHolstered() );

	if( ply:GetPlayerHolstered() == true ) then
	
		ply:SetAimAnim( false );
	
	else
	
		ply:SetAimAnim( true );
	
	end
	
	LastHolster = CurTime();

end
concommand.Add( "eng_toggleholster", CCToggleHolster );

function ccUpdateScoreboard( ply, cmd, arg )
	
	if( not tonumber( arg[1] ) or 
		not tonumber( arg[2] ) ) then
		
		return;
		
	end
	
	local code = tonumber( arg[1] );
	local ent = ents.GetByIndex( ( tonumber( arg[2] ) ) );
	
	if( ent and ent:IsValid() ) then

		if( code == 1 ) then
			ent:SendTitle(ply)
		end
		
		if( code == 2 ) then
			ent:SendTitle2(ply)
		end
		
	end

end
concommand.Add( "eng_us", ccUpdateScoreboard );

function ccUpdateCreatorSteamID( ply, cmd, arg )

	if( not tonumber( arg[1] ) ) then
	
		return;
		
	end
	
	local ent = ents.GetByIndex( ( tonumber( arg[1] ) ) );
	
	if( ent and ent:IsValid() ) then
	
		if( ent.CS ) then
			
			umsg.Start( "UPCS", ply );
				umsg.Entity( ent );
				umsg.String( ent.CS );
			umsg.End();
			
		end
	
	end

end
concommand.Add( "eng_ucs", ccUpdateCreatorSteamID );

function ccDragDropItem( ply, cmd, arg )

	if( CurTime() - ply.LastDrag < .6 ) then
		return;
	end
	
	local id = arg[1];
	local iid = tonumber( arg[2] );
	local x = tonumber( arg[3] );
	local y = tonumber( arg[4] );
	local dx = tonumber( arg[5] );
	local dy = tonumber( arg[6] );
	
	if( not id or
		not iid or
		not x or
		not y or
		not dx or
		not dy ) then
		
		return;
		
	end
	
	local amt = ply.InventoryGrid[iid][x][y].ItemData.Amount;
	
	if( ply:CanDragAt( iid, id, x, y, dx, dy ) ) then

		ply:TakeItemAt( iid, x, y );
		ply:GiveDraggedItem( iid, id, dx, dy, amt );
		
	end
	
	ply.LastDrag = CurTime();
	
end
concommand.Add( "eng_dragdropitem", ccDragDropItem );

function ccBuyStorage( ply, cmd, arg )

	if( not arg[1] or not tonumber( arg[1] ) ) then
		return;
	end
	
	if( ply:IsTied() ) then return; end 

	local id = tonumber( arg[1] );
	
	local ent = ply.ActionMenuTarget;
	
	if( not ent or not ent:IsValid() ) then return; end
	
	ply.DistanceFromItem = ( ent:GetPos() - ply:GetPos() ):Length();

	if( ply.DistanceFromItem > 90 ) then
	
		return;
	
	end
	
	if( ent:IsDoor() and ply:CanOwnDoor( ent ) ) then
	
		--ply:PurchaseProperty( ent, id );
		ply:OwnDoor( ent );
		ply:TakeMoney( id );
		
		
	end

end
concommand.Add( "eng_buystorage", ccBuyStorage );

function ccRentProperty( ply, cmd, arg )

	if( not arg[1] or not tonumber( arg[1] ) ) then
	
		ply:PrintMessage( 2, "No arg[1]" );
		return;
	end
	
	--ply:PrintMessage( 2, "Ehh.. RentProperty" );
	
	if( ply:IsTied() ) then 
		--ply:PrintMessage( 2, "ur tied" );
		return; 
	end 

	local id = tonumber( arg[1] );
	
	local ent = ply.ActionMenuTarget;
	
	if( not ent or not ent:IsValid() ) then 
		--ply:PrintMessage( 2, "ent not valid" );
		return; 
	end
	--ply:PrintMessage( 2, "ent is valid" );
	ply.DistanceFromItem = ( ent:GetPos() - ply:GetPos() ):Length();

	if( ply.DistanceFromItem > 90 ) then
	
		--ply:PrintMessage( 2, "not enough distance" );
		return;
	
	end
	
	if( ent:IsDoor() and ply:CanOwnDoor( ent ) ) then
		
		if( id == -1 and ply.OwnsFreeProperty ) then
			ply:PrintMessage( 3, "You can only own one free property at a time!" );
		else
		--ply:PurchaseProperty( ent, id );
		ply:OwnProperty( ent, id );
		end
		
	else
		--ply:PrintMessage( 2, "error 5" );
	end

end
concommand.Add( "eng_rentproperty", ccRentProperty );

function ccSellProperty( ply, cmd, arg )

	if( not arg[1] or not tonumber( arg[1] ) ) then
		return;
	end
	
	if( ply:IsTied() ) then return; end 

	local id = tonumber( arg[1] );
	
	local ent = ply.ActionMenuTarget;
	
	if( not ent or not ent:IsValid() ) then return; end
	
	ply.DistanceFromItem = ( ent:GetPos() - ply:GetPos() ):Length();

	if( ply.DistanceFromItem > 90 ) then
	
		return;
	
	end
	
	if( ent:IsDoor() ) then
		if( ent.MainOwner == ply ) then
		ent:UnownProperty( ply );
		if( id == 0 ) then
			idmsg = "nothing, this property was free!"
		else
			idmsg = id .. " credits!"
		end
		ply:GiveMoney( id );
		ply:PrintMessage( 3, "You have been refunded " .. idmsg );
		else
		ply:PrintMessage( 3, "You are not the main owner, you cannot cancel the rent!" );
		end
	end

end
concommand.Add( "eng_sellproperty", ccSellProperty );

function CCSetDoorName( ply, cmd, args )

	if( not args[1] ) then return; end
	
	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 200;
	trace.filter = ply;
	local tr = util.TraceLine( trace );
	
	if( ValidEntity( tr.Entity ) and tr.Entity:IsDoor() ) then
	
		if( tr.Entity:OwnsDoor( ply ) ) then
			
			local doorname = tr.Entity.DoorName;
			
			if( doorname ~= args[1] ) then
			
				tr.Entity.DoorName = args[1]
				
				ply:PrintMessage( 3, "Door name set to " .. args[1] );
				
			end
			
			umsg.Start( "RNM", ply );
			umsg.End();
		
		else
		
			ply:PrintMessage( 3, "You don't own this door" );
		
		end
	
	end

	return "";
	
end
concommand.Add( "eng_setdoorname", CCSetDoorName );

function CCPromptPropName( ply )

	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 200;
	trace.filter = ply;
	local tr = util.TraceLine( trace );
	
	if( ValidEntity( tr.Entity ) and tr.Entity:IsDoor() ) then
	if( tr.Entity.MainOwner == ply ) then
		umsg.Start( "PNM", ply );
			umsg.String( tr.Entity.PropertyName or "" );
			umsg.String( tr.Entity.DoorName or "" );
		umsg.End();
	else
			ply:PrintMessage( 3, "You are not the main owner, you cannot change the propertys name!" );
	end
	
	end
	
end
concommand.Add( "eng_promptpropname", CCPromptPropName );

function CCAddDoorOwner( ply, cmd, args )

	if( not args[1] ) then return; end
	
	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 200;
	trace.filter = ply;
	local tr = util.TraceLine( trace );
	
	if( ValidEntity( tr.Entity ) and tr.Entity:IsDoor() ) then
	
		if( tr.Entity:OwnsDoor( ply ) ) then
			
			local name = args[1];
			local succ, result = TS.FindPlayerByName( name );
			TS.ErrorMessage( ply, true, succ, result );
			
				if( succ ) then
				
					if( tr.Entity:OwnsDoor( result ) ) then
					
						ply:PrintMessage( 3, result:GetRPName() .. " already co-owns this door" );
						umsg.Start( "RADO", ply );
						umsg.End();
					
					else
				
						result:OwnDoor( tr.Entity );
						ply:PrintMessage( 3, result:GetRPName() .. " has been made co-owner of this door" );
						umsg.Start( "RADO", ply );
						umsg.End();
					
					end
					
				end
		
		else
		
			ply:PrintMessage( 3, "You don't own this door" );
		
		end
	
	end

	return "";
	
end
concommand.Add( "eng_ado", CCAddDoorOwner );

function CCPromptAddDoorOwner( ply )

	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 200;
	trace.filter = ply;
	local tr = util.TraceLine( trace );

		if( tr.Entity.MainOwner == ply ) then
			umsg.Start( "PADO", ply );
			umsg.End();
		else
			ply:PrintMessage( 3, "You are not the main owner, you cannot give out spare keys!" );
		end

end
concommand.Add( "eng_promptado", CCPromptAddDoorOwner );

function CCSetPropertyName( ply, cmd, args )

	if( not args[1] ) then return; end
	
	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 200;
	trace.filter = ply;
	local tr = util.TraceLine( trace );
	
	if( ValidEntity( tr.Entity ) and tr.Entity:IsDoor() ) then
	
		if( tr.Entity:OwnsDoor( ply ) ) then
			
			local parent = tr.Entity.PropertyParent;
			local propertyname = tr.Entity.PropertyName;
			
			if( propertyname ~= args[1] ) then
			
			if( propertyname == "Combine Civil Housing" ) then
			
				ply:PrintMessage( 3, "Cannot change the Property name of this door" );
				
			else
			
			tr.Entity.PropertyName = args[1]
				
			for k, v in pairs( TS.MapDoors ) do
				if( v.PropertyParent == parent and not string.find( v.Door.DoorFlags, "s" ) ) then	
					v.Door.PropertyName = args[1]
				end
			end
				
				ply:PrintMessage( 3, "Property name set to " .. args[1] );
				
			end
			end
			
		else
		
			ply:PrintMessage( 3, "You don't own this door" );
		
		end
	
	end

	return "";
	
end
concommand.Add( "eng_setpropertyname", CCSetPropertyName );
