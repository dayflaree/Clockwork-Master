ITEM.Name = "Med-X";
ITEM.Desc = "Med-X is a potent opiate analgesic that binds to opioid receptors in the brain and central nervous system, reducing the perception of pain as well as the emotional response to pain.";
ITEM.Model = "models/mosi/fallout4/props/aid/medx.mdl";
ITEM.W = 1;
ITEM.H = 1;
ITEM.UseSound = "fosounds/fix/ui_surgery_morphine_02.mp3";
ITEM.Vars.Uses = 1;
ITEM.Stackable = true;
ITEM.Category = CATEGORY_MEDICAL;
ITEM.StackLimit = 4;
ITEM.BasePrice = 999;
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

	GAMEMODE:OnChat( item.Owner, "/me removes a syringe of Med-X from " .. pronoun1 .. " pockets. Tapping it a few times, " .. pronoun2 .. " jabs it into " .. pronoun1 .. " leg before pressing down the plunger." );

end

function ITEM:GetUseText( item )

	return "Inject";
	
end