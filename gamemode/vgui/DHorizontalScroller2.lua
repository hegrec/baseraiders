PANEL = {}

AccessorFunc( PANEL, "m_iOverlap", 					"Overlap" )

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:Init()

	self.Panels = {}
	self.OffsetX = 0
	self.FrameTime = 0
	
	self.pnlCanvas 	= vgui.Create( "Panel", self )
	
	self:SetOverlap( 0 )
	
	self.btnLeft = vgui.Create( "DButton", self )
	//self.btnLeft:SetType( "left" )
	
	self.btnRight = vgui.Create( "DButton", self )
	//self.btnRight:SetType( "right" )

end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:AddPanel( pnl,position )

	position = position or #self.Panels + 1
	table.insert( self.Panels,position, pnl )
	
	pnl:SetParent( self.pnlCanvas )

end

/*---------------------------------------------------------
   Name: OnMouseWheeled
---------------------------------------------------------*/
function PANEL:OnMouseWheeled( dlta )
	
	self.OffsetX = self.OffsetX + dlta * -30
	self:InvalidateLayout( true )
	
	return true
	
end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:Think()

	// Hmm.. This needs to really just be done in one place
	// and made available to everyone.
	local FrameRate = VGUIFrameTime() - self.FrameTime
	self.FrameTime = VGUIFrameTime()

	if ( self.btnRight:IsDown() ) then
		self.OffsetX = self.OffsetX + (500 * FrameRate)
		self:InvalidateLayout( true )
	end
	
	if ( self.btnLeft:IsDown() ) then
		self.OffsetX = self.OffsetX - (500 * FrameRate)
		self:InvalidateLayout( true )
	end

end 

/*---------------------------------------------------------
	PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()

	local w, h = self:GetSize()
	
	self.pnlCanvas:SetTall( h )
	
	local x = 0
	
	for i=1,#self.Panels do
	
		self.Panels[i]:SetPos( x, 0 )
		self.Panels[i]:SetTall( h )
		self.Panels[i]:ApplySchemeSettings()
		
		x = x + self.Panels[i]:GetWide() - self.m_iOverlap
	
	end
	
	self.pnlCanvas:SetWide( x + self.m_iOverlap )
	
	if ( w < self.pnlCanvas:GetWide() ) then
		self.OffsetX = math.Clamp( self.OffsetX, 0, self.pnlCanvas:GetWide() - self:GetWide() )
	else
		self.OffsetX = 0
	end
	
	self.pnlCanvas.x = self.OffsetX * -1
	
	self.btnLeft:SetSize( 16, 16 )
	self.btnLeft:AlignLeft( 4 )
	self.btnLeft:CenterVertical()
	
	self.btnRight:SetSize( 16, 16 )
	self.btnRight:AlignRight( 4 )
	self.btnRight:CenterVertical()
	
	self.btnLeft:SetVisible( self.pnlCanvas.x < 0 )
	self.btnRight:SetVisible( self.pnlCanvas.x + self.pnlCanvas:GetWide() > self:GetWide() )

end

derma.DefineControl( "DHorizontalScroller2", "", PANEL, "DHorizontalScroller" )
