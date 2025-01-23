-- Serverside chat.AddText using datastream.

AddCSLuaFile("chat_addtext_ds.lua")

if SERVER then
	chat = {}
	function chat.AddText(...)
		datastream.StreamToClients(player.GetAll(), "chat.AddText", {...})
	end
else
	datastream.Hook("chat.AddText", function(handler, id, encoded, decoded)
		chat.AddText(unpack(decoded))
	end)
end