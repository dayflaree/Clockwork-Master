function ccDispatchLine( ply, cmd, args )

	if not ply:IsCP() and not ply:IsCA() and not ply:IsOW() then return; end
	
	line = tonumber( args[1] );
	
	if not line then
	
		for k, v in pairs( TS.DispatchLines ) do
		
			ply:PrintMessage( 2, k .. ". " .. TS.DispatchLines[k].Line );
		
		end
		
	elseif line < #TS.DispatchLines and line > 0 then
		ply:SendOverlongMessage(TS.MessageTypes.DISPATCH.id, TS.DispatchLines[line].Line);
		
		umsg.Start( "PDL" )
			umsg.String( TS.DispatchLines[line].Sound );
		umsg.End();		
		
	end

end
concommand.Add( "rp_dispatch", ccDispatchLine );

function ccSetCPModel( ply, cmd, args )

	if ply:IsCP() then
	
		local CPModels =
		{
		
			"models/purvis/male_01_metrocop.mdl",
			"models/purvis/male_24_metrocop.mdl",
			"models/purvis/male_03_metrocop.mdl",
			"models/purvis/male_04_metrocop.mdl",
			"models/purvis/male_05_metrocop.mdl",
			"models/purvis/male_06_metrocop.mdl",
			"models/purvis/male_07_metrocop.mdl",
			"models/purvis/male_08_metrocop.mdl",
			"models/purvis/male_18_metrocop.mdl",
			"models/purvis/male_12_metrocop.mdl",
			"models/purvis/male_25_metrocop.mdl",
			"models/c08cop.mdl",
			"models/police_female_blondecp.mdl",
			"models/c08cop_female.mdl",
			"models/police_female_finalcop.mdl",
			
		};
	
		if table.HasValue( CPModels, args[1] ) then
		
			ply:SetModel( args[1] );
			ply:PrintMessage( 3, "Set CP model to " .. args[1] .. "." );
			ply:PrintMessage( 2, "Set CP model to " .. args[1] .. "." );
			
		else
		
			ply:PrintMessage( 2, "Invalid CP model." );
			
		end
	
	else
	
		ply:PrintMessage( 2, "Must be Civil Protection." );
		
	end

end
concommand.Add( "rp_setcpmodel", ccSetCPModel );

function ccSelectCPModel( ply, cmd, args )

	if( not ply:IsCP() ) then
		return;
	end

	umsg.Start( "SCPM", ply );
	umsg.End();
    
end
concommand.Add( "rp_selectcpmodel", ccSelectCPModel );

function ccUnlockDoor( ply, cmd, args )

	local trace = { } 
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 4096;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	
	if( tr.Entity:IsDoor() ) then
	
		if tr.Entity.Owned and tr.Entity.MainOwner == ply then
		
			ply:EmitSound( Sound( "doors/door_latch3.wav" ) );
			
			tr.Entity:Fire( "unlock", "", 0 );
		
		end
	
	end

end
concommand.Add( "rp_unlock", ccUnlockDoor );

function ccLockDoor( ply, cmd, args )

	local trace = { } 
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 4096;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	
	if( tr.Entity:IsDoor() ) then
	
		if tr.Entity.Owned and tr.Entity.MainOwner == ply then
		
			ply:EmitSound( Sound( "doors/door_latch3.wav" ) );
			
			tr.Entity:Fire( "lock", "", 0 );
		
		end
	
	end

end
concommand.Add( "rp_lock", ccLockDoor );

function ccSellDoor( ply, cmd, arg )

	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 150;
	trace.filter = ply;
				
	local tr = util.TraceLine( trace );
	
	if tr.Entity and tr.Entity:IsDoor() then
	
		if tr.Entity.Owned and tr.Entity.MainOwner == ply then
		
			ply:AddMoney( tr.Entity.DoorPrice )
			
			tr.Entity.MainOwner = nil;
			tr.Entity.DoorDesc = nil;
			
			if tr.Entity.DoorPrice > 0 then
				ply:PrintMessage( 3, "Unowned door for " .. tr.Entity.DoorPrice .. " tokens." );
			else
				ply:PrintMessage( 3, "Unowned door." );
			end
			
			tr.Entity.Owned = false;
		
		else
		
			ply:PrintMessage( 3, "You do not own this door!" );
			
		end
	
	else
	
		ply:PrintMessage( 3, "Not a door!");
		
	end

