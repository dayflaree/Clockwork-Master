--[[
	Free Clockwork!
--]]

local PLUGIN = PLUGIN;

-- Called when the client initializes.
function PLUGIN:Initialize()
	CW_CONVAR_SHOWAREAS = Clockwork:CreateClientConVar("cwShowAreas", 1, true, true);
end;

-- Called when the local player has entered an area.
function PLUGIN:PlayerEnteredArea(name, minimum, maximum)
	Clockwork:StartDataStream("EnteredArea", {name, minimum, maximum});
end;

-- Called just after the translucent renderables have been drawn.
function PLUGIN:PostDrawTranslucentRenderables(bDrawingDepth, bDrawingSkybox)
	if (bDrawingSkybox or bDrawingDepth) then return; end;
	
	local colorWhite = Clockwork.option:GetColor("white");
	local eyeAngles = EyeAngles();
	local curTime = UnPredictedCurTime();
	local eyePos = EyePos();
	local font = Clockwork.option:GetFont("large_3d_2d");
	
	Clockwork:OverrideMainFont(font);
		cam.Start3D(eyePos, eyeAngles);
			for k, v in pairs(self.activeDisplays) do
				local areaTable = v.areaTable;
				
				cam.Start3D2D(areaTable.position, areaTable.angles, (areaTable.scale or 1) * 0.2);
					Clockwork:DrawInfo(areaTable.name, 0, 0, colorWhite, v.alpha, nil, function(x, y, width, height)
						return x, y - (height / 2);
					end, 3);
				cam.End3D2D();
				
				if (v.target == 255) then
					v.alpha = math.Clamp(1 - ((v.fadeTime - curTime) / 4), 0, 1) * 255;
					
					if (v.alpha == 255) then
						v.reverseFade = curTime + 6;
						v.fadeTime = nil;
						v.target = 0;
					end;
				elseif (curTime >= v.reverseFade) then
					if (!v.fadeTime) then
						v.fadeTime = curTime + 2;
					end;
					
					v.alpha = 255 - (math.Clamp(1 - ((v.fadeTime - curTime) / 2), 0, 1) * 255);
					
					if (v.alpha == 0) then
						self.activeDisplays[k] = nil;
					end;
				end;
			end;
		cam.End3D();
	Clockwork:OverrideMainFont(false);
end;

-- Called each tick.
function PLUGIN:Tick()
	if (IsValid(Clockwork.Client) and Clockwork.Client:HasInitialized()) then
		local lastAreaDisplay = self.currentAreaDisplay;
		local didLeave = false;
		local curTime = UnPredictedCurTime();
		
		if (!self.nextCheckAreaDisplays or curTime >= self.nextCheckAreaDisplays) then
			self.nextCheckAreaDisplays = curTime + 1;
			
			for k, v in pairs(self.areaDisplays) do
				if (Clockwork.entity:IsInBox(Clockwork.Client, v.minimum, v.maximum)) then
					if (self.currentAreaDisplay != v.name) then
						if (!v.expires) then
							self.currentAreaDisplay = v.name;
							
							Clockwork.plugin:Call("PlayerEnteredArea", v.name, v.minimum, v.maximum);
							
							if (lastAreaDisplay) then
								Clockwork.plugin:Call("PlayerExitedArea", lastAreaDisplay, v.name);
							end;
						end;
						
						if (CW_CONVAR_SHOWAREAS:GetInt() == 1 or v.expires) then
							self:AddAreaDisplayDisplay(v);
						end;
						
						self:SetExpired(k);
					end;
					
					return;
				elseif (lastAreaDisplay == v.name) then
					didLeave = v.name;
				end;
			end;
			
			if (didLeave) then
				Clockwork.plugin:Call("PlayerExitedArea", didLeave);
			end;
		end;
	end;
end;