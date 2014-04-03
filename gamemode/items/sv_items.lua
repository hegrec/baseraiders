local meta = FindMetaTable("Player")



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
	umsg.Start("recvItem",self)
		umsg.String(index)
		umsg.Char(y)
		umsg.Char(x)
	umsg.End()
	
	SaveRPAccount(self)
	return true
end


function meta:TakeItem(x,y)
	if (y == nil) then
		x,y = self:HasItem(x)
	end
	if !y then return end
	local item = self.Inventory[y][x]
	if item ==false or item == true then return end
	local tbl = GetItems()[item]
	

	local tsize = tbl.Size
	if tsize == nil then tsize = {2,2} end
	
	
	local sx,sy = unpack(tsize)
	for yPos=y,y+(sy-1) do
		
		for xPos=x,x+(sx-1) do
			self.Inventory[yPos][xPos] = false
		end
	end
	
	umsg.Start("loseItem",self)
		umsg.Char(y)
		umsg.Char(x)
	umsg.End()
	
	SaveRPAccount(self)
end

function DropItem(ply,cmd,args)
	local x = tonumber(args[1])
	local y = tonumber(args[2])
	if ply.Inventory[y][x] == false or ply.Inventory[y][x] == true then return end
	if ply:InVehicle() then ply:SendNotify("You can't drop this when in a car","NOTIFY_ERROR",4) return end
	local index = ply.Inventory[y][x]
	local tbl = GetItems()[index]
	

	
	
	ply:TakeItem(x,y)
	if (tbl.SWEPClass && !ply:HasItem(index)) then --make sure we unequip the item if we have no more
		ply:StripWeapon(tbl.SWEPClass)
	end
	
	
	local tr = ply:GetEyeTrace()
	local pos = tr.HitPos + (tr.HitNormal*10)
	local ent = SpawnRoleplayItem(index,pos,ply)
	ent:SetPos(tr.HitPos + tr.HitNormal)
end
concommand.Add("dropitem",DropItem)


function PickupItem(ply,cmd,args)
	local ent = ents.GetByIndex(args[1])
	local x = tonumber(args[2])
	local y = tonumber(args[3])
	local itemType = ent:GetNWString("ItemName")
	print(itemType)
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
	
	if !ply:ItemFits(item,newX,newY) then
		ply:SendNotify("That item doesn't fit.","NOTIFY_ERROR",4)
		return
	end
	ply:TakeItem(oldX,oldY)
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
	ent:SetNWString("ItemName",index)
	
	ent:SetPos(spawnpos)
	ent.tbl = tbl
	ent.GroupIndex = index
	if (tbl.Args) then
		for i,v in pairs(tbl.Args) do ent[i] = v end
	end
	ent:Spawn()
	ent:Activate()
	ent:SetPos(ent:GetPos()-Vector(0,0,ent:OBBMins().z)) 
	return ent
end

--Used when the player spawns
function InventoryLoad(pl,str)
	pl.tempInv = util.KeyValuesToTable(str)
end
hook.Add("OnLoadInventory","LoadInv",InventoryLoad)

--Used when the player spawns
function InventoryLoadToClient(pl,str)
	local t = pl.tempInv
	
	for y=1,INV_Y do
		for x=1,INV_X do
			if (t[y] and t[y][x]) then
				pl:GiveItem(t[y][x],x,y)
			end
		end
	end
	pl.tempInv = nil
end
hook.Add("OnPlayerReady","LoadInvToClient",InventoryLoadToClient)