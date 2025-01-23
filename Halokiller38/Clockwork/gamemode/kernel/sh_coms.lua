--[[
	Free Clockwork!
--]]

local NAME_CASH = Clockwork.option:GetKey("name_cash");

--[[
	Define the commands here, you shouldn't edit these commands
	directly from this file. You can add new ones in your schema
	or overwrite them there too!
--]]

COMMAND = Clockwork.command:New();
COMMAND.tip = "Kick a player from the server.";
COMMAND.text = "<string Name> <reason>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "o";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	local reason = table.concat(arguments, " ", 2);
	
	if (!reason or reason == "") then
		reason = "N/A";
	end;
	
	if (target) then
		Clockwork.player:NotifyAll(player:Name().." has kicked '"..target:Name().."' ("..reason..").");
			target:Kick(reason);
		target.kicked = true;
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
	end;
end;

Clockwork.command:Register(COMMAND, "PlyKick");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Set a player's user group.";
COMMAND.text = "<string Name> <string UserGroup>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	local userGroup = arguments[2];
	
	if (userGroup != "superadmin" and userGroup != "admin"
	and userGroup != "operator") then
		Clockwork.player:Notify(player, "The user group must be superadmin, admin or operator!");
		
		return;
	end;
	
	if (target) then
		Clockwork.player:NotifyAll(player:Name().." has set "..target:Name().."'s user group to "..userGroup..".");
			target:SetClockworkUserGroup(userGroup);
		Clockwork.player:LightSpawn(target, true, true);
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
	end;
end;

Clockwork.command:Register(COMMAND, "PlySetGroup");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Demote a player from their user group.";
COMMAND.text = "<string Name>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	
	if (target) then
		local userGroup = target:GetClockworkUserGroup();
		
		if (userGroup != "user") then
			Clockwork.player:NotifyAll(player:Name().." has demoted "..target:Name().." from "..cwUserGroup.." to user.");
				target:SetClockworkUserGroup("user");
			Clockwork.player:LightSpawn(target, true, true);
		else
			Clockwork.player:Notify(player, "This player is only a user and cannot be demoted!");
		end;
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
	end;
end;

Clockwork.command:Register(COMMAND, "PlyDemote");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Unban a Steam ID from the server.";
COMMAND.text = "<string SteamID|IPAddress>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "o";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local playersTable = Clockwork.config:Get("mysql_players_table"):Get();
	local schemaFolder = Clockwork:GetSchemaFolder();
	local identifier = string.upper(arguments[1]);
	
	if (Clockwork.BanList[identifier]) then
		Clockwork.player:NotifyAll(player:Name().." has unbanned '"..Clockwork.BanList[identifier].steamName.."'.");
		
		Clockwork:RemoveBan(identifier);
	else
		Clockwork.player:Notify(player, "There are no banned players with the '"..identifier.."' identifier!");
	end;
end;

Clockwork.command:Register(COMMAND, "PlyUnban");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Ban a player from the server.";
COMMAND.text = "<string Name|SteamID|IPAddress> <number Minutes> [string Reason]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "o";
COMMAND.arguments = 2;
COMMAND.optionalArguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local schemaFolder = Clockwork:GetSchemaFolder();
	local duration = tonumber(arguments[2]);
	local reason = table.concat(arguments, " ", 3);
	
	if (!reason or reason == "") then
		reason = nil;
	end;
	
	if (duration) then
		Clockwork:AddBan(arguments[1], duration * 60, reason, function(steamName, duration, reason)
			if (IsValid(player)) then
				if (steamName) then
					if (duration > 0) then
						local hours = math.Round(duration / 3600);
						
						if (hours >= 1) then
							Clockwork.player:NotifyAll(player:Name().." has banned '"..steamName.."' for "..hours.." hour(s) ("..reason..").");
						else
							Clockwork.player:NotifyAll(player:Name().." has banned '"..steamName.."' for "..math.Round(duration / 60).." minute(s) ("..reason..").");
						end;
					else
						Clockwork.player:NotifyAll(player:Name().." has banned '"..steamName.."' permanently ("..reason..").");
					end;
				else
					Clockwork.player:Notify(player, "This is not a valid identifier!");
				end;
			end;
		end);
	else
		Clockwork.player:Notify(player, "This is not a valid duration!");
	end;
end;

Clockwork.command:Register(COMMAND, "PlyBan");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Send a private message to a player.";
COMMAND.text = "<string Name> <string Text>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	
	if (target) then
		local voicemail = target:GetCharacterData("Voicemail");
		
		if (voicemail and voicemail != "") then
			Clockwork.chatBox:Add(player, target, "pm", voicemail);
		else
			Clockwork.chatBox:Add({player, target}, player, "pm", table.concat(arguments, " ", 2));
		end;
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
	end;
end;

Clockwork.command:Register(COMMAND, "PM");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Add a player to a whitelist.";
COMMAND.text = "<string Name> <string Faction>";
COMMAND.access = "s";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	
	if (target) then
		local faction = table.concat(arguments, " ", 2);
		
		if (Clockwork.faction.stored[faction]) then
			if (Clockwork.faction.stored[faction].whitelist) then
				if (!Clockwork.player:IsWhitelisted(target, faction)) then
					Clockwork.player:SetWhitelisted(target, faction, true);
					Clockwork.player:SaveCharacter(target);
					
					Clockwork.player:NotifyAll(player:Name().." has added "..target:Name().." to the "..faction.." whitelist.");
				else
					Clockwork.player:Notify(player, target:Name().." is already on the "..faction.." whitelist!");
				end;
			else
				Clockwork.player:Notify(player, faction.." does not have a whitelist!");
			end;
		else
			Clockwork.player:Notify(player, faction.." is not a valid faction!");
		end;
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
	end;
end;

Clockwork.command:Register(COMMAND, "PlyWhitelist");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Teleport a player to your target location.";
COMMAND.text = "<string Name>";
COMMAND.access = "o";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	
	if (target) then
		Clockwork.player:SetSafePosition(target, player:GetEyeTraceNoCursor().HitPos);
		Clockwork.player:NotifyAll(player:Name().." has teleported "..target:Name().." to their target location.");
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
	end;
