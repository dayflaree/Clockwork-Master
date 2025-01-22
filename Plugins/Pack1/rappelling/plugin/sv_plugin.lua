local PLUGIN = PLUGIN;

Clockwork.config:Add("rappel_grapple_distance", 512);

-- Helper functions --

local function GetDigits(player)
	local num = string.match(player:Name(), ":(%d+).");

	return num or 0;
end;

-- Are they even allowed to rappel or climb in the first place?
-- If they've got a climbing kit equipped, let them rappel.
function PLUGIN:HasEquipment(player)
	if ((player:GetFaction() == FACTION_MPF and (tonumber(GetDigits(player)) >= 60 or player:Name():find("RL."))) or player:GetFaction() == FACTION_OTA) then
		return true;
	else
		local inv = player:GetInventory();
		local foundDisposables = Clockwork.inventory:GetItemsByID(inv, "cw_climbingkit");
		local foundReusables = Clockwork.inventory:GetItemsByID(inv, "cw_rappelkit");

		-- Check for disposable kits
		if (type(foundDisposables) == "table") then
			for k, v in pairs(foundDisposables) do
				if (v:HasPlayerEquipped()) then
					return true;
				end;
			end;
		end;

		-- Check for reusable kits
		if (type(foundReusables) == "table") then
			for k, v in pairs(foundReusables) do
				if (v:HasPlayerEquipped()) then
					return true;
				end;
			end;
		end;

		return false;
	end;
end;

-- Is the edge they're trying to grapple safe to latch onto?
function PLUGIN:CanGrapple(player)
	local safetyTrace = util.QuickTrace(player:GetShootPos(), player:GetAimVector() * Clockwork.config:Get("rappel_grapple_distance"):Get(), {player});
	local edgeTrace = util.QuickTrace(safetyTrace.HitPos + Vector(0, 0, 15) - Angle(0, safetyTrace.HitNormal:Angle().y, 0):Forward() * 5, Angle(0, player:EyeAngles().y, 0):Forward() * 6.5, {player});
	local hitAng = Angle(0, safetyTrace.HitNormal:Angle().y, 0):Forward() -- Get the y angle of the hit surface, we don't need pitch or anything.
	local hitDot = Angle(0, safetyTrace.Normal:Angle().y, 0):Forward():Dot(hitAng) -- Dot product to find the 'angle'. -0.724 is about 135 degrees. So now they can't climb sideways!
	local wallNormal = safetyTrace.HitNormal:GetNormalized()
	local distToWall = wallNormal:Dot( player:GetPos() - safetyTrace.HitPos )

	if (safetyTrace.Hit and safetyTrace.Entity:GetClass() != "Player" and (!edgeTrace.Hit or edgeTrace.HitPos:Distance(edgeTrace.StartPos) >= 3) and player:EyeAngles().x <= -60 and hitDot <= -0.724 and distToWall <= 70) then
		return true;
	else
		return false;
	end;
end;

-- Credit to 'highvoltage' and 'CmdrMatthew' for this lovely arc velocity function
function PLUGIN:GetForce(targetPos, startPos, arrivalTime)
	local diff = targetPos - startPos;
	local velx = diff.x / arrivalTime;
	local vely = diff.y / arrivalTime;
	local velz = (diff.z - 0.5 * (-GetConVarNumber("sv_gravity")) * (arrivalTime ^ 2)) / arrivalTime;

	return Vector(velx, vely, velz);
end;

-- Create some rope attached to the player.
function PLUGIN:CreateRope(player, ropePos)
	SafeRemoveEntity(player.rope);
	SafeRemoveEntity(player.ropeMount);

	player.ropeMount = ents.Create("keyframe_rope");
	player.ropeMount:SetKeyValue("MoveSpeed", "200");
	player.ropeMount:SetKeyValue("Type", "0");
	player.ropeMount:SetKeyValue("Slack", "-2500");
	player.ropeMount:SetKeyValue("Subdiv", "5");
	player.ropeMount:SetKeyValue("Width", "1.5");
	player.ropeMount:SetKeyValue("TextureScale", "1");
	player.ropeMount:SetKeyValue("Collide", "1");
	player.ropeMount:SetKeyValue("RopeMaterial", "cable/cable.vmt");
	player.ropeMount:SetKeyValue("targetname", "ropeMount" .. player:UniqueID());
	player.ropeMount:SetPos(ropePos);
	player.ropeMount:Spawn();
	player.ropeMount:Activate();

	player.rope = ents.Create("move_rope");
	player.rope:SetKeyValue("MoveSpeed", "200");
	player.rope:SetKeyValue("Type", "0");
	player.rope:SetKeyValue("Slack", "-2500");
	player.rope:SetKeyValue("Subdiv", "5");
	player.rope:SetKeyValue("Width", "1.5");
	player.rope:SetKeyValue("TextureScale", "1");
	player.rope:SetKeyValue("Collide", "1");
	player.rope:SetKeyValue("PositionInterpolator", "2");
	player.rope:SetKeyValue("NextKey", "ropeMount" .. player:UniqueID());
	player.rope:SetKeyValue("RopeMaterial", "cable/cable.vmt");
	player.rope:SetKeyValue("targetname", "rope" .. player:UniqueID());
	player.rope:SetPos(player:GetPos() - player:GetForward() * 10 + Vector(0, 0, 50));
	player.rope:Spawn();
	player.rope:Activate();

	player:EmitSound("npc/combine_soldier/zipline_clip" .. math.random(1, 2) .. ".wav");
end;

