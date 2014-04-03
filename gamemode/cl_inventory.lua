hook.Add("Initialize","dfsagdfds",function()
Inventory = nil
end)
function ShowInv(pl,cmd,args)
	if !ValidPanel(Inventory) then Inventory = vgui.Create("Inventory") end
	local y = ScrH()-(Inventory:GetTall()+100)
	Inventory:MoveTo(0,y,0.2,0,1)
	Inventory:MakePopup()	
end
hook.Add("ContextMenuOpen","showinv",ShowInv)

function HideInv()
	if !ValidPanel(Inventory) then return end
	Inventory:Remove()
end

hook.Add("OnContextMenuClose","hideinv",HideInv)


local INVENTORY = {}
function INVENTORY:Init()
	self:SetSize(INV_X*INV_TILE_SIZE,INV_Y*INV_TILE_SIZE)
	self:SetPos(-self:GetWide(),ScrH()-(self:GetTall()+100))
	self.ItemSpots = {}
	for y=1,INV_Y do
		self.ItemSpots[y] = {}
		for x=1,INV_X do
			self.ItemSpots[y][x] = false
		end
	end
	self.Open = false
	for y=1,INV_Y do
		for x=1,INV_X do
			if LocalPlayer().Inventory[y][x] != false and LocalPlayer().Inventory[y][x] != true then
				self:AddItem(LocalPlayer().Inventory[y][x],x,y)
			end
		end
	end
end
function INVENTORY:Paint()
	draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(200,200,200,255))
	surface.SetDrawColor(Color(20,20,20,255))
	for y=1,INV_Y do
		surface.DrawLine(0,y*INV_TILE_SIZE,self:GetWide(),y*INV_TILE_SIZE)
		for x=1,INV_X do
			surface.DrawLine(x*INV_TILE_SIZE,0,x*INV_TILE_SIZE,self:GetTall())
			if (LocalPlayer().Inventory[y][x]) then
				draw.RoundedBox(0,(x-1)*INV_TILE_SIZE,(y-1)*INV_TILE_SIZE,INV_TILE_SIZE,INV_TILE_SIZE,Color(0,0,0,100))
			end
		end
	end
end
function INVENTORY:AddItem(index,x,y)
	local type = GetItems()[index]

	local panel = vgui.Create("DModelPanel",self)
	self.ItemSpots[y][x] = panel
	
	local tsize = type.Size
	if tsize == nil then tsize = {2,2} end
	local xSize,ySize = unpack(tsize)
	panel:SetModel(type.Model)
	panel:SetTooltip(index)
	local ang = type.Angle
	if (!ang) then ang = Angle(0,0,0) end
	panel.LayoutEntity = function(s,ent) ent:SetAngles(ang) end
	panel:SetSize(INV_TILE_SIZE*xSize,INV_TILE_SIZE*ySize)
	panel.itemType = index
	local CamPos = type.CamPos
	if !CamPos then
		CamPos = panel.Entity:OBBMaxs()
	end
	panel:SetCamPos(CamPos)
	local lookat = type.LookAt
	if !lookat then
		lookat = Vector(0,0,0)
	end
	panel:SetLookAt(lookat)
	panel.OnMousePressed = 
	function(p,mouse)
		if mouse == MOUSE_RIGHT then
			local menu = DermaMenu()
			if !type.NoDrop then
				menu:AddOption("Drop",function() RunConsoleCommand("dropitem",x,y) end)
			end
			if type.SWEPClass then
				menu:AddOption("Equip",function() RunConsoleCommand("use_gun",x,y) end)
			end
			if LocalPlayer():GetEyeTrace().Entity:GetClass() == "planted_gang_hub" then
				menu:AddOption("Transfer to Hub",function() RunConsoleCommand("item_to_hub",x,y) end)
			end
			if type.MenuAdds then
				type.MenuAdds(menu,index,x,y)
			end
			menu:Open()
		elseif mouse == MOUSE_LEFT then
			SetDraggableItem(index,x,y)
		end
	end
	panel:SetPos((x-1)*INV_TILE_SIZE,(y-1)*INV_TILE_SIZE)
	
end
function INVENTORY:GetItemSlot(mX,mY)
	return math.floor(mX/INV_TILE_SIZE)+1,math.floor(mY/INV_TILE_SIZE)+1
