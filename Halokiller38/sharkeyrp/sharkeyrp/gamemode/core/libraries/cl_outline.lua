RP.outline = {};

local OUTLINE_MATERIAL = Material("models/shadertest/predator");

function RP.outline:DrawOutline(entity, forceColor, throughWalls, forceScale)
	local r, g, b, a = entity:GetColor();
	local outlineColor = forceColor or Color(255, 0, 255, 255);
	
	if (throughWalls) then
		cam.IgnoreZ(true);
	end;
	
	-- render.SuppressEngineLighting(true);
	-- render.SetColorModulation(outlineColor.r / 255, outlineColor.g / 255, outlineColor.b / 255);
	render.SetAmbientLight(outlineColor.r / 255, outlineColor.g / 255, outlineColor.b / 255);
	render.SetBlend(outlineColor.a / 255);
	entity:SetModelScale(Vector() * 1.025 * forceScale);
	

	
	SetMaterialOverride(OUTLINE_MATERIAL);
		entity:DrawModel();
	SetMaterialOverride(nil);
	
	entity:SetModelScale( Vector() );
	-- render.SetBlend(1);
	-- render.SetColorModulation(r / 255, g / 255, b / 255);
	-- render.SuppressEngineLighting(false);
	
	if (!throughWalls) then
		entity:DrawModel();
	else
		cam.IgnoreZ(false);
	end;
end;