end
concommand.Add( "rp_selldoor", ccSellDoor );

function ccBuyDoor( ply, cmd, arg )

	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 150;
	trace.filter = ply;
				
	local tr = util.TraceLine( trace );
	
	if tr.Entity and tr.Entity:IsDoor() then
	
		if not tr.Entity.Owned and not tr.Entity.OwnedByCombine then
		
			if ply.Tokens < tr.Entity.DoorPrice then
				ply:PrintMessage( 3, "Not enough money!" );
				return;
			end
			
			ply:SubMoney( tr.Entity.DoorPrice )
			
			tr.Entity.MainOwner = ply;
			
			if tr.Entity.DoorPrice > 0 then
				ply:PrintMessage( 3, "Owned door for " .. tr.Entity.DoorPrice .. " tokens." );
			else
				ply:PrintMessage( 3, "Owned door." );
			end
		
		else
		
			if tr.Entity.OwnedByCombine then
				ply:PrintMessage( 3, "Cannot own door!" );
			else
				ply:PrintMessage( 3, "Door is owned!" );
			end
			
		end
	
	end

end
concommand.Add( "rp_buydoor", ccBuyDoor );

function ccPrintCitizens( ply, cmd, arg )

	if not ply:IsCP() then return false; end

	for k, v in pairs(player.GetAll()) do
	
		if not v:IsCP() and v:GetRPName() then
		
			ply:PrintMessage( 2, v.CID .. " - " .. v:GetRPName() );
		
		end
	
	end

end
concommand.Add( "rp_citizens", ccPrintCitizens );

function ccChangeName( ply, cmd, arg )

	if( not arg[1] ) then return; end
	
	if( ply:IsTied() ) then return; end
	
	if( string.len( arg[1] ) < 3 or 
		string.len( arg[1] ) > 30 ) then 
	
		return;
	
	end
	
	local DesiredName = arg[1];

	for n = 2, #arg do
	
		DesiredName = DesiredName .. " " .. arg[n];
	
	end
	local query = "SELECT `userID` FROM `tb_characters` WHERE `userID` = '" .. ID .. "' AND `charName` = '"..TS.Escape(self:GetRPName()).."'";
	TS.AsyncQuery(query, function(q)
		local results = q:getData()
		local saves = #results
		if saves > 0 then
	
			ply:PrintMessage( 2, "You already have a character with that name!" );
			return;
	
		end
	
		local query = "UPDATE `tb_characters` SET `charName` = '" .. TS.Escape( DesiredName ) .. "' WHERE `userID` = '" .. ply:GetSQLData( "uid" ) .. "' AND `charName` = '" .. TS.Escape( ply:GetRPName() ) .. "'";
		TS.AsyncQuery(query)

		ply:SetNWString( "RPName", DesiredName );
		ply:CharSaveData( "charName", DesiredName );
	end)

end
concommand.Add( "rp_changename", ccChangeName );

function ccDevRestart( ply, cmd, arg )

	if( not ply:IsRick() ) then return; end
	
	timer.Simple( 1, game.ConsoleCommand, "changelevel " .. game.GetMap() .. "\n" );

end
concommand.Add( "dr", ccDevRestart );

function ccPrintUserList( ply, cmd, arg )

	for n = 1, MaxPlayers() do
	
		if( player.GetByID( n ):IsValid() ) then
		
			Console( ply, n .. " - " .. player.GetByID( n ):GetRPName() .. " [" .. player.GetByID( n ):Name() .. "][" .. player.GetByID( n ):SteamID() .. "]" );
			
		end
	
	end

end
concommand.Add( "rp_printuserlist", ccPrintUserList );
concommand.Add( "rp_userlist", ccPrintUserList );

