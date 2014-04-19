items = {}


local ItemList = {}
function GetItems()
	return table.Copy(ItemList)
end

function items.DefineItem(Name)
	ItemList[Name] = ItemList[Name] or {}
	return ItemList[Name]
end





local meta = FindMetaTable("Player")
function meta:HasItem(index)
	local xmax,ymax = self:GetInventorySize()
	for y=1,ymax do
		for x=1,xmax do
			if (self.Inventory[y][x] == index) then return x,y end
		end
	end
	return false
end

function meta:GetInventorySize()

	local x = INV_X
	local y = INV_Y
	if self:IsVIP() then
		x = 15
		y = 15
	end
	return x,y

end

function meta:GetItem(x,y)
	return self.Inventory[y] and self.Inventory[y][x]
end

function meta:GetAmount(index)
	local amt = 0
	local xmax,ymax = self:GetInventorySize()
	for y=1,ymax do
		for x=1,xmax do
			if (self:GetItem(x,y) == index) then amt = amt + 1 end
		end
	end
	
	return amt
end

function meta:CanHold( item )
	local tbl = GetItems()[item] 
	if !tbl then return false end
	local xmax,ymax = self:GetInventorySize()
	for y=1,ymax do
		for x=1,xmax do

			if (self:ItemFits(item,x,y)) then return x,y end
		end
	end
	
	return false
end
function meta:ItemFits(item,x,y)

	local tbl = GetItems()[item]
	if !tbl then return false end
	local tsize = tbl.Size
	if tsize == nil then tsize = {2,2} end

	local sx,sy = unpack(tsize)
	local xmax,ymax = self:GetInventorySize()
	for yPos=y,y+(sy-1) do
		if (yPos>ymax) then return false end
		for xPos=x,x+(sx-1) do

			if (xPos>xmax) then return false end

			if self.Inventory[yPos][xPos] then return false end
		end
	end
	return true
end