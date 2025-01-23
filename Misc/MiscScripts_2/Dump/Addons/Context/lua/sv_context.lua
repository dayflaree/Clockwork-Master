--[[
	Context Admin Mod
	_Undefined
	050110
	Serverside functions etc.
]]--

CONTEXT.Commands = {}

function CONTEXT.Commander(ply, cmd, args)
	for k, PLUGIN in pairs(CONTEXT.Plugins) do
		if PLUGIN.Commands and #PLUGIN.Commands then
			for name, cmd in pairs(PLUGIN.Commands) do
				if name == args[1] then
					table.remove(args, 1)
					return cmd(ply, args)
				end
			end
		end
	end
	CONTEXT.Notify(nil, "Unhandled command: " .. args[1] .. "!")
end
concommand.Add("co", CONTEXT.Commander)

local Player = FindMetaTable("Player")

function Player:ChatPrint(...)
	datastream.StreamToClients(self, "ChatPrint", {...})
end

function Player:__le(ply2)
	return self:GetLevel() <= ply2:GetLevel()
end