-- Create some temporary broken rope, like they do in HL2's campaign.
function PLUGIN:CreateFreeRope(mountPos, endPos, removeDelay)
	local ropeMount = ents.Create("keyframe_rope");
	ropeMount:SetKeyValue("MoveSpeed", "200");
	ropeMount:SetKeyValue("Type", "0");
	ropeMount:SetKeyValue("Slack", "0");
	ropeMount:SetKeyValue("Subdiv", "5");
	ropeMount:SetKeyValue("Width", "1.5");
	ropeMount:SetKeyValue("TextureScale", "1");
	ropeMount:SetKeyValue("Collide", "1");
	ropeMount:SetKeyValue("RopeMaterial", "cable/cable.vmt");
	ropeMount:SetKeyValue("targetname", "ropeMount" .. ropeMount:EntIndex());
	ropeMount:SetPos(endPos);

	local rope = ents.Create("move_rope");
	rope:SetKeyValue("MoveSpeed", "200");
	rope:SetKeyValue("Type", "0");
	rope:SetKeyValue("Slack", "100");
	rope:SetKeyValue("Subdiv", "5");
	rope:SetKeyValue("Width", "1.5");
	rope:SetKeyValue("TextureScale", "1");
	rope:SetKeyValue("Collide", "1");
	rope:SetKeyValue("PositionInterpolator", "2");
	rope:SetKeyValue("NextKey", "ropeMount" .. ropeMount:EntIndex());
	rope:SetKeyValue("RopeMaterial", "cable/cable.vmt");
	rope:SetKeyValue("targetname", "rope" .. rope:EntIndex());
	rope:SetPos(mountPos);

	ropeMount:Spawn();
	ropeMount:Activate();
	rope:Spawn();
	rope:Activate();
	ropeMount:Fire("Break");

	if (removeDelay > 0) then
	   SafeRemoveEntityDelayed(rope, removeDelay);
	   SafeRemoveEntityDelayed(ropeMount, removeDelay);
	end;
end;

-- End helper functions --

function PLUGIN:BeginRappel(player, mountPos, edgeNormal)
	if (IsValid(player) and player.canRappel and !player:GetSharedVar("rappelling") and player:GetMoveType() != MOVETYPE_NOCLIP) then
		if (player:GetPos():Distance(mountPos) >= 1200) then return; end;

		local modelClass = Clockwork.animation:GetModelClass(player:GetModel());
		local traceLevel = player:GetPos().z < mountPos.z and Vector(mountPos.x, mountPos.y, player:GetPos().z) or Vector(mountPos.x, mountPos.y, mountPos.z - 5);
		local hullSize = player:OBBMaxs().x
		local hullData = {
			start = traceLevel + edgeNormal * 25,
			endpos = traceLevel + edgeNormal * hullSize + (edgeNormal * 1.25),
			maxs = Vector(hullSize, hullSize, 60),
			mins = Vector(-hullSize, -hullSize, 0),
			filter = {player}
		};
		local hullTrace = util.TraceHull(hullData); -- Let's find a suitable place to position them!

		if (player.IsProne and player:IsProne()) then
			prone:EndProne(player, true);
		end;

		player:SetPos(hullTrace.HitPos);
		player:SetSharedVar("rappelling", true);
		player:SetSharedVar("climbNorm", edgeNormal);
		player.ropeZ = mountPos.z;
		player.climbGrace = CurTime() + 1;

		player:SetLocalVelocity(Vector(0, 0, player:GetVelocity().z));

		self:CreateRope(player, mountPos);

		if (!player.rappelSound) then
			player.rappelSound = CreateSound(player, "npc/combine_soldier/zipline_looped.wav");
		end;

		if (modelClass == "combineOverwatch" or modelClass == "civilProtection") then
			player:SetForcedAnimation("rappelloop");
		end;
	end;
end;

function PLUGIN:ConsumeKit(player)
	local inv = player:GetInventory();
	local foundItems = Clockwork.inventory:GetItemsByID(player:GetInventory(), "cw_climbingkit");

	if (type(foundItems) == "table") then
		for k, v in pairs(foundItems) do
			if (v:HasPlayerEquipped(player)) then
				player:TakeItem(v);
				return;
			end;
		end;
	end;
end;


-- Safely dismount a zipline, or just cleanse the player of any zipline effects.

function PLUGIN:Dismount(player, bBoost, bSound, bRope)
	if (IsValid(player)) then
		player:SetSharedVar("rappelling", false);
		player:SetSharedVar("climbNorm", nil);
		player.canRappel = true;
		player.rappelSpeed = 0;
		player:SetForcedAnimation(nil);
		player:SetMoveType(MOVETYPE_WALK);

		if (player.rappelSound) then
			player.rappelSound:Stop();
		end;

		if (bRope) then
			if (IsValid(player.rope) and IsValid(player.ropeMount)) then
				self:CreateFreeRope(player.ropeMount:GetPos(), player.rope:GetPos(), 20);
			end;
		end;

		SafeRemoveEntity(player.rope); -- Remove the rope
		SafeRemoveEntity(player.ropeMount); -- Remove the attachment in the world

		-- Make them consume their rappelling kit if they aren't combine
		if (!Schema:PlayerIsCombine(player)) then
			self:ConsumeKit(player);
		end;

		-- If they need a push, shove them in an arc upwards towards a safe spot. May not always work, but better than just dropping them...
		if (bBoost) then
			local force = self:GetForce(player:GetPos() + Angle(0, player:EyeAngles().y, 0):Forward() * 25 + Vector(0, 0, 50), player:GetPos(), 0.8);

			player:SetLocalVelocity(force);
		end;

		if (bSound) then
			player:EmitSound("npc/combine_soldier/zipline_hitground" .. math.random(1, 2) .. ".wav");
		end;
	end;
end;