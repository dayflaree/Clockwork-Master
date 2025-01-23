hook.Add("PlayerSpawnedProp", "calculatecost", function(ply, mdl, ent)
    local mass = ent:GetPhysicsObject():GetMass()
    local vol = ent:GetPhysicsObject():GetVolume()
    local cost = math.Clamp(math.Round((vol * 0.005) / 4), 5, 20000)
    
    ply:ChatPrint("Cost: $" .. cost)
end)