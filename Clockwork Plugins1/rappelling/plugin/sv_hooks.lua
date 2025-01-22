local PLUGIN = PLUGIN;

function PLUGIN:PlayerSpawn(player)
	if (player:GetSharedVar("rappelling")) then
		self:Dismount(player, false, false, false);
	end;
	-- This variable basically says whether or not they can rappel regardless of what's going on.
	-- Don't touch, it's just to keep people from abusing the system.
	player.canRappel = true;
end;

-- If they switched characters while rappelling, cleanse their rappelling state.
function PLUGIN:PlayerCharacterLoaded(player)
	if (player:GetSharedVar("rappelling")) then
		self:Dismount(player, false, false, false);
	end;
end;

do
	local gravity = GetConVarNumber("sv_gravity");
	local terminalVelocity = 2816; -- Converted to miles per hour is 120mph.
	local latchMins = Vector(-2, -2, -2);
	local latchMaxs = Vector(2, 2, 3);

	-- Rappelling think function.
	function PLUGIN:PlayerThink(player)
		if (player:GetSharedVar("rappelling")) then
			--if (!player:OnGround()) then
				local targetSpeed = !player:OnGround() and -terminalVelocity or 0;
				local brakeMult = 1;

				-- This block sets the rope's pos. Can't parent it because then it would misbehave.
				if (IsValid(player.rope)) then
					local modelClass = Clockwork.animation:GetModelClass(player:GetModel());

					if (modelClass == "combineOverwatch" or modelClass == "civilProtection") then
						player.rope:SetPos(player:GetAttachment(player:LookupAttachment("zipline")).Pos)
					else
						player.rope:SetPos(player:GetPos() - player:GetForward() * 10 + Vector(0, 0, 50));
					end;
				end;

				-- Climb handling.
				if (player:KeyDown(IN_JUMP)) then
					if (player:KeyDown(IN_FORWARD)) then
						local climbNorm = player:GetSharedVar("climbNorm");
						local hullSize = player:OBBMaxs().x;
						local hullData = {
							start = player:GetPos() - Vector(0, 0, 10),
							endpos = player:GetPos() - Vector(0, 0, 10) - climbNorm * 40,
							maxs = Vector(hullSize, hullSize, 70),
							mins = Vector(-hullSize, -hullSize, 0),
							filter = {player}
						};
						local wallTrace = util.TraceHull(hullData);

						-- Make sure there is map geometry in the direction of the wall they latched on to that they can climb up.
						if (!wallTrace.HitSky and wallTrace.Hit) then
							targetSpeed = 80;
							player:SetGroundEntity(nil);
						else
							targetSpeed = 0;
						end;

						if (player:GetPos().z >= player.ropeZ + 5) then
							self:Dismount(player, true, true, true); -- Are they a bit higher than where their rope is attached? Shove them onto the ledge.
							return;
						end;
					elseif (player:KeyDown(IN_BACK)) then
						targetSpeed = -(gravity / 3.2);
					else
						targetSpeed = 0;
						brakeMult = 1.2;
					end
				end;

				-- Maybe save us from doing unnecessary math
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
					if (player.rappelSound) then
						if (player.rappelSpeed < -25) then
							if (!player.rappelSound:IsPlaying()) then
								player.rappelSound:Play();
							end;
							player.rappelSound:ChangeVolume(0.3, 0);
						elseif (player.rappelSound:IsPlaying()) then
							player.rappelSound:FadeOut(0.3);
						end;
					end;
				end;
			--end;
		elseif (player:KeyDown(IN_BACK) and player:KeyDown(IN_DUCK)) then
			if (self:HasEquipment(player) and !player:OnGround() and math.abs(player:GetVelocity().z) <= 110) then
				local edgeTrace = util.TraceHull({
					start 	= player:GetPos() - Vector(0, 0, 3),
					endpos 	= player:GetPos() - Vector(0, 0, 3) + Angle(0, player:EyeAngles().y, 0):Forward() * 75,
					mins	= latchMins,
					maxs	= latchMaxs,
					filter 	= function(ent)
						if (ent:IsPlayer() or ent == player or ent:GetOwner() == player) then
							return false;
						else
							return true;
						end;
					end;
				});
				local hitAng = Angle(0, edgeTrace.HitNormal:Angle().y, 0):Forward() -- Get the y angle of the hit surface, we don't need pitch or anything.
				local hitDot = edgeTrace.Normal:Dot(hitAng) -- Dot product to find the 'angle'. -0.724 is about 135 degrees. So now they can't rappel sideways!

				if (!edgeTrace.HitSky and edgeTrace.Hit and edgeTrace.HitNormal.z < 0.6 and hitDot <= -0.724) then
					self:BeginRappel(player, edgeTrace.HitPos - edgeTrace.HitNormal * 4, edgeTrace.HitNormal);
				end;
			end;
		end;
	end;
end;

function PLUGIN:KeyPress(player, key)
	if (player:GetSharedVar("rappelling") and key == IN_DUCK) then
        self:Dismount(player, false, true, true);
        player.canRappel = false; -- Stop them from rappelling immediately after they dismount on a wall. Spam protection, really.
    end;

    if (!player:GetSharedVar("rappelling") and key == IN_JUMP) then
        player.canRappel = false; -- Keep them from accidentally latching onto the floor. Yes, it happens.
    end;
end;

function PLUGIN:OnPlayerHitGround(player)
    if (player:GetSharedVar("rappelling") and CurTime() > player.climbGrace) then
        self:Dismount(player, false, true, true);
    end;
    player.canRappel = true;
end;