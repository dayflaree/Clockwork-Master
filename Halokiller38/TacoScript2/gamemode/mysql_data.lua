local meta = FindMetaTable( "Player" );

function meta:CharSaveData( field, value, sync )

	if( not field or not value ) then return; end

	local ID = self:GetSQLData( "uid" );

	local query = "SELECT `userID` FROM `tb_characters` WHERE `userID` = '" .. ID .. "' AND `charName` = '"..TS.Escape(self:GetRPName()).."'";
	TS.AsyncQuery(query, function(q)
		local results = q:getData()
		local saves = #results
		if saves > 0 then
	
			local query = "UPDATE `tb_characters` SET `" .. field .. "` = '" .. TS.Escape(value ) .. "' WHERE `userID` = '" .. ID .. "' AND `charName` = '" .. TS.Escape(self:GetRPName() ) .. "'";
			TS.SyncQuery(query)
		end
		
	end, nil, nil, sync)
	self[field] = value
end

function meta:SaveInventories(sync)

	local inventories = "";

	for n = 1, TS.MaxInventories do
	
		if( self.Inventories[n].Name ) then
		
			local inventory = self.Inventories[n].Name;
			
			inventories = inventories .. inventory .. ";";
			
		end
	
	end
	
	self:CharSaveData( "containers", inventories, sync );

end

function meta:SaveItems(sync)

	local items = "";
	
	for c, b in pairs( self.Inventories ) do
		
		for x, v in pairs( self.InventoryGrid[c] ) do
			
			for y, m in pairs( v ) do
				
				if( self.InventoryGrid[c][x][y].ItemData ) then
			
					local item = self.InventoryGrid[c][x][y].ItemData.ID;
					local inv = self.Inventories[c].Name;
					local itemx = x;
					local itemy = y;
					
					if( TS.ItemsData[item] 
						or (not self:IsCP() and not self:IsOW() and not self:IsCA())) then
				
						items = items .. item .. ";" .. itemx .. ";" .. itemy .. ";";
						
					end

				end
				
			end
			
		end

	end

	self:CharSaveData( "items", items, sync );

end

function meta:SaveMisc(sync)

	local data = { }
	
	data["charName"] = self:GetRPName();
	data["charModel"] = self.CitizenModel;
	data["charAge"] = self:GetPlayerAge();
	data["charTitle"] = self:GetPlayerTitle();
	data["charTitle2"] = self:GetPlayerTitle2();
	data["statStrength"] = self:GetPlayerStrength();
	data["statSpeed"] = self:GetPlayerSpeed();
	data["statEndurance"] = self:GetPlayerEndurance();
	data["statAim"] = self:GetPlayerAim();
	data["userID"] = self:GetSQLData( "uid" );
	data["combineflags"] = self.CombineFlags;
	data["playerflags"] = self.PlayerFlags;
	data["charTokens"] = self.Tokens;

	for k, v in pairs( TS.PlayerStats ) do
	
		data["stat" .. v .. "Progress"] = self[v .. "Progress"];
	
	end
	
	data["containers"] = "";
	data["items"] = "";
	
	local saveinfo = "";
	local n = false;

	local ID = self:GetSQLData( "uid" );

	local query = "SELECT `userID` FROM `tb_characters` WHERE `userID` = '" .. ID .. "' AND `charName` = '"..TS.Escape(self:GetRPName()).."'";
	TS.AsyncQuery(query, function(q)
		local results = q:getData()
		local saves = #results
		if saves > 0 then
		
			saveinfo = "UPDATE `tb_characters` SET ";
	 
			for k, v in pairs( data ) do

				if( n ) then
	  
					saveinfo = saveinfo .. ", ";

				end

				saveinfo = saveinfo .. "`" .. k .. "` = '" .. TS.Escape( v ) .. "'";
		
				n = true;
			
			end
			
			saveinfo = saveinfo .. " WHERE `userID` = '" .. ID .. "' AND `charName` = '" .. TS.Escape( self:GetRPName() ) .. "'";
		
		else
		
			saveinfo = "INSERT INTO `tb_characters` (";
	   
			for k, v in pairs( data ) do
			
				if( n ) then
			
					saveinfo = saveinfo .. ", ";
			
				end
			
				saveinfo = saveinfo .. "`" .. k .. "`";
			   
				n = true;
			
			end

			saveinfo = saveinfo .. ") VALUES ( ";

			n = false;

			for k, v in pairs( data ) do

				if( n ) then

					saveinfo = saveinfo .. ", ";

				end

				saveinfo = saveinfo .. "'" .. TS.Escape( v ) .. "'";

				n = true;

			end 

			saveinfo = saveinfo .. " )";

		end
		
		local result, succ, err = TS.AsyncQuery(saveinfo, nil, function(q, err)
			self:PrintMessage( 2, "Error saving misc info: " .. err )
		end)
	end, nil, nil, sync)

