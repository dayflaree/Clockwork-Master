--======================
--	Observer (Client)
--======================
local PLUGIN = {};

-- Create the ESP font.
surface.CreateFont("Arial", 14, 400, true, false, "observerEspFont");

function PLUGIN:drawText(text, font, x, y, colour, colourShadow)
	draw.SimpleText(text, font, x + 1, y + 1, colourShadow or Color(0, 0, 0, 255));
	draw.SimpleText(text, font, x, y, colour);
end;

hook.Add("HUDPaint", "observerDrawESP", function()
	for _,ply in ipairs(player.GetAll()) do
		if (ply:Alive()) then
			if (LocalPlayer():GetMoveType() == MOVETYPE_NOCLIP and LocalPlayer():IsSuperAdmin()) then
				local pos = ply:EyePos():ToScreen();
				
				if (pos.visible and ply != LocalPlayer()) then
					draw.RoundedBox(2, pos.x, pos.y, 8, 8, Color(196, 166, 76, 255));
					PLUGIN:drawText(ply:GetName(), "observerEspFont", pos.x, pos.y + 10, Color(196, 166, 76, 255));
					
					local distance = ply:EyePos():Distance(LocalPlayer():EyePos());
					PLUGIN:drawText("Distance: "..math.Round(distance), "observerEspFont", pos.x, pos.y + 20, Color(196, 166, 76, 255));
					
					if (ply:GetActiveWeapon().GetPrintName) then
						PLUGIN:drawText("Weapon: "..ply:GetActiveWeapon():GetPrintName(), "observerEspFont", pos.x, pos.y + 30, Color(196, 166, 76, 255));
					end;
				end;
			end;
		end;
	end;
end);
