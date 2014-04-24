local meta = FindMetaTable("Player")

util.AddNetworkString("recvItem")
util.AddNetworkString("loseItem")

function meta:GiveItem(index,x,y)
	local tbl = GetItems()[index]
	if !tbl then return end
	if x == nil or y == nil then
		x,y = self:CanHold(index)
	end
	if (x == false) then return false end
	
	if !self:ItemFits(index,x,y) then
		self:SendNotify("That item doesn't fit.","NOTIFY_ERROR",4)
		return false
	end

	self.Inventory[y][x] = index
	
	local tsize = tbl.Size
	if tsize == nil then tsize = {2,2} end
	
	
	local sx,sy = unpack(tsize)
	for yPos=y,y+(sy-1) do
		
		for xPos=x,x+(sx-1) do
			if not (xPos==x and yPos==y) then 
				self.Inventory[yPos][xPos] = true
			end
		end
	end
	net.Start("recvItem")
		net.WriteString(index)
		net.WriteInt(y,8)
		net.WriteInt(x,8)
	net.Send(self)
	
	SaveRPAccount(self)
	return x,y
end


function meta:TakeItem(x,y)
	if (y == nil) then
		x,y = self:HasItem(x)
	end
	if !y then return end
	local item = self.Inventory[y][x]
	if item ==false or item == true then return end
	local tbl = GetItems()[item]
	if (tbl.SWEPClass && !self:HasItem(item)) then --make sure we unequip the item if we have no more
		self:StripWeapon(tbl.SWEPClass)
	end

	local tsize = tbl.Size
	if tsize == nil then tsize = {2,2} end
	
	
	local sx,sy = unpack(tsize)
	for yPos=y,y+(sy-1) do
		
		for xPos=x,x+(sx-1) do
			self.Inventory[yPos][xPos] = false
		end
	end
	if (tbl.SWEPClass && !self:HasItem(item)) then --make sure we unequip the item if we have no more
		self:StripWeapon(tbl.SWEPClass)
	end
	
	net.Start("loseItem")
		net.WriteInt(y,8)
		net.WriteInt(x,8)
	net.Send(self)
	hook.Call("OnTakePlayerItem",GAMEMODE,self,item,x,y)
	SaveRPAccount(self)
	return x,y
end

function DropItem(ply,cmd,args)
	local x = tonumber(args[1])
	local y = tonumber(args[2])
	if ply.Inventory[y][x] == false or ply.Inventory[y][x] == true then return end
	if ply:InVehicle() then ply:SendNotify("You can't drop this when in a car","NOTIFY_ERROR",4) return end
	local index = ply.Inventory[y][x]
	local tbl = GetItems()[index]
	

	
	
	ply:TakeItem(x,y)

	
	
	local tr = {}
	tr.start = ply:GetShootPos()
	tr.endpos = tr.start+ply:GetAimVector()*120
	tr.filter = ply
	tr = util.TraceLine(tr)
	
	local tr2 = {}
	tr2.start = tr.HitPos
	tr2.endpos = tr2.start-Vector(0,0,300)
	tr2 = util.TraceLine(tr2)
	
	
	local pos = tr2.HitPos
	local ent = SpawnRoleplayItem(index,pos,ply)
	
	local angle = ply:GetAngles()
	angle.yaw = angle.yaw-180
	
	ent:SetAngles(angle)
end
concommand.Add("dropitem",DropItem)


function PickupItem(ply,cmd,args)
	local ent = ents.GetByIndex(args[1])
	local x = tonumber(args[2])
	local y = tonumber(args[3])
	
	local tr = {}
	tr.start = ply:GetShootPos()
	tr.endpos = ent:LocalToWorld(ent:OBBCenter())
	tr.filter = ply
	tr = util.TraceLine(tr)
	if tr.Entity != ent || tr.StartPos:Distance(tr.HitPos) > 200 then return end
	
	local itemType = ent:GetItemName()
	if ply:GiveItem(itemType,x,y) then
		ent:Remove()
	end
	
	
end
concommand.Add("pickupitem",PickupItem)

function MoveItem(ply,cmd,args)
	local oldX = tonumber(args[1])
	local oldY = tonumber(args[2])
	local newX = tonumber(args[3])
	local newY = tonumber(args[4])
	local item = ply.Inventory[oldY][oldX]
	if item ==false or item == true then return end
	local tbl = GetItems()[item]
	
	
	
	
	
	
	ply:TakeItem(oldX,oldY)
	if !ply:ItemFits(item,newX,newY) then
		ply:SendNotify("That item doesn't fit.","NOTIFY_ERROR",4)
		ply:GiveItem(item,oldX,oldY)
		return
	end
	
	ply:GiveItem(item,newX,newY)
	SaveRPAccount(ply)
end
concommand.Add("moveitem",MoveItem)


function SpawnRoleplayItem(index,spawnpos,plOwner)
	local tbl = GetItems()[index]
	if !tbl then return end
	local ent = ents.Create(tbl.EntityClass)
	if (plOwner) then
		ent.pOwner = plOwner
		ent.steamid = plOwner:SteamID()
	end
	ent:SetModel(tbl.Model)
	ent:SetItemName(index)
	
	ent:SetPos(spawnpos)
	ent.tbl = tbl
	ent.GroupIndex = index
	if (tbl.Args) then
		for i,v in pairs(tbl.Args) do ent[i] = v end
	end
	ent:Spawn()
	ent:SetPos(ent:GetPos()-Vector(0,0,ent:OBBMins().z))
	ent:Activate()
	if (tbl.Mass && IsValid(ent:GetPhysicsObject())) then
		ent:GetPhysicsObject():SetMass(tbl.Mass)
	end
	if tbl.OnSpawned then
		tbl.OnSpawned(ent,plOwner)
	end
	return ent
end

--Used when the player spawns
function InventoryLoad(pl,str)
	local t = util.KeyValuesToTable(str)
	local xmax,ymax = pl:GetInventorySize()
	umsg.Start("setInventorySize",pl)
		umsg.Char(xmax)
		umsg.Char(ymax)
	umsg.End()
	
	if !t then return end

	
	for y=1,ymax do
		for x=1,xmax do
			if (t[y] and t[y][x] and GetItems()[t[y][x]]) then
				pl:GiveItem(t[y][x],x,y)
			end
		end
	end
end
hook.Add("OnLoadInventory","LoadInv",InventoryLoad)