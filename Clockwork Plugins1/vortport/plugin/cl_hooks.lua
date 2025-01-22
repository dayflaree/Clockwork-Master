local PLUGIN = PLUGIN;

Clockwork.datastream:Hook("vortPortSound", function(data)
	local name = data[1];
	local level = data[2];
	local pitch = data[3];
	local volume = data[4];
	Clockwork.Client:EmitSound(name, level, pitch, volume);
end);