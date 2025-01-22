
concommand.Add("cwEconomyInfo", function(player, command, arguments, argumentString)
	Clockwork.datastream:Start("EconomyInfo", {arguments});
end);

Clockwork.datastream:Hook("EconomyInfo", function(data)
	for i = 1, #data do
		print(data[i]);
	end;
end);