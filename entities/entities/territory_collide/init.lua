ENT.Type = "brush"

function ENT:Initialize()
	self:PhysicsInitBox(self.minVec,self.maxVec)
	self:SetCollisionBounds(self.minVec,self.maxVec)
	 
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid( SOLID_BBOX )
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion( false )
	end
end

function ENT:SetMarker(str)
	self.marker = str
end
function ENT:SetMaxVector(v)
	self.maxVec = v
end
function ENT:SetMinVector(v)
	self.minVec = v
end

function ENT:StartTouch(ent)
	if ent:IsPlayer() then
		ent:SetNWInt("TerritoryID",self.TerritoryID)
	end
end
function ENT:EndTouch(ent)
	if ent:IsPlayer() then
		ent:SetNWInt("TerritoryID",0)
	end
end