end;

Clockwork.command:Register(COMMAND, "PlyTeleport");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Goto a player's location.";
COMMAND.text = "<string Name>";
COMMAND.access = "o";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	
	if (target) then
		Clockwork.player:SetSafePosition(player, target:GetPos());
		Clockwork.player:NotifyAll(player:Name().." has gone to "..target:Name().."'s location.");
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
	end;
end;

Clockwork.command:Register(COMMAND, "PlyGoto");


COMMAND = Clockwork.command:New();
COMMAND.tip = "Remove a player from a whitelist.";
COMMAND.text = "<string Name> <string Faction>";
COMMAND.access = "s";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	
	if (target) then
		local faction = table.concat(arguments, " ", 2);
		
		if (Clockwork.faction.stored[faction]) then
			if (Clockwork.faction.stored[faction].whitelist) then
				if (Clockwork.player:IsWhitelisted(target, faction)) then
					Clockwork.player:SetWhitelisted(target, faction, false);
					Clockwork.player:SaveCharacter(target);
					
					Clockwork.player:NotifyAll(player:Name().." has removed "..target:Name().." from the "..faction.." whitelist.");
				else
					Clockwork.player:Notify(player, target:Name().." is not on the "..faction.." whitelist!");
				end;
			else
				Clockwork.player:Notify(player, faction.." does not have a whitelist!");
			end;
		else
			Clockwork.player:Notify(player, faction.." is not a valid faction!");
		end;
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
	end;
end;

Clockwork.command:Register(COMMAND, "PlyUnwhitelist");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Unban a character from being used.";
COMMAND.text = "<string Name>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	for k, v in ipairs(_player.GetAll()) do
		if (v:HasInitialized()) then
			if (v:Name() == arguments[1]) then
				Clockwork.player:NotifyAll(player:Name().." unbanned the character '"..arguments[1].."'.");
				Clockwork.player:SetBanned(player, false);
				return;
			else
				for k2, v2 in pairs(v:GetCharacters()) do
					if (v2.name == arguments[1]) then
						Clockwork.player:NotifyAll(player:Name().." unbanned the character '"..arguments[1].."'.");
						v2.data.banned = false;
						return;
					end;
				end;
			end;
		end;
	end;
	
	local charactersTable = Clockwork.config:Get("mysql_players_table"):Get();
	local charName = tmysql.escape(arguments[1]);
	
	tmysql.query("SELECT * FROM "..charactersTable.." WHERE _Name = \""..tmysql.escape(charName).."\"", function(result)
		if (result and type(result) == "table" and #result > 0) then
			tmysql.query("UPDATE "..charactersTable.." SET _Data = REPLACE(_Data, \"\"banned\":true\", \"\"banned\":false\") WHERE _Name = \""..tmysql.escape(charName).."\"");
			
			Clockwork.player:NotifyAll(player:Name().." unbanned the character '"..arguments[1].."'.");
		else
			Clockwork.player:NotifyAll("This is not a valid character!");
		end;
	end);
end;

Clockwork.command:Register(COMMAND, "CharUnban");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Ban a character from being used.";
COMMAND.text = "<string Name>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(table.concat(arguments, " "));
	
	if (target) then
		Clockwork.player:SetBanned(target, true);
		Clockwork.player:NotifyAll(player:Name().." banned the character '"..target:Name().."'.");
		
		target:KillSilent();
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
	end;
end;

Clockwork.command:Register(COMMAND, "CharBan");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Set a character's model permanently.";
COMMAND.text = "<string Name> <string Model>";
COMMAND.access = "s";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	
	if (target) then
		local model = table.concat(arguments, " ", 2);
		
		target:SetCharacterData("Model", model, true);
		target:SetModel(model);
		
		Clockwork.player:NotifyAll(player:Name().." set "..target:Name().."'s model to "..model..".");
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
	end;
end;

Clockwork.command:Register(COMMAND, "CharSetModel");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Change your character's physical description.";
COMMAND.text = "[string Text]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 0;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (arguments[1]) then
		local minimumPhysDesc = Clockwork.config:Get("minimum_physdesc"):Get();
		local text = table.concat(arguments, " ");
		
		if (string.len(text) < minimumPhysDesc) then
			Clockwork.player:Notify(player, "The physical description must be at least "..minimumPhysDesc.." characters long!");
			
			return;
		end;
		
		player:SetCharacterData("PhysDesc", Clockwork:ModifyPhysDesc(text));
	else
		umsg.Start("cwPhysDesc", player);
		umsg.End();
	end;
end;

Clockwork.command:Register(COMMAND, "CharPhysDesc");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Give an item to a character.";
COMMAND.text = "<string Name> <string Item>";
COMMAND.access = "s";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (Clockwork.player:HasFlags(player, "G")) then
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target) then
			local itemTable = Clockwork.item:FindByID(arguments[2]);
			
			if (itemTable) then
				local itemTable = Clockwork.item:CreateInstance(itemTable("uniqueID"));
				local success, fault = target:GiveItem(itemTable, true);
				
				if (success) then
					if (string.sub(itemTable("name"), -1) == "s") then
						Clockwork.player:Notify(player, "You have given "..target:Name().." some "..itemTable("name")..".");
					else
						Clockwork.player:Notify(player, "You have given "..target:Name().." a "..itemTable("name")..".");
					end;
					
					if (player != target) then
						if (string.sub(itemTable("name"), -1) == "s") then
							Clockwork.player:Notify(target, player:Name().." has given you some "..itemTable("name")..".");
						else
							Clockwork.player:Notify(target, player:Name().." has given you a "..itemTable("name")..".");
						end;
					end;
				else
					Clockwork.player:Notify(player, target:Name().." does not have enough space for this item!");
				end;
			else
				Clockwork.player:Notify(player, "This is not a valid item!");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
		end;
	else
		Clockwork.player:Notify(player, "I'm sorry, it seems like you cannot be trusted with this command!");
	end;
end;

Clockwork.command:Register(COMMAND, "CharGiveItem");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Set a character's name permanently.";
COMMAND.text = "<string Name> <string Name>";
COMMAND.access = "o";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	
	if (target) then
		local name = table.concat(arguments, " ", 2);
		
		Clockwork.player:NotifyAll(player:Name().." set "..target:Name().."'s name to "..name..".");
		
		Clockwork.player:SetName(target, name);
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
	end;
