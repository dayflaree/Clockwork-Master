ASS_LVL_SERVER_OWNER	= 0
ASS_LVL_SUPER_ADMIN	= 1
ASS_LVL_ADMIN		= 2
ASS_LVL_TEMPADMIN	= 3
ASS_LVL_RESPECTED	= 4
ASS_LVL_GUEST		= 5
ASS_LVL_BANNED		= 255

ASS_VERSION = "ASSmod 2.20"

function ASS_Init_Shared()

	local PLAYER = FindMetaTable("Player")
	function PLAYER:IsSuperAdmin()	return self:GetNetworkedInt("ASS_isAdmin", 5) <= ASS_LVL_SUPER_ADMIN	end
	function PLAYER:IsAdmin()	return self:GetNetworkedInt("ASS_isAdmin", 5) <= ASS_LVL_ADMIN		end
	function PLAYER:IsTempAdmin()	return self:GetNetworkedInt("ASS_isAdmin", 5) <= ASS_LVL_TEMPADMIN	end
	function PLAYER:IsRespected()	return self:GetNetworkedInt("ASS_isAdmin", 5) <= ASS_LVL_RESPECTED	end

	function PLAYER:IsGuest()	return self:GetNetworkedInt("ASS_isAdmin", 5) >= ASS_LVL_GUEST && self:GetNetworkedInt("ASS_isAdmin", 5) < ASS_LVL_BANNED end
	function PLAYER:IsUnwanted()	return self:GetNetworkedInt("ASS_isAdmin", 5) >= ASS_LVL_BANNED end

	function PLAYER:GetLevel()		return self:GetNetworkedInt("ASS_isAdmin", 5)						end
	function PLAYER:HasLevel(n)		return self:GetNetworkedInt("ASS_isAdmin", 5) <= n						end
	function PLAYER:IsBetterOrSame(PL2)	return self:GetNetworkedInt("ASS_isAdmin", 5) <= PL2:GetNetworkedInt("ASS_isAdmin", 5)	end
	function PLAYER:GetTAExpiry(n)		return self:GetNetworkedFloat("ASS_tempAdminExpiry")	end
	function PLAYER:AssId()		return self:SteamID()	end
	PLAYER = nil

end

function IncludeSharedFile( S )
	
	if (SERVER) then
		AddCSLuaFile(S)
	end
	
	include(S)

end

function LevelToString( LEVEL, TIME )

	if (LEVEL <= ASS_LVL_SERVER_OWNER) then					return "Owner";
	elseif (LEVEL <= ASS_LVL_SUPER_ADMIN) then				return "Super Admin";
	elseif (LEVEL <= ASS_LVL_ADMIN) then					return "Admin";
	elseif (LEVEL <= ASS_LVL_TEMPADMIN) then				if (TIME) then return "Admin for " .. TIME else return "Temp Admin" end
	elseif (LEVEL <= ASS_LVL_RESPECTED) then				return "Respected"
	elseif (LEVEL >= ASS_LVL_GUEST && LEVEL < ASS_LVL_BANNED) then		return "Guest"
	else
		return "Banned";	
	end
end

function ASS_FormatText( TEXT )

	if (CLIENT) then
		TEXT = string.Replace(TEXT, "%assmod%", ASS_VERSION )

		TEXT = string.Replace(TEXT, "%cl_time%", os.date("%H:%M:%S") )
		TEXT = string.Replace(TEXT, "%cl_date%",  os.date("%d/%b/%Y") )
		TEXT = string.Replace(TEXT, "%cl_timedate%", os.date("%H:%M:%S") .. " " ..  os.date("%d/%b/%Y") )

		TEXT = string.Replace(TEXT, "%sv_time%", GetGlobalString("ServerTime") )
		TEXT = string.Replace(TEXT, "%sv_date%", GetGlobalString("ServerDate") )
		TEXT = string.Replace(TEXT, "%sv_timedate%", GetGlobalString("ServerTime") .. " " .. GetGlobalString("ServerDate") )

		TEXT = string.Replace(TEXT, "%hostname%", GetGlobalString( "ServerName" ) )
		TEXT = string.gsub(TEXT, "%%%&([%w_]+)%%", GetConVarString)
	end
	if (SERVER) then
	
		TEXT = string.Replace(TEXT, "%map%", game.GetMap() )
		TEXT = string.Replace(TEXT, "%gamemode%", gmod.GetGamemode().Name )

		TEXT = string.gsub(TEXT, "%%@([%w_]+)%%", GetConVarString)
	
	end
	
	TEXT = ASS_RunPluginFunction("FormatText", TEXT, TEXT)


	return TEXT
	
end

IncludeSharedFile("ass_plugins.lua")
IncludeSharedFile("ass_debug.lua")
IncludeSharedFile("ass_config.lua")

