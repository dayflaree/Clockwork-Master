local PLUGIN = PLUGIN;
local Clockwork = Clockwork;
local playerMeta = FindMetaTable("Player")

util.AddNetworkString("chatMessage");

Clockwork.config:Add("enable_ooc", true);
Clockwork.config:Add("admin_super_ooc", true);
Clockwork.config:Add("staff_respect_interval", true)
Clockwork.config:Add("operator_super_ooc", false)
Clockwork.config:Add("admin_interval", 20)
Clockwork.config:Add("admin_echoes", true)
Clockwork.config:Add("ooc_enable", true)

echo = Clockwork.config:Get("admin_echoes")

function playerMeta:GetTempFlags()
	return self:GetCharacterData("tempFlags") or false;
end;

function playerMeta:GetTempFlagsInfo()
	local playerFlags = self:GetTempFlags();
	if !playerFlags then return false; end;
	local flagData = {}
	for k, v in pairs (playerFlags) do
		if type(v) != "number" then return; end;
		local timeLeft = v - os.time();
		local timeUnit = "minutes";
		if timeLeft < 60 then
			timeUnit = "seconds";
		else
			timeLeft = math.Round(((v - os.time()) / 60), 2);
		end;
		table.insert(flagData, "'"..k.."' Flag - Expires in "..timeLeft.." "..timeUnit..".");
	end;
	return flagData;
end;

function playerMeta:GiveTempFlags(flags, duration, giver, bSilent)
	local playerFlags = self:GetCharacterData("tempFlags") or {}
	for i = 1, #flags do
		local flag = string.sub(flags, i, i);
		Clockwork.plugin:Call("PlayerFlagsGiven", self, flag);
		playerFlags[flag] = os.time() + duration;
	end;
	self:SetCharacterData("tempFlags", playerFlags);
	if bSilent then return; end;
	if IsValid(giver) then
		Clockwork.player:NotifyAll(self:Name().." was given '"..flags.."' flags for "..(duration / 60).." minutes, by "..giver:GetName()..".");
	else
		Clockwork.player:NotifyAll(self:Name().." was given '"..flags.."' flags for "..(duration / 60).." minutes, by an unknown admin.");
	end;
end;

function playerMeta:TakeTempFlags(flags, taker, bSilent)
	local playerFlags = self:GetCharacterData("tempFlags") or {}
	for i = 1, #flags do
		local flag = string.sub(flags, i, i);
		for k, v in pairs (playerFlags) do
			if k == flag then
				playerFlags[k] = nil;
			end;
			if !Clockwork.player:HasFlags(self, flag) then
				Clockwork.plugin:Call("PlayerFlagsTaken", self, flag);
			end;
		end;
	end;
	if table.Count(playerFlags) != 0 then
		self:SetCharacterData("tempFlags", playerFlags);
	else
		self:SetCharacterData("tempFlags", nil);
	end;
	if bSilent then return; end;
	if IsValid(taker) then
		Clockwork.player:NotifyAll(self:Name().." was taken '"..flags.."' temp flags, by "..taker:GetName()..".")
	else
		Clockwork.player:NotifyAll(self:Name().." was taken '"..flags.."' temp flags, by an unknown admin.")
	end;
end;

-- A shortcut to Clockwork.player:Notify(player, text, class)
function playerMeta:Notify(text, class)
	Clockwork.player:Notify(self, text, class)
end

