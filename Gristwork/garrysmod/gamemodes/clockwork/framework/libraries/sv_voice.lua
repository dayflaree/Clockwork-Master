--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local Clockwork = Clockwork;

--[[
	@codebase Server
	@details Provides an interface to the server-side voice channels.
	@field stored A table containing a list of voice channels.
--]]
Clockwork.voice = Clockwork.kernel:NewLibrary("Voice");
Clockwork.voice.stored = Clockwork.voice.stored or {};

--[[
	@codebase Server
	@details A function to get all of the voice channels.
	@returns Table A table containing a list of channels.
--]]
function Clockwork.voice:GetChannels()
	return self.stored;
end;

--[[
	@codebase Server
	@details A function to get a voice channel.
	@param String A unique identifier.
	@returns String The flag for the channel.
--]]
function Clockwork.voice:GetChannel(name)
	return self.stored[name];
end;

--[[
	@codebase Server
	@details A function to create a voice channel.
	@param String A unique identifier.
--]]
function Clockwork.voice:CreateChannel(name)
	self.stored[name] = name;
end;

--[[
	@codebase Server
	@details A function to add a player to a voice channel.
	@param Player The player to add to the channel.
	@param String A unique identifier.
--]]
function Clockwork.voice:AddToChannel(player, name)
	if (!self:GetChannel(name)) then
		self:CreateChannel(name);
	end;

	player.cwVoiceChannel = self:GetChannel(name);
end;

--[[
	@codebase Server
	@details A function to remove a player from a channel.
	@param Player The player to remove from the channel.
--]]
function Clockwork.voice:RemoveFromChannel(player)
	if (player.cwVoiceChannel) then
		player.cwVoiceChannel = nil;
	end;
end;

--[[
	@codebase Server
	@details A function if a player is in the channel.
	@param Player The player to check if in a channel.
	@param String A unique identifier.
	@returns Bool Whether or not the player is in the channel.
--]]
function Clockwork.voice:IsInChannel(player, name)
	if (player.cwVoiceChannel and player.cwVoiceChannel != "") then	
		if (player.cwVoiceChannel == self:GetChannel(name)) then
			return true;
		end;
	end;
end;

--[[
	@codebase Server
	@details A function to get the players active channel.
	@param Player The player to check if in a channel.
	@param String A unique identifier.
	@returns Bool Whether or not the player is in the channel.
--]]
function Clockwork.voice:GetActiveChannel(player)
	return player.cwVoiceChannel;
end;