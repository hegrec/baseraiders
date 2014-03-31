ENT.Type = "anim"
ENT.Base = "base_anim" 

function ENT:GetAmount()
	return self:GetNWInt("Amount")
end