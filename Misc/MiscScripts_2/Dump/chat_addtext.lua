-- Serverside chat.AddText that supports the same functionality as the clientside version (players, strings and colors).
-- Probably incredibly inefficient.
-- By _Undefined
-- Modified heavily from Overv's: http://www.facepunch.com/showthread.php?t=768062

AddCSLuaFile("chat_addtext.lua")

if SERVER then
	chat = {}
	function chat.AddText(...)
		local RF = RecipientFilter()
		
		if type(arg[1]) == "Player" then
			RF:AddPlayer(arg[1])
		elseif type(arg[1]) == "table" then
			for _, ply in pairs(arg[1]) do
				RF:AddPlayer(ply)
			end
		else
			RF:AddAllPlayers()
		end
		
		umsg.Start("chat.AddText", RF)
			umsg.Short(#arg)
			for _, v in pairs(arg) do
				if type(v) == "string" then
					umsg.String("s" .. v)
				elseif type(v) == "number" then
					umsg.String("s" .. tostring(v))
				elseif type(v) == "Player" then
					umsg.String("p" .. v:EntIndex())
				elseif type(v) == "table" then
					umsg.String("c" .. v.r .. "," .. v.g .. "," .. v.b)
				end
			end
		umsg.End()
	end
else
	usermessage.Hook("chat.AddText", function(um)
		local s, t, d = "", "", ""
		
		local argc = um:ReadShort()
		local args = {}
		for i = 1, argc - 1 do
			s = um:ReadString()
			t = string.sub(s, 1, 1)
			d = string.sub(s, 2)
			
			if t == "s" then
				table.insert(args, d)
			elseif t == "p" then
				table.insert(args, Entity(d))
			elseif t == "c" then
				local p = string.Explode(",", d)
				table.insert(args, Color(p[1], p[2], p[3]))
			end
		end
		
		chat.AddText(unpack(args))
	end)
end