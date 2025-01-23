--[[
	Free Clockwork!
--]]

local PLUGIN = PLUGIN;

-- Called just after the translucent renderables have been drawn.
function PLUGIN:PostDrawTranslucentRenderables(bDrawingDepth, bDrawingSkybox)
	if (bDrawingSkybox or bDrawingDepth) then return; end;
	
	local colorWhite = Clockwork.option:GetColor("white");
	local eyeAngles = EyeAngles();
	local eyePos = EyePos();
	local font = Clockwork.option:GetFont("large_3d_2d");
	
	Clockwork:OverrideMainFont(font);
		cam.Start3D(eyePos, eyeAngles);
			for k, v in pairs(self.surfaceTexts) do
				local alpha = math.Clamp(Clockwork:CalculateAlphaFromDistance(512, eyePos, v.position) * 1.5, 0, 255);
				
				if (alpha > 0) then
					local text = string.Explode("|", v.text);
					local y = 0;
					
					cam.Start3D2D(v.position, v.angles, (v.scale or 0.25) * 0.2);
						for k2, v2 in ipairs(text) do
							y = Clockwork:DrawInfo(v2, 0, y, colorWhite, alpha, nil, function(x, y, width, height)
								return x, y - (height / 2);
							end, 3);
						end;
					cam.End3D2D();
				end;
			end;
		cam.End3D();
	Clockwork:OverrideMainFont(false);
end;