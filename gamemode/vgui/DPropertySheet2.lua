local PANEL = {}

Derma_Hook( PANEL, "Paint", "Paint", "PropertySheet" )

AccessorFunc( PANEL, "m_bBackground", 			"DrawBackground" )
AccessorFunc( PANEL, "m_pActiveTab", 			"ActiveTab" )
AccessorFunc( PANEL, "m_iPadding",	 			"Padding" )
AccessorFunc( PANEL, "m_fFadeTime", 			"FadeTime" )

AccessorFunc( PANEL, "m_bShowIcons", 			"ShowIcons" )

function PANEL:GetItems()
	return self.Items
end 

function PANEL:Init()
	
	self:SetShowIcons( false )

	self.tabScroller 	= vgui.Create( "DHorizontalScroller2", self )
	self.tabScroller:SetOverlap( 5 )

	self:SetFadeTime( 0.1 )
	self:SetPadding( 5 )
		
	self.animFade = Derma_Anim( "Fade", self, self.CrossFade )
	
	self.Items = {}
	
end

/*---------------------------------------------------------
   Name: AddSheet
---------------------------------------------------------*/
function PANEL:AddSheet( label, panel, material, NoStretchX, NoStretchY, Tooltip, position )

	if ( !IsValid( panel ) ) then return end

	position = position or #self.Items + 1
	position = math.min(position,#self.Items + 1)
	
	local Sheet = {}
	
	Sheet.Tab = vgui.Create( "DTab", self )
	Sheet.Tab:SetTooltip( Tooltip )
	Sheet.Tab:Setup( label, self, panel, nil )
	
	Sheet.Panel = panel
	Sheet.Panel.NoStretchX = NoStretchX
	Sheet.Panel.NoStretchY = NoStretchY
	
	panel:SetParent( self )
	
	table.insert( self.Items, position, Sheet )
	
	if ( !self:GetActiveTab() ) then
		self:SetActiveTab( Sheet.Tab )
	end
	
	self.tabScroller:AddPanel( Sheet.Tab, position)

end

/*---------------------------------------------------------
   Name: SetActiveTab
---------------------------------------------------------*/
function PANEL:SetActiveTab( active )

	if ( self.m_pActiveTab == active ) then return end
	
	if ( self.m_pActiveTab ) then
		self.animFade:Start( self:GetFadeTime(), { OldTab = self.m_pActiveTab, NewTab = active } )
	end

	self.m_pActiveTab = active
	self:InvalidateLayout()

end

/*---------------------------------------------------------
   Name: Think
---------------------------------------------------------*/
function PANEL:Think()

	self.animFade:Run()

end


/*---------------------------------------------------------
   Name: CrossFade
---------------------------------------------------------*/
function PANEL:CrossFade( anim, delta, data )
	
	local old = data.OldTab:GetPanel()
	local new = data.NewTab:GetPanel()
	
	if ( anim.Finished ) then
	
		old:SetVisible( false )
		new:SetAlpha( 255 )
		
		old:SetZPos( 0 )
		new:SetZPos( 0 )
		
	return end
	
	if ( anim.Started ) then
	
		old:SetZPos( 0 )
		new:SetZPos( 1 )
		
		old:SetAlpha( 255 )
		new:SetAlpha( 0 )
		
	end
	
	old:SetVisible( true )
	new:SetVisible( true )
		
	new:SetAlpha( 255 * delta )

end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()

	local ActiveTab = self:GetActiveTab()
	local Padding = self:GetPadding()
	
	if (!ActiveTab) then return end
	
	// Update size now, so the height is definitiely right.
	ActiveTab:InvalidateLayout( true )
	
	self.tabScroller:StretchToParent( Padding, 0, Padding, nil )
	self.tabScroller:SetTall( ActiveTab:GetTall() )
	self.tabScroller:InvalidateLayout( true )
	
	for i = 1,#self.Items do
	
		self.Items[i].Tab:GetPanel():SetVisible( false )
		self.Items[i].Tab:SetZPos( 100 - i )
		self.Items[i].Tab:ApplySchemeSettings()
	
	end
	
	
	if ( ActiveTab ) then
	
		local ActivePanel = ActiveTab:GetPanel()
	
		ActivePanel:SetVisible( true )
		ActivePanel:SetPos( Padding, ActiveTab:GetTall() + Padding )
		
		if ( !ActivePanel.NoStretchX ) then 
			ActivePanel:SetWide( self:GetWide() - Padding * 2 ) 
		else
			ActivePanel:CenterHorizontal()
		end
		
		if ( !ActivePanel.NoStretchY ) then 
			ActivePanel:SetTall( self:GetTall() - ActiveTab:GetTall() - Padding * 2 ) 
		else
			ActivePanel:CenterVertical()
		end
		
		ActivePanel:InvalidateLayout()
		
		ActiveTab:SetZPos( 100 )
	
	end

	// Give the animation a chance
	self.animFade:Run()
	
end


/*---------------------------------------------------------
   Name: SizeToContentWidth
---------------------------------------------------------*/
function PANEL:SizeToContentWidth()

	local wide = 0

	for k, v in pairs( self.Items ) do
	
		if ( v.Panel ) then
			v.Panel:InvalidateLayout( true )
			wide = math.max( wide, v.Panel:GetWide()  + self.m_iPadding * 2 )
		end
	
	end
	
	self:SetWide( wide )

end

derma.DefineControl( "DPropertySheet2", "", PANEL, "DPropertySheet" )
