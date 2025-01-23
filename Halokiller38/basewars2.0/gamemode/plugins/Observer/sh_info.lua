--======================
--	Observer (Shared)
--======================
local PLUGIN = PLUGIN;

PLUGIN.name = "Observer";

local COMMAND = {};
COMMAND.description = "Enter/exit observer mode";
COMMAND.arguments = {{"Bool", "Return"}};
COMMAND.flag = "a"
function COMMAND:OnRun(ply, args)
	if (!ply._observer) then
		-- Set up the observer information.
		ply._observerMoveType = ply:GetMoveType();
		ply._observerColour = {ply:GetColor()};
		ply._observerMaterial = ply:GetMaterial();
		ply._observerAngles = ply:EyeAngles();
		ply._observerPos = ply:GetPos();
		
		ply:SetMoveType(MOVETYPE_NOCLIP);
		ply:GodEnable();
		
		ply._observer = true;
	else
		local shouldReturn = args[1] == "true";
		
		if (ply._observerMoveType) then
			ply:SetMoveType(ply._observerMoveType or MOVETYPE_WALK);
		end;
		
		if (ply._observerColour) then
			ply:SetColor(unpack(ply._observerColour));
		end;
		
		if (ply._observerMaterial) then
			ply:SetMaterial(ply._observerMaterial);
		end;
		
		ply:DrawWorldModel(true);
		ply:DrawShadow(true);
		
		if (shouldReturn) then
			ply:SetPos(ply._observerPos);
			ply:SetEyeAngles(ply._observerAngles);
		end;
		
		ply:GodDisable();
		
		-- Remove observer settings.
		ply._observerMoveType = nil;
		ply._observerColour = nil;
		ply._observerMaterial = nil;
		ply._observerAngles = nil;
		ply._observerPos = nil;
		
		ply._observer = nil;
	end;
end;

RP.Command:New("observer", COMMAND);

-- Called every frame.
hook.Add("Think", "observerThink", function()
	for k,ply in pairs(player.GetAll()) do
		if (ply._observer and !ply:IsVehicle()) then
			local r, g, b, a = ply:GetColor();
			
			ply:DrawWorldModel(false);
			ply:DrawShadow(false);
			ply:SetColor(r, g, b, 0);
		end;
	end;
end);
