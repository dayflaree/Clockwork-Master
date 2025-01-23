--[[
Name: "cl_auto.lua".
Product: "Day One".
--]]

local PLUGIN = PLUGIN;

BLUEPRINT:IncludePrefixed("sh_auto.lua");

usermessage.Hook("bp_StorageMessage", function(msg)
	local entity = msg:ReadEntity();
	local message = msg:ReadString();
	
	if ( IsValid(entity) ) then
		entity.message = message;
	end;
end);

usermessage.Hook("bp_ContainerPassword", function(msg)
	local entity = msg:ReadEntity();
	
	Derma_StringRequest("Password", "What is the password for this container?", nil, function(text)
		BLUEPRINT:StartDataStream( "ContainerPassword", {text, entity} );
	end);
end);