end;

Clockwork.command:Register(COMMAND, "CharSetName");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Transfer a character to a faction.";
COMMAND.text = "<string Name> <string Faction> [string Data]";
COMMAND.access = "o";
COMMAND.arguments = 2;
COMMAND.optionalArguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	
	if (target) then
		local faction = arguments[2];
		local name = target:Name();
		
		if (Clockwork.faction.stored[faction]) then
			if (!Clockwork.faction.stored[faction].whitelist or Clockwork.player:IsWhitelisted(target, faction)) then
				local targetFaction = target:GetFaction();
				
				if (targetFaction != faction) then
					if (Clockwork.faction:IsGenderValid(faction, target:GetGender())) then
						if (Clockwork.faction.stored[faction].OnTransferred) then
							local success, fault = Clockwork.faction.stored[faction]:OnTransferred(target, Clockwork.faction.stored[targetFaction], arguments[3]);
							
							if (success != false) then
								target:SetCharacterData("Faction", faction, true);
								
								Clockwork.player:LoadCharacter(target, Clockwork.player:GetCharacterID(target));
								Clockwork.player:NotifyAll(player:Name().." has transferred "..name.." to the "..faction.." faction.");
							else
								Clockwork.player:Notify(player, fault or target:Name().." could not be transferred to the "..faction.." faction!");
							end;
						else
							Clockwork.player:Notify(player, target:Name().." cannot be transferred to the "..faction.." faction!");
						end;
					else
						Clockwork.player:Notify(player, target:Name().." is not the correct gender for the "..faction.." faction!");
					end;
				else
					Clockwork.player:Notify(player, target:Name().." is already the "..faction.." faction!");
				end;
			else
				Clockwork.player:Notify(player, target:Name().." is not on the "..faction.." whitelist!");
			end;
		else
			Clockwork.player:Notify(player, faction.." is not a valid faction!");
		end;
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
	end;
end;

Clockwork.command:Register(COMMAND, "CharTransfer");

COMMAND.tip = "Give flags to a character.";
COMMAND.text = "<string Name> <string Flag(s)>";
COMMAND.access = "s";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	
	if (target) then
		if (string.find(arguments[2], "a") or string.find(arguments[2], "s")
		or string.find(arguments[2], "o")) then
			Clockwork.player:Notify(player, "You cannot give 'o', 'a' or 's' flags!");
			
			return;
		end;
		
		Clockwork.player:GiveFlags(target, arguments[2]);
		
		Clockwork.player:NotifyAll(player:Name().." gave "..target:Name().." '"..arguments[2].."' flags.");
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
	end;
end;

Clockwork.command:Register(COMMAND, "CharGiveFlags");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Take flags from a character.";
COMMAND.text = "<string Name> <string Flag(s)>";
COMMAND.access = "s";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	
	if (target) then
		if (string.find(arguments[2], "a") or string.find(arguments[2], "s")
		or string.find(arguments[2], "o")) then
			Clockwork.player:Notify(player, "You cannot take 'o', 'a' or 's' flags!");
			
			return;
		end;
		
		Clockwork.player:TakeFlags(target, arguments[2]);
		
		Clockwork.player:NotifyAll(player:Name().." took '"..arguments[2].."' flags from "..target:Name()..".");
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
	end;
end;

Clockwork.command:Register(COMMAND, "CharTakeFlags");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Change the current map.";
COMMAND.text = "<string Map>";
COMMAND.access = "a";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local map = string.lower(arguments[1]);
	
	if (file.Exists("../maps/"..map..".bsp")) then
		Clockwork.player:NotifyAll(player:Name().." is changing the map to "..map.." in 5 seconds!");
		
		timer.Simple(5, RunConsoleCommand, "changelevel", map);
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid map!");
	end;
end;

Clockwork.command:Register(COMMAND, "MapChange");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Restart the current map.";
COMMAND.access = "a";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local map = string.lower(game.GetMap());
	Clockwork.player:NotifyAll(player:Name().." is restarting the map in 5 seconds!");
	
	timer.Simple(5, RunConsoleCommand, "changelevel", map);
end;

Clockwork.command:Register(COMMAND, "MapRestart");

