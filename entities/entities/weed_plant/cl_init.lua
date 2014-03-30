include("shared.lua")

function ENT:Initialize()
	self.Plant = ClientsideModel("models/props_foliage/spikeplant01.mdl",RENDERGROUP_OPAQUE)
	self.Plant:SetPos(self.Entity:GetPos()+self.Entity:GetUp()*15)
end 

function ENT:Draw()
	if !IsValid(self.Plant) then return end
	local size = 0.2*self.Entity:GetCharges()
	self.Plant:SetModelScale(size,0)
	self:DrawModel()
	self.Plant:SetPos(self.Entity:GetPos()+self.Entity:GetUp()*15)
	self.Plant:SetAngles(self.Entity:GetAngles())

end 

function ENT:OnRemove()
	self.Plant:Remove()
end 