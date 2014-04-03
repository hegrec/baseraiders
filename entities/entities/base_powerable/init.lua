--AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
 
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self:SetUseType(SIMPLE_USE)
	
end 
function ENT:TurnOn(activator)

	local nearby = ents.FindInSphere(self:GetPos(),POWER_DISTANCE)
	for i,v in pairs(nearby) do
		if v:GetClass() == "power_socket" || v:GetClass() == "darkland_generator" then
			if v:PowerEntity(self,activator) then
				self:SetPoweredBy(v)
				return
			end
		end
	end
	activator:SendNotify("There are no nearby sources of power","NOTIFY_ERROR",4)

end
function ENT:SetPoweredBy(entity)
	self.poweringEntity = entity
	if entity == nil then
		self:SetPowered(false)
	else
		self:SetPowered(true)
	end
end
function ENT:SetPowered(b)
	self:SetNWBool("Powered",b)
end
function ENT:GetPoweredBy()
	return self.poweringEntity
end
function ENT:TurnOff(activator)

	self:GetPoweredBy():UnpowerEntity(self,activator)
	self:SetPoweredBy(nil)

end
function ENT:Use(activator, caller)
	if (self:IsPowered()) then
		self:TurnOff(activator)
	else
		self:TurnOn(activator)
	end	
end 