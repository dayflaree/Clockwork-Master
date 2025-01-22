--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]
local PLUGIN = PLUGIN;

-- Called just after the translucent renderables have been drawn.
function PLUGIN:PostDrawTranslucentRenderables(bDrawingDepth, bDrawingSkybox)
	if (bDrawingSkybox or bDrawingDepth) then return; end;

	local large3D2DFont = Clockwork.option:GetFont("large_3d_2d");
	local colorWhite = Clockwork.option:GetColor("white");
	local eyeAngles = EyeAngles();
	local eyePos = EyePos();

	for k, v in pairs(self.storedList) do
		local alpha = math.Clamp(
			Clockwork.kernel:CalculateAlphaFromDistance(512, eyePos, v.position) * 1.5, 0, 255
		);

		if (alpha > 0) then
			if (!v.red) then
				v.red = 220
			end
			if (!v.blue) then
				v.blue = 220
			end
			if (!v.green) then
				v.green = 220
			end
			if (!v.markupObject) then
				v.markupObject = markup.Parse(
					"<font="..large3D2DFont.."><colour="..v.red..","..v.blue..","..v.green..",255>"..string.gsub(v.text, "\\n", "\n").."</font></colour>"
				);
				Clockwork.kernel:OverrideMarkupDraw(v.markupObject);
			end;

			cam.Start3D2D(v.position, v.angles, (v.scale or 0.25) * 0.2);
				render.PushFilterMin(TEXFILTER.ANISOTROPIC);
				render.PushFilterMag(TEXFILTER.ANISOTROPIC);
						v.markupObject:Draw(0, 0, 1, nil, alpha);
				render.PopFilterMag();
				render.PopFilterMin();
			cam.End3D2D();
		end;
	end;
end;