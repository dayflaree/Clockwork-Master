if not SERVER then return end

if file.Exists("../addons/wire/SVNrevision174.info") then
	RealWireVersion = tonumber(file.Read("../addons/wire/SVNrevision174.info"))
end

local function PrintWireVersion(ply, cmd, args)
	if ply and ply:IsValid() then
		ply:ChatPrint("Server Wire Revision: "..RealWireVersion)
	else
		print("Server Wire Revision: "..RealWireVersion)
	end
end
concommand.Add("Wire_PrintVersion", PrintWireVersion)