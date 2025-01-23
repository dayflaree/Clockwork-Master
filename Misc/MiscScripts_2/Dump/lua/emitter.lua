local centr = Vector(0, 0, 100)
local em = ParticleEmitter(centr)
for i = 1, math.random(5, 20) do
	local part = em:Add("sprites/light_glow02_add", centr)
	if part then
		part:SetColor(255, 0, 0, math.random(255))
		part:SetVelocity(VectorRand() * 50)
		part:SetGravity(Vector(0, 200, 0))
		part:SetDieTime(20)
		part:SetLifeTime(0)
		part:SetStartSize(30)
		part:SetEndSize(5)
	end
end
em:Finish()