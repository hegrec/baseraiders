 
include( "admin_buttons.lua" )
include( "vote_button.lua" )

local PANEL = {}

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:Init()

	self.InfoLabels = {}
	self.InfoLabels[ 1 ] = {}
	self.InfoLabels[ 2 ] = {}
	
	self.btnKick = vgui.Create( "PlayerKickButton", self )
	self.btnBan = vgui.Create( "PlayerBanButton", self )
	self.btnPBan = vgui.Create( "PlayerPermBanButton", self )
	
	self.VoteButtons = {}
	

end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:SetInfo( column, k, v )

	if ( !v || v == "" ) then v = "N/A" end

	if ( !self.InfoLabels[ column ][ k ] ) then
	
		self.InfoLabels[ column ][ k ] = {}
		self.InfoLabels[ column ][ k ].Key 	= vgui.Create( "DLabel", self )
		self.InfoLabels[ column ][ k ].Value 	= vgui.Create( "DLabel", self )
		self.InfoLabels[ column ][ k ].Key:SetText( k )
		self:InvalidateLayout()
	
	end
	
	self.InfoLabels[ column ][ k ].Value:SetText( v )
	return true

end


/*---------------------------------------------------------
   Name: UpdatePlayerData
---------------------------------------------------------*/
function PANEL:SetPlayer( ply )

	self.Player = ply
	self:UpdatePlayerData()

end

/*---------------------------------------------------------
   Name: UpdatePlayerData
---------------------------------------------------------*/
function PANEL:UpdatePlayerData()

	if (!self.Player) then return end
	if ( !self.Player:IsValid() ) then return end
	
	self:SetInfo( 1, "Website:", "http://www.zebgamers.com" )
	self:SetInfo( 1, "Location:", "" )
	self:SetInfo( 1, "Email:", "" )
	self:SetInfo( 1, "GTalk:", "") 
	self:SetInfo( 1, "MSN:", "" )
	self:SetInfo( 1, "AIM:", "" )
	self:SetInfo( 1, "XFire:", "" )
	
	self:SetInfo( 2, "Props:", ""/*self.Player:GetCount( "props" ) + self.Player:GetCount( "ragdolls" ) + self.Player:GetCount( "effects" )*/ )
	self:SetInfo( 2, "HoverBalls:", ""/*self.Player:GetCount( "hoverballs" )*/ )
	self:SetInfo( 2, "Thrusters:", ""/*self.Player:GetCount( "thrusters" )*/ )
	self:SetInfo( 2, "Balloons:", ""/*self.Player:GetCount( "balloons" )*/ )
	self:SetInfo( 2, "Buttons:", ""/*self.Player:GetCount( "buttons" )*/ )
	self:SetInfo( 2, "Dynamite:", ""/*self.Player:GetCount( "dynamite" )*/ )
	self:SetInfo( 2, "SENTs:", ""/*self.Player:GetCount( "sents" )*/ )
	
	self:InvalidateLayout()

end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:ApplySchemeSettings()

	for _k, column in pairs( self.InfoLabels ) do

		for k, v in pairs( column ) do
		
			v.Key:SetFGColor( 0, 0, 0, 100 )
			v.Value:SetFGColor( 0, 70, 0, 200 )
		
		end
	
	end

end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:Think()

	if ( self.PlayerUpdate && self.PlayerUpdate > CurTime() ) then return end
	self.PlayerUpdate = CurTime() + 0.25
	
	self:UpdatePlayerData()

end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()	

	local x = 5

	for colnum, column in pairs( self.InfoLabels ) do
	
		local y = 0
		local RightMost = 0
	
		for k, v in pairs( column ) do
	
			v.Key:SetPos( x, y )
			v.Key:SizeToContents()
			
			v.Value:SetPos( x + 70 , y )
			v.Value:SizeToContents()
			
			y = y + v.Key:GetTall() + 2
			
			RightMost = math.max( RightMost, v.Value.x + v.Value:GetWide() )
		
		end
		
		//x = RightMost + 10
		x = x + 300
	
	end
	
	if ( !self.Player ||
		 self.Player == LocalPlayer() ||
		 !LocalPlayer():IsAdmin() ) then 
	
		self.btnKick:SetVisible( false )
		self.btnBan:SetVisible( false )
		self.btnPBan:SetVisible( false )
	
	else
	
		self.btnKick:SetVisible( true )
		self.btnBan:SetVisible( true )
		self.btnPBan:SetVisible( true )
	
		self.btnKick:SetPos( self:GetWide() - 52 * 3, 80 )
		self.btnKick:SetSize( 48, 20 )

		self.btnBan:SetPos( self:GetWide() - 52 * 2, 80 )
		self.btnBan:SetSize( 48, 20 )
		
		self.btnPBan:SetPos( self:GetWide() - 52 * 1, 80 )
		self.btnPBan:SetSize( 48, 20 )
	
	end
	
	for k, v in ipairs( self.VoteButtons ) do
	
		v:InvalidateLayout()
		v:SetPos( self:GetWide() -  k * 25, 0 )
		v:SetSize( 20, 32 )
	
	end
	
end

function PANEL:Paint()
	return true
end


vgui.Register( "ScorePlayerInfoCard", PANEL, "Panel" )