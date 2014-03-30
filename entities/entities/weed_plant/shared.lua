ENT.Type = "anim"
ENT.Base = "base_anim" 
ENT.MaxGrow = 10

function ENT:GetCharges()
	return self.Entity:GetNWInt("Charges")
end 

function ENT:NeedsWater()
	return self.Entity:GetNWBool("NeedsWater")
end 