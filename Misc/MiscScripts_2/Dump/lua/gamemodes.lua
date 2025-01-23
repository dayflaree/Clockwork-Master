local allGamemodes = file.FindDir("../gamemodes/*")
for k, v in pairs(allGamemodes) do
	self.gamemodesMenu:AddOption(v, function() PChat("You clicked "..v.."\n") end)
end