local hguns = { "weapon_physgun", "weapon_physcannon", "gmod_tool" }

function ccSelectWeapon( ply, cmd, arg )

	if( not arg[1] ) then
		return;
	end
	
	if( ply:IsTied() ) then return; end 
	
	if( ply:HasWeapon( arg[1] ) ) then
	
		ply:SelectWeapon( arg[1] );
		
		if( table.HasValue( hguns, arg[1] ) ) then
		
			ply:SetAimAnim( true );
			return;
		
		end
		
		if( ply.Unholstered ) then
			
			ply:SetAimAnim( false );
		
		end
		
	end

end
concommand.Add( "rp_selectweapon", ccSelectWeapon );

function ccICSit( ply, cmd, arg )
	
	if( CurTime() - ply.LastStanceAction < 2 ) then
		return;
	end

	ply.LastStanceAction = CurTime();
	
	if( not ply.InStanceAction ) then

		if( ply:Crouching() ) then return; end

		local trace = { }
		trace.start = ( ply:EyePos() - Vector( 0, 0, 30 ) );
		trace.endpos = trace.start - ply:GetAngles():Forward() * 22;
		trace.filter = ply;
		
		local tr = util.TraceLine( trace );
	
		if( not tr.Hit ) then
		
			local trace = { }
			trace.start = ( ply:EyePos() - Vector( 0, 0, 25 ) ) - ply:GetAngles():Forward() * 22;
			trace.endpos = trace.start - Vector( 0, 0, 25 );
			trace.filter = ply;
			
			local tr = util.TraceLine( trace );

			if( tr.Hit ) then

				ply.StanceSnapToPlayerPos = ply:GetPos();
				ply:SetPos( ply:GetPos() + ply:GetAngles():Forward() * -10 );
				
				ply:HandleSit( tr.Entity );

				ply:PrintMessage( 3, "Sitting down" );
				
			else
			
				ply:PrintMessage( 3, "Can't sit here" );
				
			end
			
		else
		
			ply:PrintMessage( 3, "Can't sit here" );
			
		end
	
	elseif( ply.StanceSit ) then
		
		if( ply.StanceSnapToPlayerPos ) then
			
			ply:SetPos( ply.StanceSnapToPlayerPos );
		
		end
		
		ply:SnapOutOfStance();
		
	end

end
concommand.Add( "rp_ic_sit", ccICSit );

function ccICSitGround( ply, cmd, arg )
	
	if( CurTime() - ply.LastStanceAction < 2 ) then
		return;
	end

	ply.LastStanceAction = CurTime();

	if( not ply.InStanceAction ) then
	
		ply:HandleSitGround();
		
		ply:PrintMessage( 3, "Sitting down" );
	
	elseif( ply.StanceGroundSit ) then
	
		ply:SnapOutOfStance();
		
	end

end
concommand.Add( "rp_ic_sitground", ccICSitGround );

function ccICLean( ply, cmd, arg )
	
	if( CurTime() - ply.LastStanceAction < 2 ) then
		return;
	end

	ply.LastStanceAction = CurTime();
	
	local TurnOffLean = function()
	
		ply:SnapOutOfStance();
		ply:Freeze( false );
	
	end
	
	if( not ply.InStanceAction ) then

		local trace = { }
		trace.start = ply:EyePos();
		trace.endpos = ( trace.start - Vector( 0, 0, 25 ) ) - ply:GetAngles():Forward() * 20;
		trace.filter = ply;
		
		local tr = util.TraceLine( trace );
		
		if( tr.Hit ) then
	
			ply:HandleLean();
			ply:PrintMessage( 3, "Leaning" );
			
		end
		
		local function leanthink()
		
			if( ply.StanceLean ) then
			
				local trace = { }
				trace.start = ply:EyePos();
				trace.endpos = ( trace.start - Vector( 0, 0, 25 ) ) - ply:GetAngles():Forward() * 20;
				trace.filter = ply;
				
				local tr = util.TraceLine( trace );
				
				if( not tr.Hit ) then
			
					TurnOffLean();
					
				else
				
					timer.Simple( 1, leanthink );
				
				end
			
			end
		
		end
		
		timer.Simple( 1, leanthink );
		
	elseif( ply.StanceLean ) then
	
		TurnOffLean();
		ply:Freeze( false );
		
	end

