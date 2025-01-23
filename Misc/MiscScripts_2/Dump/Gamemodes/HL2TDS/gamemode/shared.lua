GM.Name 		= "HL2: TDS"
GM.Author 		= "_Undefined"
GM.Email 		= "admin@equinox-studios.co.uk"
GM.Website 		= "http://equinox-studios.co.uk"
GM.TeamBased 	= false

DeriveGamemode("base")

function GM:ShouldDrawHats()
	return true
end

function ents.FindByClassInSphere(class, start, radius)
	local r = {}
	local e = ents.FindInSphere(start, radius)
	
	if e and #e > 0 then
		for _, ent in pairs(e) do
			if ent:GetClass() == class then
				table.insert(r, ent)
			end
		end
	end
	
	return r
end