
local Clockwork = Clockwork
local pairs = pairs
local table = table

Clockwork.setting = Clockwork.kernel:NewLibrary("Setting")
Clockwork.setting.stored = Clockwork.setting.stored or {}

-- A function to add a number slider setting.
function Clockwork.setting:AddNumberSlider(category, text, conVar, minimum, maximum, decimals, toolTip, Condition)
	local index = #self.stored + 1

	self.stored[index] = {
		Condition = Condition,
		category = category,
		decimals = decimals,
		toolTip = toolTip,
		maximum = maximum,
		minimum = minimum,
		conVar = conVar,
		class = "numberSlider",
		text = text
	}

	return index
end

-- A function to add a multi-choice setting.
function Clockwork.setting:AddMultiChoice(category, text, conVar, options, toolTip, Condition)
	local index = #self.stored + 1

	if options then
		table.sort(options, function(a, b) return a < b end)
	else
		options = {}
	end

	self.stored[index] = {
		Condition = Condition,
		category = category,
		toolTip = toolTip,
		options = options,
		conVar = conVar,
		class = "multiChoice",
		text = text
	}

	return index
end

-- A function to add a number wang setting.
function Clockwork.setting:AddNumberWang(category, text, conVar, minimum, maximum, decimals, toolTip, Condition)
	local index = #self.stored + 1

	self.stored[index] = {
		Condition = Condition,
		category = category,
		decimals = decimals,
		toolTip = toolTip,
		maximum = maximum,
		minimum = minimum,
		conVar = conVar,
		class = "numberWang",
		text = text
	}

	return index
end

-- A function to add a text entry setting.
function Clockwork.setting:AddTextEntry(category, text, conVar, toolTip, Condition)
	local index = #self.stored + 1

	self.stored[index] = {
		Condition = Condition,
		category = category,
		toolTip = toolTip,
		conVar = conVar,
		class = "textEntry",
		text = text
	}

	return index
end

-- A function to add a check box setting.
function Clockwork.setting:AddCheckBox(category, text, conVar, toolTip, Condition)
	local index = #self.stored + 1

	self.stored[index] = {
		Condition = Condition,
		category = category,
		toolTip = toolTip,
		conVar = conVar,
		class = "checkBox",
		text = text
	}

	return index
end

-- A function to add a color mixer setting.
function Clockwork.setting:AddColorMixer(category, text, conVar, toolTip, Condition)
	local index = #self.stored + 1

	self.stored[index] = {
		Condition = Condition,
		category = category,
		toolTip = toolTip,
		conVar = conVar,
		class = "colorMixer",
		text = text
	}

	return index
end

-- A function to remove a setting by its index.
function Clockwork.setting:RemoveByIndex(index)
	self.stored[index] = nil
end

-- A function to remove a setting by its convar.
function Clockwork.setting:RemoveByConVar(conVar)
	for k, v in pairs(self.stored) do
		if v.conVar == conVar then
			self.stored[k] = nil
		end
	end
end

-- A function to remove a setting.
function Clockwork.setting:Remove(category, text, class, conVar)
	for k, v in pairs(self.stored) do
		if (not category or v.category == category) and (not conVar or v.conVar == conVar) and (not class or v.class == class) and (not text or v.text == text) then
			self.stored[k] = nil
		end
	end
end

