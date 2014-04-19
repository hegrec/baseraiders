hook.Add("Initialize","dfsagdfds",function()
Inventory = nil
end)
function ShowInv(pl,cmd,args)
	if !LocalPlayer().Inventory then return end
	Inventory = vgui.Create("Inventory")
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
	local sz = INV_TILE_SIZE
	

	local xmax,ymax = LocalPlayer():GetInventorySize()
	
	local height = ymax*sz
	if height>ScrH()-100 then
		sz = (ScrH()-100)/ymax
	end
	self:SetTileSize(sz)
	
	
	self:SetSize(ymax*self.tileSize+150,xmax*self.tileSize)
	self:SetPos(-self:GetWide(),ScrH()-(self:GetTall()+100))
	self.ItemSpots = {}
	
	for y=1,ymax do
		self.ItemSpots[y] = {}
		for x=1,xmax do
			self.ItemSpots[y][x] = false
		end
	end
	self.Open = false
	for y=1,ymax do
		for x=1,xmax do
			if LocalPlayer().Inventory[y][x] and LocalPlayer().Inventory[y][x] != true then
				self:AddItem(LocalPlayer().Inventory[y][x],x,y)
			end
		end
	end

	local infoX = xmax*self.tileSize

	self.itemLabel = Label("Inventory",self)
	self.itemLabel:SetFont("HUDBars")
	self.itemLabel:SetPos(infoX+5,5)
	self.itemLabel:SizeToContents()

	self.amountLabel = Label("",self)
	self.amountLabel:SetFont("HUDBars")
	self.amountLabel:SetPos(infoX+5,25)
	self.amountLabel:SizeToContents()

	self.descriptionLabel = Label("",self)
	self.descriptionLabel:SetPos(infoX+5,35)
	self.descriptionLabel:SetMultiline(true)
	self.descriptionLabel:SetWrap(true)

	self.descriptionLabel:SetSize(140,100)
end
function INVENTORY:SetTileSize(sz)
	self.tileSize = sz
end
function INVENTORY:Paint()
	draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(200,200,200,255))
	surface.SetDrawColor(Color(20,20,20,255))
	local xmax,ymax = LocalPlayer():GetInventorySize()
	for y=1,ymax do
		surface.DrawLine(0,y*self.tileSize,xmax*self.tileSize,y*self.tileSize)
		for x=1,xmax do
			surface.DrawLine(x*self.tileSize,0,x*self.tileSize,self:GetTall())
			if (LocalPlayer().Inventory[y][x]) then
				draw.RoundedBox(0,(x-1)*self.tileSize,(y-1)*self.tileSize,self.tileSize,self.tileSize,Color(0,0,0,100))
			end
		end
	end
	local infoX = xmax*self.tileSize
	draw.RoundedBox(0,infoX,0,200,self:GetTall(),Color(50,50,50,255))