COMMAND = Clockwork.command:New();
COMMAND.tip = "List the Clockwork config variables.";
COMMAND.text = "[string Find]";
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	player:PrintMessage(2, "######## [Clockwork] Config ########");
		local search = arguments[1];
		local config = {};
		
		if (search) then
			search = string.lower(search);
		end;
		
		for k, v in pairs(Clockwork.config.stored) do
			if (type(v.value) != "table" and (!search or string.find(string.lower(k), search))) then
				if (!v.isStatic) then
					if (v.isPrivate) then
						config[#config + 1] = { k, string.rep("*", string.len(tostring(v.value))) };
					else
						config[#config + 1] = { k, tostring(v.value) };
					end;
				end;
			end;
		end;
		
		table.sort(config, function(a, b)
			return a[1] < b[1];
		end);
		
		for k, v in ipairs(config) do
			local adminValues = Clockwork.config:GetFromSystem(v[1]);
			
			if (adminValues) then
				player:PrintMessage(2, "// "..systemValues.help);
			end;
			
			player:PrintMessage(2, v[1].." = \""..v[2].."\";");
		end;
	player:PrintMessage(2, "######## [Clockwork] Config ########");
	
	Clockwork.player:Notify(player, "The config variables have been printed to the console.");
end;

Clockwork.command:Register(COMMAND, "CfgListVars");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Set a Clockwork config variable.";
COMMAND.text = "<string Key> [all Value] [string Map]";
COMMAND.access = "s";
COMMAND.arguments = 1;
COMMAND.optionalArguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local key = arguments[1];
	local value = arguments[2] or "";
	local configObject = Clockwork.config:Get(key);
	
	if (configObject:IsValid()) then
		local keyPrefix = "";
		local useMap = arguments[3];
		
		if (useMap == "") then
			useMap = nil;
		end;
		
		if (useMap) then
			useMap = string.lower(Clockwork:Replace(useMap, ".bsp", ""));
			keyPrefix = useMap.."'s ";
			
			if (!file.Exists("../maps/"..useMap..".bsp")) then
				Clockwork.player:Notify(player, useMap.." is not a valid map!");
				
				return;
			end;
		end;
		
		if (!configObject("isStatic")) then
			value = configObject:Set(value, useMap);
			
			if (value != nil) then
				local printValue = tostring(value);
				
				if (configObject("isPrivate")) then
					if (configObject("needsRestart")) then
						Clockwork.player:NotifyAll(player:Name().." set "..keyPrefix..key.." to '"..string.rep("*", string.len(printValue)).."' for the next restart.");
					else
						Clockwork.player:NotifyAll(player:Name().." set "..keyPrefix..key.." to '"..string.rep("*", string.len(printValue)).."'.");
					end;
				elseif (configObject("needsRestart")) then
					Clockwork.player:NotifyAll(player:Name().." set "..keyPrefix..key.." to '"..printValue.."' for the next restart.");
				else
					Clockwork.player:NotifyAll(player:Name().." set "..keyPrefix..key.." to '"..printValue.."'.");
				end;
			else
				Clockwork.player:Notify(player, key.." was unable to be set!");
			end;
		else
			Clockwork.player:Notify(player, key.." is a static config key!");
		end;
	else
		Clockwork.player:Notify(player, key.." is not a valid config key!");
	end;
end;

Clockwork.command:Register(COMMAND, "CfgSetVar");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Give "..string.lower(NAME_CASH).." to the target character.";
COMMAND.text = "<number "..string.gsub(NAME_CASH, "%s", "")..">";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = player:GetEyeTraceNoCursor().Entity;
	
	if (target and target:IsPlayer()) then
		if (target:GetShootPos():Distance(player:GetShootPos()) <= 192) then
			local cash = tonumber(arguments[1]);
			
			if (cash and cash > 1) then
				cash = math.floor(cash);
				
				if (Clockwork.player:CanAfford(player, cash)) then
					local playerName = player:Name();
					local targetName = target:Name();
					
					if (!Clockwork.player:DoesRecognise(player, target)) then
						targetName = Clockwork.config:Get("unrecognised_name"):Get();
					end;
					
					if (!Clockwork.player:DoesRecognise(target, player)) then
						playerName = Clockwork.config:Get("unrecognised_name"):Get();
					end;
					
					Clockwork.player:GiveCash(player, -cash, targetName);
					Clockwork.player:GiveCash(target, cash, playerName);
				else
					local amount = cash - player:GetCash();
					Clockwork.player:Notify(player, "You need another "..FORMAT_CASH(amount, nil, true).."!");
				end;
			else
				Clockwork.player:Notify(player, "This is not a valid amount!");
			end;
		else
			Clockwork.player:Notify(player, "This character is too far away!");
		end;
	else
		Clockwork.player:Notify(player, "You must look at a valid character!");
	end;
end;

Clockwork.command:Register(COMMAND, "Give"..string.gsub(NAME_CASH, "%s", ""));

COMMAND = Clockwork.command:New();
COMMAND.tip = "Drop "..string.lower(NAME_CASH).." at your target position.";
COMMAND.text = "<number "..string.gsub(NAME_CASH, "%s", "")..">";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor();
	local cash = tonumber(arguments[1]);
	
	if (cash and cash > 1) then
		cash = math.floor(cash);
		
		if (player:GetShootPos():Distance(trace.HitPos) <= 192) then
			if (Clockwork.player:CanAfford(player, cash)) then
				Clockwork.player:GiveCash(player, -cash, Clockwork.option:GetKey("name_cash"));
				
				local entity = Clockwork.entity:CreateCash(player, cash, trace.HitPos);
				
				if (IsValid(entity)) then
					Clockwork.entity:MakeFlushToGround(entity, trace.HitPos, trace.HitNormal);
				end;
			else
				local amount = cash - player:GetCash();
				Clockwork.player:Notify(player, "You need another "..FORMAT_CASH(amount, nil, true).."!");
			end;
		else
			Clockwork.player:Notify(player, "You cannot drop "..string.lower(NAME_CASH).." that far away!");
		end;
	else
		Clockwork.player:Notify(player, "This is not a valid amount!");
	end;
end;

Clockwork.command:Register(COMMAND, "Drop"..string.gsub(NAME_CASH, "%s", ""));

COMMAND = Clockwork.command:New();
COMMAND.tip = "Set your personal message voicemail.";
COMMAND.text = "[string Text]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "o";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (arguments[1] == "none") then
		player:SetCharacterData("Voicemail", nil);
		
		Clockwork.player:Notify(player, "You have removed your voicemail.");
	else
		player:SetCharacterData("Voicemail", arguments[1]);
		
		Clockwork.player:Notify(player, "You have set your voicemail to '"..arguments[1].."'.");
	end;
end;

Clockwork.command:Register(COMMAND, "SetVoicemail");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Set the class of your character.";
COMMAND.text = "<string Class>";
COMMAND.flags = CMD_HEAVY;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local class = Clockwork.class:Get(arguments[1]);
	
	if (player:InVehicle()) then
		Clockwork.player:Notify(player, "You cannot do this action at the moment!");
		
		return;
	end;
	
	if (class) then
		local limit = Clockwork.class:GetLimit(class.name);
		
		if (Clockwork.plugin:Call("PlayerCanBypassClassLimit", player, class.index)) then
			limit = MaxPlayers();
		end;
		
		if (_team.NumPlayers(class.index) >= limit) then
			Clockwork.player:Notify(player, "There are too many characters with this class!");
		else
			local previousTeam = player:Team();
			
			if (player:Team() != class.index) then
				if (Clockwork:HasObjectAccess(player, class)) then
					if (Clockwork.plugin:Call("PlayerCanChangeClass", player, class)) then
						local success, fault = Clockwork.class:Set(player, class.index, nil, true);
						
						if (!success) then
							Clockwork.player:Notify(player, fault);
						end;
					end;
				else
					Clockwork.player:Notify(player, "You do not have access to this class!");
				end;
			end;
		end;
	else
		Clockwork.player:Notify(player, "This is not a valid class!");
	end;
end;

Clockwork.command:Register(COMMAND, "SetClass");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Close the active storage.";
COMMAND.flags = CMD_DEFAULT;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local storageTable = player:GetStorageTable();
	
	if (storageTable) then
		Clockwork.storage:Close(player, true);
	else
		Clockwork.player:Notify(player, "You do not have storage open!");
	end;
end;

Clockwork.command:Register(COMMAND, "StorageClose");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Take some "..string.lower(NAME_CASH).." from storage.";
COMMAND.text = "<number "..string.gsub(NAME_CASH, "%s", "")..">";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local storageTable = player:GetStorageTable();
	
	if (storageTable) then
		local target = storageTable.entity;
		
		if (IsValid(target) and Clockwork.config:Get("cash_enabled"):Get()) then
			local cash = tonumber(arguments[1]);
			
			if (cash and cash > 0) then
				if (cash <= storageTable.cash) then
					if (!storageTable.CanTakeCash or (storageTable.CanTakeCash(player, storageTable, cash) != false)) then
						if (!target:IsPlayer()) then
							Clockwork.player:GiveCash(player, cash, nil, true);
							Clockwork.storage:UpdateCash(player, storageTable.cash - cash);
						else
							Clockwork.player:GiveCash(player, cash, nil, true);
							Clockwork.player:GiveCash(target, -cash, nil, true);
							Clockwork.storage:UpdateCash(player, target:GetCash());
						end;
						
						if (storageTable.OnTakeCash) then
							if (storageTable.OnTakeCash(player, storageTable, cash)) then
								Clockwork.storage:Close(player);
							end;
						end;
					end;
				end;
			end;
		end;
	else
		Clockwork.player:Notify(player, "You do not have storage open!");
	end;
end;

Clockwork.command:Register(COMMAND, "StorageTake"..string.gsub(NAME_CASH, "%s", ""));

COMMAND = Clockwork.command:New();
COMMAND.tip = "Give some "..string.lower(NAME_CASH).." to storage.";
COMMAND.text = "<number "..string.gsub(NAME_CASH, "%s", "")..">";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local storageTable = player:GetStorageTable();
	
	if (storageTable) then
		local target = storageTable.entity;
		
		if (IsValid(target) and Clockwork.config:Get("cash_enabled"):Get()) then
			local cash = tonumber(arguments[1]);
			
			if (cash and cash > 0) then
				if (Clockwork.player:CanAfford(player, cash)) then
					if (!storageTable.CanGiveCash or (storageTable.CanGiveCash(player, storageTable, cash) != false)) then
						if (!target:IsPlayer()) then
							if (Clockwork.storage:GetWeight(player) + (Clockwork.config:Get("cash_weight"):Get() * cash) <= storageTable.weight) then
								Clockwork.player:GiveCash(player, -cash, nil, true);
								Clockwork.storage:UpdateCash(player, storageTable.cash + cash);
							end;
						else
							Clockwork.player:GiveCash(player, -cash, nil, true);
							Clockwork.player:GiveCash(target, cash, nil, true);
							Clockwork.storage:UpdateCash(player, target:GetCash());
						end;
						
						if (storageTable.OnGiveCash) then
							if (storageTable.OnGiveCash(player, storageTable, cash)) then
								Clockwork.storage:Close(player);
							end;
						end;
					end;
				end;
			end;
		end;
	else
		Clockwork.player:Notify(player, "You do not have storage open!");
	end;
end;

Clockwork.command:Register(COMMAND, "StorageGive"..string.gsub(NAME_CASH, "%s", ""));

COMMAND = Clockwork.command:New();
COMMAND.tip = "Take an item from storage.";
COMMAND.text = "<string uniqueID> <string ItemID>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local storageTable = player:GetStorageTable();
	local uniqueID = arguments[1];
	local itemID = tonumber(arguments[2]);
	
	if (storageTable and IsValid(storageTable.entity)) then
		local itemTable = Clockwork.inventory:FindItemByID(
			storageTable.inventory, uniqueID, itemID
		);
		local target = storageTable.entity;
		
		if (!itemTable) then
			Clockwork.player:Notify(player, "The storage does not contain an instance of this item!");
			return;
		end;
		
		if (Clockwork.storage:CanTakeFrom(player, itemTable)) then
			local canTakeStorage = !itemTable.CanTakeStorage or itemTable:CanTakeStorage(player, storageTable);
			if (canTakeStorage == false) then return; end;
			
			canTakeStorage = !storageTable.CanTakeItem or storageTable.CanTakeItem(player, storageTable, itemTable);
			if (canTakeStorage == false) then return; end;
			
			if (!target:IsPlayer()) then
				Clockwork.storage:TakeFrom(player, itemTable);
				
				if (storageTable.OnTake and storageTable.OnTake(player, storageTable, itemTable)) then
					Clockwork.storage:Close(player);
				end;
				
				if (itemTable.OnStorageTake and itemTable:OnStorageTake(player, itemTable)) then
					Clockwork.storage:Close(player);
				end;
			elseif (target:HasItemInstance(itemTable)) then
				local bSuccess = player:GiveItem(itemTable);
				
				if (bSuccess) then
					target:TakeItem(itemTable);
					
					if (storageTable.OnTake and storageTable.OnTake(player, storageTable, itemTable)) then
						Clockwork.storage:Close(player);
					end;
					
					if (itemTable.OnStorageTake and itemTable:OnStorageTake(player, storageTable)) then
						Clockwork.storage:Close(player);
					end;
				
					Clockwork.storage:UpdateWeight(player, target:GetMaxWeight());
				end;
			end;
		end;
	else
		Clockwork.player:Notify(player, "You do not have storage open!");
	end;
end;

Clockwork.command:Register(COMMAND, "StorageTakeItem");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Give an item to storage.";
COMMAND.text = "<string UniqueID> <string ItemID>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local storageTable = player:GetStorageTable();
	local uniqueID = arguments[1];
	local itemID = tonumber(arguments[2]);
	
	if (storageTable and IsValid(storageTable.entity)) then
		local itemTable = player:FindItemByID(uniqueID, itemID);
		local target = storageTable.entity;
		
		if (!itemTable) then
			Clockwork.player:Notify(player, "You do not have an instance of this item!");
			return;
		end;
		
		if (Clockwork.storage:CanGiveTo(player, itemTable)) then
			local canGiveStorage = !itemTable.CanGiveStorage or itemTable:CanGiveStorage(player, storageTable);
			if (canGiveStorage == false) then return; end;
			
			canGiveStorage = !storageTable.CanGiveItem or storageTable.CanGiveItem(player, storageTable, itemTable);
			if (canGiveStorage == false) then return; end;
			
			if (!target:IsPlayer()) then
				local weight = itemTable("storageWeight", itemTable("weight"));
				
				if (Clockwork.storage:GetWeight(player) + math.max(weight, 0) <= storageTable.weight) then
					Clockwork.storage:GiveTo(player, itemTable);
					
					if (storageTable.OnGiveItem and storageTable.OnGiveItem(player, storageTable, itemTable)) then
						Clockwork.storage:Close(player);
					end;
					
					if (itemTable.OnStorageGive and itemTable:OnStorageGive(player, storageTable)) then
						Clockwork.storage:Close(player);
					end;
				end;
			elseif (player:HasItemInstance(itemTable)) then
				local bSuccess = target:GiveItem(itemTable);
				
				if (bSuccess) then
					player:TakeItem(itemTable);
					
					if (storageTable.OnGiveItem and storageTable.OnGiveItem(player, storageTable, itemTable)) then
						Clockwork.storage:Close(player);
					end;
					
					if (itemTable.OnStorageGive and itemTable:OnStorageGive(player, storageTable)) then
						Clockwork.storage:Close(player);
					end;
				
					Clockwork.storage:UpdateWeight(player, target:GetMaxWeight());
				end;
			end;
		end;
	else
		Clockwork.player:Notify(player, "You do not have storage open!");
	end;
end;

Clockwork.command:Register(COMMAND, "StorageGiveItem");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Run an inventory action on an item.";
COMMAND.text = "<string Action> <string UniqueID> [string ItemID]";
COMMAND.flags = CMD_DEFAULT | CMD_FALLENOVER;
COMMAND.arguments = 2;
COMMAND.optionalArguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local itemAction = string.lower(arguments[1]);
	local itemTable = player:FindItemByID(arguments[2], tonumber(arguments[3]));
	
	if (itemTable) then
		local customFunctions = itemTable("customFunctions");
		
		if (customFunctions) then
			for k, v in ipairs(customFunctions) do
				if (string.lower(v) == itemAction) then
					if (itemTable.OnCustomFunction) then
						itemTable:OnCustomFunction(player, v);
						return;
					end;
				end;
			end;
		end;
		
		if (itemAction == "destroy") then
			if (Clockwork.plugin:Call("PlayerCanDestroyItem", player, itemTable)) then
				Clockwork.item:Destroy(player, itemTable);
			end;
		elseif (itemAction == "drop") then
			local position = player:GetEyeTraceNoCursor().HitPos;
			
			if (player:GetShootPos():Distance(position) <= 192) then
				if (Clockwork.plugin:Call("PlayerCanDropItem", player, itemTable, position)) then
					Clockwork.item:Drop(player, itemTable);
				end;
			else
				Clockwork.player:Notify(player, "You cannot drop the item that far away!");
			end;
		elseif (itemAction == "use") then
			if (player:InVehicle() and itemTable("useInVehicle") == false) then
				Clockwork.player:Notify(player, "You cannot use this item in a vehicle!");
				
				return;
			end;
			
			if (Clockwork.plugin:Call("PlayerCanUseItem", player, itemTable)) then
				return Clockwork.item:Use(player, itemTable);
			end;
		else
			Clockwork.plugin:Call("PlayerUseUnknownItemFunction", player, itemTable, itemAction);
		end;
	else
		Clockwork.player:Notify(player, "You do not own this item!");
	end;
end;

Clockwork.command:Register(COMMAND, "InvAction");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Drop your weapon at your target position.";
COMMAND.flags = CMD_DEFAULT | CMD_FALLENOVER;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local weapon = player:GetActiveWeapon();
	
	if (IsValid(weapon)) then
		local class = weapon:GetClass();
		local itemTable = Clockwork.item:GetByWeapon(weapon);
		
		if (itemTable) then
			if (Clockwork.plugin:Call("PlayerCanDropWeapon", player, itemTable, weapon)) then
				local trace = player:GetEyeTraceNoCursor();
				
				if (player:GetShootPos():Distance(trace.HitPos) <= 192) then
					local entity = Clockwork.entity:CreateItem(player, itemTable, trace.HitPos);
					
					if (IsValid(entity)) then
						Clockwork.entity:MakeFlushToGround(entity, trace.HitPos, trace.HitNormal);
							player:TakeItem(itemTable, true);
							player:StripWeapon(class);
							player:SelectWeapon("cw_hands");
						Clockwork.plugin:Call("PlayerDropWeapon", player, itemTable, entity, weapon);
					end;
				else
					Clockwork.player:Notify(player, "You cannot drop your weapon that far away!");
				end;
			end;
		else
			Clockwork.player:Notify(player, "This is not a valid weapon!");
		end;
	else
		Clockwork.player:Notify(player, "This is not a valid weapon!");
	end;
end;

Clockwork.command:Register(COMMAND, "DropWeapon");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Order an item shipment at your target position.";
COMMAND.text = "<string Item>";
COMMAND.flags = CMD_DEFAULT | CMD_FALLENOVER;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local itemTable = Clockwork.item:FindByID(arguments[1]);
	
	if (itemTable and itemTable:CanBeOrdered()) then
		itemTable = Clockwork.item:CreateInstance(arguments[1]);
		
		if (Clockwork:HasObjectAccess(player, itemTable)) then
			Clockwork.plugin:Call("PlayerAdjustOrderItemTable", player, itemTable);
			
			if (Clockwork.plugin:Call("PlayerCanOrderShipment", player, itemTable)) then
				if (Clockwork.player:CanAfford(player, itemTable("cost") * itemTable("batch"))) then
					if (itemTable.CanOrder and itemTable:CanOrder(player, v) == false) then
						return;
					end;
					
					if (itemTable("batch") > 1) then
						Clockwork.player:GiveCash(player, -(itemTable("cost") * itemTable("batch")), itemTable("batch").." "..Clockwork:Pluralize(itemTable("name")));
						Clockwork:PrintLog(LOGTYPE_MINOR, player:Name().." has ordered "..itemTable("batch").." "..Clockwork:Pluralize(itemTable("name"))..".");
					else
						Clockwork.player:GiveCash(player, -(itemTable("cost") * itemTable("batch")), itemTable("batch").." "..itemTable("name"));
						Clockwork:PrintLog(LOGTYPE_MINOR, player:Name().." has ordered "..itemTable("batch").." "..itemTable("name")..".");
					end;
					
					local trace = player:GetEyeTraceNoCursor();
					local entity = nil;
					
					if (itemTable.OnCreateShipmentEntity) then
						entity = itemTable:OnCreateShipmentEntity(player, itemTable("batch"), trace.HitPos);
					end;
					
					if (!IsValid(entity)) then
						if (itemTable("batch") > 1) then
							entity = Clockwork.entity:CreateShipment(player, itemTable("uniqueID"), itemTable("batch"), trace.HitPos);
						else
							entity = Clockwork.entity:CreateItem(player, itemTable, trace.HitPos);
						end;
					end;
					
					if (IsValid(entity)) then
						Clockwork.entity:MakeFlushToGround(entity, trace.HitPos, trace.HitNormal);
					end;
					
					if (itemTable.OnOrder) then
						itemTable:OnOrder(player, entity);
					end;
					
					Clockwork.plugin:Call("PlayerOrderShipment", player, itemTable, entity);
					player.cwNextOrderTime = CurTime() + (2 * itemTable("batch"));
					
					umsg.Start("cwOrderTime", player);
						umsg.Long(player.cwNextOrderTime);
					umsg.End();
				else
					local amount = (itemTable("cost") * itemTable("batch")) - player:GetCash();
					Clockwork.player:Notify(player, "You need another "..FORMAT_CASH(amount, nil, true).."!");
				end;
			end;
		else
			Clockwork.player:Notify(player, "You not have access to order this item!");
			
			return false;
		end;
	else
		Clockwork.player:Notify(player, "This item is not available for order!");
	end;
end;

Clockwork.command:Register(COMMAND, "OrderShipment");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Get your character up from the floor.";
COMMAND.flags = CMD_DEFAULT;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (player:GetRagdollState() == RAGDOLL_FALLENOVER and player:GetSharedVar("FallenOver")) then
		if (Clockwork.plugin:Call("PlayerCanGetUp", player)) then
			Clockwork.player:SetUnragdollTime(player, 5);
			
			player:SetSharedVar("FallenOver", false);
		end;
	end;
end;

Clockwork.command:Register(COMMAND, "CharGetUp");

--[[ 
	Removing this command will make your serial key
	become invalid. Remove this command at your own risk
	but do not complain when your serial key gets banned.
--]]

COMMAND = Clockwork.command:New();
COMMAND.tip = "Find out the license holder of this Clockwork schema.";
COMMAND.flags = CMD_DEFAULT;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (player:SteamID() == "STEAM_0:1:8387555") then
		Clockwork.player:Notify(player, "The license holder of this Clockwork schema is "..Clockwork:GetLicenseHolder()..".");
	else
		Clockwork.player:Notify(player, "You do not have the authority to view the license holder.");
	end;
end;

Clockwork.command:Register(COMMAND, "License");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Make your character fall to the floor.";
COMMAND.text = "[number Seconds]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.optionalArguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local curTime = CurTime();
	
	if (!player.cwNextFallTime or curTime >= player.cwNextFallTime) then
		player.cwNextFallTime = curTime + 5;
		
		if (!player:InVehicle()) then
			local seconds = tonumber(arguments[1]);
			
			if (seconds) then
				seconds = math.Clamp(seconds, 2, 30);
			elseif (seconds == 0) then
				seconds = nil;
			end;
			
			if (!player:IsRagdolled()) then
				Clockwork.player:SetRagdollState(player, RAGDOLL_FALLENOVER, seconds);
				
				player:SetSharedVar("FallenOver", true);
			end;
		else
			Clockwork.player:Notify(player, "You cannot do this action at the moment!");
		end;
	end;
end;

Clockwork.command:Register(COMMAND, "CharFallOver");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Attempt to load a plugin.";
COMMAND.text = "<string Name>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local plugin = Clockwork.plugin:FindByID(arguments[1]);
	
	if (plugin) then
		if (!Clockwork.plugin:IsDisabled(plugin.name)) then
			local success = Clockwork.plugin:SetUnloaded(plugin.name, false);
			local recipients = {};
			
			if (success) then
				Clockwork.player:NotifyAll(player:Name().." has loaded the "..plugin.name.." plugin for the next restart.");
				
				for k, v in ipairs(_player.GetAll()) do
					if (v:HasInitialized()) then
						if (Clockwork.player:HasFlags(v, loadTable.access)
						or Clockwork.player:HasFlags(v, unloadTable.access)) then
							recipients[#recipients + 1] = v;
						end;
					end;
				end;
				
				if (#recipients > 0) then
					Clockwork:StartDataStream(recipients, "AdminMntSet", {plugin.name, false});
				end;
			else
				Clockwork.player:Notify(player, "This plugin could not be loaded!");
			end;
		else
			Clockwork.player:Notify(player, "This plugin depends on another plugin!");
		end;
	else
		Clockwork.player:Notify(player, "This plugin is not valid!");
	end;
end;

Clockwork.command:Register(COMMAND, "PluginLoad");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Attempt to unload a plugin.";
COMMAND.text = "<string Name>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local plugin = Clockwork.plugin:FindByID(arguments[1]);
	
	if (plugin) then
		if (!Clockwork.plugin:IsDisabled(plugin.name)) then
			local success = Clockwork.plugin:SetUnloaded(plugin.name, true);
			local recipients = {};
			
			if (success) then
				Clockwork.player:NotifyAll(player:Name().." has unloaded the "..plugin.name.." plugin for the next restart.");
				
				for k, v in ipairs(_player.GetAll()) do
					if (v:HasInitialized()) then
						if (Clockwork.player:HasFlags(v, loadTable.access)
						or Clockwork.player:HasFlags(v, unloadTable.access)) then
							recipients[#recipients + 1] = v;
						end;
					end;
				end;
				
				if (#recipients > 0) then
					Clockwork:StartDataStream(recipients, "AdminMntSet", {plugin.name, true});
				end;
			else
				Clockwork.player:Notify(player, "This plugin could not be unloaded!");
			end;
		else
			Clockwork.player:Notify(player, "This plugin depends on another plugin!");
		end;
	else
		Clockwork.player:Notify(player, "This plugin is not valid!");
	end;
end;

Clockwork.command:Register(COMMAND, "PluginUnload");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Send a radio message out to other characters.";
COMMAND.text = "<string Text>";
COMMAND.flags = CMD_DEFAULT | CMD_DEATHCODE | CMD_FALLENOVER;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	Clockwork.player:SayRadio(player, table.concat(arguments, " "), true);
end;

Clockwork.command:Register(COMMAND, "Radio");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Send an event to all characters.";
COMMAND.text = "<string Text>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	Clockwork.chatBox:Add(nil, player, "event",  table.concat(arguments, " "));
end;

Clockwork.command:Register(COMMAND, "Event");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Roll a number between 0 and 100.";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	Clockwork.chatBox:AddInRadius(player, "roll", "has rolled "..math.random(0, 100).." out of 100.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get());
end;

Clockwork.command:Register(COMMAND, "Roll");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Yell to characters near you.";
COMMAND.text = "<string Text>";
COMMAND.flags = CMD_DEFAULT | CMD_DEATHCODE;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local text = table.concat(arguments, " ");
	
	if (text == "") then
		Clockwork.player:Notify(player, "You did not specify enough text!");
		
		return;
	end;
	

	Clockwork.chatBox:AddInRadius(player, "yell", text, player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
end;

Clockwork.command:Register(COMMAND, "Y");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Describe a local action or event.";
COMMAND.text = "<string Text>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local text = table.concat(arguments, " ");
	
	if (string.len(text) < 8) then
		Clockwork.player:Notify(player, "You did not specify enough text!");
		
		return;
	end;
	

	Clockwork.chatBox:AddInTargetRadius(player, "it", text, player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
end;

Clockwork.command:Register(COMMAND, "It");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Speak in third person to others around you.";
COMMAND.text = "<string Text>";
COMMAND.flags = CMD_DEFAULT | CMD_DEATHCODE;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local text = table.concat(arguments, " ");
	
	if (text == "") then
		Clockwork.player:Notify(player, "You did not specify enough text!");
		
		return;
	end;
	

	Clockwork.chatBox:AddInTargetRadius(player, "me", string.gsub(text, "^.", string.lower), player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
end;

Clockwork.command:Register(COMMAND, "Me");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Whisper to characters near you.";
COMMAND.text = "<string Text>";
COMMAND.flags = CMD_DEFAULT | CMD_DEATHCODE;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local talkRadius = math.min(Clockwork.config:Get("talk_radius"):Get() / 3, 80);
	local text = table.concat(arguments, " ");
	
	if (text == "") then
		Clockwork.player:Notify(player, "You did not specify enough text!");
		
		return;
	end;
	
	Clockwork.chatBox:AddInRadius(player, "whisper", text, player:GetPos(), talkRadius);
end;

Clockwork.command:Register(COMMAND, "W");

if (SERVER) then
	concommand.Add("cwStatus", function(player, command, arguments)
		if (IsValid(player)) then
			if (Clockwork.player:IsAdmin(player)) then
				player:PrintMessage(2, "# User ID | Name | Steam Name | Steam ID | IP Address");
				
				for k, v in ipairs(_player.GetAll()) do
					if (v:HasInitialized()) then
						local status = Clockwork.plugin:Call("PlayerCanSeeStatus", player, v);
						
						if (status) then
							player:PrintMessage(2, status);
						end;
					end;
				end;
			else
				player:PrintMessage(2, "You do not have access to this command, "..player:Name()..".");
			end;
		else
			print("# User ID | Name | Steam Name | Steam ID | IP Address");
			
			for k, v in ipairs(_player.GetAll()) do
				if (v:HasInitialized()) then
					print("# "..v:UserID().." | "..v:Name().." | "..v:SteamName().." | "..v:SteamID().." | "..v:IPAddress());
				end;
			end;
		end;
	end);
	
	concommand.Add("cwStartDS", function(player, command, arguments)
		local name = arguments[1];
		local index = tonumber(arguments[2]);
		
		if (name and index) then
			player.cwDataStreamName = name;
			player.cwDataStreamData = "";
			player.cwDataStreamIdx = index;
		end;
	end);
	
	concommand.Add("cwDataDS", function(player, command, arguments)
		if (player.cwDataStreamName and player.cwDataStreamData and player.cwDataStreamIdx) then
			local data = arguments[1];
			local index = tonumber(arguments[2]);
			local replaceTable = { ["\\"] = "\\", ["n"] = "\n" };
			
			if (data and index) then
				player.cwDataStreamData = player.cwDataStreamData..data;
				
				if (player.cwDataStreamIdx == index) then
					player.cwDataStreamData = string.gsub(player.cwDataStreamData, "\\(.)", replaceTable);
					
					if (Clockwork.DataStreamHooks[player.cwDataStreamName]) then
						Clockwork.DataStreamHooks[player.cwDataStreamName](player, glon.decode(player.cwDataStreamData));
					end;
					
					player.cwDataStreamName = nil;
					player.cwDataStreamData = nil;
					player.cwDataStreamIdx = nil;
				end;
			end;
		end;
	end);

	concommand.Add("cwDeathCode", function(player, command, arguments)
		if (player.cwDeathCodeIdx) then
			if (arguments and tonumber(arguments[1]) == player.cwDeathCodeIdx) then
				player.cwDeathCodeAuth = true;
			end;
		end;
	end);
end;