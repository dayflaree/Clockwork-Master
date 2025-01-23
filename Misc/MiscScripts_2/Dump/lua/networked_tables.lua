require("datastream")

local Entity = _R.Entity

Entity.NetworkedTables = {}

if SERVER then

	function Entity:SetNetworkedTable(name, tbl)
		self.NetworkedTables[name] = tbl
		
		datastream.StreamToClients(player.GetAll(), "NetworkedTable", { Entity = self, Name = name, Data = tbl })
	end
	
	Entity.SetNWTable = Entity.SetNetworkedTable

end

function Entity:GetNetworkedTable(name, default)
	if not default then default = {} end
	if not self.NetworkedTables[name] then return default end
	
	return self.NetworkedTables[name]
end

Entity.GetNWTable = Entity.GetNetworkedTable

datastream.Hook("NetworkedTable", function(handler, id, encoded, decoded)
	local ent = decoded.Entity
	local name = decoded.Name
	local data = decoded.Data
	
	if ValidEntity(ent) then
		ent.NetworkedTables[name] = data
	end
end)