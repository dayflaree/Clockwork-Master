
local Clockwork = Clockwork;
local PLUGIN = PLUGIN;
local Color = Color;

Clockwork.config:AddToSystem("[Needs] Kill On Max Needs", "kill_on_max_needs", "Enable players being killed when reaching max hunger or thirst.");
Clockwork.config:AddToSystem("[Needs] Hunger Hours", "hunger_hours", "How many hours it takes for a player to gain 60 hunger.", 0, 24, 0);
Clockwork.config:AddToSystem("[Needs] Thirst Hours", "thirst_hours", "How many hours it takes for a player to gain 60 thirst.", 0, 24, 0);
Clockwork.config:AddToSystem("[Needs] Needs Tick Time", "needs_tick_time", "How many seconds between each time a player's needs are calculated.", 0, 300, 0);

function PLUGIN:GetHungerText(hunger)
	if (hunger <= 50) then
		return "Satisfied", Color(34, 139, 34, 255); -- green
	elseif (hunger <= 60) then
		return "Slightly Hungry", Color(102, 255, 51, 255); -- lime green
	elseif (hunger <= 80) then
		return "Hungry", Color(255, 255, 0, 255); -- yellow
	elseif (hunger <= 90) then
		return "Very Hungry", Color(255, 140, 0, 255); -- orange
	elseif (hunger <= 100) then
		return "Starving", Color(255, 0, 0, 255); -- red
	end;

	return "Unknown", Color(255, 255, 255, 255);
end;

function PLUGIN:GetThirstText(thirst)
	if (thirst <= 50) then
		return "Satisfied", Color(34, 139, 34, 255); -- green
	elseif (thirst <= 60) then
		return "Slightly Thirsty", Color(102, 255, 51, 255); -- lime green
	elseif (thirst <= 80) then
		return "Thirsty", Color(255, 255, 0, 255); -- yellow
	elseif (thirst <= 90) then
		return "Very Thirsty", Color(255, 140, 0, 255); -- orange
	elseif (thirst <= 100) then
		return "Dehydrated", Color(255, 0, 0, 255); -- red
	end;

	return "Unknown", Color(255, 255, 255, 255);
end;