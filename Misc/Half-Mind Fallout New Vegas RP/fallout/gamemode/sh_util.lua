function util.wrapText(text, width, font) // thanks chessnut
	font = font or "Infected.SubTitle"
	surface.SetFont(font)

	local exploded = string.Explode("%s", text, true)
	local line = ""
	local lines = {}
	local w = surface.GetTextSize(text)
	local maxW = 0

	if (w <= width) then
		return {(text:gsub("%s", " "))}, w
	end

	for i = 1, #exploded do
		local word = exploded[i]
		line = line.." "..word
		w = surface.GetTextSize(line)

		if (w > width) then
			lines[#lines + 1] = line
			line = ""

			if (w > maxW) then
				maxW = w
			end
		end
	end

	if (line != "") then
		lines[#lines + 1] = line
	end

	return lines, maxW
end

function BoolToNumber( bool )

	if( bool ) then

		return 1;
		
	else

		return 0;
		
	end
	
end