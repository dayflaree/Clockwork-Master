AddCSLuaFile("autorun/client/mybb.lua")

require("tmysql")

--[[ Config: Edit this ]]--

local db_host = ""
local db_user = ""
local db_pass = ""
local db_name = ""
local db_prefix = "mybb_"

--[[ Stop editing ]]--

tmysql.initialize(db_host, db_user, db_pass, db_name, 3306)

MyBB = {}

MyBB.UserGroups = {}
MyBB.GuestGroup = 1 -- Fall back to this gid if it can't be retrieved later on!

function MyBB.LoadUserGroups()
	tmysql.query("SELECT `gid`, `title`, `isbannedgroup`, `gmod_isadmingroup`, `gmod_isguestgroup`, `gmod_inheritfrom`, `gmod_permissions` FROM `" .. db_prefix .. "usergroups`", function(g_result, status, err)
		for _, group in SortedPairs(g_result) do
			MyBB.UserGroups[tonumber(group[1])] = {
				_gid = tonumber(group[1]),
				Title = group[2],
				IsBannedGroup = group[3],
				IsAdminGroup = group[4],
				IsGuestGroup = group[5],
				InheritFrom = group[6],
				Permissions = group[7]
			}
			
			if group[5] == "1" then
				MyBB.GuestGroup = tonumber(group[1])
			end
		end
	end)
end

function MyBB.AssociateUser(ply, cmd, args)	
	local username = args[1]
	local password = args[2]
	
	http.Get("http://equinox-studios.com/integrate.php?username=" .. username .. "&password=" .. password .. "&steamid=" .. ply:SteamID(), "", function(c, s)
		if string.find(c, "ok") then
			SendUserMessage("MyBB_Associate", ply, "Congratulations, your account has been linked!")
		else
			SendUserMessage("MyBB_Associate", ply, "Sorry, your association attempt has failed. Reason: " .. c)
		end
	end)
end
concommand.Add("mybb_associate", MyBB.AssociateUser)

local Player = FindMetaTable("Player")

function Player:SetGroupFromMyBB()
	tmysql.query("SELECT `usergroup` FROM `" .. db_prefix .. "users` WHERE `gmod_steamid` = '" .. self:SteamID() .. "'", function(u_result, status, err)
		if u_result and #u_result > 0 then
			local gid = u_result[1][1]
			self:SetMyBBGroup(gid)
		end
	end)
		
	self:ChatPrint("Hey " .. self:Nick() .. "! You're in the '" .. self:GetMyBBGroup().Title .. "' group on this server!")
end

function Player:SetMyBBGroup(gid)
	if not self.MyBB then self.MyBB = {} end
	self.MyBB._gid = tonumber(gid) or MyBB.GuestGroup
end

function Player:GetMyBBGroup()
	if not self.MyBB then self.MyBB = {} end
	return MyBB.UserGroups[self.MyBB._gid] or MyBB.UserGroups[MyBB.GuestGroup]
end

hook.Add("PlayerSpawn", "MyBB_PlayerSpawn", function(ply)
	timer.Simple(2, function() ply:SetGroupFromMyBB() end)
end)

hook.Add("Initialize", "MyBB_Initialize", function()
	MyBB.LoadUserGroups()
end)