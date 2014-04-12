ENT.Type = "anim"
ENT.Base = "base_anim" 

function ENT:IsPowered()
	return self:GetDTBool(0)
end

function ENT:GetPowered()
	return self:GetDTBool(0)
end

