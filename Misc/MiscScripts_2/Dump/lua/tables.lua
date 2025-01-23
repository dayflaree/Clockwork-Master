local plr = player

player = {}

function player.GetAll()
	
end

local t = player.GetAll()

setmetatable(t, {
	__index = function(tbl, k)
		if _R.Player[k] then
			for _, ply in pairs(tbl) do
				if ply:IsPlayer() then
					return ply[k](ply) or function() return end
				end
			end
		end
	end
})

t:Kill()