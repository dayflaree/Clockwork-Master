local COMMAND = Clockwork.command:New("CharSkinSet");
COMMAND.tip = "Sets the skin of someone's model.";
COMMAND.text = "<string Name> <number Skin>";
COMMAND.access = "s";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	
	if( target )then
		local targetSkins = target:GetCharacterData("Skins") or {};
		local skin = tonumber(arguments[2]) or 0;
		local model = target:GetModel();
		
		if( skin < target:SkinCount()  )then
			targetSkins[model] = targetSkins[model] or {};
			
			if( skin == 0 )then
				targetSkins[model] = nil;
			else
				targetSkins[model] = skin;
			end;
			
			target:SetSkin(skin);
			
			target:SetCharacterData("Skins", targetSkins);
			
			Clockwork.player:Notify(player, "Successfully changed " .. target:Name() .. "'s 'skin to".. skin .."'.");
		else
			Clockwork.player:Notify(player, "'".. skin .. "' is not a valid skin for this model!");
		end;
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
	end;
end;

COMMAND:Register();