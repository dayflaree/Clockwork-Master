local PLUGIN = PLUGIN;
PLUGIN.colortracker = {};
local purple = Color(145, 0, 250);

local function LerpColor(frac,from,to)
	local col = Color(
		Lerp(frac,from.r,to.r),
		Lerp(frac,from.g,to.g),
		Lerp(frac,from.b,to.b),
		Lerp(frac,from.a,to.a)
	)
	return col;
end;

-- Disallow movement during channeling
function PLUGIN:KeyPress(player, key)
	if (player:GetSharedVar("vortChanneling") and (key == IN_FORWARD or key == IN_MOVELEFT or key == IN_MOVERIGHT or key == IN_BACK or key == IN_JUMP)) then
		self:FailWarp(player);
	end;
end;

-- If someone leaves during a channel, disband it
function PLUGIN:PlayerDisconnected(player)
	if (player:GetSharedVar("vortChanneling")) then
		self:FailWarp(player, "Channeling cancelled due to player disconnect.");
	end;
end;

-- Turn people purple :)
function PLUGIN:Tick()
	if (#self.channels > 0) then
		if ((self.nextThink or 0) > CurTime()) then
			self.nextThink = CurTime() + 1;
			for i = 1, #self.channels do
				for k, v in pairs(self:GetChannelUsers(i)) do
					if (v:GetSharedVar("vortChanneling")) then
						self.colortracker[v] = LerpColor(0.01, self.colortracker[v] or color_white, purple);
						v:SetColor(self.colortracker[v]);
					end;
				end;
			end;
		end;
	end;
end;