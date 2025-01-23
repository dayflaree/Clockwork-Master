require("mysqloo")

local MyBB_DB = mysqloo.connect("", "", "", "", 3306)

function MyBB_DB:onConnectionFailed(err)
	MyBB:Error(err)
end

function MyBB_DB.onConnected()
	MsgN("Connected!")
	MyBB:SyncGroups()
end

MyBB_DB:connect()

MyBB = {}
MyBB.__index = MyBB

MyBB.Groups = {}

function MyBB:Error(err)
	Error("[MyBB] ERROR: " .. err)
end

function MyBB:SyncGroups()
	local Q = MyBB_DB:query("SELECT * FROM `mybb_usergroups`")
	
	function Q:onData(data)
		MyBB.Groups[data.gid] = {
			GID = data.gid,
			Name = data.title,
			IsAdminGroup = tobool(data.gmod_isadmingroup),
			IsGuestGroup = tobool(data.gmod_isguestgroup),
			Color = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255))
		}
		
		if data.gmod_isguestgroup == 1 then
			MyBB.DefaultGroup = data.gid
		end
		
		team.SetUp(MyBB.Groups[data.gid].GID, MyBB.Groups[data.gid].Name, MyBB.Groups[data.gid].Color)
	end
	
	Q.onError = MyBB.Error
	
	Q:start()
end

hook.Add("PlayerInitialSpawn", "mybb", function(ply)
	for gid, group in pairs(MyBB.Groups) do
		SendUserMessage("MyBB_Group", ply, group.GID, group.Name, tobool(group.IsAdminGroup), tobool(group.IsGuestGroup), Vector(group.Color.r, group.Color.g, group.Color.b))
	end
	
	timer.Simple(1, function() ply:SetTeam(MyBB.DefaultGroup) end)
	
	local Q = MyBB_DB:query("SELECT * FROM `mybb_users` WHERE `gmod_steamid` = '" .. ply:SteamID() .. "'")
	
	function Q:onData(data)
		if data.usergroup then
			timer.Simple(1, function() ply:SetTeam(data.usergroup) end)
		end
	end
	
	Q.onError = MyBB.Error
	
	Q:start()
end)

local Player = _R.Player

function Player:IsAdmin()
	return MyBB.Groups[self:Team()].IsAdminGroup
end
