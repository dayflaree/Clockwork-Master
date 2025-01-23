ITEM.Name = "Psycho";
ITEM.Desc = "No one really knows where Psycho came from, whether it be the government or some back-yard chemist from the Old World. This chem dampens higher brain functions, making the user tougher as well as uncontrollable.";
ITEM.Model = "models/mosi/fallout4/props/aid/pyscho.mdl";
ITEM.W = 1;
ITEM.H = 1;
ITEM.UseSound = "fosounds/fix/npc_human_using_psycho_01.mp3";
ITEM.Vars.Uses = 1;
ITEM.Stackable = true;
ITEM.StackLimit = 4;
ITEM.BasePrice = 999;
ITEM.Category = CATEGORY_MEDICAL;
ITEM.RemoveOnUse = true;

function ITEM:OnUse( item )

	local pronoun1 = "their";
	local pronoun2 = "they";
	
	if( item.Owner:Sex() == MALE ) then -- really should write a helper func
	
		pronoun1 = "his";
		pronoun2 = "he";
		
	elseif( item.Owner:Sex() == FEMALE ) then
	
		pronoun1 = "her";
		pronoun2 = "she";
		
	end

	GAMEMODE:OnChat( item.Owner, "/me removes a Psycho auto-injector from " .. pronoun1 .. " pockets. Tapping it a few times, " .. pronoun2 .. " jabs it into " .. pronoun1 .. " leg for a few moments before ripping it out of " .. pronoun1 .. " flesh." );

end

function ITEM:GetUseText( item )

	return "Inject";
	
end