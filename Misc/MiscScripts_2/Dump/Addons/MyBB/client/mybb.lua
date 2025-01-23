MyBB = {}
MyBB.__index = MyBB

MyBB.Groups = {}

usermessage.Hook("MyBB_Group", function(um)
	local gid = um:ReadLong()
	local name = um:ReadString()
	local ag = um:ReadBool()
	local gg = um:ReadBool()
	local color = um:ReadVector()
	
	MyBB.Groups[gid] = {
		GID = gid,
		Name = name,
		IsAdminGroup = ag,
		IsGuestGroup = gg,
		Color = Color(color.r, color.g, color.b)
	}
	
	team.SetUp(MyBB.Groups[gid].GID, MyBB.Groups[gid].Name, MyBB.Groups[gid].Color)
end)

local Player = _R.Player

function Player:IsAdmin()
	return MyBB.Groups[self:Team()].IsAdminGroup
end
