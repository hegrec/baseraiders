local isSmelting = false;

local PANEL = {}
function PANEL:Init()
	self:SetTitle("Crafting Table")
	
	self:SetSize(350,ScrH()*0.6)
	self:Center()
	
	self:SetDraggable(false)
	
	
		
	self.craftables = vgui.Create("DPanelList",self)
	self.craftables:StretchToParent(5,25,5,5)
	self.craftables:SetSpacing(4)
	self.craftables:EnableVerticalScrollbar(true)
	self.craftables.HUDPaint = function() end
	
	
	local var = "Craftable"
	if isSmelting then
		var = "Smeltable"
		self:SetTitle("Smelting Furnace")
	end
	self.ItemGroups = {}

	local items = GetItems()
	for i,v in pairs(items) do
		if (v[var]) then
			self:AddItemGroup(v.Group,var)
			--self:AddCraftable(i,v)
		end
	end


	self:MakePopup()
end
function PANEL:AddItemGroup(groupName,var)
	if self.ItemGroups[groupName] then return end
	local DCollapsibleCategory = vgui.Create( "DCollapsibleCategory2" )
	DCollapsibleCategory:SetLabel( groupName )
	
	
	local innerList = vgui.Create("DPanelList")
	innerList:EnableVerticalScrollbar(true)
	innerList.HUDPaint = function() end
	local items = GetItems()
	for i,v in pairs(items) do
		if (v[var]) and v.Group == groupName then
			innerList:AddItem(self:AddCraftable(i,v,innerList))
		end
	end
	
	
	DCollapsibleCategory:SetStartHeight(128*#innerList:GetItems())
	DCollapsibleCategory:SetSize(300,25+128*#innerList:GetItems())
	innerList:SizeToContents()
	DCollapsibleCategory:SetContents(innerList)
	DCollapsibleCategory:InvalidateLayout( true )
	DCollapsibleCategory.Header.DoClick = function(s)
		
		--s:GetParent():SetExpanded(false)
		s:GetParent():Toggle()
		
		for i,v in pairs(self.ItemGroups) do
			if (v:GetParent() != s:GetParent()) then
			v:GetParent():SetExpanded(true)
			v:GetParent():Toggle()
			end
		end
		
	end
	
	self.ItemGroups[groupName] = innerList
	self.craftables:AddItem(DCollapsibleCategory)
	DCollapsibleCategory:Toggle()
end
function PANEL:AddCraftable(name,tbl,parentList)
	local pnl = vgui.Create("DPanel")
	pnl:SetTall(128)
	local lblName = vgui.Create("DLabel",pnl)
	lblName:SetPos(5,5)
	lblName:SetText(name)
	lblName:SetFont("HUDBars")
	lblName:SizeToContents()
	lblName:SetTextColor(Color(0,0,0,255))
	
	local var = "Craftable"
	if isSmelting then
		var = "Smeltable"
	end
	
	pnl.Paint = function(s)
		local can_craft = true
		for i=1,#tbl[var],2 do
			if (LocalPlayer():GetAmount(tbl[var][i])<tbl[var][i+1]) then can_craft = false break end
		end

		local color = Color(100,200,100,255)
		if (!can_craft) then
			color = Color(200,100,100,255)
		end
		draw.RoundedBox(0,0,0,s:GetWide(),s:GetTall(),color)
	end
	
	for i=1,#tbl[var],2 do
		local text = tbl[var][i+1] .. " " .. tbl[var][i]
		
		local lblRequirement = vgui.Create("DLabel",pnl)
		lblRequirement:SetPos(5,20+(i/2)*15)
		lblRequirement:SetText(text)
		lblRequirement:SetTextColor(Color(0,100,0,255))
		lblRequirement:SizeToContents()
		draw.SimpleTextOutlined(text,"Default",5,20+(i/2)*15,Color(200,200,200,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM,1,Color(0,0,0,255))
	end
	
	local model = vgui.Create("DModelPanel",pnl)
	model:SetPos(200,0)
	
	local tsize = {2,2}
	if tbl.Size then tsize = tbl.Size end
	
	
	local x,y = tsize[1]*INV_TILE_SIZE,tsize[2]*INV_TILE_SIZE
	
	
	model:SetSize(x/2,y)
	model:SetModel(tbl.Model)
	model:SetMouseInputEnabled(false)
	
	local create = vgui.Create("DButton",pnl)
	
	pnl:SetToolTip(tbl.Description)
	create:SetSize(150,25)
	create:SetText("Craft Item")
	create.DoClick = function() RunConsoleCommand("craft_item",name) end
	create:SetPos(5,pnl:GetTall()-30)
	
	return pnl
end
function PANEL:Think()
	if !Me:Alive() then self:Close() end --Auto save for the player if they die
end

function PANEL:Close()
	self:Remove()
	RunConsoleCommand("crafting_finished")
end
vgui.Register("CraftingMenu",PANEL,"DFrame")


local function showCraftMenu( um )
	isSmelting = um:ReadBool()
	craftingMenu = vgui.Create("CraftingMenu")
end
usermessage.Hook("showCraftMenu",showCraftMenu)