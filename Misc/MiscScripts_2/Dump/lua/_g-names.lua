setmetatable(_G, {
	__index = function(tbl, key)
		for _, ply in pairs(player.GetAll()) do
			if string.find(string.lower(ply:Nick()), string.lower(key)) then
				return ply
			end
		end
	end
})