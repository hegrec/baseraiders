AddCSLuaFile("shared.lua")
include("shared.lua")
ENT.Users = {}
function ENT:Initialize()
	self:SetModel("models/props_lab/powerbox02b.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_NONE)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	local phys = self.Entity:GetPhysicsObject()
	phys:EnableMotion(false)
	self:SetNWInt("WattsAvailable",1000)
	self.powering = {}
end 
function ENT:PowerEntity(ent,activator)
	local item = ent:GetItemName()
	if !item then return end
	local tbl = GetItems()[item]
	if !tbl then return end
	
	
	
	local watts = tbl.Watts
	
	if (power.GetCityPowerLeft()<watts) then activator:SendNotify("The power grid is currently maxed out. Better use a generator!","NOTIFY_ERROR",5) return end
	 
	if (self:GetWattsLeft()>=watts) then 
		self.powering[ent:EntIndex()] = watts
		self:SetNWInt("WattsAvailable",self:GetNWInt("WattsAvailable")-watts)
		self:RecalculateUsedPower()
		return true
	end
	
	
	return false
end
function ENT:RecalculateUsedPower()
	local sockets = ents.FindByClass("power_socket")
	local total = 0
	for i,v in ipairs(sockets) do
		for ndx,watts in pairs(v.powering) do
			total = total + watts
		end
	end
	SetGlobalInt("PowerUsed",total)
end
function ENT:UnpowerEntity(ent,activator)
	local item = ent:GetItemName()
	if !item then return end
	local tbl = GetItems()[item]
	if !tbl then return end
	if !self.powering[ent:EntIndex()] then return end
	local watts = tbl.Watts
	self.powering[ent:EntIndex()] = nil
	self:SetNWInt("WattsAvailable",self:GetNWInt("WattsAvailable")+watts)
	self:RecalculateUsedPower()
end

function ENT:Think()
	for i,v in pairs(self.powering) do
		local ent = ents.GetByIndex(i)
		if !ent or !ent:IsValid() then
			self.powering[i] = nil
			self:SetNWInt("WattsAvailable",self:GetNWInt("WattsAvailable")+v)
		elseif ent:GetPos():Distance(self:GetPos())>POWER_DISTANCE then
			ent:TurnOff()
		end
	end
	self:RecalculateUsedPower()
end