ENT.Type = "anim"
ENT.Base = "base_anim" 

function ENT:GetExplodeTime()
	return self:GetNWInt("ExplodeTime")
end