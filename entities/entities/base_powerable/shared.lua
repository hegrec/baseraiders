ENT.Type = "anim"
ENT.Base = "base_anim" 

function ENT:IsPowered()
	return self:GetNWBool("Powered")
end

function ENT:GetPowered()
	return self:GetNWBool("Powered")
end

