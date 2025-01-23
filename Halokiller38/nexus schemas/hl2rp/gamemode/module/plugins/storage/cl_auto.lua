--[[
Name: "cl_auto.lua".
Product: "Half-Life 2".
--]]

local PLUGIN = PLUGIN;

RESISTANCE:IncludePrefixed("sh_auto.lua");

usermessage.Hook("roleplay_StorageMessage", function(msg)
	local entity = msg:ReadEntity();
	local message = msg:ReadString();
	
	if ( IsValid(entity) ) then
		entity.message = message;
	end;
end);

usermessage.Hook("roleplay_ContainerPassword", function(msg)
	local entity = msg:ReadEntity();
	
	Derma_StringRequest("Password", "What is the password for this container?", nil, function(text)
		RESISTANCE:StartDataStream( "ContainerPassword", {text, entity} );
	end);
end);