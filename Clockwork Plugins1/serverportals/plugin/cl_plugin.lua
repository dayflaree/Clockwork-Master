
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

Clockwork.config:AddToSystem("Main Server", "main_server", "The IP of the server unwhitelisted people should be directed to.");
Clockwork.config:AddToSystem("Server whitelist identity", "server_whitelist_identity", "The identity used for the server whitelist.\nLeave blank for no identity.");

Clockwork.datastream:Hook("AreaPortals", function(data)
	PLUGIN.areaPortals = data;
end);

Clockwork.datastream:Hook("PortalSpawns", function(data)
	PLUGIN.portalSpawns = data;
end);

Clockwork.datastream:Hook("UseAreaPortal", function(data)
	Clockwork.Client:ConCommand("connect "..PLUGIN.areaPortals[data[1]].ip);
end);

Clockwork.datastream:Hook("ConnectToMain", function(data)
	Clockwork.Client:ConCommand("connect "..data[1]);
end);