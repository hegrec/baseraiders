include("shared.lua")

function ENT:Initialize()
	self.Plant = ClientsideModel("models/Fungi/sta_skyboxshroom2.mdl",RENDERGROUP_OPAQUE)
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
	if(IsValid(self.Plant))then
		self.Plant:Remove()
	end
end 