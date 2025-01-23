local PLUGIN = {}
PLUGIN.Name = "Data Transfer"
PLUGIN.Description = "Used for sending data to clients without nonsense."
PLUGIN.Author = "_Undefined"

PLUGIN.Extend = {
	Player = {
		Send = function(self, name, ...)
			for _, v in pairs({...}) do
				if type(v) == "table" then
					if table.Count(v) > 0 then
						MsgN("[NERO] sending datastream: " .. name)
						datastream.StreamToClients(self, "NERO_DataTransfer", { TransferName = name, Data = v })
						break
					end
				else
					MsgN("[NERO] sending usermessage: " .. name)
					SendUserMessage("NERO_DataTransfer", self, name, ...)
					break
				end
			end
		end
	}
}

PLUGIN.IncomingUsermessage = function(um)
	local transfer_name = um:ReadString()
	
	MsgN("[NERO] handling usermessage: " .. transfer_name)
	
	for Name, PLUGIN in pairs(NERO.Plugins) do
		if PLUGIN.DataHooks and PLUGIN.DataHooks[transfer_name] then
			PLUGIN.DataHooks[transfer_name](um)
			break
		end
	end
end
usermessage.Hook("NERO_DataTransfer", PLUGIN.IncomingUsermessage)

PLUGIN.IncomingDatastream = function(a, b, c, decoded)
	local transfer_name = decoded.TransferName
	
	MsgN("[NERO] handling datastream: " .. transfer_name)
	
	for Name, PLUGIN in pairs(NERO.Plugins) do
		if PLUGIN.DataHooks and PLUGIN.DataHooks[transfer_name] then
			PLUGIN.DataHooks[transfer_name](decoded.Data)
			break
		end
	end
end
datastream.Hook("NERO_DataTransfer", PLUGIN.IncomingDatastream)

NERO:RegisterPlugin(PLUGIN)