-- A function to send a gimp message.
function playerMeta:SendGimp(chatType)
	if #PLUGIN.gimps.stored > 0 then
		local text
		local gimp = PLUGIN.gimps.stored[math.random(1, #PLUGIN.gimps.stored)]
		local gimpText = gimp.text
		local gimpDisplay = ""
		local curTime = CurTime();

		if gimp.bShowIsGimp then
			gimpDisplay = "GIMP: "
		end

		text = gimpDisplay..gimpText
		if chatType == "ooc" or chatType == "looc" then
			Clockwork.kernel:ServerLog("["..string.upper(chatType).."] "..self:Name()..": "..text);
		end
		if chatType == "ic" then
			Clockwork.chatBox:AddInRadius(self, "ic", text, self:GetPos(), Clockwork.config:Get("talk_radius"):Get());
		elseif chatType == "looc" then
			Clockwork.chatBox:AddInRadius(self, "looc", text, self:GetPos(), Clockwork.config:Get("talk_radius"):Get());
		elseif chatType == "ooc" then
			Clockwork.chatBox:Add(nil, self, chatType, text);
		else
			Clockwork.chatBox:Add(nil, self, chatType, text);
		end
		if chatType == "ooc" then
			self.cwNextTalkOOC = curTime + Clockwork.config:Get("ooc_interval"):Get();
		end
	else
		text = "GIMP: lol how do i talk"
		if chatType == "ooc" or chatType == "looc" then
			Clockwork.kernel:ServerLog("["..string.upper(chatType).."] "..self:Name()..": "..text);
		end
		if chatType == "ic" then
			Clockwork.chatBox:AddInRadius(self, "ic", text, self:GetPos(), Clockwork.config:Get("talk_radius"):Get());
		elseif chatType == "looc" then
			Clockwork.chatBox:AddInRadius(self, "looc", text, self:GetPos(), Clockwork.config:Get("talk_radius"):Get());
		elseif chatType == "ooc" then
			Clockwork.chatBox:Add(nil, self, chatType, text);
		else
			Clockwork.chatBox:Add(nil, self, chatType, text);
		end
		if chatType == "ooc" then
			self.cwNextTalkOOC = curTime + Clockwork.config:Get("ooc_interval"):Get();
		end
	end
end

-- A function to check whether or not there is an admin online.
function PLUGIN:AnyAdminOnline()
	local count = 0
	for k, v in pairs (player.GetAll()) do
		if Clockwork.player:IsAdmin(v) then
			count = count + 1
		end
	end
	return count > 0;
end

--[[
function PLUGIN:SaveReportLog(player, text)
	if (IsValid(player) and text) then
		Clockwork.kernel:SetupFullDirectory("NoMoreULX Reports/"..os.date("%d %B %Y").."/"..Schema:GetName().."/"..game.GetMap())
		Clockwork.file:Write("NoMoreULX Reports/"..os.date("%d %B %Y").."/"..Schema:GetName().."/"..game.GetMap().."/"..os.date("%H%M%S")..player:GetCharacterKey()..".txt", "Date of the Report: "..os.date("%d %B %Y").."\nTime of the Report: "..os.date("%H:%M").."\n\nCharacter Name: "..player:Name().."\nCharacter Faction: "..player:GetFaction().."\n\nSteam Name: "..player:SteamName().."\nSteamID: "..player:SteamID().."\n\nWere admins online: "..tostring(PLUGIN:AnyAdminOnline()).."\n\n--Body of the Report: \n\n"..text)
	end;
end;
--]]

-- A function that overrides default commands to adapt them to this plugin
function PLUGIN:PatchOriginalCode()
	local COMMAND = Clockwork.command:New("It");
	COMMAND.tip = "Describe a local action or event.";
	COMMAND.text = "<string Text>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local text = table.concat(arguments, " ");
		
		if player.muted then
			Clockwork.player:Notify(player, "You are muted!");
			return;
		end
		if player.icmuted then
			Clockwork.player:Notify(player, "Your In-character chat is muted!");
			return;
		end

		if player.gimped then
			if #PLUGIN.gimps.stored > 0 then
				local gimp = PLUGIN.gimps.stored[math.random(1, #PLUGIN.gimps.stored)]
				local gimpText = gimp.text
				local gimpDisplay = ""
				if gimp.bShowIsGimp then
					gimpDisplay = "GIMP: "
				end

				text = gimpDisplay..gimpText
			else
				text = "GIMP: lol how do i talk"
			end
		end

		if (string.len(text) < 8) then
			Clockwork.player:Notify(player, "You did not specify enough text!");
			
			return;
		end;

		Clockwork.chatBox:AddInTargetRadius(player, "it", text, player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
	end;

	COMMAND:Register();

	COMMAND = Clockwork.command:New("Me");
	COMMAND.tip = "Speak in third person to others around you.";
	COMMAND.text = "<string Text>";
	COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_DEATHCODE);
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local text = table.concat(arguments, " ");
		
		if player.muted then
			Clockwork.player:Notify(player, "You are muted!");
			return;
		end
		if player.icmuted then
			Clockwork.player:Notify(player, "Your In-character chat is muted!");
			return;
		end

		if player.gimped then
			if #PLUGIN.gimps.stored > 0 then
				local gimp = PLUGIN.gimps.stored[math.random(1, #PLUGIN.gimps.stored)]
				local gimpText = gimp.text
				local gimpDisplay = ""
				if gimp.bShowIsGimp then
					gimpDisplay = "GIMP: "
				end

				text = gimpDisplay..gimpText
			else
				text = "GIMP: lol how do i talk"
			end
		end
		
		if (text == "") then
			Clockwork.player:Notify(player, "You did not specify enough text!");
			
			return;
		end;

		Clockwork.chatBox:AddInTargetRadius(player, "me", string.gsub(text, "^.", string.lower), player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
	end;

	COMMAND:Register();

	COMMAND = Clockwork.command:New("W");
	COMMAND.tip = "Whisper to characters near you.";
	COMMAND.text = "<string Text>";
	COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_DEATHCODE);
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local talkRadius = math.min(Clockwork.config:Get("talk_radius"):Get() / 3, 80);
		local text = table.concat(arguments, " ");
		
		if player.muted then
			Clockwork.player:Notify(player, "You are muted!");
			return;
		end
		if player.icmuted then
			Clockwork.player:Notify(player, "Your In-character chat is muted!");
			return;
		end

		if player.gimped then
			if #PLUGIN.gimps.stored > 0 then
				local gimp = PLUGIN.gimps.stored[math.random(1, #PLUGIN.gimps.stored)]
				local gimpText = gimp.text
				local gimpDisplay = ""
				if gimp.bShowIsGimp then
					gimpDisplay = "GIMP: "
				end

				text = gimpDisplay..gimpText
			else
				text = "GIMP: lol how do i talk"
			end
		end
		
		if (text == "") then
			Clockwork.player:Notify(player, "You did not specify enough text!");
			
			return;
		end;
		
		Clockwork.chatBox:AddInRadius(player, "whisper", text, player:GetPos(), talkRadius);
	end;

	COMMAND:Register();

	COMMAND = Clockwork.command:New("Y");
	COMMAND.tip = "Yell to characters near you.";
	COMMAND.text = "<string Text>";
	COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_DEATHCODE);
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local text = table.concat(arguments, " ");
		
		if player.muted then
			Clockwork.player:Notify(player, "You are muted!");
			return;
		end
		if player.icmuted then
			Clockwork.player:Notify(player, "Your In-character chat is muted!");
			return;
		end

		if player.gimped then
			if #PLUGIN.gimps.stored > 0 then
				local gimp = PLUGIN.gimps.stored[math.random(1, #PLUGIN.gimps.stored)]
				local gimpText = gimp.text
				local gimpDisplay = ""
				if gimp.bShowIsGimp then
					gimpDisplay = "GIMP: "
				end

				text = gimpDisplay..gimpText
			else
				text = "GIMP: lol how do i talk"
			end
		end
		
		if (text == "") then
			Clockwork.player:Notify(player, "You did not specify enough text!");
			
			return;
		end;
		
		Clockwork.chatBox:AddInRadius(player, "yell", text, player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
	end;

	COMMAND:Register();

	COMMAND = Clockwork.command:New("Radio");
	COMMAND.tip = "Send a radio message out to other characters.";
	COMMAND.text = "<string Text>";
	COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_DEATHCODE, CMD_FALLENOVER);
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local text = table.concat(arguments, " ");

		if player.muted then
			Clockwork.player:Notify(player, "You are muted!");
			return;
		end
		if player.icmuted then
			Clockwork.player:Notify(player, "Your In-character chat is muted!");
			return;
		end

		if player.gimped then
			if #PLUGIN.gimps.stored > 0 then
				local gimp = PLUGIN.gimps.stored[math.random(1, #PLUGIN.gimps.stored)]
				local gimpText = gimp.text
				local gimpDisplay = ""
				if gimp.bShowIsGimp then
					gimpDisplay = "GIMP: "
				end

				text = gimpDisplay..gimpText
			else
				text = "GIMP: lol how do i talk"
			end
		end

		Clockwork.player:SayRadio(player, text, true);
	end;

	COMMAND:Register();

	COMMAND = Clockwork.command:New("CharFallOver");
	COMMAND.tip = "Make your character fall to the floor.";
	COMMAND.text = "[number Seconds]";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.optionalArguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local curTime = CurTime();
		
		if player:IsFrozen() then
			player:Notify("You cannot do this action at the moment!")
			return;
		end

		if (!player.cwNextFallTime or curTime >= player.cwNextFallTime) then
			player.cwNextFallTime = curTime + 5;
			
			if (!player:InVehicle() and !Clockwork.player:IsNoClipping(player)) then
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

	COMMAND:Register();
end;