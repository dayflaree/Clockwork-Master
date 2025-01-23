RP.command = {};

RP.command.commands = {};

function RP.command:New(commandName, data)
	self.commands[string.lower(commandName)] = data;
	self.commands[string.lower(commandName)].niceName = commandName;
end;

function RP.command:Get(commandName)
	for k, v in pairs(self.commands) do
		if (string.lower(commandName) == string.lower(k)) then
			return v;
		end;
	end;
	return false;
end;

if (SERVER) then

	function RP.command:ParseSayText(player, text)
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

	function RP.command:VerifyCommand(player, command, arguments)

		if (!self:Get(command)) then
			player:Notify("Invalid Command!");
			return false;
		end;
		
		local commandTable = self:Get(command);
		if (#arguments != commandTable.arguments) then
			player:Notify("/"..command.." "..commandTable.help.."!");
			return false;
		end;
		
		return true;
		
	end;
	
	function RP.command:Run(player, command, arguments)
		if (self:VerifyCommand(player, command, arguments)) then
			print("Player "..player:Name().." ran command: "..command.." "..table.concat(arguments, " "));
			self.commands[string.lower(command)]:OnRun(player, arguments);
		else
			return;
		end;
	end;
		
	concommand.Add("rp", function(player, cmd, arguments)
		local command = table.remove(arguments, 1);
		RP.command:Run(player, command, arguments);
	end);
		
else
	function RP.command:Run(command, ...)
		local arguments = {...}
		RunConsoleCommand("rp", command, unpack(arguments));
	end;
end;