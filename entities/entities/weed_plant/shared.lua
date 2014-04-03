ENT.Type = "anim"
ENT.Base = "base_anim" 
ENT.MaxGrow = 10

function ENT:GetGrowthPercentage()
	return self.Entity:GetNWInt("GrowthPercentage")
end 

function ENT:NeedsWater()
	return self.Entity:GetNWBool("NeedsWater")
end 
function ENT:GetLightAmount()
	local lights = ents.FindByClass("darkland_light")
	local amt = 0
	for i,v in pairs(lights) do
		
		if (v:IsPowered() and v:GetPos():Distance(self:GetPos()) < v:GetLightFactor()*20) then
			amt = amt + 1
		end
	end
	return math.min(3,amt)
end