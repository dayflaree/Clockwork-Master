local PLUGIN = PLUGIN;

function PLUGIN:AdjustMouseSensitivity()
	if (Clockwork.Client) then
		if (IsValid(Clockwork.Client:GetActiveWeapon())) then
			if (Clockwork.Client:GetActiveWeapon():GetNetworkedInt("Zoom", 0) > 0) then
				return 0.17;
			end;
		end;
	end;
end;