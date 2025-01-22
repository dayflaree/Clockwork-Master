
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

Clockwork.config:AddToSystem("Gas Tick Time", "gas_tick_time", "The amount of time in seconds between each tick of the gaszones plugin.", 0, 10);
Clockwork.config:AddToSystem("Gas Damage", "gas_damage", "The amount of damage in seconds for each tick of the gaszones plugin.", 0, 200);
Clockwork.config:AddToSystem("Gas Filter Scale", "gas_filter_scale", "The scale by which gas zones drain filters.", 0.01, 10);