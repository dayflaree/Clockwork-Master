--[[
Name: "sv_auto.lua".
Product: "Skeleton".
--]]

RESISTANCE:IncludePrefixed("sh_auto.lua");

--[[
	This is where we'd define our own config settings for our
	module. You can get a full list of config functions and learn
	how they work at:
		resistance/gamemode/core/libraries/sh_config.lua
--]]

--[[
	This is where we change the defaults of some existing config options.
	You can get a full list of existing config options at:
		resistance/gamemode/core/config/sv_config.lua
--]]
resistance.config.Get("disable_sprays"):Set(false); -- We don't wanna disable sprays in this module!

-- We can add some hints to our module here.
resistance.hint.Add("Be Good", "Be good and behave otherwise Dazzle Modifications will come get ya!"); -- Add an interesting hint.

--[[
	The good thing about resistance modules and plugins, is that any function
	created like PLUGIN:Function or MODULE:Function is automatically hooked
	as a Garry's Mod hook (but only if that hook exists). For example:
		function MODULE:PlayerSpawn(player)
		end;
--]]

--[[
	Called when a player's weapons should be given.
	This is for people who know what they're doing, check out
	the resistance framework for a complete list of libraries and functions.
--]]
function MODULE:PlayerGiveWeapons(player)
	if (player:Team() == CLASS_CITIZEN) then
		player:Give("gmod_camera"); -- Give them a camera if they're a citizen!
	end;
end;

--[[
	A function to scale damage by hit group.
	This is for people who know what they're doing, check out
	the resistance framework for a complete list of libraries and functions.
--]]
function MODULE:PlayerScaleDamageByHitGroup(player, attacker, hitGroup, damageInfo, baseDamage)
	--[[
		Get the player's endurance. Find out what the arguments mean at:
			resistance/gamemode/core/libraries/sh_attributes.lua
	--]]
	
	local endurance = resistance.attributes.Fraction(player, ATB_ENDURANCE, 0.75, 0.75);
	
	-- Scale the damage based on their endurance attribute.
	damageInfo:ScaleDamage(1.5 - endurance);
end;