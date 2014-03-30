include("shared.lua")
AddCSLuaFile("shared.lua")

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS 
end

function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	
end
