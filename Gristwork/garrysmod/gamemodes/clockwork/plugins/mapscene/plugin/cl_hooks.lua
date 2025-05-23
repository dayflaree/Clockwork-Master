--[[
	� 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

-- Called when the character background should be drawn.
function cwMapScene:ShouldDrawCharacterBackground()
	if (self.curStored) then return false; end;
end;

-- Called when the view should be calculated.
function cwMapScene:CalcView(player, origin, angles, fov)
	if (Clockwork.kernel:IsChoosingCharacter() and self.curStored) then
		local addAngles = Angle(0, 0, 0);
		
		if (self.curStored.shouldSpin) then
			addAngles = Angle(0, math.sin(CurTime() * 0.2) * 180, 0);
		end;
		
		return {
			origin = self.curStored.position,
			angles = self.curStored.angles + addAngles,
			fov = fov
		};
	end;
end;