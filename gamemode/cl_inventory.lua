
Inventory = {}
local EquippedGuns = {} --hold this for the visual weight bar 

local inv
local function ShowInv(pl,cmd,args)
	if !ValidPanel(inv) then inv = vgui.Create("Inventory") end
	inv:SetVisible(true)
	local y = ScrH()-(inv:GetTall()+100)
	if !inv.Open then 
		inv:MoveTo(0,y,0.2,0,1)
		gui.EnableScreenClicker(true)
	else
		inv:MoveTo(-inv:GetWide(),y,0.2,0,1)
		gui.EnableScreenClicker(false)
	end
	inv.Open = !inv.Open
	
end
hook.Add("ContextMenuOpen","showinv",ShowInv)
hook.Add("OnContextMenuClose","hideinv",ShowInv)



local INVENTORY = {}
function INVENTORY:Init()
	self:SetSize(500,280)
	self:SetPos(-self:GetWide(),ScrH()-(self:GetTall()+100))
	self.TargetPos = ScrW()
	self:SetTitle("Inventory")
	self:SetDraggable(false)
	self:ShowCloseButton(false)
	self.List = vgui.Create("DPanelList",self)
	self.List:StretchToParent(5,35,5,5);
	self.List:EnableHorizontal(true);
	self.List:EnableVerticalScrollbar()
	self.TotalWeight = 0
	self.Open = false
	self.animPress = Derma_Anim( "Popout", self, self.PressedAnim )
	self.animPress2 = Derma_Anim( "Popin", self, self.PressedAnim2 )
	
	for i,v in pairs(Inventory) do
		self:MakeItem(i,v)
	end
end

function INVENTORY:MakeItem(index,amt,noweight)
	local type = GetItems()[index]
	
	for i,v in pairs(self.List.Items) do
		if v.itemType == index then self.List.Items[i].amt = v.amt+amt if !noweight then self:CalculateWeight() end return end
	end
	local panel = vgui.Create("DModelPanel")

	panel:SetModel(type.Model)
	panel:SetTooltip(index) 
	panel:SetSize(80,80)
	panel.amt = amt
	panel.itemType = index
	local CamPos = type.CamPos
	if !CamPos then
		CamPos = Vector(10,10,10)
	end
	panel:SetCamPos(CamPos)
	local lookat = type.LookAt
	if !lookat then
		lookat = Vector(0,0,0)
	end
	panel:SetLookAt(lookat)
	panel.PaintOver = function() draw.SimpleText(panel.amt,"ScoreboardSub",60,60,Color(255,255,255,255),2,4) end
	panel.OnMousePressed = 
	function()
		local menu = DermaMenu()
		if !type.NoDrop then
			menu:AddOption("Drop",function() RunConsoleCommand("dropitem",index) end)
		end
		if type.MenuAdds then
			type.MenuAdds(menu,index)
		end
		menu:Open()
	end
	self.List:AddItem(panel);
	self:CalculateWeight()
	if self.IsUsed then hook.Call("InventoryAddedItem",GAMEMODE,panel) end
	
end
function INVENTORY:TakeItem(index,amt)
	local ii;
	local itemp;
	for i,v in pairs(inv.List.Items) do
		if v.itemType == index then 
			inv.List.Items[i].amt = v.amt-amt
			ii=i
			itemp = v
			break
		end
	end
	if inv.List.Items[ii] and inv.List.Items[ii].amt <= 0 then 
		inv.List:RemoveItem(itemp);
		inv.List:InvalidateLayout()
	end
	self:CalculateWeight()
end
function INVENTORY:CalculateWeight()
	local weight = 0
	for i,v in pairs(Inventory) do
		weight = weight + GetItems()[i].Weight*v
	end
	for i,v in pairs(EquippedGuns) do
		weight = weight + GetItems()[i].Weight
	end
	self.TotalWeight = weight
end

function INVENTORY:PaintOver()
	draw.RoundedBox(0,2,24,self:GetWide()-4,7,Color(0,0,0,255))
	local g = 255-self.TotalWeight/MAX_INVENTORY*255
	draw.RoundedBox(0,2,24,self.TotalWeight/MAX_INVENTORY*(self:GetWide()-4),7,Color(self.TotalWeight/MAX_INVENTORY*255,g,0,255))
end
function INVENTORY:SetCustomUse(bool)
	self.IsUsed = bool
	if !bool then
		self:SetSize(500,280)
		self:SetPos(ScrW(),ScrH()-400)
		self.TargetPos = ScrW()
		self:SetParent(nil)
		self.List:StretchToParent(5,35,5,5);
		self:InvalidateLayout()
	end
end
vgui.Register("Inventory",INVENTORY,"DFrame")

local function ReceiveItem( um )
	local index = um:ReadString()
	local amt = um:ReadShort()
	
	
	Inventory[index] = Inventory[index] or 0
	Inventory[index] = Inventory[index] + amt
	
	if inv then
		inv:MakeItem(index,amt)
	end
	
end
usermessage.Hook("recvItem",ReceiveItem)

local function ReceiveGun( um )--USED WITH /HOLSTER ONLY
	local index = um:ReadString()
	
	
	Inventory[index] = Inventory[index] or 0
	Inventory[index] = Inventory[index] + 1
	
	
	EquippedGuns[index] = nil
	inv:MakeItem(index,1)
	
end
usermessage.Hook("recvGun",ReceiveGun)

local function LoseItem( um )
	local index = um:ReadString()
	local amt = um:ReadShort()
	
	Inventory[index] = Inventory[index] or 0
	Inventory[index] = Inventory[index] - amt
	
	if inv then
		inv:TakeItem(index,amt)
	end
end
usermessage.Hook("loseItem",LoseItem)

local function UseGun( um )
	local index = um:ReadString()
	
	Inventory[index] = Inventory[index] - 1
	EquippedGuns[index] = true
	inv:TakeItem(index,1)
	
end
usermessage.Hook("usegun",UseGun)

local function LoseGun( um )
	local index = um:ReadString()
	EquippedGuns[index] = nil
	inv:CalculateWeight()
end
usermessage.Hook("losegun",LoseGun)

hook.Add("InitPostEntity","CreateInventory",function() inv = vgui.Create("Inventory") end)
	
	
	
function GetInventoryPanel()
	return inv
end