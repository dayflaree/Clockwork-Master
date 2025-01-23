lolbot = {}
lolbot.__index = lolbot
lolbot.commands = {}
lolbot.name = "lolbot"

function lolbot:Register(CMD)
	table.insert(self.commands, CMD)
end

function lolbot.Reply(text, func)
	timer.Simple(math.random(1, 2), function()	
		lolbot.Say(text)
		if func then
			timer.Simple(math.random(1, 2), func)
		end
	end)
end

function lolbot.Say(text)
	hook.Call("BotSay", GAMEMODE, lolbot.name, text)
	local RF = RecipientFilter()
	RF:AddAllPlayers()
	umsg.Start("lolbot")
		umsg.String(lolbot.name)
		umsg.String(glon.encode({text}))
	umsg.End()
end

function lolbot.PlayerSay(ply, text)
	local parts = string.Explode(" ", text)
	local prefix = string.lower(parts[1])
	local replies = { "hey,", "hi,", "hi", "hey", "hello", "hello," }
	
	if prefix == lolbot.name or prefix == lolbot.name .. "," then
		if #parts < 2 then
			lolbot.Reply(ply:Nick(true))
			return
		end
		
		local command = string.lower(parts[2])
		local args = string.Explode(" ", table.concat(parts, " ", 3))
		for k, CMD in pairs(lolbot.commands) do
			if CMD.Command == command then
				CMD.RunFunction(ply, args)
				return
			end
		end
		lolbot.Reply("Sorry " .. ply:Nick(true) .. ", I don't understand...")
	elseif table.HasValue(replies, prefix) then
		local name = false
		if parts[2] then
			name = string.lower(parts[2])
		end
		
		if name == lolbot.name or name == lolbot.name.."." or (not name and math.random(5) > 3) then
			lolbot.Reply(replies[math.random(#replies)] .. " " .. ply:Nick(true))
		end
	end
end
hook.Add("PlayerSay", "lolbot_playersay", lolbot.PlayerSay)

function lolbot.BotSay(name, text)
	// Called when a bot says something. 
	// if name == lolbot.name then return end
	// lolbot_reply(name.." said: "..text)
	MsgN(name.." said: "..text)
end
hook.Add("BotSay", "lolbot_botsay", lolbot.BotSay)

function lolbot.CreateBot()
	local lol = ents.Create("npc_kleiner")
	lol:SetPos(Vector(0, 0, 0))
	lol:Spawn()
	lol.islolbot = true
	lol:SetNWBool("lolbot", true)
	lol:SetSolid(SOLID_NONE)
	
	lolbot.NPC = lol
end
hook.Add("InitPostEntity", "lolbot_initpostentity", lolbot.CreateBot)

function lolbot.FindPlayer(name)
	for k, ply in pairs(player.GetAll()) do
		if string.match(string.lower(ply:LolbotNick()), string.lower(name)) then
			return ply
		end
	end
	return false
end

function lolbot.CallBack(content, size)
	if string.len(content) > 0 then
		lolbot.Reply(content)
	end
end

function lolbot.ToSelf(name, ply)
	if string.lower(name) == "me" or lolbot.FindPlayer(name) == ply then
		return true
	end
	return false
end

local Player = FindMetaTable("Player")
local oldNick = Player.Nick

function Player:Nick(lolbot)
	if lolbot and self:GetPData("lolbot_alias") then
		return self:GetPData("lolbot_alias")
	else
		return oldNick(self)
	end
end
