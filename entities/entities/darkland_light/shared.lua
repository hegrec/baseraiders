ENT.Type = "anim"
ENT.Base = "base_powerable" 

function ENT:GetLightFactor()
	return self:GetNWInt("LightFactor")
end