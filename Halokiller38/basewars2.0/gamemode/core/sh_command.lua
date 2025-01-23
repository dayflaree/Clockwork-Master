RP.Command = {};

RP.Command.commands = {};

function RP.Command:New(commandName, data)
	self.commands[string.lower(commandName)] = data;
	self.commands[string.lower(commandName)].niceName = commandName;
end;

function RP.Command:Get(commandName)
	for k, v in pairs(self.commands) do
		if (string.lower(commandName) == string.lower(k)) then
			return v;
		end;
	end;
	return false;
end;

if (SERVER) then

	function RP.Command:ParseSayText(player, text)
		if (string.sub(text, 1, 1) == "/") then
			text = string.sub(text, 2);
		else
			return false;
		end;
		
		local arguments = string.Explode(" ", text)
		local command = table.remove(arguments, 1);
		
		if (!self:VerifyCommand(player, command, arguments)) then
			return true;
		end;
		
		player:ConCommand("rp "..text);
		return true;
	end;

	function RP.Command:VerifyCommand(player, command, arguments)
		local commandTable = self:Get(command);
		
		if (!commandTable) then
			player:Notify("Invalid Command!");
			return false;
		end;
		
		if (commandTable.flag) then
			if (!player:HasFlag(commandTable.flag)) then
				player:Notify("You do not have access to that command!");
				return false;
			end;
		end;
		
		-- This was replaced by the super-cool new way to find arguments :3
		-- local commandTable = self:Get(command);
		-- if (#arguments != commandTable.arguments) then
			-- player:Notify("/"..command.." "..commandTable.help.."!");
			-- return false;
		-- end;
		
		return true;
		
	end;
	
	function RP.Command:GenerateHelp(command)
		local commandTable = self:Get(command);
		local returnString = "";
		if (command) then
			for k, v in pairs(commandTable.arguments) do
				local argType = v[1];
				local argName = v[2];
				
				returnString = returnString.."<"..string.lower(argType).." "..argName.."> ";
			end;
		end;
		return string.sub(returnString, 1, -2);
	end;
	
	function RP.Command:GetArgumentTable(player, command, arguments)
		local commandTable = self:Get(command);
		
		
		if (#commandTable.arguments > 1) then
			local lastArgument = commandTable.arguments[#commandTable.arguments];
			if (lastArgument[1] == "String") then
				local lastString = "";
				for k, v in pairs(arguments) do
					if (k >= #commandTable.arguments) then
						lastString = lastString.." "..v;
					end;
				end;
				lastString = string.sub(lastString, 2);
				arguments[#commandTable.arguments] = lastString;
			end;
		end;
		
		local argumentTable = {};
		
		if (#commandTable.arguments == 1) then
			local v = commandTable.arguments[1];
			local argType = v[1];
			local argName = v[2];
			
			argumentTable[1] = table.concat(arguments, " ");
			argumentTable[argName] = table.concat(arguments, " ");
			return argumentTable;
		end;
		
		for k, v in pairs(commandTable.arguments) do
			local argType = v[1];
			local argName = v[2];
				
			if (!arguments[k]) then
				return false;
			end;
			
			if (string.lower(arguments[k]) == "true") then
				arguments[k] = true;
			elseif (string.lower(arguments[k]) == "false") then
				arguments[k] = false;
			end;
			
			if (string.lower(argType) == "player") then
				local target = RP:FindPlayer(arguments[k]);
				if (!target) then
					player:Notify("Could not find anyone with the name of '"..arguments[k].."' in Argument <"..string.lower(argType).." "..argName..">!");
					return false;
				end;
				argumentTable[k] = target;
			elseif (string.lower(argType) == "bool") then
				if (type(arguments[k]) == "boolean") then
					argumentTable[k] = arguments[k];
				else
					return false;
				end;
			elseif (string.lower(argType) == "number") then
				if (tonumber(arguments[k])) then
					argumentTable[k] = tonumber(arguments[k]);
				else
					return false;
				end;
			else
				if (type(arguments[k]) == string.lower(argType)) then
					argumentTable[k] = arguments[k];
				else
					return false;
				end;
			end;
			argumentTable[argName] = argumentTable[k];
		end;
		
		if (#argumentTable != #commandTable.arguments) then
			return false;
		end;
		
		return argumentTable;
	end;
	
	function RP.Command:Run(player, command, arguments)
		if (self:VerifyCommand(player, command, arguments)) then
			if (!arguments) then
				arguments = {};
			end;
			print("Player "..player:Name().." ran command: "..command.." "..table.concat(arguments, " "));
			local commandTable = self.commands[string.lower(command)];
			local argumentTable = self:GetArgumentTable(player, command, arguments);
			if (argumentTable) then
				self.commands[string.lower(command)]:OnRun(player, argumentTable);
			else
				player:Notify("/"..command.." "..self:GenerateHelp(command).."!");
			end;
		else
			return;
		end;
	end;
		
	concommand.Add("rp", function(player, cmd, arguments)
		local command = table.remove(arguments, 1);
		RP.Command:Run(player, command, arguments);
	end);
		
else
	function RP.Command:Run(command, ...)
		local arguments = {...}
		RunConsoleCommand("rp", command, unpack(arguments));
	end;
end;