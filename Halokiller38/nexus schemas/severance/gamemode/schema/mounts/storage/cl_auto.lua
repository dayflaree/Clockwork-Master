--[[
Name: "cl_auto.lua".
Product: "Severance".
--]]

local MOUNT = MOUNT;

NEXUS:IncludePrefixed("sh_auto.lua");

usermessage.Hook("nx_StorageMessage", function(msg)
	local entity = msg:ReadEntity();
	local message = msg:ReadString();
	
	if ( IsValid(entity) ) then
		entity.message = message;
	end;
end);

usermessage.Hook("nx_ContainerPassword", function(msg)
	local entity = msg:ReadEntity();
	
	Derma_StringRequest("Password", "What is the password for this container?", nil, function(text)
		NEXUS:StartDataStream( "ContainerPassword", {text, entity} );
	end);
end);