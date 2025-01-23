ITEM.Name = "Mentats";
ITEM.Desc = "An worn cardboard box emblazened with 'Mentats' on the front. There are four red pills in a blister pack inside. These pills make you smarter, more charismatic, and more perceptive.";
ITEM.Model = "models/mosi/fallout4/props/aid/mentats.mdl";
ITEM.W = 1;
ITEM.H = 1;
ITEM.UseSound = "fosounds/fix/npc_human_eating_mentats.mp3";
ITEM.Vars.Uses = 4;
ITEM.Stackable = true;
ITEM.StackLimit = 10;
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

	GAMEMODE:OnChat( item.Owner, "/me pops out a red pill from a blister pack, throwing it into " .. pronoun1 .. " mouth before chewing it loudly." );

end

function ITEM:GetUseText( item )

	return "Chew";
	
end