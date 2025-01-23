datastream.Hook("Nero_Notify", function(a, b, c, decoded)
	chat.AddText(Color(255, 88, 88), "[NERO] ", Color(255, 255, 255), unpack(decoded))
end)