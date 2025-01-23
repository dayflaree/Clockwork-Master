--[[
	Free Clockwork!
--]]

local PLUGIN = PLUGIN;
PLUGIN.playing = false;
PLUGIN.soundObj = nil;
PLUGIN.sounds = {
	-- {
		-- corner1 = Vector(4400, 332, 900),
		-- corner2 = Vector(5284, 1459, 1295),
		-- sound = "/slidefuse/music_medic.mp3",
		-- duration = 90
	-- }
}
	
-- Called when the client thinks
function PLUGIN:Think()
	local inBox = false;
	for k, v in pairs(self.sounds) do
		if (self:IsInBox(v.corner1, v.corner2, Clockwork.Client:GetPos())) then
			if (self.playing == false) then
				self.playing = true;
				self.soundObj = CreateSound(Clockwork.Client, v.sound);
				self.soundObj:PlayEx(0.75, 100);
				timer.Simple(v.duration, function(cwPlugin)
					cwPlugin.playing = false
				end, self);
			end;
			inBox = true;
		end;
	end;
	if (!inBox and self.soundObj) then
		self.playing = false
		self.soundObj:FadeOut(4);
		self.soundObj = nil;
	end;
end;

function PLUGIN:IsInBox(v1, v2, pos)
	if (pos.x >= v1.x and pos.x <= v2.x and pos.y >= v1.y and pos.y <= v2.y and pos.z >= v1.z and pos.z <= v2.z) then
		return true;
	end;
end;
