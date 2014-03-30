AddCSLuaFile("shared.lua")
include("shared.lua")
ENT.Users = {}
function ENT:Initialize()
	self:SetModel("models/props_wasteland/kitchen_counter001b.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_NONE)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self.Entity:GetPhysicsObject()
	phys:EnableMotion(false)
end 
function ENT:Use(activator, caller)
	local nearby = ents.FindInSphere(self:GetPos(),20)
	local found = false
	for i,v in pairs(nearby) do
		if v:GetClass() == "darkland_fire" then
			found = true;
			break
		end
	end
	if !found then
		activator:SendNotify("You need to place a fire in the smelter to use it","NOTIFY_ERROR",4)
		return
	end
	activator:ConCommand("startCrafting "..self:EntIndex())
end 