challenge = {}
local challenges = {}

function challenge.Register(id, tbl)
	challenges[id] = tbl
end

function challenge.Get(id)
	return challenges[id] or nil
end

local Player = _R.Player

function Player:DoingChallenge()
	return self._CC ~= nil
end

function Player:CurrentChallenge()
	return self:DoingChallenge() and challenge.Get(self._CC) or nil
end