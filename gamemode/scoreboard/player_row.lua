 
include( "player_infocard.lua" )

//surface.CreateFont( "coolvetica", 19, 500, true, false, "ScoreboardPlayerName" )
//surface.CreateFont( "coolvetica", 22, 500, true, false, "ScoreboardPlayerNameBig" )
surface.CreateFont("ScoreboardPlayerName", {font='coolvetica', size=19, weight=500});
surface.CreateFont("ScoreboardPlayerNameBig", {font='coolvetica', size=22, weight=500});

local texGradient = surface.GetTextureID( "gui/center_gradient" )

local PANEL = {}

/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:Init()

	self.Size = 36
	self:OpenInfo( false )
	
	self.infoCard	= vgui.Create( "ScorePlayerInfoCard", self )
	
	self.lblName 	= vgui.Create( "DLabel", self )
	self.lblFrags 	= vgui.Create( "DLabel", self )
	self.lblDeaths 	= vgui.Create( "DLabel", self )
	self.lblPing 	= vgui.Create( "DLabel", self )
	self.lblTeams 	= vgui.Create( "DLabel", self )
	
	self.Mute		= vgui.Create( "DImageButton", self )
	
	// If you don't do this it'll block your clicks
	self.lblName:SetMouseInputEnabled( false )
	self.lblFrags:SetMouseInputEnabled( false )
	self.lblDeaths:SetMouseInputEnabled( false )
	self.lblPing:SetMouseInputEnabled( false )
	self.lblTeams:SetMouseInputEnabled( false )
	
	self.imgAvatar = vgui.Create( "AvatarImage", self )
	
	self:SetCursor( "hand" )

end

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Paint()


	
	if ( !IsValid( self.Player ) ) then return end
	
	local color = team.GetColor(self.Player:Team())
	

	if ( self.Open || self.Size != self.TargetSize ) then
	
		draw.RoundedBox( 4, 0, 16, self:GetWide(), self:GetTall() - 16, color )
		draw.RoundedBox( 4, 2, 16, self:GetWide()-4, self:GetTall() - 16 - 2, Color( 250, 250, 245, 255 ) )
		
		surface.SetTexture( texGradient )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRect( 2, 16, self:GetWide()-4, self:GetTall() - 16 - 2 ) 
	
	end
	
	draw.RoundedBox( 4, 0, 0, self:GetWide(), 36, color )
	
	surface.SetTexture( texGradient )
	surface.SetDrawColor( 255, 255, 255, 50 )
	surface.DrawTexturedRect( 0, 0, self:GetWide(), 36 ) 	
	
	return true

end

/*---------------------------------------------------------
   Name: SetPlayer
---------------------------------------------------------*/
function PANEL:SetPlayer( ply )

	self.Player = ply
	
	self.infoCard:SetPlayer( ply )
	self.imgAvatar:SetPlayer( ply )
	
	self:UpdatePlayerData()

end

/*---------------------------------------------------------
   Name: UpdatePlayerData
---------------------------------------------------------*/
function PANEL:UpdatePlayerData()

	if ( !self.Player ) then return end
	if ( !self.Player:IsValid() ) then return end

	self.lblName:SetText( self.Player:Name() )
	self.lblFrags:SetText( self.Player:Frags() )
	self.lblDeaths:SetText( self.Player:Deaths() )
	self.lblPing:SetText( self.Player:Ping() )
	self.lblTeams:SetText( self.Player:GetGangName() )
	self.lblTeams:SizeToContents()
	
end



/*---------------------------------------------------------
   Name: ApplySchemeSettings
---------------------------------------------------------*/
function PANEL:ApplySchemeSettings()

	self.lblName:SetFont( "ScoreboardPlayerNameBig" )
	self.lblFrags:SetFont( "ScoreboardPlayerName" )
	self.lblDeaths:SetFont( "ScoreboardPlayerName" )
	self.lblPing:SetFont( "ScoreboardPlayerName" )
	self.lblTeams:SetFont( "ScoreboardPlayerName" )
	
	self.lblName:SetFGColor( color_white )
	self.lblFrags:SetFGColor( color_white )
	self.lblDeaths:SetFGColor( color_white )
	self.lblPing:SetFGColor( color_white )
	self.lblTeams:SetFGColor( color_white )