end
concommand.Add( "rp_ic_lean", ccICLean );

function ccMOTD( ply )
	
	if( CurTime() - ply.LastMOTDPrompt < 2 ) then
		return;
	end
	
	if( not ply.CanInitialize ) then
		return;
	end

	ply.LastMOTDPrompt = CurTime();

	ply:PromptMOTD();	

end
concommand.Add( "rp_motd", ccMOTD );

function CCSpawnSWEP( ply, cmd, arg )

	if( not ply:IsSuperAdmin() ) then

		return;
		
	end
	
	local trace = { } 
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 60;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	
	local weap = arg[1];
	
	if( TS.ItemsData[weap] ) then

		local weapon = TS.CreateItemProp( arg[1], tr.HitPos );
		weapon:SetPos( tr.HitPos );
		weapon:Spawn();
		
	else
	
		ply:PrintMessage( 3, "Cannot spawn non-TS2 supported weapons!" );
		
	end

end 
concommand.Add( "gm_spawnswep", CCSpawnSWEP );
concommand.Add( "gm_giveswep", CCSpawnSWEP );

function ccFreqChange( ply, cmd, args )

	if( ply:IsCP() ) then return; end
	
	if( not ply:HasItem( "radio" ) ) then return; end

	local freq = tonumber( args[1] );
	
	if( freq ) then
	
		freq = math.floor( freq );
	
	else
	
		return;
	
	end
	
	if( freq < 0 ) then
	
		return;
	
	end 

	if( freq > 999 ) then
	
		return;
	
	end 
	
	ply.Frequency = freq;

end
concommand.Add( "rp_changefrequency", ccFreqChange );

function ccSpawnList( ply, cmd, arg )

	if( not ply.Initialized ) then
		return;
	end
	
	if( not	ply:HasPlayerFlag( "Y" ) and not ply:HasPlayerFlag( "X" ) ) then
	
		ply:PrintMessage( 3, "You need the Y or X flag to access this!" );
		return; 
		
	end
	
	local function OpenSpawnMenu()
	
		local x = false;
	
		if( ply:HasPlayerFlag( "X" ) ) then
	
			x = true;
	
		end
	
		umsg.Start( "PSM", ply );
			umsg.Bool( x );
		umsg.End();
	
	end
	
	if( ply.SpawnMenuLoaded ) then
	
		OpenSpawnMenu();
		
	else
	
		if( ply.SpawnMenuLoading ) then
			return;
		end
		
		ply.SpawnMenuLoading = true;
	
		local time = .5;
	
		for k, v in pairs( TS.ProcessedItems ) do
	
			time = time + .2;
	
		end

		SendProcessedItems( ply );
	
		local function loadthink( ply, done )
	
			if( done ) then
	
				OpenSpawnMenu();
		
				ply:PrintMessage( 3, "Spawn menu initialize complete!" );
		
				ply.SpawnMenuLoaded = true;
			
				DestroyProcessBar( "spawnload", ply );
				return;
			
			end
	
		end
	
		CreateProcessBar( "spawnload", "Loading Spawn Menu", ply );
			SetEstimatedTime( time, ply );
			SetThinkDelay( .25, ply );
			SetThink( loadthink, ply );
		EndProcessBar( ply );	

	end
	
end
concommand.Add( "rp_spawning", ccSpawnList );

