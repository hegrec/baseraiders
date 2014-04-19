AddCSLuaFile("shared.lua")
include("shared.lua")
ENT.Users = {}
function ENT:Initialize()
	self:SetModel("models/dav0r/tnt/tnttimed.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(SOLID_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	local phys = self.Entity:GetPhysicsObject()
	self:SetNWInt("ExplodeTime",CurTime()+10)
	self.powering = {}
	self.beep = CurTime()
end 
function ENT:Think()
	if self.beep < CurTime() then
		self:EmitSound("weapons/c4/c4_click.wav")
		self.beep = self.beep+1
	end
	if self:GetExplodeTime() < CurTime() then
		self:Explode()
	end

end


function ENT:Explode()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart( vPoint ) -- not sure if ( we need a start and origin ( endpoint ) for this effect, but whatever
	effectdata:SetOrigin( vPoint )
	effectdata:SetScale( 1 )
	util.Effect( "HelicopterMegaBomb", effectdata )
	
	local inRange = ents.FindInSphere(self:GetPos(),60)
	local maxDamage = 1000
	local dist = 60
	for i,v in pairs(inRange) do
		local distMod = (60-v:NearestPoint(self:GetPos()):Distance(self:GetPos()))/60
		v:TakeDamage(maxDamage*distMod,self,self.planter)
	end
	if self:GetParent():IsDoor() then
		self:GetParent():Fire("unlock")
		self:GetParent().Locked = false
		self:GetParent():Fire("Open")
		self:GetParent().nextlock = CurTime()+20
	end

	self:Remove()
	self:EmitSound("ambient/explosions/explode_5.wav")
end