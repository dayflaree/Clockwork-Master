--[[
Name: "cl_auto.lua".
Product: "Cider Two".
--]]

local PLUGIN = PLUGIN;

openAura:IncludePrefixed("sh_auto.lua");

openAura.config:AddAuraWatch("max_locker_weight", "The maximum weight a player's locker can hold.");

usermessage.Hook("aura_StorageMessage", function(msg)
	local entity = msg:ReadEntity();
	local message = msg:ReadString();
	
	if ( IsValid(entity) ) then
		entity.message = message;
	end;
end);

usermessage.Hook("aura_ContainerPassword", function(msg)
	local entity = msg:ReadEntity();
	
	Derma_StringRequest("Password", "What is the password for this container?", nil, function(text)
		openAura:StartDataStream( "ContainerPassword", {text, entity} );
	end);
end);

openAura.chatBox:RegisterClass("wire", "ic", function(info)
	openAura.chatBox:Add(info.filtered, nil, Color(275, 255, 200, 255), info.text);
end);