end
function INVENTORY:TakeItem(x,y)
	if ValidPanel(self.ItemSpots[y][x]) then
		self.ItemSpots[y][x]:Remove()
		self.ItemSpots[y][x] = false
	end
end
vgui.Register("Inventory",INVENTORY,"DPanel")

local function ReceiveItem( um )
	local index = um:ReadString()
	local y = um:ReadChar()
	local x = um:ReadChar()
	
	local tbl = GetItems()[index]
	
	LocalPlayer().Inventory[y][x] = index
	local tsize = tbl.Size
	if tsize == nil then tsize = {2,2} end
	local sx,sy = unpack(tsize)
	for yPos=y,y+(sy-1) do
		
		for xPos=x,x+(sx-1) do
			if not (xPos==x and yPos==y) then 
				LocalPlayer().Inventory[yPos][xPos] = true
			end
		end
	end
	
	
	if ValidPanel(Inventory) then
		Inventory:AddItem(index,x,y)
	end
	
end
usermessage.Hook("recvItem",ReceiveItem)
local function LoseItem( um )
	local y = um:ReadChar()
	local x = um:ReadChar()
	local index = LocalPlayer().Inventory[y][x]
	local tbl = GetItems()[index]
	local tsize = tbl.Size
	if tsize == nil then tsize = {2,2} end
	local sx,sy = unpack(tsize)
	for yPos=y,y+(sy-1) do
		for xPos=x,x+(sx-1) do
			LocalPlayer().Inventory[yPos][xPos] = false
		end
	end
	if ValidPanel(Inventory) then
		Inventory:TakeItem(x,y)
	end
end
usermessage.Hook("loseItem",LoseItem)


hook.Add("InitPostEntity","CreateInventory",function() LocalPlayer().Inventory = {}
for y=1,INV_Y do
		LocalPlayer().Inventory[y] = {}
		for x=1,INV_X do
			LocalPlayer().Inventory[y][x] = false
		end
	end
 end)
 
local draggingEntity
 hook.Add("GUIMousePressed","hoverclick",function(code,pos)
	local ent = properties.GetHovered(LocalPlayer():EyePos(),LocalPlayer():GetAimVector())
	if (ent and ent:IsValid()) then
		if ent:GetNWString("ItemName") then
			draggingEntity = ent
			SetDraggableItem(ent:GetNWString("ItemName"))
			
		end
	end
end)

local draggableItem
function SetDraggableItem(item,x,y)
	if ValidPanel(draggableItem) then draggableItem:Remove() end
	local type = GetItems()[item]
	if !type then print("ITEM NOT FOUND: ",item) return end
	local panel = vgui.Create("DModelPanel")
	local tsize = type.Size
	if tsize == nil then tsize = {2,2} end
	local xSize,ySize = unpack(tsize)
	panel:SetModel(type.Model)
	local ang = type.Angle
	if (!ang) then ang = Angle(0,0,0) end
	panel.LayoutEntity = function(s,ent) ent:SetAngles(ang) end
	panel:SetSize(INV_TILE_SIZE*xSize,INV_TILE_SIZE*ySize)
	panel.itemType = item
	local CamPos = type.CamPos
	if !CamPos then
		CamPos = panel.Entity:OBBMaxs()
	end
	panel:SetCamPos(CamPos)
	local lookat = type.LookAt
	if !lookat then
		lookat = Vector(0,0,0)
	end
	panel:SetLookAt(lookat)
	panel:SetMouseInputEnabled(false)
	panel.DropDragger = function(p)
		local cX,cY = Inventory:CursorPos()
		if cX>0 and cX < Inventory:GetWide() and cY>0 and cY < Inventory:GetTall() then
			local xSlot,ySlot = Inventory:GetItemSlot(cX,cY)
			if (draggingEntity and draggingEntity:IsValid()) then
				RunConsoleCommand("pickupItem",draggingEntity:EntIndex(),xSlot,ySlot)
			else
				RunConsoleCommand("moveItem",x,y,xSlot,ySlot)
			end
		else
		end
	end
	panel:MakePopup()
	panel.Think = function(p) if !input.IsMouseDown(MOUSE_LEFT) then p:DropDragger() draggingEntity = nil p:Remove() else p:SetPos(gui.MouseX(),gui.MouseY()) end end
	draggableItem = panel
end
	
function GetInventoryPanel()
	return Inventory
end