function Clockwork.setting:AddSettings()
	if not Clockwork.setting.SettingsAdded then
		local langTable = {}

		for k, v in pairs(Clockwork.lang:GetAll()) do
			table.insert(langTable, k)
		end

		local themeTable = {}

		for k, v in pairs(Clockwork.theme:GetAll()) do
			table.insert(themeTable, k)
		end

		local frameworkStr = L("Framework")
		local chatBoxStr = L("ChatBox")
		local themeStr = L("Theme")

		Clockwork.setting:AddCheckBox(frameworkStr, "Enable the admin console log.", "cwShowLog", "Whether or not to show the admin console log.", function() return Clockwork.player:IsAdmin(Clockwork.Client) end)
		Clockwork.setting:AddCheckBox(frameworkStr, "Enable the twelve hour clock.", "cwTwelveHourClock", "Whether or not to show a twelve hour clock.")
		Clockwork.setting:AddCheckBox(frameworkStr, "Show bars at the top of the screen.", "cwTopBars", "Whether or not to show bars at the top of the screen.")
		Clockwork.setting:AddCheckBox(frameworkStr, "Enable the hints system.", "cwShowHints", "Whether or not to show you any hints.")
		Clockwork.setting:AddCheckBox(frameworkStr, "Enable Vignette.", "cwShowVignette", "Whether or not to draw the vignette.")
		Clockwork.setting:AddCheckBox(frameworkStr, "Enable Crosshair.", "cwShowCrosshair", "Whether or not to draw the crosshair.")
		Clockwork.setting:AddCheckBox(frameworkStr, "Enable Dynamic Crosshair.", "cwShowCrosshairDynamic", "Whether or not to draw the dynamic crosshair — can cause performace issues.")
		Clockwork.setting:AddNumberSlider(frameworkStr, "Headbob Amount:", "cwHeadbobScale", 0, 1, 1, "The amount to scale the headbob by.")
		Clockwork.setting:AddMultiChoice(frameworkStr, L("Language") .. ":", "cwLang", langTable, L("LangDesc"))

		Clockwork.setting:AddCheckBox(chatBoxStr, "Show timestamps on messages.", "cwShowTimeStamps", "Whether or not to show you timestamps on messages.")
		Clockwork.setting:AddCheckBox(chatBoxStr, "Show messages related to Clockwork.", "cwShowClockwork", "Whether or not to show you any Clockwork messages.")
		Clockwork.setting:AddCheckBox(chatBoxStr, "Show messages from the server.", "cwShowServer", "Whether or not to show you any server messages.")
		Clockwork.setting:AddCheckBox(chatBoxStr, "Show out-of-character messages.", "cwShowOOC", "Whether or not to show you any out-of-character messages.")
		Clockwork.setting:AddCheckBox(chatBoxStr, "Show in-character messages.", "cwShowIC", "Whether or not to show you any in-character messages.")
		Clockwork.setting:AddNumberSlider(chatBoxStr, "Chat Lines:", "cwMaxChatLines", 1, 10, 0, "The amount of chat lines shown at once.")

		Clockwork.setting:AddCheckBox(themeStr, "Fade Panels.", "cwFadePanels", "Whether or not to fade in and out menu panels.")
		Clockwork.setting:AddCheckBox(themeStr, "Show Gradient.", "cwShowGradient", "Whether or not to show a gradient background.")
		Clockwork.setting:AddNumberSlider(themeStr, "Tab Menu X-Axis:", "cwTabPosX", 0, ScrW(), 0, "The position of the tab menu on the X axis.")
		Clockwork.setting:AddNumberSlider(themeStr, "Tab Menu Y-Axis:", "cwTabPosY", 0, ScrH(), 0, "The position of the tab menu on the Y axis.")
		Clockwork.setting:AddMultiChoice(themeStr, themeStr .. ":", "cwActiveTheme", themeTable, "The current active GUI theme to display.", function() return Clockwork.config:Get("modify_themes"):GetBoolean() end)
		Clockwork.setting:AddColorMixer(themeStr, "Text Color:", "cwTextColor", "The Text Color", function() return not Clockwork.theme:IsFixed() end)

		Clockwork.setting:AddCheckBox("Admin ESP", "Enable the Admin ESP.", "cwAdminESP", "Whether or not to show the admin ESP.", function() return Clockwork.player:IsAdmin(Clockwork.Client) end)
		Clockwork.setting:AddCheckBox("Admin ESP", "Draw ESP Bars.", "cwESPBars", "Whether or not to draw progress bars for certain values.", function() return Clockwork.player:IsAdmin(Clockwork.Client) end)
		Clockwork.setting:AddCheckBox("Admin ESP", "Show Item Entities.", "cwItemESP", "Whether or not to view items in the admin ESP.", function() return Clockwork.player:IsAdmin(Clockwork.Client) end)
		Clockwork.setting:AddCheckBox("Admin ESP", "Show Salesmen Entities.", "cwSaleESP", "Whether or not to view salesmen in the admin ESP.", function() return Clockwork.player:IsAdmin(Clockwork.Client) end)
		Clockwork.setting:AddNumberSlider("Admin ESP", "ESP Interval:", "cwESPTime", 0, 2, 0, "The amount of time between ESP checks.", function() return Clockwork.player:IsAdmin(Clockwork.Client) end)

		Clockwork.setting.SettingsAdded = true
	end
end
