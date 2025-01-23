--[[
	Free Clockwork!
--]]

local PLUGIN = PLUGIN;

-- Called when the character background should be drawn.
function PLUGIN:ShouldDrawCharacterBackground()
	if (self.mapScene) then return false; end;
end;

-- Called when the view should be calculated.
function PLUGIN:CalcView(player, origin, angles, fov)
	if (Clockwork:IsChoosingCharacter() and self.mapScene) then
		local addAngles = Angle(0, 0, 0);
		
		if (self.mapScene.shouldSpin) then
			addAngles = Angle(0, math.sin( CurTime() * 0.2 ) * 180, 0);
		end;
		
		return {
			vm_origin = self.mapScene.position + Vector(0, 0, 2048),
			vm_angles = Angle(0, 0, 0),
			origin = self.mapScene.position,
			angles = self.mapScene.angles + addAngles,
			fov = fov
		};
	end;
end;