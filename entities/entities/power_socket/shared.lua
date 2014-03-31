ENT.Type = "anim"
ENT.Base = "base_anim" 

function ENT:GetWattsLeft()
	return self:GetNWInt("WattsAvailable")
end