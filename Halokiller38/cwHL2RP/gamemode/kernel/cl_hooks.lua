--[[
	Free Clockwork!
--]]

local OUTLINE_MATERIAL = Material("white_outline");
Clockwork.schema.combineOverlay = Material("effects/combine_binocoverlay");
-- Called when the HUD should be painted.
function Clockwork.schema:HUDPaint()
	local colorWhite = Clockwork.option:GetColor("white");
	local curTime = CurTime();
	
end;

-- Called when a cash entity is drawn.
function Clockwork.schema:CashEntityDraw(entity)
	self:GeneratorEntityDraw(entity, Color(255, 255, 255, 255));
end;

-- Called when a shipment entity is drawn.
function Clockwork.schema:ShipmentEntityDraw(entity)
	//self:GeneratorEntityDraw(entity, Color(255, 255, 255, 255));
end;

-- Called when a generator entity is drawn.
function Clockwork.schema:GeneratorEntityDraw(entity, forceColor)
	local curTime = CurTime();
	local sineWave = math.max(math.abs(math.sin(curTime) * 32), 16);
	local r, g, b, a = entity:GetColor();
	local outlineColor = forceColor or Color(255, 255, 255, 255);
	
	render.SuppressEngineLighting(true);
	render.SetColorModulation(outlineColor.r / 255, outlineColor.g / 255, outlineColor.b / 255);
	
	render.SetAmbientLight(1, 1, 1);
	render.SetBlend(outlineColor.a / 255);
	entity:SetModelScale(Vector() * (1.025 + (sineWave / 320)));
	
	SetMaterialOverride(OUTLINE_MATERIAL);
		entity:DrawModel();
	SetMaterialOverride(nil);
	entity:SetModelScale(Vector());
	
	render.SetBlend(1);
	render.SetColorModulation(r / 255, g / 255, b / 255);
	render.SuppressEngineLighting(false);
end;

-- Called when an item entity is drawn.
function Clockwork.schema:ItemEntityDraw(itemTable, entity)
	-- local curTime = CurTime();
	-- local sineWave = math.max(math.abs(math.sin(curTime) * 32), 16);
	-- local r, g, b, a = entity:GetColor();
	-- local outlineColor = itemTable("color") or Color(255, 255, 255, 255);
	
	-- cam.Start3D(EyePos(), EyeAngles());
		-- render.SuppressEngineLighting(true);
		-- render.SetColorModulation(outlineColor.r / 255, outlineColor.g / 255, outlineColor.b / 255);
		
		-- render.SetAmbientLight(1, 1, 1);
		-- entity:SetModelScale(Vector() * (1.025 + (sineWave / 320)));
		
		-- SetMaterialOverride(OUTLINE_MATERIAL);
			-- entity:DrawModel();
		-- SetMaterialOverride(nil);
		-- entity:SetModelScale(Vector());
		
		-- render.SetColorModulation(r / 255, g / 255, b / 255);
		-- render.SuppressEngineLighting(false);
	-- cam.End3D();
end;

-- Called just after a player is drawn.
function Clockwork.schema:PostPlayerDraw(player)
	
end;

-- Called when the target player's text is needed.
function Clockwork.schema:GetTargetPlayerText(player, targetPlayerText)
	
end;