end

/*---------------------------------------------------------
   Name: DoClick
---------------------------------------------------------*/
function PANEL:DoClick( x, y )

	if ( self.Open ) then
		surface.PlaySound( "ui/buttonclickrelease.wav" )
	else
		surface.PlaySound( "ui/buttonclick.wav" )
	end

	self:OpenInfo( !self.Open )

end

/*---------------------------------------------------------
   Name: OpenInfo
---------------------------------------------------------*/
function PANEL:OpenInfo( bool )

	if ( bool ) then
		self.TargetSize = 150
	else
		self.TargetSize = 36
	end
	
	self.Open = bool

end

/*---------------------------------------------------------
   Name: Think
---------------------------------------------------------*/
function PANEL:Think()

	if ( self.Size != self.TargetSize ) then
	
		self.Size = math.Approach( self.Size, self.TargetSize, (math.abs( self.Size - self.TargetSize ) + 1) * 10 * FrameTime() )
		self:PerformLayout()
		SCOREBOARD:InvalidateLayout()
	//	self:GetParent():InvalidateLayout()
	
	end
	
	if ( !self.PlayerUpdate || self.PlayerUpdate < CurTime() ) then
	
		self.PlayerUpdate = CurTime() + 0.5
		self:UpdatePlayerData()
		
	end
	
	if ( self.Muted == nil || self.Muted != self.Player:IsMuted() ) then

		self.Muted = self.Player:IsMuted()
		if ( self.Muted ) then
			self.Mute:SetImage( "icon32/muted.png" )
		else
			self.Mute:SetImage( "icon32/unmuted.png" )
		end
			
		self.Mute.DoClick = function() self.Player:SetMuted( !self.Muted ) end

	end

end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()

	self.imgAvatar:SetPos( 2, 2 )
	self.imgAvatar:SetSize( 32, 32 )

	self:SetSize( self:GetWide(), self.Size )
	
	self.lblName:SizeToContents()
	self.lblName:SetPos( 24, 2 )
	self.lblName:MoveRightOf( self.imgAvatar, 8 )
	
	local COLUMN_SIZE = 50
	
	self.lblPing:SetPos( self:GetWide() - COLUMN_SIZE * 1, 0 )
	self.lblDeaths:SetPos( self:GetWide() - COLUMN_SIZE * 2, 0 )
	self.lblFrags:SetPos( self:GetWide() - COLUMN_SIZE * 3, 0 )
	self.lblTeams:SetPos( self:GetWide() - COLUMN_SIZE * 8, 0 )
	
	if ( self.Open || self.Size != self.TargetSize ) then
	
		self.infoCard:SetVisible( true )
		self.infoCard:SetPos( 4, self.imgAvatar:GetTall() + 10 )
		self.infoCard:SetSize( self:GetWide() - 8, self:GetTall() - self.lblName:GetTall() - 10 )
	
	else
	
		self.infoCard:SetVisible( false )
	
	end
	
	self.Mute:SetSize( 32, 32 )
	self.Mute:SetPos( self:GetWide()-32, 0 )

end

/*---------------------------------------------------------
   Name: HigherOrLower
---------------------------------------------------------*/
function PANEL:HigherOrLower( row )

	if ( !self.Player:IsValid() || self.Player:Team() == TEAM_CONNECTING ) then return false end
	if ( !row.Player:IsValid() || row.Player:Team() == TEAM_CONNECTING ) then return true end
	
	
	return self.Player:Team() < row.Player:Team()

end


vgui.Register( "ScorePlayerRow", PANEL, "Button" )