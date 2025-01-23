ITEM.Name = "Buffout";
ITEM.Desc = "A highly advanced steroid that was popularized before the Great War by professional athletes and their clandestine use of the drug. Using too much buffout causes cardiac arrest, or even death";
ITEM.Model = "models/mosi/fallout4/props/aid/buffout.mdl";
ITEM.W = 1;
ITEM.H = 1;
ITEM.UseSound = "fosounds/fix/npc_human_eating_mentats.mp3";
ITEM.Vars.Uses = 4;
ITEM.Stackable = true;
ITEM.Category = CATEGORY_MEDICAL;
ITEM.BasePrice = 999;
ITEM.StackLimit = 8;
ITEM.RemoveOnUse = true;

function ITEM:OnUse( item )

	local pronoun = "their";
	
	if( item.Owner:Sex() == MALE ) then
	
		pronoun = "his";
		
	elseif( item.Owner:Sex() == FEMALE ) then
	
		pronoun = "her";
		
	end

	GAMEMODE:OnChat( item.Owner, "/me takes out a container of Buffout, screwing off the cap quickly before popping a few into " .. pronoun .. " mouth." );

end

function ITEM:GetUseText( item )

	return "Chew";
	
end