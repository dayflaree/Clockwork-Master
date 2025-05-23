--[[
	Free Clockwork!
--]]

local PLUGIN = PLUGIN;

-- Called just after the translucent renderables have been drawn.
function PLUGIN:PostDrawTranslucentRenderables(bDrawingDepth, bDrawingSkybox)
	if (bDrawingSkybox or bDrawingDepth) then return; end;
	
	local eyeAngles = EyeAngles();
	local curTime = UnPredictedCurTime();
	local eyePos = EyePos();
	
	cam.Start3D(eyePos, eyeAngles);
		for k, v in pairs(self.dynamicAdverts) do
			if (!IsValid(v.panel)) then
				if (Clockwork.player:CanSeePosition(Clockwork.Client, v.position, nil, true)) then
					self:CreateHTMLPanel(v);
				end;
			else
				v.panel:SetPaintedManually(false);
					cam.Start3D2D(v.position, v.angles, v.scale or 0.25);
						v.panel:PaintManual();
					cam.End3D2D();
				v.panel:SetPaintedManually(true);
			end;
		end;
	cam.End3D();
end;