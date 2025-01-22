--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

Clockwork.config:AddToSystem("Radio Distortion Error", "distortion_error", "Decide what ASCII character to replace errors with. (32 for random)", 0, 256);
Clockwork.config:AddToSystem("Radio Distortion Minimum", "distortion_minimum", "Minimum distance from speaker to listener where chat will start garbling.", 256, 8192);
Clockwork.config:AddToSystem("Radio Distortion Maximum", "distortion_maximum", "Maximum distance from speaker to listener where entire chat garbles.", 10240, 20480);