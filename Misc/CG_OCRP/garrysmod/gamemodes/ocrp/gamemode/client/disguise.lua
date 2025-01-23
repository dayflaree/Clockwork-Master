local pmeta = FindMetaTable("Player")
local emeta = FindMetaTable("Entity")

local DisguisedTable = {}

emeta.RealGetNetworkedInt = emeta.GetNetworkedInt
function emeta:GetNetworkedInt(str)
	if str and DisguisedTable and str == "ASS_isAdmin" and DisguisedTable[self] then
		return 5
	else
		return self:RealGetNetworkedInt(str)
	end
end

pmeta.RealIsAdmin = pmeta.IsAdmin
function pmeta:IsAdmin()
	if DisguisedTable then
		if DisguisedTable[self] then
			return false
		else
			return self:RealIsAdmin()
		end
	else
		return self:RealIsAdmin()
	end
end

pmeta.RealIsSuperAdmin = pmeta.IsSuperAdmin
function pmeta:IsSuperAdmin()
	if DisguisedTable then
		if DisguisedTable[self] then
			return false
		else
			return self:RealIsSuperAdmin()
		end
	else
		return self:RealIsSuperAdmin()
	end
end

local function AddDisguisedAdmin(um)
	local ply = um:ReadEntity()
	//print("ply send : ", ply)
	//print("local ply: ", LocalPlayer())
	DisguisedTable = DisguisedTable or {}
	DisguisedTable[ply] = ply
end
usermessage.Hook("AddDisAdmin", AddDisguisedAdmin)

local function RemoveDisguisedAdmin(um)
	local ply = um:ReadEntity()
	DisguisedTable = DisguisedTable or {}
	if DisguisedTable and DisguisedTable[ply] then
		DisguisedTable[ply] = nil
	end
end
usermessage.Hook("RemoveDisAdmin", RemoveDisguisedAdmin)

