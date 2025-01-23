local allMaps = file.Find("../maps/gm_*.bsp")
for k, v in pairs(allMaps) do
	self.mapsMenu:AddOption(string.gsub(string.lower( v ), ".bsp", ""), function() PChat("You clicked "..string.gsub(string.lower( v ), ".bsp", "").."\n") end)
end