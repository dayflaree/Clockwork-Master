local PLUGIN = PLUGIN;

function PLUGIN:PlayerSpawnedProp(client, model, entity)
	if(IsValid(entity) && IsValid(client)) then
		entity:SetOwnerKey(client:GetCharacterKey());
	end;
end;

function PLUGIN:CanRemoveProp(client, entity)
	return client:IsAdmin() || client:IsUserGroup("operator") || entity:GetOwnerKey() == client:GetCharacterKey();
end;

function PLUGIN:CanUseTool(client, trace, tool)
	if tool:lower() == "remover" then
		local ent = trace.Entity;

		if (IsValid(ent) and !self:CanRemoveProp(client, ent)) then
			return false;
		end;
	end;
end;