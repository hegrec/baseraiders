local isSmelting = false;

local PANEL = {}
function PANEL:Init()
	self:SetTitle("Crafting Table")
	
	self:SetSize(350,ScrH()*0.6)
	self:Center()
	
	self:SetDraggable(false)
	
	
		
	self.craftables = vgui.Create("DPanelList",self)
	self.craftables:StretchToParent(5,25,5,5)
	self.craftables:EnableVerticalScrollbar(true)
	self.craftables.HUDPaint = function() end
	
	
	local var = "Craftable"
	if isSmelting then
		var = "Smeltable"
	end
	
	
	local items = GetItems()
	for i,v in pairs(items) do
		if (v[var]) then
			self:AddCraftable(i,v)
		end
	end


	self:MakePopup()
end
function PANEL:AddCraftable(name,tbl)
	local pnl = vgui.Create("DPanel")
	pnl:SetTall(128)
	
	local lblName = vgui.Create("DLabel",pnl)
	lblName:SetPos(5,5)
	lblName:SetText(name)
	lblName:SetTextColor(Color(0,0,0,255))
	
	local var = "Craftable"
	if isSmelting then
		var = "Smeltable"
	end
	
	
	for i=1,#tbl[var],2 do
		local text = tbl[var][i+1] .. " " .. tbl[var][i]
		
		local lblRequirement = vgui.Create("DLabel",pnl)
		lblRequirement:SetPos(5,20+(i/2)*15)
		lblRequirement:SetText(text)
		lblRequirement:SetTextColor(Color(0,100,0,255))
		draw.SimpleTextOutlined(text,"Default",5,20+(i/2)*15,Color(200,200,200,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM,1,Color(0,0,0,255))
	end
	
	
	local create = vgui.Create("DButton",pnl)
	
	
	create:SetSize(150,25)
	pnl:SizeToContents()
	create:SetText("Craft Item")
	create.DoClick = function() RunConsoleCommand("craftItem",name) end
	create:SetPos(5,pnl:GetTall()-30)
	self.craftables:AddItem(pnl)
end
function PANEL:Think()
	if !Me:Alive() then self:Close() end --Auto save for the player if they die
end

function PANEL:Close()
	self:Remove()
	RunConsoleCommand("craftingFinished")
end
vgui.Register("CraftingMenu",PANEL,"DFrame")


local function showCraftMenu( um )
	isSmelting = um:ReadBool()
	craftingMenu = vgui.Create("CraftingMenu")
end
usermessage.Hook("showCraftMenu",showCraftMenu)