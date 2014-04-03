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
	for y=1,INV_Y do
		for x=1,INV_X do
			if (self.Inventory[y][x] == index) then return x,y end
		end
	end
	return false
end

function meta:GetItem(x,y)
	return self.Inventory[y] and self.Inventory[y][x]
end

function meta:GetItem(x,y)
	return self.Inventory[y] and self.Inventory[y][x]
end
function meta:GetAmount(index)
	local amt = 0
	for y=1,INV_Y do
		for x=1,INV_X do
			if (self:GetItem(x,y) == index) then amt = amt + 1 end
		end
	end
	
	return amt
end

 function meta:CanHold( item ) --note that item must be an actual item, not a InvItem panel.
	local tbl = GetItems()[item] 
	if !tbl then return false end
	for y=1,INV_Y do
		for x=1,INV_X do
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
	for yPos=y,y+(sy-1) do
		if (yPos>INV_Y) then return false end
		for xPos=x,x+(sx-1) do
			if (xPos>INV_X) then return false end

			if self.Inventory[yPos][xPos] then return false end
		end
	end
	return true
end