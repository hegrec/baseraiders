items = {}


local ItemList = {}
function GetItems()
	return table.Copy(ItemList)
end

function items.DefineItem(Name)
	ItemList[Name] = ItemList[Name] or {}
	
	return ItemList[Name]
end