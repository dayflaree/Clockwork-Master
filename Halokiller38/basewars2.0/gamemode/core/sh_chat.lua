--[[
	2011 Slidefuse Networks; Do NOT Share/Distribute/Modify
	Author: Spencer Sharkey (spencer@sf-n.com)
--]]

RP.chat = {};

if (SERVER) then
	
	-- A function that's called when chat should be parsed
	function RP.chat:ParseSayText(player, text, playerTeam)
		local icon = nil;
		if (player:HasFlag("a")) then
			icon = "gui/silkicons/shield";
		end;
		self:Add(_player.GetAll(), {team.GetColor(player:Team()), player:Name(), Color(255, 255, 225), ": "..text}, icon);
	end;
	
	-- A server function that'll add chat to a player's winow
	function RP.chat:Add(player, text, icon, sound)
		RP:DataStream(player, "ChatAdd", {text=text, icon=icon or nil, sound=sound or nil});
	end;

	
	
else
	
	RP:DataHook("ChatAdd", function(data)
		RP.chatbox:AddLine(data.text, data.icon, data.sound);
	end);
	
	function RP.chat:Add(text, icon, sound)
		RP.chatbox:AddLine(text, icon, sound);
	end;

	function RP:ChatText(pID, pName, text, filter)		
		if (filter == "none") then
			RP.chat:Add({Color(200, 246, 255), text}, "gui/silkicons/plugin");
		elseif (filter == "Console") then
			RP.chat:Add({Color(251, 164, 255), text}, "gui/silkicons/shield");
		end;
		
		return true;
	end;

	
end;