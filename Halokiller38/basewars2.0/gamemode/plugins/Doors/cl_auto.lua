--================
--	Doors Plugin
--================
local PLUGIN = PLUGIN;

surface.CreateFont("Arial", 16, 600, true, false, "doorFont", false, false, 0);

function PLUGIN:HUDPaint()
	local ent = LocalPlayer():GetEyeTraceNoCursor().Entity;

	if (ValidEntity(ent)) then
		if (ent:IsDoor()) then
			local text = "Press F2 to purchase ($10)";
			local y = ScrH() / 2 + math.sin(UnPredictedCurTime()) * 8;
			local alpha = 255 - 255 * math.TimeFraction(0, 256, LocalPlayer():GetPos():Distance(ent:GetPos()));
			local owner = ent:GetNWEntity("RPOwner");
			
			if (ValidEntity(owner)) then
				text = ent:GetNWEntity("RPOwner"):GetName().." owns this door";
			elseif (ent:GetNWString("RPDoorType") and ent:GetNWString("RPDoorType") == "unownable") then
				text = "Unownable";
			end;
			
			y = RP.menu:DrawSimpleText(text, "doorFont", ScrW() / 2, y, Color(200, 255, 200, alpha), 1, 1);
			
			if (ValidEntity(owner)) then
				local accessText = "You do not have access to this door";
				local accessColour = Color(255, 200, 200, alpha);
				
				if (RP.party.curParty and table.HasValue(RP.party.curParty, owner) or owner == LocalPlayer()) then
					accessText = "You have access to this door";
					accessColour = Color(200, 200, 255, alpha);
				end;
				
				RP.menu:DrawSimpleText(accessText, "doorFont", ScrW() / 2, y, accessColour, 1, 1);
			end;
		end;
	end;
end



--Author: Nori [Passed down from like, 3 gamemodes. Thanks!]
function PLUGIN:Get3D2DPos(door, reversed)
	local traceData = {};
	local obbCenter = door:OBBCenter();
	local obbMaxs = door:OBBMaxs();
	local obbMins = door:OBBMins();
	
	traceData.endpos = door:LocalToWorld(obbCenter);
	traceData.filter = ents.FindInSphere(traceData.endpos, 20);
	
	for k, v in pairs(traceData.filter) do
		if (v == door) then
			traceData.filter[k] = nil;
		end;
	end;
	
	local length = 0;
	local width = 0;
	local size = obbMins - obbMaxs;
	
	size.x = math.abs(size.x);
	size.y = math.abs(size.y);
	size.z = math.abs(size.z);
	
	if (size.z < size.x and size.z < size.y) then
		length = size.z;
		width = size.y;
		
		if (reverse) then
			traceData.start = traceData.endpos - (door:GetUp() * length);
		else
			traceData.start = traceData.endpos + (door:GetUp() * length);
		end;
	elseif (size.x < size.y) then
		length = size.x;
		width = size.y;
		
		if (reverse) then
			traceData.start = traceData.endpos - (door:GetForward() * length);
		else
			traceData.start = traceData.endpos + (door:GetForward() * length);
		end;
	elseif (size.y < size.x) then
		length = size.y;
		width = size.x;
		
		if (reverse) then
			traceData.start = traceData.endpos - (door:GetRight() * length);
		else
		
			traceData.start = traceData.endpos + (door:GetRight() * length);
		end;
	end;

	local trace = util.TraceLine(traceData);
	local angles = trace.HitNormal:Angle();
	
	if (trace.HitWorld and !reversed) then
		return self:CalculateDoorTextPosition(door, true);
	end;
	
	angles:RotateAroundAxis(angles:Forward(), 90);
	angles:RotateAroundAxis(angles:Right(), 90);
	
	local position = trace.HitPos - ( ( (traceData.endpos - trace.HitPos):Length() * 2) + 2 ) * trace.HitNormal;
	local anglesBack = trace.HitNormal:Angle();
	local positionBack = trace.HitPos + (trace.HitNormal * 2);
	
	anglesBack:RotateAroundAxis(anglesBack:Forward(), 90);
	anglesBack:RotateAroundAxis(anglesBack:Right(), -90);
	
	return {
		positionBack = positionBack,
		anglesBack = anglesBack,
		position = position,
		hitWorld = trace.HitWorld,
		angles = angles,
		width = math.abs(width)
	};
end;
