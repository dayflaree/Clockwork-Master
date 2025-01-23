PLUGIN.Name = "Fallout RP"; -- What is the plugin name
PLUGIN.Author = "FalloutRP.com"; -- Author of the plugin
PLUGIN.Description = "A collection of team making functions."; -- The description or purpose of the plugin

function PLUGIN.Init( )
	
end

function LEMON.FalloutTeam(name, armor, color, model_path, default_model, partial_model, weapons, flag_key, door_groups, sound_groups, item_groups, salary, public, business)

	local team = LEMON.TeamObject();
	
	team.name = LEMON.NilFix(name, "Resident");
	team.armor = LEMON.NilFix(armor, 0)
	team.color = LEMON.NilFix(color, Color(0, 255, 0, 255));
	team.model_path = LEMON.NilFix(model_path, "");
	team.default_model = LEMON.NilFix(default_model, false);
	team.partial_model = LEMON.NilFix(partial_model, false);
	team.weapons = LEMON.NilFix(weapons, {});
	team.flag_key = LEMON.NilFix(flag_key, "resident");
	team.door_groups = LEMON.NilFix(door_groups, { });
	team.sound_groups = LEMON.NilFix(sound_groups, { 1 });
	team.item_groups = LEMON.NilFix(item_groups, { });
	team.salary = LEMON.NilFix(salary, 50);
	team.public = LEMON.NilFix(public, true);
	team.business = LEMON.NilFix(business, false);
	
	return team;
	
end