end
function INVENTORY:AddItem(index,x,y)
	local type = GetItems()[index]
	if !type then print("FAILED TO LOAD ITEM: ",index,x,y) return end
	local panel = vgui.Create("DModelPanel",self)
	self.ItemSpots[y][x] = panel
	
	local tsize = type.Size
	if tsize == nil then tsize = {2,2} end
	local xSize,ySize = unpack(tsize)
	panel:SetModel(type.Model)
	panel:SetTooltip(index)
	local ang = type.Angle
	if (!ang) then ang = Angle(0,0,0) end
	panel.LayoutEntity = function(s,ent)  ent:SetAngles(ang) end
	panel:SetSize(self.tileSize*xSize,self.tileSize*ySize)
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

	
	panel.PaintOver = function(p)


		if GetItems()[p.itemType].SWEPClass  then
			local found = false
			for i,v in pairs(LocalPlayer():GetWeapons()) do
				if v:GetClass() == GetItems()[p.itemType].SWEPClass then
					found = true
					break
				end
			end
			if found then

				draw.RoundedBox(0,0,0,p:GetWide(),p:GetTall(),Color(200,200,20,50)) 
			end
		end


		if p.m_isSelected then
			surface.SetDrawColor(Color(255,255,0,255))
			surface.DrawLine(0,0,p:GetWide(),0)
			surface.DrawLine(0,1,p:GetWide(),1)

			surface.DrawLine(0,p:GetTall()-1,p:GetWide(),p:GetTall()-1)
			surface.DrawLine(0,p:GetTall()-2,p:GetWide(),p:GetTall()-2)


			surface.DrawLine(0,0,0,p:GetTall())
			surface.DrawLine(1,0,1,p:GetTall())

			surface.DrawLine(p:GetWide()-1,0,p:GetWide()-1,p:GetTall())
			surface.DrawLine(p:GetWide()-2,0,p:GetWide()-2,p:GetTall())
		end
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



				local found = false
				for i,v in pairs(LocalPlayer():GetWeapons()) do
					if v:GetClass() == type.SWEPClass then
						found = true
						break
					end
				end
				if !found then
					menu:AddOption("Equip",function() RunConsoleCommand("use_gun",x,y) end)
				else
					menu:AddOption("Holster",function() RunConsoleCommand("holster_gun",x,y) end)
				end

			end
			if LocalPlayer():GetEyeTrace().Entity:GetClass() == "gang_vault" then
				menu:AddOption("Transfer to Vault",function() RunConsoleCommand("item_to_hub",x,y) end)
				menu:AddOption("Transfer all to Vault",function() RunConsoleCommand("item_to_hub",x,y,"1") end)
			end
			if LocalPlayer():GetNWBool("Banking") then
				menu:AddOption("Transfer to Bank",function() RunConsoleCommand("item_to_bank",x,y) end)
				menu:AddOption("Transfer all to Bank",function() RunConsoleCommand("item_to_bank",x,y,"1") end)
			end
			if type.MenuAdds then
				type.MenuAdds(menu,index,x,y)
			end
			menu:Open()
		elseif mouse == MOUSE_LEFT then
			p.downOn = {x,y}
			p.wasDown = true
			
		end

	end
	panel.OnMouseReleased = function(p,mouse)
		if mouse == MOUSE_LEFT && p.wasDown then
			self:SelectItem(panel)
			p.downOn = nil
			p.wasDown = nil
		end
	end

	panel.OnCursorMoved = function(p,xpos,ypos)
		if p.downOn then
			p.wasDown = false
			SetDraggableItem(index,p.downOn[1],p.downOn[2])
		end





	end
	panel:SetPos((x-1)*self.tileSize,(y-1)*self.tileSize)
	
end
function INVENTORY:GetItemSlot(mX,mY)
	return math.floor(mX/self.tileSize)+1,math.floor(mY/self.tileSize)+1
end

function INVENTORY:SelectItem(pnl)
	if ValidPanel(self.selectedPanel) then
		self.selectedPanel.m_isSelected = false
	end
	pnl.m_isSelected = true
	self.selectedPanel = pnl

	self.selectedItem = pnl.itemType
	self.itemLabel:SetText(pnl.itemType)
	self.itemLabel:SizeToContents()
	local tbl = GetItems()[pnl.itemType]

	self.amountLabel:SetText(LocalPlayer():GetAmount(pnl.itemType))
	self.amountLabel:SizeToContents()

	self.descriptionLabel:SetText(tbl.Description)
	


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
	if !tbl then return end
	
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


function recvInventorySize(um) 
	LocalPlayer().Inventory = {}
	local x = um:ReadChar()
	local y = um:ReadChar()
	
	for y=1,y do
		LocalPlayer().Inventory[y] = {}
		for x=1,x do
			LocalPlayer().Inventory[y][x] = false
		end
	end
 end
 usermessage.Hook("setInventorySize",recvInventorySize)
local draggingEntity
 hook.Add("GUIMousePressed","hoverclick",function(code,pos)
	local ent = properties.GetHovered(LocalPlayer():EyePos(),LocalPlayer():GetAimVector())
	
	
	
	
	if (ent and ent:IsValid()) then
	
		local tr = {}
		tr.start = LocalPlayer():GetShootPos()
		tr.endpos = ent:LocalToWorld(ent:OBBCenter())
		tr.filter = LocalPlayer()
		tr = util.TraceLine(tr)
		if tr.Entity != ent || tr.StartPos:Distance(tr.HitPos) > MAX_INTERACT_DIST then return end
	
		if ent:GetItemName() then
			draggingEntity = ent
			SetDraggableItem(ent:GetItemName())
			
		end
	end
end)

local draggableItem
function SetDraggableItem(item,x,y)
	if ValidPanel(draggableItem) then draggableItem:Remove() end
	local type = GetItems()[item]
	if !type then return end
	local panel = vgui.Create("DModelPanel")
	local tsize = type.Size
	if tsize == nil then tsize = {2,2} end
	local xSize,ySize = unpack(tsize)
	panel:SetModel(type.Model)
	local ang = type.Angle
	if (!ang) then ang = Angle(0,0,0) end
	panel.LayoutEntity = function(s,ent) ent:SetAngles(ang) end
	panel:SetSize(Inventory.tileSize*xSize,Inventory.tileSize*ySize)
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
		if !ValidPanel(Inventory) then return end
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