function ccDeleteCharacter( ply, cmd, arg )

	if( not arg[1] ) then
		ply:PrintMessage( 2, "rp_deletesave - Delete a character permanently" );
		return;
	end
	
	local name = arg[1];
	
	for n = 2, #arg do
	
		name = name .. " " .. arg[n];
	
	end	
	local query = "SELECT `userID` FROM `tb_characters` WHERE `userID` = '" .. ID .. "' AND `charName` = '"..TS.Escape(self:GetRPName()).."'";
	TS.AsyncQuery(query, function(q)
		local results = q:getData()
		local saves = #results
		if saves <= 0 then
		
			ply:PrintMessage( 2, "Save does not exist!" );
			return;
		
		end
	
		--If they're playing on the save..
		if( ply:GetRPName() == name ) then
			
			ply:PrintMessage( 2, "Save removed: " .. name );
			
			local query = "DELETE FROM `tb_characters` WHERE `userID` = '" .. ply:GetSQLData( "uid" ) .. "' AND `charName` = '" .. TS.Escape( name ) .. "'";		
			TS.AsyncQuery(query)
			
			ply:RefreshChar();
			
			if( not ply.CharacterMenu ) then
			
				ply:PromptCharacterMenu();
				ply:CallEvent( "HorseyMapViewOn" );
				
			end
			
		else
		
			ply:PrintMessage( 2, "Save removed: " .. name );
		
			local query = "DELETE FROM `tb_characters` WHERE `userID` = '" .. ply:GetSQLData( "uid" ) .. "' AND `charName` = '" .. TS.Escape(name) .. "'";		
			TS.AsyncQuery(query)

		end
	end)

end
concommand.Add( "rp_deletesave", ccDeleteCharacter );

--Player item spawning
function ccSpawnItem( ply, cmd, arg )

	if( not arg[1] or not TS.ItemsData[arg[1]] ) then return; end
	
	if( not ply:HasPlayerFlag( "Y" ) and not ply:HasPlayerFlag( "X" ) ) then
	
		ply:PrintMessage( 3, "You need the X or Y flag to spawn items!" );
		return;
		
	end
	
	if( string.find( arg[1], "donator_" ) ) then return; end

	if( string.find( arg[1], "clothes_" ) or
		string.find( arg[1], "ts2_" ) and not ply:HasPlayerFlag( "X" ) ) then
	
		return;
	
	end
	
	if string.find( arg[1], "ts2_") then
	
		for k, v in pairs(weapons.GetList()) do
		
			if v.ClassName == arg[1] then
				if ply.Tokens > v.Price then
				
					ply:PrintMessage(2, "Spawning " .. arg[1] );
				
					TS.WriteLog( "spawnmenu", ply:GetRPName() .. " ( " .. ply:SteamID() .. " )" .. " has spawned: " .. arg[1] .. " " .. "( " .. tostring( os.date() ) .. " )" );
					
					ply:SubMoney(v.Price);
					
					local trace = { }
					trace.start = ply:EyePos();
					trace.endpos = trace.start + ply:GetAimVector() * 150;
					trace.filter = ply;
					
					local tr = util.TraceLine( trace );
					
					TS.CreateItemProp( arg[1], tr.HitPos );
					
					return;
				
				else
				
					ply:PrintMessage(3, "Not enough tokens!");
					return;
				
				end
			
			end
		
		end
		
	else
	
		if not TS.ItemsData[arg[1]] then
			ply:PrintMessage(2, "Invalid ID");
			return;
		end
	
		if ply.Tokens > TS.ItemsData[arg[1]].Price then
		
			ply:PrintMessage(2, "Spawning " .. arg[1] );
		
			TS.WriteLog( "spawnmenu", ply:GetRPName() .. " ( " .. ply:SteamID() .. " )" .. " has spawned: " .. arg[1] .. " " .. "( " .. tostring( os.date() ) .. " )" );
			
			ply:SubMoney(TS.ItemsData[arg[1]].Price);
			
			local trace = { }
			trace.start = ply:EyePos();
			trace.endpos = trace.start + ply:GetAimVector() * 150;
			trace.filter = ply;
			
			local tr = util.TraceLine( trace );

			TS.CreateItemProp( arg[1], tr.HitPos );
			return;
		
		else
		
			ply:PrintMessage(3, "Not enough tokens!");
			return;
			
		end
		
	end

