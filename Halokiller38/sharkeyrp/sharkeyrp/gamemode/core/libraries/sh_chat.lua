RP.chat = {};

if (SERVER) then
	
	function RP.chat:ParseSayText(player, text, team)
		self:Add(_player.GetAll(), {Color(130, 255, 80), player:Name(), Color(255, 255, 220), ": "..text}, "gui/silkicons/shield");
	end;
	
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

end;