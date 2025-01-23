resource.AddFile("materials/es/logo.vtf")
resource.AddFile("materials/es/logo.vmt")

local maploc = {
	gm_flatgrass = Vector(1010, 0, 500),
	gm_flatsnow = Vector(1010, 0, 500),
	gm_construct = Vector(1240, -60, 365),
	gm_wireconstruct_rc = Vector(2449, 1893, -12800)
}

function spawnlogo()
	timer.Simple(1, function()
		logo = ents.Create("3d_logo")
		logo:SetPos(maploc[game.GetMap()] or Vector(0, 0, 0))
		logo:Spawn()
	end)
end
hook.Add("InitPostEntity", "spawnlogo", spawnlogo)
