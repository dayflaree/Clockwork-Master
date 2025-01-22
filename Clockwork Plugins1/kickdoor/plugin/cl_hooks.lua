local PLUGIN = PLUGIN;

--[[
function PLUGIN:Think()
	for k, v in pairs( player.GetAll() ) do
		if (IsValid(v._kickDoorAnimObj)) then
			local deltaTime = CurTime() - v._kickAnimStartTime

			if deltaTime < 1.4 then
				v._kickDoorAnimObj:SetCycle( deltaTime / 3 )
			else
				v:SetNoDraw( false )
				v:DrawViewModel( true )
				v._kickDoorAnimObj:Remove()
			end;
		end;
	end;
end;
]]--

function PLUGIN:ShouldDrawLocalPlayer(player)
	if (player:GetSharedVar("KickingDoor")) then
		return true;
	end;
end;

function PLUGIN:CalcView(player, position, angles)
	if (player:GetSharedVar("KickingDoor")) then
		local origin = position + player:GetAngles():Forward() * -64;
		local angles = (position - origin):Angle();
		local view = {
			[ "origin" ] = origin,
			[ "angles" ] = angles
		};

		return view;
	end;
end;