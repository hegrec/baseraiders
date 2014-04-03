AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
DRUG_GROW = 120

function ENT:Initialize()
	self:SetModel("models/nater/weedplant_pot_planted.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self:SetUseType(SIMPLE_USE)
	self.Entity:SetNWInt("GrowthPercentage",0)
	self:SetNWBool("NeedsWater",false)
	self.Entity:SetHealth(100)
	self.CurrentStage = 1
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
			activator:SendNotify("You have watered a wilted plant. It will now grow normally","NOTIFY_GENERIC",4)
			self:SetNWBool("NeedsWater",false)
			return
		end
		activator:SendNotify("This plant has wilted away. Maybe some water could restore it.","NOTIFY_ERROR",4)
		return
	end


	if self:GetGrowthPercentage() < 100 then activator:SendNotify("This plant is not finished growing.","NOTIFY_ERROR",5) return end
	activator:GiveItem("Weed",4)
	local pot = ents.Create("empty_pot")
	pot:SetPos(self:GetPos())
	pot:SetModel("models/nater/weedplant_pot.mdl")
	pot:SetAngles(self:GetAngles())
	pot.tbl = GetItems()["Empty Pot"]
	pot:SetNWString("ItemName","Empty Pot")
	pot:Spawn()
	self:Remove()
end 
ENT.NextGrow = 0
function ENT:Think()
	if self.NextGrow > CurTime() then return end
	self.NextGrow = CurTime()+0.1
	local lightmod = self:GetLightAmount()
	self:SetNWInt("GrowthPercentage",self:GetGrowthPercentage()+0.1*lightmod)
	
	if (self:GetGrowthPercentage()>=100 && self.CurrentStage < 8) then
		self:SetModel("models/nater/weedplant_pot_growing7.mdl")
		self.CurrentStage = 8
	elseif (self:GetGrowthPercentage()>=85 && self.CurrentStage < 7) then
		self:SetModel("models/nater/weedplant_pot_growing6.mdl")
		self.CurrentStage = 7
	elseif (self:GetGrowthPercentage()>=60 && self.CurrentStage < 6) then
		self:SetModel("models/nater/weedplant_pot_growing5.mdl")
		self.CurrentStage = 6
	elseif (self:GetGrowthPercentage()>=45 && self.CurrentStage < 5) then
		self:SetModel("models/nater/weedplant_pot_growing4.mdl")
		self.CurrentStage = 5
	elseif (self:GetGrowthPercentage()>=25 && self.CurrentStage < 4) then
		self:SetModel("models/nater/weedplant_pot_growing3.mdl")
		self.CurrentStage = 4
	elseif (self:GetGrowthPercentage()>=15 && self.CurrentStage < 3) then
		self:SetModel("models/nater/weedplant_pot_growing2.mdl")
		self.CurrentStage = 3
	elseif (self:GetGrowthPercentage()>=5 && self.CurrentStage < 2) then
		self:SetModel("models/nater/weedplant_pot_growing1.mdl")
		self.CurrentStage = 2	
	end
end
