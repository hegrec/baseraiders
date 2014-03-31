--AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	self.Entity:SetModel("models/props/cs_assault/Money.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
 
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self:SetUseType(SIMPLE_USE)
	self:SetNWInt("Amount",0)
end 

function ENT:Use(activator, caller)
	if !activator:IsPlayer() then return end
	activator:AddMoney(self:GetNWInt("Amount"))
	self:Remove()
end 
function ENT:AddMoney(amt)
	self:SetNWInt("Amount",self:GetNWInt("Amount")+amt)
end