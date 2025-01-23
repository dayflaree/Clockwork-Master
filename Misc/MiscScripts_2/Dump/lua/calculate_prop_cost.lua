local MinCost = 10
local MaxCost = 300

hook.Add("PlayerSpawnedProp", "calculatecost", function(ply, mdl, ent)
    local mass = ent:GetPhysicsObject():GetMass()
    local vol = ent:GetPhysicsObject():GetVolume()
    local cost = vol * mass / 10000 -- MinCost, MaxCost)
    
    ply:ChatPrint("Mass: " .. mass .. ", Volume: " .. vol .. ", Cost: $" .. cost)
end)