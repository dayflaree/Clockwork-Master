local spriteData = {
	material = Material("sprites/blueglow2"),
	colour = Color(0, 255, 0, 150)
};

-- This is called when the entity should draw.
function ENT:Draw() 
	self.Entity:DrawModel();
	
	local Pos = self:GetPos() + Vector(0, 0, 24);
	local angle = self:GetAngles();
	local alpha = 255 - 255 * math.TimeFraction(0, 256, LocalPlayer():GetPos():Distance(self:GetPos()));
	
	surface.SetFont("generator_shards")
	
	local text = tostring("Holding: "..self:GetNWInt("holdingAmount").." shards");
	local TextWidth = surface.GetTextSize(text)	
	
	local x, y = -60, 8;
	local power = self:GetNWInt("genEnergy");
	local _type = self:GetNWString("genType");
	local genData = RP.generator:Get(_type);
	
	if (genData) then		
		local traceData = {
			start = LocalPlayer():EyePos(),
			endpos = self:GetPos(),
			filter = {LocalPlayer(), self}
		};
		local trace = util.TraceLine(traceData);
		
		cam.IgnoreZ(true);
		
		if (!trace.Hit) then

			local mul = math.TimeFraction(0, genData.startEnergy, power);
			local upgrade = RP.generator.upgradeBars[self.Entity];
			
			cam.Start3D2D(Pos, Angle(0, angle.yaw, 90), 0.2);
				if (self:GetNWInt("holdingAmount") > 0) then
					draw.SimpleTextOutlined(text, "generator_shards", 0, -24, Color(255, 255, 255, alpha), 1, 1, 1, Color(0, 0, 0, alpha));
				end;
				
				draw.SimpleTextOutlined(genData.name, "generator_power", x + 60, y - 12, Color(255, 255, 255, alpha), 1, 1, 1, Color(0, 0, 0, alpha));

				surface.SetDrawColor(0, 0, 0, alpha * 0.75);
				surface.DrawRect(x, y, 120, 14);
				surface.SetDrawColor(200, 150, 0, alpha);
				
				local xOffset = mul * 59;
				surface.DrawRect(x + 60 - xOffset, y + 1, 118*mul, 12);
				
				draw.SimpleTextOutlined("POWER", "generator_power", x + 60, y + 7, Color(255, 255, 255, alpha), 1, 1, 1, Color(0, 0, 0, alpha));
				
				if (upgrade) then
					local upgradeMul = math.TimeFraction(upgrade.startTime, upgrade.endTime, CurTime());
					local colour = RP:ModAlpha(upgrade.colour, alpha);
					local newY = y + 16;
					
					surface.SetDrawColor(0, 0, 0, alpha * 0.75);
					surface.DrawRect(x, newY, 120, 14);
					surface.SetDrawColor(colour);
					
					local xOffset = upgradeMul * 59;
					surface.DrawRect(x + 60 - xOffset, newY + 1, 118*upgradeMul, 12);
					
					draw.SimpleTextOutlined("UPGRADING", "generator_power", x + 60, newY + 7, Color(255, 255, 255, alpha), 1, 1, 1, Color(0, 0, 0, alpha));
				end;
			cam.End3D2D();
			
			angle:RotateAroundAxis(angle:Right(), 180);
			
			cam.Start3D2D(Pos, Angle(0, angle.yaw, 90), 0.2);
				if (self:GetNWInt("holdingAmount") > 0) then
					draw.SimpleTextOutlined(text, "generator_shards", 0, -24, Color(255, 255, 255, alpha), 1, 1, 1, Color(0, 0, 0, alpha));
				end;
				
				draw.SimpleTextOutlined(genData.name, "generator_power", x + 60, y - 12, Color(255, 255, 255, alpha), 1, 1, 1, Color(0, 0, 0, alpha));
				draw.SimpleTextOutlined("POWER", "generator_power", x + 60, y + 7, Color(255, 255, 255, alpha), 1, 1, 1, Color(0, 0, 0, alpha));
				
				if (upgrade) then
					local newY = y + 16;
					
					draw.SimpleTextOutlined("UPGRADING", "generator_power", x + 60, newY + 7, Color(255, 255, 255, alpha), 1, 1, 1, Color(0, 0, 0, alpha));
				end;
			cam.End3D2D();
			
			if (self:GetNWInt("holdingAmount") > 0) then
				cam.Start3D(EyePos(),EyeAngles());
					render.SetMaterial(spriteData.material);
					render.DrawSprite(self:GetPos() + Vector(0, 0, 40), 16, 16, spriteData.colour);
				cam.End3D();
			end;
			
		end;
		cam.IgnoreZ(false);

	end;
end;

-- Creates the floating cash model.
function ENT:CreateFloatCash()
	local pos = self.Entity:GetPos();
	
	self.cashModel = ClientsideModel("models/props/cs_assault/Money.mdl", RENDERGROUP_OPAQUE);
	self.cashModel:SetPos(pos + Vector(0, 0, 40));
	self.cashModel:SetAngles(Angle(0, 0, 90));
	self.cashModel:SetColor(200, 255, 200, 150);
end;

-- Called every frame.
function ENT:Think()
	if (self:GetNWInt("holdingAmount") > 0 and !ValidEntity(self.cashModel)) then
		self:CreateFloatCash();
	end;
	
	if (ValidEntity(self.cashModel)) then
		local angle = self.cashModel:GetAngles();
		self.cashModel:SetAngles(angle + Angle(0, 1, 0));
		
		local pos = self.Entity:GetPos();
		self.cashModel:SetPos(pos + Vector(0, 0, 40));
		
		if (self:GetNWInt("holdingAmount") <= 0) then
			self.cashModel:Remove();
			self.cashModel = nil;
		end;
	end;
end;

-- Called when the entity is removed.
function ENT:OnRemove()
	if (self.cashModel) then
		self.cashModel:Remove();
		self.cashModel = nil;
	end;
end;
