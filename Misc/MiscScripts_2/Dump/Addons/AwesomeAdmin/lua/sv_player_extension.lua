local Player = FindMetaTable("Player")

function Player:HasPermission(permission)
	return true --table.HasValue(AA.Ranks[ply:GetRank()].Permissions, permission) or table.HasValue(ply.Permissions, permission)
end

function Player:GivePermission(permission)
	if not table.HasValue(ply.Permissions, permission) then
		table.insert(ply.Permissions, permission)
	end
end