end
concommand.Add( "rp_spawnitem", ccSpawnItem );

function ccCPMake( ply, cmd, arg )

	if ply:IsCP() or ply:IsOW() then

		if arg[1] == "ration"
		or arg[1] == "bandage"
		or arg[1] == "medkit"
		or arg[1] == "crdevice" then
	
			local trace = { }
			trace.start = ply:EyePos();
			trace.endpos = trace.start + ply:GetAimVector() * 30;
			trace.filter = ply;
			
			local tr = util.TraceLine( trace );
			
			TS.CreateItemProp( arg[1], tr.HitPos );
			
		else
		
			v:PrintMessage( 2, "Must use ration, bandage, or medkit." );
			
		end
		
	end

end
concommand.Add( "rp_make", ccCPMake );

function ccDropWeap( ply, cmd, arg )

	local activeweap = ply:GetActiveWeapon();
	
	if( not activeweap or not activeweap:IsValid() ) then
	
		ply:PrintMessage( 3, "Take out a weapon to give!" );
		return;
	
	end
	
	if( activeweap:GetClass() == "gmod_tool" or
		activeweap:GetClass() == "weapon_physcannon" or
		activeweap:GetClass() == "weapon_physgun" or
		activeweap:GetClass() == "ts2_hands" or
		activeweap:GetClass() == "ts2_vort" ) then
		
		ply:PrintMessage( 3, "You cannot give this!" );
		return;
		
	end

	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 40;
	trace.filter = ply;
	local tr = util.TraceLine( trace );
	
	if( tr.Entity and tr.Entity:IsValid() and tr.Entity:IsPlayer() ) then
	
		if( tr.Entity:EyePos():Distance( ply:EyePos() ) <= 50 ) then
	
			if( activeweap:GetClass() == ply.TempWeaponClass ) then
			
				tr.Entity:GiveTempWeapon( activeweap:GetClass() );
				ply:StripWeapon( ply.TempWeaponClass );
				ply.HasTempWeapon = false;
			
				return;
			
			end
		
			TS.CreateItemProp( activeweapon:GetClass(), tr.HitPos );	
	
			ply:StripWeapon( activeweap:GetClass() );
		
			for i, v in pairs( ply.InventoryGrid ) do
	
				for x, c in pairs( v ) do
		
					for y, u in pairs( c ) do
				
						if( ply.InventoryGrid[i][x][y].ItemData ) then
				
							if( ply.InventoryGrid[i][x][y].ItemData.ID == activeweap:GetClass() )  then
						
								ply:TakeItemAt( i, x, y );
							
							end
						
						end
			
					end
			
				end
		
			end
		
		end
		
	end

end
concommand.Add( "rp_dropweap", ccDropWeap );

function ccGiveWeap( ply, cmd, arg )

	local activeweap = ply:GetActiveWeapon();
	
	if( not activeweap or not activeweap:IsValid() ) then
	
		ply:PrintMessage( 3, "Take out a weapon to give!" );
		return;
	
	end
	
	if( activeweap:GetClass() == "gmod_tool" or
		activeweap:GetClass() == "weapon_physcannon" or
		activeweap:GetClass() == "weapon_physgun" or
		activeweap:GetClass() == "ts2_hands" or
		activeweap:GetClass() == "ts2_vort" ) then
		
		ply:PrintMessage( 3, "You cannot give this!" );
		return;
		
	end

	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 60;
	trace.filter = ply;
	local tr = util.TraceLine( trace );
	
	if( tr.Entity and tr.Entity:IsValid() and tr.Entity:IsPlayer() ) then
	
		if( tr.Entity:EyePos():Distance( ply:EyePos() ) <= 50 ) then
	
			if( activeweap:GetClass() == ply.TempWeaponClass ) then
			
				tr.Entity:GiveTempWeapon( activeweap:GetClass() );
				ply:StripWeapon( ply.TempWeaponClass );
				ply.HasTempWeapon = false;
			
				return;
			
			end
		
			if( not tr.Entity:CanItemFitInAnyInventory( activeweap:GetClass() ) ) then
		
				ply:PrintMessage( 3, "Player cannot fit weapon in inventory!" );
				return;
		
			end
		
			tr.Entity:GiveAnyInventoryItem( activeweap:GetClass() );
			tr.Entity:Give( activeweap:GetClass() );
	
			ply:StripWeapon( activeweap:GetClass() );
		
			for i, v in pairs( ply.InventoryGrid ) do
	
				for x, c in pairs( v ) do
		
					for y, u in pairs( c ) do
				
						if( ply.InventoryGrid[i][x][y].ItemData ) then
				
							if( ply.InventoryGrid[i][x][y].ItemData.ID == activeweap:GetClass() )  then
						
								ply:TakeItemAt( i, x, y );
							
							end
						
						end
			
					end
			
				end
		
			end
		
		else
		
			ply:PrintMessage( 3, "Not close enough to player!" );
		
		end
		
	end

