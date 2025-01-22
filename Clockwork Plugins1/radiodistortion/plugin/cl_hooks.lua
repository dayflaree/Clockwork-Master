--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

-- Called when the chat box info should be adjusted.
function cwRadioDistortion:ChatBoxAdjustInfo(info)
	if (info.class == "radio") then
		local speaker, listener = info.speaker, Clockwork.Client;
		local minimum = Clockwork.config:Get("distortion_minimum"):Get();
		local maximum = Clockwork.config:Get("distortion_maximum"):Get();
		local distance = speaker:GetPos():Distance(listener:GetPos());
		
		if (distance >= minimum) then
			local modifiedText = "";

			info.text:gsub(".", function(c)
				local textError = string.char(math.random(33, 93));
				local dividend, divisor = (distance - minimum), (maximum - minimum);
				local odds = math.Clamp((dividend / divisor), 0, 1);
			
				if (math.floor(Clockwork.config:Get("distortion_error"):Get()) != 32) then
					textError = string.char(math.floor(Clockwork.config:Get("distortion_error"):Get()));
				end;
				
				if (math.random() <= odds) then
					c = textError;
				end;
			
				modifiedText = modifiedText..c;
			end);
			
			info.text = modifiedText;
		end;
	end;
end;