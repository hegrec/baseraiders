local meta = FindMetaTable("Player")
function meta:HasItem(index)
	return (self.Inventory[index] and self.Inventory[index] > 0) or false
end

function meta:GetAmount(index)
	return self.Inventory[index] or 0
end

function meta:CanHold(amt,weight)
	return self.TotalWeight + (weight*amt) < MAX_INVENTORY
end

function meta:GiveItem(index,amt,noweight)
	if amt == 0 then return true end
	amt = amt or 1
	local tbl = GetItems()[index]
	if !tbl then return end
	if !noweight then
		local weight = tbl.Weight*amt
		if !self:CanHold(1,weight) then self:SendNotify("You are carrying too much already","NOTIFY_ERROR",4) return end
		self.TotalWeight = self.TotalWeight + weight
	end
	self.Inventory[index] = self.Inventory[index] or 0
	self.Inventory[index] = self.Inventory[index] + amt
	if !noweight then
		umsg.Start("recvItem",self)
			umsg.String(index)
			umsg.Short(amt)
		umsg.End()
	else
		umsg.Start("recvGun",self)
			umsg.String(index)
		umsg.End()
	end
	SaveRPAccount(self)
	return true
end


function meta:TakeItem(index,amt,equip)
	if amt == 0 then return true end
	amt = amt or 1
	local tbl = GetItems()[index]
	if !equip then
		local weight = tbl.Weight*amt
		self.TotalWeight = self.TotalWeight - weight
		if(self.TotalWeight < 0)then self.TotalWeight = 0 end
	end
	
	self.Inventory[index] = self.Inventory[index] - amt
	if self.Inventory[index] <= 0 then self.Inventory[index] = nil end
	if !equip then
		umsg.Start("loseItem",self)
			umsg.String(index)
			umsg.Short(amt)
		umsg.End()
	else
		umsg.Start("usegun",self)
			umsg.String(index)
		umsg.End()
	end
	SaveRPAccount(self)
end

function DropItem(ply,cmd,args)
	local index = args[1]
	if !ply:HasItem(index) then return end
	if ply:InVehicle() then ply:SendNotify("You can't drop this when in a car","NOTIFY_ERROR",4) return end
	CreateRolePlayItem(index,ply)
	SaveRPAccount(ply)
end
concommand.Add("dropitem",DropItem)

function CreateRolePlayItem(index,pl,notake,death) //Quick func to make items
	local tbl = GetItems()[index]
	if !tbl then return end
	pl.nextItemDrop = pl.nextItemDrop or 0
	if pl.nextItemDrop > CurTime() && !death then if notake then pl:AddMoney(tbl.BulkPrice) end pl:SendNotify("Wait a second to drop another item","NOTIFY_ERROR",4) return end
	pl.nextItemDrop = CurTime() + 0.5
	
	
	local tr = pl:EyeTrace(100)
	local pos = tr.HitPos + (tr.HitNormal*10)
	local ent = SpawnRoleplayItem(index,pos,pl)
	ent:SetPos(tr.HitPos + (tr.HitNormal*(ent:OBBMaxs()*2)))
	if tbl.OnSpawn then tbl.OnSpawn(pl,ent) end
	if notake then return end
	pl:TakeItem(index)
end

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
	return ent
end

--Used when the player spawns
function InventoryLoad(pl,str)
	local t = table.ToLoad(str)
	
	for i,v in pairs(t) do
		if GetItems()[i] then
			pl:GiveItem(i,tonumber(v))
		end
	end
end
hook.Add("OnLoadInventory","LoadInv",InventoryLoad)