ITEM.Name = "Jet";
ITEM.Desc = "An inhaler filled with the mysterious substance known as 'Jet'. It's rumoured by some that it is made by taking brahmin shit and extracting the fumes.";
ITEM.Model = "models/mosi/fallout4/props/aid/jet.mdl";
ITEM.W = 1;
ITEM.H = 1;
ITEM.UseSound = "fosounds/fix/npc_human_using_jet.mp3";
ITEM.Vars.Uses = 2;
ITEM.Stackable = true;
ITEM.Category = CATEGORY_MEDICAL;
ITEM.StackLimit = 6;
ITEM.BasePrice = 999;
ITEM.RemoveOnUse = true;

function ITEM:OnUse( item )

	local pronoun1 = "their";
	local pronoun2 = "their";
	
	if( item.Owner:Sex() == MALE ) then
	
		pronoun1 = "his";
		pronoun2 = "he";
		
	elseif( item.Owner:Sex() == FEMALE ) then
	
		pronoun1 = "her";
		pronoun2 = "she";
		
	end

	GAMEMODE:OnChat( item.Owner, "/me slides a jet inhaler out, shaking it a few times as " .. pronoun2 .. " places it into " .. pronoun1 .. " mouth. Pressing down the plunger, " .. pronoun2 .. " inhales sharply." );

end

function ITEM:GetUseText( item )

	return "Inhale";
	
end