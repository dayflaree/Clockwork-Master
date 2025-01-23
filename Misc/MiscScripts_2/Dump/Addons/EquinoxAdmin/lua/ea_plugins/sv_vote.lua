local PLUGIN = {}

PLUGIN.Name = "Voting"
PLUGIN.Purpose = "Lets users vote."
PLUGIN.Command = "vote"
PLUGIN.Help = "ea vote [map/kick/ban] [mapname/player/part]"

function PLUGIN.HandleCommand(ply, args)
	if args[1] == "map" then
		-- Check map exists.
	elseif args[1] == "kick" then
		if not PLUGIN.VoteRunning then
			-- Start Vote.
		else
			-- Send error (already running).
			return
		end
		pp_ply = EA:FindPlayer(args[2])
		if not pp_ply then return end
	elseif args[1] == "ban" then
		pp_ply = EA:FindPlayer(args[2])
		if not pp_ply then return end
	elseif args[1] == "v" then
		if PLUGIN.VoteRunning then
			if not PLUGIN.Votes[ply] then
				PLUGIN.Votes[ply] = args[2]
			else
				-- Send error (already voted).
				return
			end
			PLUGIN.CheckVotes()
		end
	end
end

function PLUGIN.StartVote(action, key)
	PLUGIN.Votes = {}
	PLUGIN.VoteRunning = true
	PLUGIN.VoteEndAction = action
	PLUGIN.VoteEndKey = key or 0
	PLUGIN.VoteStartTime = CurTime()
end

function PLUGIN.CheckVotes()
	local votes = {}
	for ply, vote in pairs(PLUGIN.Votes) do
		if not votes[vote] then
			votes[vote] = 1
		else
			votes[vote] = votes[vote] + 1
		end
	end
	if #votes == #player.GetAll() then
		return table.GetWinningKey(votes)
	end
	return false
end

function PLUGIN.EndVote(result)
	PLUGIN.VoteRunning = false
	if result then
		PLUGIN.VoteEndAction()
	end
end

EA:RegisterPlugin(PLUGIN)