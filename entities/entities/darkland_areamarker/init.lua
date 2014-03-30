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
	if ent:IsPlayer()  and ent.lastMark != self.marker and ent.lastMark then
		umsg.Start("newArea",ent)
			umsg.String(self.marker)
		umsg.End()
		ent.lastMark = self.marker
	elseif ent:IsPlayer() and ent.lastMark == nil then
		ent.lastMark = self.marker
		umsg.Start("newArea",ent)
			umsg.String(self.marker)
		umsg.End()
	end
end