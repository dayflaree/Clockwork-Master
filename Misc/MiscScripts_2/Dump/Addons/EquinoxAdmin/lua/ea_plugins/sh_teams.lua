local PLUGIN = {}

PLUGIN.Name = "Teams"
PLUGIN.Purpose = "Sets players teams based on Flags"

team.SetUp(4, "Server Owner", Color(255, 0, 51, 255))
team.SetUp(5, "Administrator", Color(255, 102, 51, 255))
team.SetUp(6, "Moderator", Color(157, 255, 0, 255))
team.SetUp(7, "Regular", Color(255, 238, 0, 255))
team.SetUp(8, "Guest", Color(0, 179, 255, 255))
team.SetUp(9, "Previously Banned", Color(135, 135, 135, 255))

function PLUGIN.SetTeams(ply)
	if ply:HasFlag("O") then
		ply:SetTeam(4)
	elseif ply:HasFlag("A") then
		ply:SetTeam(5)
	elseif ply:HasFlag("M") then
		ply:SetTeam(6)
	elseif ply:HasFlag("R") then
		ply:SetTeam(7)
	elseif ply:HasFlag("B") then
		ply:SetTeam(99)
	else
		ply:SetTeam(8)
	end
end
EA:RegisterHook("PlayerSpawn", "Teams", PLUGIN.SetTeams)