include("shared.lua")
AddCSLuaFile("shared.lua")

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS 
end

function ENT:SetUpDefault(dtxt,txtclr,bgclr) --will be used for saving, and when reselling a billboard
	self.dbgclr = bgclr.r .. "|" .. bgclr.g .. "|" .. bgclr.b
	self.dtxtclr = txtclr.r .. "|" .. txtclr.g .. "|" .. txtclr.b
	self.DText = {}
	for i=1,6 do --faster since no table.count call
			self.DText["dtxt"..i] = dtxt[tostring(i)] or ""
	end
end

function ENT:SetUpInfo(pos1,pos2,ang,bgclr,width,height,txt,txtclr,ownable,cost)
	self:SetPos(pos1)
	self:SetNWVector("endpos",pos2)
	self:SetAngles(ang)
	self:SetNWInt("width",width)
	self:SetNWInt("height",height)	
	for i=1,6 do --faster since no table.count call
		self:SetNWString("txt"..i,txt[tostring(i)])
	end	
	
	if(bgclr.r != 0 or bgclr.g != 0 or bgclr.b != 0)then
		self:SetNWString("bgclr",bgclr.r .. "|" .. bgclr.g .. "|" .. bgclr.b)
	end
	
	if(txtclr.r != 255 or txtclr.g != 255 or txtclr.b != 255)then
		self:SetNWString("txtclr",txtclr.r .. "|" .. txtclr.g .. "|" .. txtclr.b)
	end
	
	if(ownable)then
		self:SetNWBool("ownable",ownable) 
		self:SetNWEntity("Owner",NULL) 
		
		self.cost = cost
		if(cost != 1000)then
			self:SetNWInt("cost",cost)
		end
	end
end 