end
concommand.Add( "rp_giveweap", ccGiveWeap );

function ccPlayerFlagPlayerT( ply, cmd, arg )
	if( not ply:HasCombineFlag( "E" ) ) then
		Console( ply, "You need the E flag!" );
		return;
	end

	if( not arg[1] ) then 
		Console( ply, "rp_setcombineflag <Name> <Flag> - Set a player's Combine Flag(s)" );
		return;
	end
	
	local name = arg[1];
	
	local succ, result = TS.FindPlayerByName( name );
	TS.ErrorMessage( ply, false, succ, result );
	
	if( not arg[2] ) then
		arg[2] = " ";
	end

	if( succ ) then
		
		result.CombineFlags = arg[2];
		
		local query = "UPDATE `tb_characters` SET `combineflags` = '" .. arg[2] .. "' WHERE `userID` = '" .. result:GetSQLData( "uid" ) .. "' AND `charName` = '" .. TS.Escape( result:GetRPName() ) .. "'";	
		TS.AsyncQuery(query)
		
		ply:PrintMessage( 3, "Updated Combine flags for: " .. result:GetRPName() .. " ( " .. result.CombineFlags .. " )" );
		result:PrintMessage( 3, "Your Combine flags have been updated by " .. ply:GetRPName() .. "." );
		result:PrintMessage( 3, "Combine flags: " .. result.CombineFlags );
		
	end
		
end
concommand.Add( "rp_setcombineflag", ccPlayerFlagPlayerT );


function ccSoundList( ply, cmd, args )
	if not ply:IsCP() and not ply:IsOW() then
		return
	end
	
	ply:PrintMessage( 2, "COMBINE SOUND LIST - USE playline <id> OR rp_playline <id>" );
	ply:PrintMessage( 2, "ID   |   LINE" );
	
	for k, v in pairs( TS.CombineSounds ) do
	
		ply:PrintMessage( 2, k .. "  |  " .. v.line );
	
	end

end
concommand.Add( "rp_soundlist", ccSoundList );

function ccPlaySound( ply, cmd, args )

	if( #args < 1 ) then return; end

	if( not ply:IsCP() and not ply:IsOW() and not ply:IsCA() ) then
		return;
	end

	local n = tonumber( args[1] );

	if( n == nil ) then
	
		ply:PrintMessage( 2, "Invalid. Use sound ID" );
		return;
		
	end
	
	if( not TS.CombineSounds[n] ) then
	
		ply:PrintMessage( 2, "Sound doesn't exist" );
		return;
	
	end
	
	util.PrecacheSound( TS.CombineSounds[n].dir );
	ply:EmitSound( TS.CombineSounds[n].dir );

end
concommand.Add( "rp_playline", ccPlaySound );
concommand.Add( "playline", ccPlaySound );

--[[
65 A
66 B
67 C 
68 D 
69 E
70 F 
71 G
72 H 
73 I
74 J 
75 K
76 L 
77 M 
78 N 
79 O 
80 P 
81 Q
82 R
83 S 
84 T 
85 U
86 V 
87 W 
88 X 
89 Y 
90 Z
--]]
















