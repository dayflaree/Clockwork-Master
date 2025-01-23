--==============
--	Generators
--==============
surface.CreateFont("Arial", 14, 600, true, false, "generator_power", false, false, 0);
surface.CreateFont("Arial", 24, 600, true, false, "generator_shards", false, false, 0);

-- local spriteData = {
	-- material = Material("sprites/blueglow2"),
	-- colour = Color(0, 255, 0, 150)
-- };

RP.generator.upgradeBars = {};

function RP.generator:AddUpgradeBar(entity, time, customData)
	local curTime = CurTime();
	
	local data = {
		entity = entity,
		startTime = curTime,
		endTime = curTime + time,
		text = "Upgrade",
		colour = Color(100, 93, 150, 255)
	};
	
	if (customData) then
		for k,v in pairs(customData) do
			data[k] = v;
		end;
	end;
	
	self.upgradeBars[entity] = data;
	
	timer.Simple(time, function()
		self.upgradeBars[entity] = nil;
	end);
end;

RP:DataHook("addUpgradeBar", function(data)
	local entity = data[1];
	local time = data[2];
	local custom = data[3];
	
	RP.generator:AddUpgradeBar(entity, time, custom);
end);

-- function PLUGIN:HUDPaint()
	-- local generator = LocalPlayer():GetEyeTraceNoCursor().Entity;
	
	-- if (ValidEntity(generator) and generator:GetClass() == "rp_generator") then
		-- local power = generator:GetNWInt("genEnergy");
		-- local _type = generator:GetNWString("genType");
		-- local genData = RP.generator:Get(_type);
		-- local alpha = 255 - 255 * math.TimeFraction(0, 256, LocalPlayer():GetPos():Distance(generator:GetPos()));
		
		-- if (genData) then			
			-- local mul = math.TimeFraction(0, genData.startEnergy, power);
			-- local x, y = ScrW() / 2 - 60, ScrH() / 2 - 6;
			
			-- if (generator:GetNWInt("holdingAmount") > 0) then
				-- draw.SimpleTextOutlined("Holding "..generator:GetNWInt("holdingAmount").." shards", "generator_power", x, y, Color(150, 150, 200, alpha), 0, 0, 1, Color(0, 0, 0, alpha));
				-- y = y + 16;
			-- end;
			
			-- draw.RoundedBox(4, x, y, 120, 14, Color(0, 0, 0, alpha * 0.75));
			-- draw.RoundedBox(4, x + 1, y + 1, 118 * mul, 12, Color(200, 150, 0, alpha));
			
			-- draw.SimpleTextOutlined("POWER", "generator_power", x + 60, y + 7, Color(255, 255, 255, alpha), 1, 1, 1, Color(0, 0, 0, alpha));
		-- end;
	-- end;
	
	-- for k,v in ipairs(ents.FindByClass("rp_generator")) do
		-- if (v:GetNWInt("holdingAmount") > 0) then
			-- cam.Start3D(EyePos(),EyeAngles()) ;
				-- render.SetMaterial(spriteData.material);
				-- render.DrawSprite(v:GetPos() + Vector(0, 0, 32), 16, 16, spriteData.colour);
			-- cam.End3D();
		-- end;
	-- end;
-- end;
