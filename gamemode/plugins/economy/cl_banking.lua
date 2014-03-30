local bankMenu;

local PANEL = {}
function PANEL:Init()
	self:SetTitle("Bank Account")
	
	self:SetSize(ScrW()*0.6,ScrH()*0.6)
	self:Center()
	
	self:SetDraggable(false)
	
	local inventory = GetInventoryPanel()
	for i,v in pairs(inventory.List.Items) do
		v.OldMousePressed = v.OnMousePressed
		v.OnMousePressed = 
		function()
			local menu = DermaMenu()
			menu:AddOption("Transfer to Bank",function() RunConsoleCommand("itemToBank",v.itemType) end)
			menu:AddOption("Transfer X to Bank",function()
				Derma_StringRequest( "Question", 
					"How many do you wish to transfer?", 
					"Type a number here", 
					function( strTextOut ) RunConsoleCommand("itemToBank",v.itemType,strTextOut) end,
					function( strTextOut )  end,
					"Transfer", 
					"Cancel" )
			end)
			menu:AddOption("Transfer all to Bank",function() RunConsoleCommand("itemToBank",v.itemType,"all") end)
			menu:Open()
		end
	end
	inventory:SetCustomUse(true)
	inventory:SetParent(self)
	inventory:StretchToParent(5,25,5,self:GetTall()*0.5+5)
	inventory.List:StretchToParent(5,35,5,5);
	inventory:InvalidateLayout()
	
	self.bankAccount = vgui.Create("DFrame",self)
	self.bankAccount:SetTitle("My Bank Account")
	self.bankAccount:SetDraggable(false)
	self.bankAccount:ShowCloseButton(false)
	self.bankAccount:StretchToParent(5,self:GetTall()*0.5,5,5)
	
	self.bankList = vgui.Create("DPanelList",self.bankAccount)
	self.bankList:StretchToParent(5,25,5,5)
	self.bankList:EnableHorizontal(true)
	self.bankList:EnableVerticalScrollbar(true)

	gui.EnableScreenClicker(true)
end

function PANEL:AddBankItem(index,amount)
	for i,v in pairs(self.bankList.Items) do
		if v.itemType == index then
			v.amt = v.amt + amount
			return
		end
	end
	local type = GetItems()[index]
	local panel = vgui.Create("DModelPanel")

	panel:SetModel(type.Model)
	panel:SetTooltip(index)
	panel:SetSize(80,80)
	panel.amt = amount
	panel.itemType = index
	panel:SetCamPos(type.CamPos)
	panel:SetLookAt(type.LookAt)
	panel.PaintOver = function() draw.SimpleText(panel.amt,"ScoreboardSub",60,60,Color(255,255,255,255),2,4) end
	panel.OnMousePressed = 
	function()
		local menu = DermaMenu()
		menu:AddOption("Transfer to Inventory",function() RunConsoleCommand("itemToInventory",index) end)
		menu:AddOption("Transfer X to Inventory",function()
				Derma_StringRequest( "Question", 
					"How many do you wish to transfer?", 
					"Type a number here", 
					function( strTextOut ) RunConsoleCommand("itemToInventory",index,strTextOut) end,
					function( strTextOut )  end,
					"Transfer", 
					"Cancel" )
			end)
		menu:AddOption("Transfer all to Inventory",function() RunConsoleCommand("itemToInventory",index,"all") end)
		menu:Open()
	end
	self.bankList:AddItem(panel)
end

function PANEL:RemoveBankItem(index,amount)
	for i,v in pairs(self.bankList.Items) do
		if v.itemType == index then
			v.amt = v.amt - amount
			if v.amt < 1 then self.bankList:RemoveItem(v) self.bankList:InvalidateLayout() end
		end
	end
end

function PANEL:Think()
	if !Me:Alive() then self:Close() end --Auto save for the player if they die
end

function PANEL:Close() --Don't try manually removing this or you will be stuck and have to rejoin and your bank will not save. TODO: Make a temp backup in case server crashes during a large transaction or make a force save for item movements over 10 or something
	for i,v in pairs(GetInventoryPanel().List.Items) do
		v.OnMousePressed = v.OldMousePressed;
		v.OldMousePressed = nil;
	end
	--No longer customly use this
	GetInventoryPanel():SetCustomUse(false)
	self:Remove()
	bankMenu = nil
	gui.EnableScreenClicker(false)
	RunConsoleCommand("bankFinished")
end
vgui.Register("BankMenu",PANEL,"DFrame")

--Hook and fix up the menu for items that are new to the inventory
hook.Add("InventoryAddedItem","RedoDropMenu",function(v)
		v.OldMousePressed = v.OnMousePressed
		v.OnMousePressed = 
		function()
			local menu = DermaMenu()
			menu:AddOption("Transfer to Bank",function() RunConsoleCommand("itemToBank",v.itemType) end)
			menu:AddOption("Transfer X to Bank",function()
				Derma_StringRequest( "Question", 
					"How many do you wish to transfer?", 
					"Type a number here", 
					function( strTextOut ) RunConsoleCommand("itemToBank",v.itemType,strTextOut) end,
					function( strTextOut )  end,
					"Transfer", 
					"Cancel" )
			end)
			menu:AddOption("Transfer all to Bank",function() RunConsoleCommand("itemToBank",v.itemType,"all") end)
			menu:Open()
		end
		
end)

function GetBankItem( um )
	if !bankMenu then return end
	bankMenu:AddBankItem(um:ReadString(),um:ReadLong())
end
usermessage.Hook("getBankItem",GetBankItem)

function LoseBankItem( um )
	if !bankMenu then return end
	bankMenu:RemoveBankItem(um:ReadString(),um:ReadLong())
end
usermessage.Hook("loseBankItem",LoseBankItem)

function openBank()
	bankMenu = vgui.Create("BankMenu")
	RunConsoleCommand("requestBank")
end
usermessage.Hook("openBank",openBank)

local function fixMouse()
	if bankMenu && bankMenu:IsValid() then
		gui.EnableScreenClicker(true)
	end
end
hook.Add("ChatEnded","FixTheMouse",fixMouse)