-- Called when the local player's color modify should be adjusted.
function Clockwork.schema:PlayerAdjustColorModify(colorModify)
	local interval = FrameTime() / 2;
	
	if (!self.colorModify) then
		self.colorModify = {
			brightness = colorModify["$pp_colour_brightness"],
			contrast = colorModify["$pp_colour_contrast"],
			color = colorModify["$pp_colour_colour"],
			mulr = colorModify["$pp_colour_mulr"],
			mulg = colorModify["$pp_colour_mulg"],
			mulb = colorModify["$pp_colour_mulb"]
		};
	end;
	
	if (self.thirdPersonAmount > 0) then
		colorModify["$pp_colour_contrast"] = 1.2;
		colorModify["$pp_colour_colour"] = 0.6;
	end;
	
	if (self.suppressEffect) then
		local curTime = CurTime();
		local timeLeft = self.suppressEffect - curTime;
		local curColor = colorModify["$pp_colour_colour"];
		local curContrast = colorModify["$pp_colour_contrast"];
		
		if (timeLeft > 0) then
			colorModify["$pp_colour_colour"] = curColor - ((curColor / 10) * timeLeft);
			colorModify["$pp_colour_contrast"] = curContrast + ((0.5 / 10) * timeLeft);
		end;
		
		interval = (interval * 3);
	end;
	
	self.colorModify.brightness = math.Approach(self.colorModify.brightness, colorModify["$pp_colour_brightness"], interval);
	self.colorModify.contrast = math.Approach(self.colorModify.contrast, colorModify["$pp_colour_contrast"], interval);
	self.colorModify.color = math.Approach(self.colorModify.color, colorModify["$pp_colour_colour"], interval);
	self.colorModify.mulr = math.Approach(self.colorModify.mulr, colorModify["$pp_colour_mulr"], interval);
	self.colorModify.mulg = math.Approach(self.colorModify.mulg, colorModify["$pp_colour_mulg"], interval);
	self.colorModify.mulb = math.Approach(self.colorModify.mulb, colorModify["$pp_colour_mulb"], interval);
	
	colorModify["$pp_colour_brightness"] = self.colorModify.brightness;
	colorModify["$pp_colour_contrast"] = self.colorModify.contrast;
	colorModify["$pp_colour_colour"] = self.colorModify.color;
	colorModify["$pp_colour_mulr"] = self.colorModify.mulr;
	colorModify["$pp_colour_mulg"] = self.colorModify.mulg;
	colorModify["$pp_colour_mulb"] = self.colorModify.mulb;
end;

-- Called when the local player attempts to see the top bars.
function Clockwork.schema:PlayerCanSeeBars(class)
	if (class == "top") then
		return true;
	end;
		-- end;
	-- elseif (class == "tab") then
		-- return false;
	-- elseif (class == "3d") then
		-- return true;
	-- end;
	return false;
end;

function Clockwork.schema:GetBars(bars)
	local stam = Clockwork.Client:GetSharedVar("Stamina");
	bars:Add("STAMINA", Color(100, 175, 100, 255), "", stam, 100, stam < 30);
end;

-- Called when the local player should be drawn.
function Clockwork.schema:ShouldDrawLocalPlayer()
	-- if ((Clockwork.Client:IsRunning() and !Clockwork.player:IsNoClipping(Clockwork.Client))
	-- and (!self.overrideThirdPerson or UnPredictedCurTime() >= self.overrideThirdPerson)) then
		-- self.thirdPersonAmount = math.Approach(self.thirdPersonAmount, 1, FrameTime() / 10);
	-- else
		-- self.thirdPersonAmount = math.Approach(self.thirdPersonAmount, 0, FrameTime() / 10);
	-- end;
	
	-- if (self.thirdPersonAmount > 0) then
		-- return true;
	-- end;
end;

