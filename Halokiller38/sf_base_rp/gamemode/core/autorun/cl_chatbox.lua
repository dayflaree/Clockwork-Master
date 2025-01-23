--[[
Credits:
The Maw - For making this possible
Me (Jova) - Writing everything except for a few little functions
]]

function DrawText( text, font, x, y, col, align1, align2 )
	draw.SimpleText( text, font, x, y, col, align1, align2 )
end

local chatshow = false
local history = {}
local spacing = 20
local chatmessage = ""

function textsize(t, f) local w = surface.GetTextSize(t, f); return w; end

local function SendText(text, msg)
	local hist = {
	Text = text, 
	Time = RealTime()+7, 
	Msg = msg
	}
	table.insert( history, 1, hist )
	table.remove( history, 21 )
end

local y = ScrH()-130
local x = 150
hook.Add("PostRenderVGUI", "ChatPaint", function()
	for k, v in pairs( history ) do
		if v.Time > RealTime() or chatshow then
			DrawText(v.Text, "Trebuchet19", x+1, (y-k*spacing)+1, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
			DrawText(v.Text, "Trebuchet19", x, y-k*spacing, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)

			DrawText(v.Msg, "Trebuchet19", x+1, (y-k*spacing)+1, Color(0, 0, 0, 255), TEXT_ALIGN_RIGHT)
			DrawText(v.Msg, "Trebuchet19", x, y-k*spacing, Color(0, 195, 25, 255), TEXT_ALIGN_RIGHT)
		else
		end
	end
	if chatshow then
		draw.RoundedBox(0, x-67, y+4, 60, 20, Color( 25, 25, 25, 255 ))

		surface.SetDrawColor( 25, 25, 25, 255 )
		surface.SetTexture(surface.GetTextureID("gui/gradient"))
		surface.DrawTexturedRect(x+489, y+4, 100, 20)
		draw.RoundedBox(0, x-9, y+4, 499, 20, Color( 25, 25, 25, 255 ))
		
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetTexture(surface.GetTextureID("gui/gradient"))
		surface.DrawTexturedRect(x+489, y+5, 100, 18)
		draw.RoundedBox(0, x-9, y+5, 498, 18, Color( 255, 255, 255, 255 ))
		
		DrawText( "Chat", "Trebuchet19", x-5, y+5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT )
		DrawText( chatmessage, "Default", x-7, y+8, Color( 25, 25, 25, 255 ), TEXT_ALIGN_LEFT )
	end
end)

hook.Add("OnPlayerChat", "PlayerChat", function(  pl, text, teamtext, alive )
	if (ValidEntity(pl)) then
		SendText(text, pl:Nick().."> ")
	else
		SendText(text, "Console> ")
	end
end)

hook.Add("ChatText", "ChatText", function( filter, name, text )
	if (filter == 0) then
		SendText(text, "JC> ")
	end
end)

hook.Add("StartChat", "StartChat", function() chatshow = true return true end)
hook.Add("FinishChat", "FinishChat", function() chatshow = false return true end)
hook.Add("ChatTextChanged", "TextChanged", function(text) chatmessage = text end)