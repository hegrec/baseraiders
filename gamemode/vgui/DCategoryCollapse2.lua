--[[   _                                
	( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DCategoryCollapse2
	

--]]
local PANEL = {}

AccessorFunc( PANEL, "m_bSizeExpanded", 		"Expanded", 		FORCE_BOOL )
AccessorFunc( PANEL, "m_iContentHeight",	 	"StartHeight" )
AccessorFunc( PANEL, "m_fAnimTime", 			"AnimTime" )
AccessorFunc( PANEL, "m_bDrawBackground", 		"DrawBackground", 	FORCE_BOOL )
AccessorFunc( PANEL, "m_iPadding", 				"Padding" )
AccessorFunc( PANEL, "m_pList", 				"List" )

--[[---------------------------------------------------------
	Init
-----------------------------------------------------------]]
function PANEL:Init()
	self.Header = vgui.Create( "DCategoryHeader", self )
	self.Header:Dock( TOP )
	self.Header:SetSize( 20, 20 )
	
	self:SetSize( 16, 16 );
	self:SetExpanded( true )
	self:SetMouseInputEnabled( true )
	
	self:SetAnimTime( 0.2 )
	self.animSlide = Derma_Anim( "Anim", self, self.AnimSlide )
	
	self:SetDrawBackground( true )
	self:DockMargin( 0, 0, 0, 2 )
	self:DockPadding( 0, 0, 0, 5 )

end

--[[---------------------------------------------------------
   Name: button
-----------------------------------------------------------]]
function PANEL:Add( strName )

	local button = vgui.Create( "DButton", self )
	button.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "CategoryButton", panel, w, h ) end
	button.UpdateColours = function( button, skin )
	
			if ( button.AltLine ) then

				if ( button.Depressed || button.m_bSelected )		then return button:SetTextStyleColor( skin.Colours.Category.LineAlt.Text_Selected ) end
				if ( hovered )										then return button:SetTextStyleColor( skin.Colours.Category.LineAlt.Text_Hover ) end
				return button:SetTextStyleColor( skin.Colours.Category.LineAlt.Text )	
						
			end
	
			if ( button.Depressed || button.m_bSelected )		then return button:SetTextStyleColor( skin.Colours.Category.Line.Text_Selected ) end
			if ( hovered )										then return button:SetTextStyleColor( skin.Colours.Category.Line.Text_Hover ) end
			return button:SetTextStyleColor( skin.Colours.Category.Line.Text )
	
		end
		
	button:SetHeight( 17 )
	button:SetTextInset( 4, 0 )
	
	button:SetContentAlignment( 4 )
	button:DockMargin( 1, 0, 1, 0 )
	button.DoClickInternal =  function()
	
		if ( self:GetList() ) then
			self:GetList():UnselectAll()
		else
			self:UnselectAll()
		end
		
		button:SetSelected( true )
		
	end
	
	button:Dock( TOP )
	button:SetText( strName )
	
	self:InvalidateLayout( true )
	self:UpdateAltLines()
	
	return button 

end

function PANEL:UnselectAll()

	local children = self:GetChildren()
	for k, v in pairs( children ) do
	
		if ( v.SetSelected ) then
			v:SetSelected( false )
		end
		
	end

end

function PANEL:UpdateAltLines()

	local children = self:GetChildren()
	for k, v in pairs( children ) do
		v.AltLine = k % 2 != 1		
	end

end


--[[---------------------------------------------------------
   Name: Think
-----------------------------------------------------------]]
function PANEL:Think()

	self.animSlide:Run()

end

--[[---------------------------------------------------------
	SetLabel
-----------------------------------------------------------]]
function PANEL:SetLabel( strLabel )

	self.Header:SetText( strLabel )

end

--[[---------------------------------------------------------
	Paint
-----------------------------------------------------------]]
function PANEL:Paint( w, h )

	derma.SkinHook( "Paint", "CollapsibleCategory", self, w, h )
	return false

end

--[[---------------------------------------------------------
   Name: SetContents
-----------------------------------------------------------]]
function PANEL:SetContents( pContents )

	self.Contents = pContents
	self.Contents:SetParent( self )
	self.Contents:Dock( FILL )
	self:InvalidateLayout()

end

--[[---------------------------------------------------------
   Name: Toggle
-----------------------------------------------------------]]
function PANEL:Toggle()

	self:SetExpanded( !self:GetExpanded() )

	self.animSlide:Start( self:GetAnimTime(), { From = self:GetTall() } )
	
	self:InvalidateLayout( true )
	self:GetParent():InvalidateLayout()
	self:GetParent():GetParent():InvalidateLayout()
	
	local cookie = '1'
	if ( !self:GetExpanded() ) then cookie = '0' end
	self:SetCookie( "Open", cookie )
	
end

--[[---------------------------------------------------------
   Name: DoExpansion
-----------------------------------------------------------]]
function PANEL:DoExpansion( b )

	if ( self.m_bSizeExpanded == b ) then return end
	self:Toggle();
	
end

--[[---------------------------------------------------------
   Name: PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

	local Padding = self:GetPadding() or 0

	if ( self.Contents ) then
		
		if ( self:GetExpanded() ) then
			self.Contents:InvalidateLayout( true )
			self.Contents:SetVisible( true )
		else
			self.Contents:SetVisible( false )
		end
		
	end
	
	if ( self:GetExpanded() ) then
		self:SetTall(self.Header:GetTall()+5+self.m_iContentHeight)
	
	else
		
		self:SetTall( self.Header:GetTall() )
	
	end	
	
	-- Make sure the color of header text is set
	self.Header:ApplySchemeSettings()
	
	self.animSlide:Run()
	self:UpdateAltLines();

end

--[[---------------------------------------------------------
	OnMousePressed
-----------------------------------------------------------]]
function PANEL:OnMousePressed( mcode )

	if ( !self:GetParent().OnMousePressed ) then return end;
	
	return self:GetParent():OnMousePressed( mcode )

end

--[[---------------------------------------------------------
   Name: AnimSlide
-----------------------------------------------------------]]
function PANEL:AnimSlide( anim, delta, data )
	
	self:InvalidateLayout()
	self:InvalidateParent()
	
	if ( anim.Started ) then
		data.To = self:GetTall()	
	end
	
	if ( anim.Finished ) then
		return end

	if ( self.Contents ) then self.Contents:SetVisible( true ) end
	
	self:SetTall( Lerp( delta, data.From, data.To ) )
	
end

--[[---------------------------------------------------------
	LoadCookies
-----------------------------------------------------------]]
function PANEL:LoadCookies()

	local Open = self:GetCookieNumber( "Open", 1 ) == 1

	self:SetExpanded( Open )
	self:InvalidateLayout( true )
	self:GetParent():InvalidateLayout()
	self:GetParent():GetParent():InvalidateLayout()

end


derma.DefineControl( "DCollapsibleCategory2", "Collapsable Category Panel2", PANEL, "Panel" )