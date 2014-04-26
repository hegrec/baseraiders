local isSmelting = false;
local portableCraft = false;
local PANEL = {}
function PANEL:Init()
	self:SetTitle("Crafting Table")
	
	self:SetSize(600,ScrH()*0.6)
	self:Center()
	
	self:SetDraggable(false)
	
	
		
	self.craftables = vgui.Create("DPanelList",self)
	self.craftables:StretchToParent(5,25,305,5)
	self.craftables:SetSpacing(4)
	self.craftables:EnableVerticalScrollbar(true)
	self.craftables.HUDPaint = function() end
	
	
	local var = "Craftable"
	if isSmelting then
		var = "Smeltable"
		self:SetTitle("Smelting Furnace")
	end

	if (portableCraft) then
		self:SetTitle("Portable "..var.." Menu")
	end

	self.ItemGroups = {}

	local items = GetItems()
	for i,v in pairs(items) do
		if (v[var]) then
			self:AddItemGroup(v.Group,var)
			--self:AddCraftable(i,v)
		end
	end

	self.detailPanel = vgui.Create("DPanel",self)
	self.detailPanel:StretchToParent(305,25,5,5)
	
	


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
	
	
	DCollapsibleCategory:SetStartHeight(32*#innerList:GetItems())
	DCollapsibleCategory:SetSize(300,25+32*#innerList:GetItems())
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
function PANEL:SetActiveItem(name)

	local tbl = GetItems()[name]
	self.detailPanel:Clear()
	self.detailPanel:SetToolTip(tbl.Description)


	self.detailName = vgui.Create("DLabel",self.detailPanel)
	self.detailName:SetPos(15,5)
	self.detailName:SetText(name)
	self.detailName:SetFont("HUDBars")
	self.detailName:SizeToContents()
	self.detailName:SetTextColor(Color(0,0,0,255))

	self.detailDesc = vgui.Create("DLabel",self.detailPanel)
	self.detailDesc:SetPos(15,35)
	self.detailDesc:SetText(tbl.Description)
	self.detailDesc:SetFont("HUDBars")
	self.detailDesc:SetSize(200,60)
	self.detailDesc:SetWrap(true)
	self.detailDesc:SetTextColor(Color(0,0,0,255))

	local var = "Craftable"
	if isSmelting then
		var = "Smeltable"
	end

	local lblRequirement = vgui.Create("DLabel",self.detailPanel)
	lblRequirement:SetPos(120,100)
	lblRequirement:SetText("Requirements")
	lblRequirement:SetTextColor(Color(0,0,0,255))
	lblRequirement:SizeToContents()


	for i=1,#tbl[var],2 do
		local text = tbl[var][i+1] .. " " .. tbl[var][i]
		
		local lblRequirement = vgui.Create("DLabel",self.detailPanel)
		lblRequirement:SetPos(120,120+(i/2)*15)
		lblRequirement:SetText(text)
		lblRequirement:SetTextColor(Color(0,100,0,255))
		if (LocalPlayer():GetAmount(tbl[var][i])<tbl[var][i+1]) then
			lblRequirement:SetTextColor(Color(100,0,0,255))
		end
		lblRequirement:SizeToContents()
	end
	
	local model = vgui.Create("DModelPanel",self.detailPanel)
	model:SetPos(15,100)
	
	local tsize = {2,2}
	if tbl.Size then tsize = tbl.Size end
	
	
	local x,y = tsize[1]*INV_TILE_SIZE,tsize[2]*INV_TILE_SIZE
	
	local properHeight = (100/x)*y

	model:SetSize(100,properHeight)
	model:SetModel(tbl.Model)
	model:SetLookAt(tbl.LookAt)
	model:SetCamPos(tbl.CamPos)
	model:SetMouseInputEnabled(false)
	model.LayoutEntity = function() end
	if !portableCraft then
		local create = vgui.Create("DButton",self.detailPanel)
		
		
		create:SetSize(150,25)
		create:SetText("Craft Item")
		create.DoClick = function() RunConsoleCommand("craft_item",name) end
		create:SetPos(5,self.detailPanel:GetTall()-30)
	else
		local lblFindTbl = vgui.Create("DLabel",self.detailPanel)
		lblFindTbl:SetPos(5,self.detailPanel:GetTall()-100)
		lblFindTbl:SetText("You can create this at a crafting table if you have the required materials")
		if isSmelting then
			lblFindTbl:SetText("You can create this at a smelting furnace if you have the required materials")
		end
		lblFindTbl:SetTextColor(Color(0,0,0,255))
		lblFindTbl:SetFont("HUDBars")
		lblFindTbl:SetWrap(true)
		lblFindTbl:SetSize(self.detailPanel:GetWide()-10,70)

	end




end
function PANEL:AddCraftable(name,tbl,parentList)
	local pnl = vgui.Create("DPanel")
	pnl:SetTall(32)
	local lblName = vgui.Create("DLabel",pnl)
	lblName:SetPos(5,5)
	lblName:SetText(name)
	lblName:SetFont("HUDBars")
	lblName:SizeToContents()
	lblName:SetTextColor(Color(0,0,0,255))
	pnl.OnMousePressed = function()
		self:SetActiveItem(name)
	end
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
	portableCraft = false
	craftingMenu = vgui.Create("CraftingMenu")
end
usermessage.Hook("showCraftMenu",showCraftMenu)


function ShowCraftingMenu(smelt)
	isSmelting = smelt
	portableCraft = true
	craftingMenu = vgui.Create("CraftingMenu")

end