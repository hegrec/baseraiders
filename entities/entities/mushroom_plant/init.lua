AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
DRUG_GROW = 120

function ENT:Initialize()
	self:PhysicsInitBox(Vector(-5,-5,-1),Vector(5,5,10))
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
 
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self:SetUseType(SIMPLE_USE)
	self.Entity:SetNWInt("Charges",0)
	self:SetNWBool("NeedsWater",false)
	self.Entity:SetHealth(100)
	
	--local ent = ents.Create("prop_physics")
	
	
	--ent:SetModel("models/Fungi/sta_skyboxshroom2.mdl")
	--ent:SetPos(self.Entity:GetPos()+self.Entity:GetUp()*15)
	--ent:SetParent(self.Entity)
	--ent:Spawn()
	--ent:SetSolid(false)
	--self:SetNWEntity("plant",ent)
end 

function ENT:OnTakeDamage(dmg) 
	self.Entity:SetHealth(self.Entity:Health() - dmg:GetDamage())
	if(self.Entity:Health() <= 0)then
		hook.Call("DrugLabDestroyed",GAMEMODE,self.Entity)
		local effectdata = EffectData()
		effectdata:SetStart(self.Entity:GetPos())
		effectdata:SetOrigin(self.Entity:GetPos())
 		util.Effect("Explosion", effectdata, true, true)
		self.Entity:Remove()
	end
end


function ENT:Use(activator, caller)
	if self:NeedsWater() then
		if activator:HasItem("Water") then
			activator:TakeItem("Water")
			activator:SendNotify("You have watered a wilted mushroom. It will now grow normally","NOTIFY_GENERIC",4)
			self:SetNWBool("NeedsWater",false)
			return
		end
		activator:SendNotify("This mushroom has wilted away. Maybe some water could restore it.","NOTIFY_ERROR",4)
		return
	end

	local amt = math.floor((self:GetCharges()*self:GetCharges())*0.05)
	if !activator:GiveItem("Shrooms",amt) then return end
	if amt < 1 then activator:SendNotify("The batch did not have enough to harvest a single mushroom! Wait until it is more full.","NOTIFY_ERROR",5)
	else self.Entity:SetNWInt("Charges",0) 
	end
end 
ENT.NextGrow = 0
function ENT:Think()
	if self.NextGrow > CurTime() then return end
	self.NextGrow = CurTime()+DRUG_GROW
	local charges = self:GetCharges()
	
	if charges < self.MaxGrow && !self:NeedsWater() then
		self:SetNWInt("Charges",self:GetCharges()+1)
		return
	else
		self:SetNWInt("Charges",0)
		self:SetNWBool("NeedsWater",true)
	end
end
