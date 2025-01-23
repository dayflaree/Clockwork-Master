--[[
	© 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local PLUGIN = PLUGIN;

local CREATE_MESSAGES_TABLE = [[
CREATE TABLE IF NOT EXISTS `messages` (
	`_Key` int(11) NOT NULL AUTO_INCREMENT,
	`_ServerName` varchar(255) NOT NULL,
	`_PlayerName` varchar(255) NOT NULL,
	`_Text` text NOT NULL,
	`_Color` varchar(255) NOT NULL,
	PRIMARY KEY (`_Key`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;]];

-- Called when OpenAura has loaded all of the entities.
function PLUGIN:OpenAuraInitPostEntity()
	tmysql.query( string.gsub(CREATE_MESSAGES_TABLE, "%s", " ") );
end;

-- Called when a player attempts to say something out-of-character.
function PLUGIN:PlayerCanSayOOC(player, text)
	local curTime = CurTime();
	local playerName = tmysql.escape( player:Name() );
	local serverName = tmysql.escape( openAura.config:Get("cross_server_chat_name"):Get() );
	local teamColor = tmysql.escape( Json.Encode( _team.GetColor( player:Team() ) ) );
	local chatText = tmysql.escape(text);

	if (openAura.config:Get("cross_server_chat_enabled"):Get()
	and playerName != "" and serverName != "" and text != "") then
		if (!player.nextTalkOOC or curTime > player.nextTalkOOC) then
			tmysql.query("INSERT INTO messages (_ServerName, _PlayerName, _Text, _Color) VALUES (\""..serverName.."\", \""..playerName.."\", \""..chatText.."\", \""..teamColor.."\")");
		end;
	end;
end;

-- Called each tick.
function PLUGIN:Tick()
	local curTime = CurTime();
	
	if (openAura.config:Get("cross_server_chat_enabled"):Get()) then
		if (!self.nextQueryChat or curTime >= self.nextQueryChat) then
			self:QueryChat();
		end;
	end;
end;