end

function meta:CharSave(sync)
	if type(sync) ~= "boolean" then sync = false end
	self:SaveMisc(sync);
	self:SaveInventories(sync);
	self:SaveItems(sync);

end

function meta:LoadInventories( name )

	local ID = self:GetSQLData( "uid" );

	local query = "SELECT `containers` FROM `tb_characters` WHERE `userID` = '" .. ID .. "' AND `charName` = '" .. TS.Escape(name) .. "'";	
	TS.AsyncQuery(query, function(q)
		local data = q:getData()[1]
		if not data then return; end
		
		local inventories = string.Explode( ";", data.containers );

		for n = 1, #inventories do
		
			if( inventories ) then

				for k, v in pairs( TS.Inventories ) do
			
					if( inventories[n] == k ) then
					
						self:WearItem( v );
					
					end
				
				end
				
			end
		
		end
	end)
end

function meta:LoadItems( name )

	local ID = self:GetSQLData( "uid" );

	local query = "SELECT `items` FROM `tb_characters` WHERE `userID` = '" .. ID .. "' AND `charName` = '" .. TS.Escape(name) .. "'";	
	TS.AsyncQuery(query, function(q)
		local data = q:getData()[1]
		if not data then return; end
		
		local items = string.Explode( ";", data.items );
		local j = 1;
		local delay = 1;
		
		for n = 1, #items do
		
			if( items[j] and items[j + 1] and items[j + 2] ) then
			
				local item = items[j];
				local x = tonumber( items[j + 1] );
				local y = tonumber( items[j + 2] );
				print(item.."@("..x..","..y..")")
				
				timer.Simple( delay, self.GiveSavedItem, self, item, x, y );
				delay = delay + .3;
				
				j = j + 3;
				
			end
		
		end
	end)
end

function meta:LoadMisc( name )

	local ID = self:GetSQLData( "uid" );

	local query = "SELECT `charModel`, `charAge`, `charTitle`, `statStrength`, `statAIM`, `statEndurance`, `statSpeed`, `combineflags`, `playerflags`, `charTitle2`, `statStrengthProgress`, `statSpeedProgress`, `statEnduranceProgress`, `statAimProgress`, `charTokens`, `CID` FROM `tb_characters` WHERE `userID` = '" .. ID .. "' AND `charName` = '" .. TS.Escape(name ) .. "'";	
	TS.AsyncQuery(query, function(q)
		local data = q:getData()[1]
		if( not data ) then return; end
		
		self.CitizenModel = data.charModel;
		self:SetModel(self.CitizenModel)

		self:SetPlayerAge( data.charAge );
		
		self:SetPlayerTitle( data.charTitle );
		self:SetPlayerTitle2( data.charTitle2 );
		
		self:SetPlayerStrength( tonumber( data.statStrength ) );
		self:SetPlayerAim( tonumber( data.statAIM ) );
		self:SetPlayerEndurance( tonumber( data.statEndurance ) );
		self:SetPlayerSpeed( tonumber( data.statSpeed ) );
		
		self.CombineFlags = data.combineflags;
		self.PlayerFlags = data.playerflags;
		self.Tokens = tonumber(data.charTokens);
		self.CID = data.CID;
		self.Away = nil
		self.LastTitleUpdate = CurTime()
		
		local num = 11;
		
		for k, v in pairs( TS.PlayerStats ) do
		
			self[v .. "Progress"] = tonumber( data[num] ) or 0;
			
			num = num + 1;
			
		end
		
		-- LOTS OF STUFF WE CAN MAKE A FUNCTION INSTEAD OF UMSG HERE!
		-- TODO HACK FIXME IGNORE ME LOOK AT ME
		timer.Simple( 1, function()
			self:SendTitle()
			self:SendTitle2()
			
			umsg.Start( "UDPM" )
				umsg.Float( self.Tokens );
			umsg.End();
			
			umsg.Start( "UDPC" )
				umsg.String( self.CID );
			umsg.End();
			
			umsg.Start( "CABM" )
				umsg.Bool( string.find(self.PlayerFlags, "[XY]") );
			umsg.End();
		end );
	end)
