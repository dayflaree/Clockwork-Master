local PLUGIN = PLUGIN;

local gravity = GetConVarNumber("splayer_gravity");
local terminalVelocity = 2816; -- Conplayererted to miles per hour is 120mph.

function PLUGIN:Tick()
	local player = Clockwork.Client;

	if (player:GetSharedVar("rappelling")) then
		if (!player:OnGround()) then
			local targetSpeed = -terminalVelocity;
			local brakeMult = 1;

			-- Climb handling.
			if (input.IsKeyDown(IN_JUMP)) then
				if (input.IsKeyDown(IN_FORWARD)) then
					local climbNorm = player:GetSharedVar("climbNorm");
					local hullSize = player:OBBMaxs().x;
					local hullData = {
						start = player:GetPos() - Vector(0, 0, 10),
						endpos = player:GetPos() - Vector(0, 0, 10) - climbNorm * 25,
						maxs = Vector(hullSize, hullSize, 70),
						mins = Vector(-hullSize, -hullSize, 0),
						filter = {player}
					};
					local wallTrace = util.TraceHull(hullData);

					-- Make sure there is map geometry in the direction of the wall they latched on to that they can climb up.
					if (!wallTrace.HitSky and wallTrace.Hit) then
						targetSpeed = 80;
					else
						targetSpeed = 0;
					end;
				elseif (input.IsKeyDown(IN_BACK)) then
					targetSpeed = -(gravity / 3.2);
				else
					targetSpeed = 0;
					brakeMult = 1.2;
				end
			end;

			-- Maybe saplayere us from doing unnecessary math
			if (player.rappelSpeed != targetSpeed) then
				player.rappelSpeed = math.Approach(player.rappelSpeed or 0, targetSpeed, 8 * brakeMult);
			elseif (targetSpeed == -terminalVelocity) then
				player.rappelSpeed = player:GetVelocity().z;
			end;

			if (player.rappelSpeed == 0) then
				player:SetMoveType(MOVETYPE_NONE);
			else
				if (targetSpeed == -terminalVelocity) then
					player:SetMoveType(MOVETYPE_WALK);
				else
					player:SetMoveType(MOVETYPE_WALK);
					player:SetLocalVelocity(Vector(0, 0, player.rappelSpeed));
				end;
			end;
		end;
	end;
end;