-- Called when the local player's item menu should be adjusted.
function Clockwork.schema:PlayerAdjustItemMenu(itemTable, menuPanel, itemFunctions)
	if (itemTable:IsBasedFrom("custom_weapon") or itemTable:IsBasedFrom("custom_clothes")) then
		-- menuPanel:AddOption("Repair", function()
			-- Clockwork:StartDataStream("RepairItem", Clockwork.item:GetSignature(itemTable));
		-- end);
		
		local durability = itemTable:GetData("Durability");
		local panel = menuPanel.Items[#menuPanel.Items];
		
		if (IsValid(panel)) then
			if (durability == 100) then
				panel:SetToolTip("This item already has full durability and does not need to be repaired.");
				return;
			end;
			
			local itemCost = itemTable("cost");
			local minPrice = itemCost * 0.25;
			local maxPrice = itemCost * 0.75;
			local repairCost = math.max((maxPrice / 100) * (100 - durability), minPrice);
			local currentCash = Clockwork.player:GetCash();
			
			if (currentCash >= minPrice) then
				panel:SetToolTip("You need atleast "..FORMAT_CASH(minPrice, true).." to begin repairing this item.");
				return;
			end;
			
			if (currentCash < repairCost) then
				local newDurability = ((100 - durability) / repairCost) * currentCash;
				local newRepairCost = (repairCost / (100 - durability)) * newDurability;
				panel:SetToolTip("You can repair this item to "..(math.Round((durability + newDurability))).."% for "..FORMAT_CASH(newRepairCost, true)..".");
			else
				panel:SetToolTip("This item will cost you "..FORMAT_CASH(repairCost, true).." to fully repair.");
			end;
		end;
	end;
end;

-- Called to check if a player does recognise another player.
function Clockwork.schema:PlayerDoesRecognisePlayer(player, status, isAccurate, realValue)
	if (self:PlayerIsCombine(player) or player:GetFaction() == FACTION_CITYADMIN) then
		return true;
	end;
end;

-- Called when an entity's menu options are needed.
function Clockwork.schema:GetEntityMenuOptions(entity, options)
	local mineTypes = {"cw_firemine", "cw_freezemine", "cw_explomine"};
	
	if (entity:GetClass() == "cw_belongings") then
		options["Open"] = "cwBelongingsOpen";
	elseif (entity:GetClass() == "cw_breach") then
		options["Charge"] = "cwBreachCharge";
	elseif (entity:IsPlayer()) then
		local cashEnabled = Clockwork.config:Get("cash_enabled"):Get();
		local cashName = Clockwork.option:GetKey("name_cash");
		
		options["Quick Admin Report"] = {
			Callback = function(entity) Clockwork:RunCommand("PlyReport"); end,
			isArgTable = true,
			toolTip = "Report this player to the admin team."
		};
		
		if (self:PlayerIsCombine(Clockwork.Client)) then
			options["View Combine Data"] = {
				Callback = function(entity) Clockwork:RunCommand("ViewData"); end,
				isArgTable = true,
				toolTip = "View the data stored on the combine database about this character."
			};
		end;
		
		if (entity:GetSharedVar("IsTied")) then
			options["Unrestrain"] = {
				Callback = function(entity) Clockwork:RunCommand("PlyUntie"); end,
				isArgTable = true,
				toolTip = "Cut the restraint on this character. They must stand still."
			};
			options["Search"] = {
				Callback = function(entity) Clockwork:RunCommand("CharSearch"); end,
				isArgTable = true,
				toolTip = "Search through this character's belongings."
			};
		else
			if (Clockwork.inventory:HasItemByID(Clockwork.inventory:GetClient(), "zip_tie")) then
				options["Restrain"] = {
					Callback = function(entity) Clockwork:RunCommand("InvAction", "use", "zip_tie"); end,
					isArgTable = true,
					toolTip = "Use a restraint on this character."
				};
			end;
		end;
		
		if (cashEnabled) then
			options["Give "..cashName] = {
				Callback = function(entity)
					Derma_StringRequest("Amount", "How many "..string.lower(cashName).." you want to give them?", "0", function(text)
						Clockwork:RunCommand("Give"..string.gsub(cashName, "%s", ""), text);
					end);
				end,
				isArgTable = true,
				toolTip = "Give this character some "..string.lower(cashName).."."
			};
		end;
	end;
	
	if (Clockwork.entity:IsPhysicsEntity(entity)) then
		local model = string.lower(entity:GetModel());
		
		if (self.containers[model]) then
			options["Open"] = "cwContainerOpen";
		end;
	elseif (entity:GetClass() == "cw_locker") then
		options["Open"] = "cwContainerOpen";
	end;
end;

-- Called when a player's footstep sound should be played.
function Clockwork.schema:PlayerFootstep(player, position, foot, sound, volume, recipientFilter)
	return true;
end;

-- Called when a text entry has gotten focus.
function Clockwork.schema:OnTextEntryGetFocus(panel)
	self.textEntryFocused = panel;
end;

-- Called when a text entry has lost focus.
function Clockwork.schema:OnTextEntryLoseFocus(panel)
	self.textEntryFocused = nil;
end;

-- Called when the cinematic intro info is needed.
function Clockwork.schema:GetCinematicIntroInfo()
	return {
		credits = "Designed and developed by "..self:GetAuthor()..".",
		title = Clockwork.config:Get("intro_text_big"):Get(),
		text = Clockwork.config:Get("intro_text_small"):Get()
	};
end;

-- Called when the target's status should be drawn.
function Clockwork.schema:DrawTargetPlayerStatus(target, alpha, x, y)
	local colorInformation = Clockwork.option:GetColor("information");
	local thirdPerson = "him";
	local mainStatus = nil;
	local untieText = nil;
	local gender = "He";
	local action = Clockwork.player:GetAction(target);
	
	if (target:GetGender() == GENDER_FEMALE) then
		thirdPerson = "her";
		gender = "She";
	end;
	
	if (target:Alive()) then
		if (action == "die") then
			mainStatus = gender.." is in critical condition.";
		end;
		
		if (target:GetRagdollState() == RAGDOLL_KNOCKEDOUT) then
			mainStatus = gender.." is clearly unconscious.";
		end;
		
		if (target:GetSharedVar("IsTied")) then
			if (Clockwork.player:GetAction(Clockwork.Client) == "untie") then
				mainStatus = gender.. " is being un-restrained.";
			else
				mainStatus = gender.." has been restrained.";
			end;
		elseif (Clockwork.player:GetAction(Clockwork.Client) == "chloro") then
			mainStatus = gender.." is having chloroform used on "..thirdPerson..".";
		elseif (Clockwork.player:GetAction(Clockwork.Client) == "tie") then
			mainStatus = gender.." is being restrained.";
		end;
		
		if (mainStatus) then
			y = Clockwork:DrawInfo(mainStatus, x, y, colorInformation, alpha);
		end;
		
		return y;
	end;
end;

-- Called to get whether a player's target ID should be drawn.
function Clockwork.schema:ShouldDrawPlayerTargetID(player)
	if (player:GetMaterial() == "sprites/heatwave") then
		return false;
	end;
end;

-- Called when screen space effects should be rendered.
function Clockwork.schema:RenderScreenspaceEffects()
	local modify = {};
	
	if (!Clockwork:IsScreenFadedBlack()) then
		local curTime = CurTime();
		
		if (self.flashEffect) then
			local timeLeft = math.Clamp(self.flashEffect[1] - curTime, 0, self.flashEffect[2]);
			local incrementer = 1 / self.flashEffect[2];
			
			if (timeLeft > 0) then
				modify = {};
				
				modify["$pp_colour_brightness"] = 0;
				modify["$pp_colour_contrast"] = 1 + (timeLeft * incrementer);
				modify["$pp_colour_colour"] = 1 - (incrementer * timeLeft);
				modify["$pp_colour_addr"] = incrementer * timeLeft;
				modify["$pp_colour_addg"] = 0;
				modify["$pp_colour_addb"] = 0;
				modify["$pp_colour_mulr"] = 1;
				modify["$pp_colour_mulg"] = 0;
				modify["$pp_colour_mulb"] = 0;
				
				DrawColorModify(modify);
				DrawMotionBlur(1 - (incrementer * timeLeft), 1, 0);
			end;
		end;
		
		if (self.tearGassed) then
			local timeLeft = self.tearGassed - curTime;
			
			if (timeLeft > 0) then
				if (timeLeft >= 15) then
					DrawMotionBlur(0.1 + (0.9 / (20 - timeLeft)), 1, 0);
				else
					DrawMotionBlur(0.1, 1, 0);
				end;
			else
				self.tearGassed = nil;
			end;
		end;

		if ( self:PlayerIsCombine(Clockwork.Client) ) then
			render.UpdateScreenEffectTexture();
			
			self.combineOverlay:SetMaterialFloat("$refractamount", 0.3);
			self.combineOverlay:SetMaterialFloat("$envmaptint", 0);
			self.combineOverlay:SetMaterialFloat("$envmap", 0);
			self.combineOverlay:SetMaterialFloat("$alpha", 0.5);
			self.combineOverlay:SetMaterialInt("$ignorez", 1);
			
			render.SetMaterial(self.combineOverlay);
			render.DrawScreenQuad();
		end;
	end;
end;

-- Called when the local player's motion blurs should be adjusted.
function Clockwork.schema:PlayerAdjustMotionBlurs(motionBlurs)
	if (self.suppressEffect) then
		local curTime = CurTime();
		local timeLeft = self.suppressEffect - curTime;
		
		if (timeLeft > 0) then
			motionBlurs.blurTable["Suppression"] = 1 - ((1 / 10) * timeLeft);
		end;
	end;
end;

-- Called when the calc view table should be adjusted.
function Clockwork.schema:CalcViewAdjustTable(view)
	if (self.thirdPersonAmount > 0 and !Clockwork.player:IsNoClipping(Clockwork.Client)) then
		local defaultOrigin = view.origin;
		local traceLine = nil;
		local position = Clockwork.Client:EyePos();
		local angles = Clockwork.Client:GetRenderAngles():Forward();
		
		if (defaultOrigin) then
			traceLine = util.TraceLine({
				start = position,
				endpos = position - (angles * (80 * self.thirdPersonAmount)),
				filter = Clockwork.Client
			});
			
			if (traceLine.Hit) then
				view.origin = traceLine.HitPos + (angles * 4) + Vector(0, 0, 16);
				
				if (view.origin:Distance(position) <= 32) then
					view.origin = defaultOrigin + Vector(0, 0, 16);
				end;
			else
				view.origin = traceLine.HitPos + Vector(0, 0, 16);
			end;
		end;
	end;
end;

-- Called when the foreground HUD should be painted.
function Clockwork.schema:HUDPaintForeground()
	local backgroundColor = Clockwork.option:GetColor("background");
	local dateTimeFont = Clockwork.option:GetFont("date_time_text");
	local colorWhite = Clockwork.option:GetColor("white");
	local y = (ScrH() / 2) - 128;
	local x = ScrW() / 2;
	
	if (Clockwork.Client:Alive()) then
		local curTime = CurTime();
		
		if (self.stunEffects) then
			for k, v in pairs(self.stunEffects) do
				local alpha = math.Clamp((255 / v[2]) * (v[1] - curTime), 0, 255);
				
				if (alpha != 0) then
					draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(255, 255, 255, alpha));
				else
					table.remove(self.stunEffects, k);
				end;
			end;
		end;
		
		if (self.shotEffect) then
			local alpha = math.Clamp((255 / self.shotEffect[2]) * (self.shotEffect[1] - curTime), 0, 255);
			local scrH = ScrH();
			local scrW = ScrW();
			
			if (alpha != 0) then
				draw.RoundedBox(0, 0, 0, scrW, scrH, Color(255, 50, 50, alpha));
			end;
		end;
		
		if (#self.damageNotify > 0) then
			Clockwork:OverrideMainFont(dateTimeFont);
				for k, v in ipairs(self.damageNotify) do
					local alpha = math.Clamp((255 / v.duration) * (v.endTime - curTime), 0, 255);
					
					if (alpha != 0) then
						local position = v.position:ToScreen();
						local canSee = Clockwork.player:CanSeePosition(Clockwork.Client, v.position);
						
						if (canSee) then
							Clockwork:DrawInfo(v.text, position.x, position.y - ((255 - alpha) / 2), v.color, alpha);
						end;
					else
						table.remove(self.damageNotify, k);
					end;
				end;
			Clockwork:OverrideMainFont(false);
		end;
	end;
end;

-- Called to get the screen text info.
function Clockwork.schema:GetScreenTextInfo()
	local blackFadeAlpha = Clockwork:GetBlackFadeAlpha();
	
	if (!Clockwork.Client:Alive() and self.deathType) then
		return {
			alpha = blackFadeAlpha,
			title = "YOU WERE KILLED BY "..self.deathType,
			text = "Crying to an admin won't get you anywhere..."
		};
	elseif (Clockwork.Client:GetSharedVar("BeingChloro")) then
		return {
			alpha = 255 - blackFadeAlpha,
			title = "SOMEBODY IS USING CHLOROFORM ON YOU"
		};
	elseif (Clockwork.Client:GetSharedVar("BeingTied")) then
		return {
			alpha = 255 - blackFadeAlpha,
			title = "YOU ARE BEING RESTRAINED"
		};
	elseif (Clockwork.Client:GetSharedVar("IsTied")) then
		return {
			alpha = 255 - blackFadeAlpha,
			title = "YOU HAVE BEEN RESTRAINED"
		};
	end;
end;

-- Called when the chat box info should be adjusted.
function Clockwork.schema:ChatBoxAdjustInfo(info)
	if ( IsValid(info.speaker) ) then
		if (info.data.anon) then
			info.name = "Somebody";
		end;
		
		if ( self:PlayerIsCombine(info.speaker) ) then
			if ( self:IsPlayerCombineRank(info.speaker, "SCN") ) then
				if (info.class == "radio" or info.class == "radio_eavesdrop") then
					info.name = "Dispatch";
				end;
			end;
		end;
	end;
end;

-- Called when the post progress bar info is needed.
function Clockwork.schema:GetPostProgressBarInfo()
	if (Clockwork.Client:Alive()) then
		local action, percentage = Clockwork.player:GetAction(Clockwork.Client, true);
		
		if (action == "die") then
			return {text = "You are slowly dying.", percentage = percentage, flash = percentage > 75};
		elseif (action == "chloroform") then
			return {text = "You are using chloroform on somebody.", percentage = percentage, flash = percentage > 75};
		elseif (action == "defuse") then
			return {text = "You are defusing a landmine.", percentage = percentage, flash = percentage > 75};
		end;
	end;
end;

-- Called when an entity's target ID HUD should be painted.
function Clockwork.schema:HUDPaintEntityTargetID(entity, info)
	local colorTargetID = Clockwork.option:GetColor("target_id");
	local colorWhite = Clockwork.option:GetColor("white");
	
	if (Clockwork.entity:IsPhysicsEntity(entity)) then
		local model = string.lower(entity:GetModel());
		
		if (self.containers[model]) then
			info.y = Clockwork:DrawInfo(self.containers[model][2], info.x, info.y, colorTargetID, info.alpha);
			
			if (entity:GetNetworkedString("Name") != "") then
				info.y = Clockwork:DrawInfo(entity:GetNetworkedString("Name"), info.x, info.y, colorWhite, info.alpha);
			else
				info.y = Clockwork:DrawInfo("It can temporarily hold stuff.", info.x, info.y, colorWhite, info.alpha);
			end;
		end;
	elseif (entity:GetClass() == "cw_locker") then
		info.y = Clockwork:DrawInfo("Locker", info.x, info.y, colorTargetID, info.alpha);
		info.y = Clockwork:DrawInfo("It can permanently hold stuff.", info.x, info.y, colorWhite, info.alpha);
	end;
end;

-- Called when the local player's storage is rebuilt.
function Clockwork.schema:PlayerStorageRebuilt(panel, categories)
	if (panel.storageType == "Container") then
		local entity = Clockwork.storage:GetEntity();
		
		if (IsValid(entity) and entity.cwMessage) then
			local messageForm = vgui.Create("DForm", panel);
			local helpText = messageForm:Help(entity.cwMessage);
			
			messageForm:SetPadding(5);
			messageForm:SetName("Message");
			helpText:SetFont("Default");
			
			panel:AddItem(messageForm);
		end;
	end;
end;