end

function meta:CharLoad( name )

	self:LoadInventories( name );
	self:LoadItems( name );
	self:LoadMisc( name );
	
end

function meta:LoadSQLData()

	local query = "SELECT `groupID` FROM `tb_users` WHERE `STEAMID` = '" .. self:SteamID() .. "'";	
	local result = TS.AsyncQuery(query, function(q)
		local result = q:getData()
		local id = tonumber( result[1].uID );
		print(id)
		
		if( not id or id == "" ) then
		
			id = 1;
			
			local query = "UPDATE `tb_users` SET `groupID` = '1' WHERE `STEAMID` = '" .. self:SteamID() .. "'";	
			TS.AsyncQuery(query);
		
		end
		
		for k, v in pairs( TS.SQLData ) do
		
			self:SetSQLData( k, 0 );
		
		end

		self:SetSQLData( "group_id", id );
		
		if self:GetGroupID() == 2 then
		
			self:SetSQLData( "group_hastt", 1 )
			self:SetSQLData( "group_max_props", 15 );
		
		else
		
			self:SetSQLData( "group_max_props", 10 );
		
		end

		local query = "SELECT `MaxRagdolls`, `MaxProps`, `CustomModel` FROM `tb_donations` WHERE `STEAMID` = '" .. self:SteamID() .. "'"
		TS.AsyncQuery(query, function(q)
			local result = q:getData()
			if( result and #result > 0 ) then
			
				self:SetSQLData( "group_max_ragdolls", tonumber( result[1].MaxRagdolls ) );
				
				if( tonumber( result[1][2] ) > 0 ) then
				
					self:SetSQLData( "group_max_props", tonumber( result[1].MaxProps ) or 15 );
					
				end
			
			end
		end)
		
		if( self:IsAdmin() ) then
		
			for k, v in pairs( TS.SQLData ) do
			
				if( k ~= "group_id" ) then
		
					self:SetSQLData( k, 100 );
					
				end
		
			end
			
			self:SetSQLData( "group_hastt", 1 );	
		
		end
	end)

end

function meta:HandlePlayer()
	
	local query = "SELECT * FROM `tb_users` WHERE `STEAMID` = '" .. self:SteamID() .. "'";
	TS.AsyncQuery(query, function(q)
		local result = q:getData()
		if( result and #result > 0 ) then 
	
			self:SetSQLData( "uid", result[1].uID );	
		
			self:LoadSQLData();
		
			timer.Simple( .5, self.PromptCharacterMenu, self );
		else
			timer.Simple( .5, self.PromptQuizMenu, self );
		end
	end, function()
		self:PrintMessage( 3, "MYSQL ERROR" );
	end)
end

function meta:AddMoney( amt )

	self.Tokens = self.Tokens + amt;
	
	local query = "UPDATE `tb_characters` SET `charTokens` = '" .. self.Tokens .. "' WHERE `userID` = '" .. self:GetSQLData( "uid" ) .. "' AND `charName` = '" .. TS.Escape( self:GetRPName() ) .. "'";	
	TS.AsyncQuery(query)

	umsg.Start( "UDPM", self )
		umsg.Float( self.Tokens );
	umsg.End();
end

function meta:SubMoney( amt )

	self.Tokens = self.Tokens - amt;
	
	local query = "UPDATE `tb_characters` SET `charTokens` = '" .. self.Tokens .. "' WHERE `userID` = '" .. self:GetSQLData( "uid" ) .. "' AND `charName` = '" .. TS.Escape( self:GetRPName() ) .. "'";	
	TS.AsyncQuery(query);	
	
	umsg.Start( "UDPM", self )
		umsg.Float( self.Tokens );
	umsg.End();

end

function meta:SetCID( val )

	self.CID = val;
	
	local query = "UPDATE `tb_characters` SET `CID` = '" .. self.CID .. "' WHERE `userID` = '" .. self:GetSQLData( "uid" ) .. "' AND `charName` = '" .. TS.Escape( self:GetRPName() ) .. "'";	
	TS.AsyncQuery( query );	
	
	umsg.Start( "UDPC", self )
		umsg.Float( self.CID );
	umsg.End();

end
