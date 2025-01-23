local Player = FindMetaTable("Player")

function Player:HasPermission(perm)
	return true
	-- return self:GetRank().Permissions[perm] or self.Permissions[perm]
end

function Player:GetRank()
	return NERO.Ranks[self.NERO.Rank]
end

function Player:GetLevel()
	return NERO.Ranks[self.NERO.Rank].Level
end

function Player:__lt(ply, ply2)
	return ply:GetLevel() < ply2:GetLevel()
end

function Player:__le(ply, ply2)
	return ply:GetLevel() <= ply2:GetLevel()
end

function Player:__eq(ply, ply2)
	return ply:GetLevel() == ply2:GetLevel()
end