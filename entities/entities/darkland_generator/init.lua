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
	self:SetGallons(0)
	self:SetNWInt("WattsAvailable",0)
	self:SetNWBool("On",false)
	self.nextGallonDecrease = CurTime()
	self.On = false
	self.powering = {}
end

function ENT:StartTouch(ent)

	if ent:GetItemName() == "Gasoline" then
		ent:Remove()
		self:AddGallons(1)
	end

end
function ENT:SetGallons(i)
	self:SetDTInt(3,i)
end

function ENT:AddGallons(i)
	self:SetGallons(self:GetGallons()+i)
end
function ENT:Use(pl)

	if (self.On) then
		for i,v in pairs(self.powering) do
			local ent = ents.GetByIndex(i)
			ent:TurnOff()
		end
		self.powering = {}
		self.On = false
		self:SetNWInt("WattsAvailable",0)
		self:StopSound("generator_idle")
		self:EmitSound("ambient/machines/spindown.wav")
		self:SetNWBool("On",false)
	else
		
		if self:GetGallons() > 1 then
			self.On = true
			self:SetGallons(self:GetGallons()-1)
			self.nextGallonDecrease = CurTime()+60
			self:SetNWInt("WattsAvailable",self.tbl.Watts)
			self:EmitSound("generator_idle")
			self:EmitSound("ambient/machines/spinup.wav")
			self:SetNWBool("On",true)
		else
			pl:SendNotify("You need at least 2 gallons in the tank. Touch gas to generator.","NOTIFY_ERROR",4)
		end
		
	end

	
end

function ENT:PowerEntity(ent,activator)
	local item = ent:GetItemName()
	
	if !item then return false end
	local tbl = GetItems()[item]
	if !tbl then return false end
	
	if !self.On then return false end
	local watts = tbl.Watts
	if (self:GetWattsLeft()>=watts) then 
		self.powering[ent:EntIndex()] = watts
		self:SetNWInt("WattsAvailable",self:GetNWInt("WattsAvailable")-watts)
		return true
	end
	
	return false
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

end

function ENT:Think()
	if (CurTime()>self.nextGallonDecrease and self.On) then
		self.nextGallonDecrease = CurTime()+30
		self:SetGallons(self:GetGallons()-1)
		if self:GetGallons() < 1 then
			for i,v in pairs(self.powering) do
				local ent = ents.GetByIndex(i)
				ent:TurnOff()
			end
			self.powering = {}
			self.On = false
			self:SetNWInt("WattsAvailable",0)
			self:StopSound("generator_idle")
			self:EmitSound("ambient/machines/spindown.wav")
			self:SetNWBool("On",false)
		end
	end
	for i,v in pairs(self.powering) do
		local ent = ents.GetByIndex(i)
		if !ent or !ent:IsValid() then
			self.powering[i] = nil
			self:SetNWInt("WattsAvailable",self:GetNWInt("WattsAvailable")+v)
		elseif ent:GetPos():Distance(self:GetPos())>POWER_DISTANCE then
			ent:TurnOff()
		end
	end
end