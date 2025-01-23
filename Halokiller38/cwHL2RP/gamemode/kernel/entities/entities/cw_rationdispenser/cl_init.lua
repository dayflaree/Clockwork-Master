--[[
	Free Clockwork!
--]]

Clockwork:IncludePrefixed("shared.lua")

local glowMaterial = Material("sprites/glow04_noz");

-- Called when the entity should draw.
function ENT:Draw()
	local r, g, b, a = self:GetColor();
	local rationTime = self:GetDTFloat("ration");
	local flashTime = self:GetDTFloat("flash");
	local setRed = self:GetDTBool("fail");
	local position = self:GetPos();
	local forward = self:GetForward() * 8;
	local curTime = CurTime();
	local right = self:GetRight() * 5;
	local up = self:GetUp() * 13;
	
	if (setRed) then
		cam.Start3D( EyePos(), EyeAngles() );
			render.SetMaterial(glowMaterial);
			render.DrawSprite(position + forward + right + up, 10, 10, Color(255, 0, 0));
		cam.End3D();
	elseif (self:IsLocked()) then
		cam.Start3D( EyePos(), EyeAngles() );
			render.SetMaterial(glowMaterial);
			render.DrawSprite(position + forward + right + up, 10, 10, Color(255, 210, 0));
		cam.End3D();
	else
		if (rationTime > curTime) then
			local glowColor = Color(0, 0, 255, a);
			local timeLeft = rationTime - curTime;
			
			if ( !self.nextFlash or curTime >= self.nextFlash or (self.flashUntil and self.flashUntil > curTime) ) then
				cam.Start3D( EyePos(), EyeAngles() );
					render.SetMaterial(glowMaterial);
					render.DrawSprite(position + forward + right + up, 10, 10, glowColor);
				cam.End3D();
				
				if (!self.flashUntil or curTime >= self.flashUntil) then
					self.nextFlash = curTime + (timeLeft / 4);
					self.flashUntil = curTime + (FrameTime() * 4);
					self:EmitSound("hl1/fvox/boop.wav");
				end;
			end;
		else
			local glowColor = Color(0, 255, 0, a);

			cam.Start3D( EyePos(), EyeAngles() );
				render.SetMaterial(glowMaterial);
				render.DrawSprite(position + forward + right + up, 10, 10, glowColor);
			cam.End3D();
		end;
	end;
end;