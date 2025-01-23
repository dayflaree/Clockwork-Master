local PLUGIN = PLUGIN;

function PLUGIN:PlayerChat(player, text, public)
	if (!public) then
		RP.Command:Run(player, "party", {text});
		return false;
	end;
	local icon = "gui/silkicons/user";
	if (player:HasFlag("a")) then
		icon = "gui/silkicons/shield";
	end;
	
	local listeners = {};
	for _, v in pairs(ents.FindInSphere(player:GetPos(), 450)) do
		if (v:IsPlayer() and v:Alive() and v:IsValid()) then
			table.insert(listeners, v);
		end;
	end;
	
	chatTable = {Color(100, 100, 175), " [LOCAL] ", team.GetColor(player:Team()), player:Name(), Color(255, 255, 225), ": "..text};
	
	if (player:Alive()) then
		RP.chat:Add(listeners, chatTable, icon);
	else
		player:Notify("You can not talk while you are dead!");
	end;
	
	return false;
end;

function PLUGIN:PlayerChatPreCommand(player, text, public)
	if (string.sub(text, 1, 2) == "//") then
		RP.Command:Run(player, "/", {string.sub(text, 3)});
		return false;
	end;
end;

function PLUGIN:PlayerCanHearPlayersVoice(listener, speaker)
	if (listener:GetPos():Distance( speaker:GetPos() ) > 450) then
		return false;
	end;
	return true, true;
end