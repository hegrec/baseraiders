local leaderboard = {}
function receiveLeaderboard( um )
	leaderboard = {}
	local amt = um:ReadChar()
	for i=1,amt do
		table.insert(leaderboard,{um:ReadString(),um:ReadLong()})
	end
end
usermessage.Hook("sendLeaderboard",receiveLeaderboard)


local PANEL = {}

/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:Init()

	self.Size = 36
	self:OpenInfo( true )
	
	--[[self.infoCard	= vgui.Create( "ScorePlayerInfoCard", self )
	
	self.lblName 	= vgui.Create( "DLabel", self )
	self.lblFrags 	= vgui.Create( "DLabel", self )
	self.lblDeaths 	= vgui.Create( "DLabel", self )
	self.lblPing 	= vgui.Create( "DLabel", self )
	self.lblTeams 	= vgui.Create( "DLabel", self )
	
	// If you don't do this it'll block your clicks
	self.lblName:SetMouseInputEnabled( false )
	self.lblFrags:SetMouseInputEnabled( false )
	self.lblDeaths:SetMouseInputEnabled( false )
	self.lblPing:SetMouseInputEnabled( false )
	self.lblTeams:SetMouseInputEnabled( false )
	
	self.imgAvatar = vgui.Create( "AvatarImage", self )
	
	self:SetCursor( "hand" )]]

end

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Paint()

	local color = Color(255,255,0,255)
	

	if ( self.Open || self.Size != self.TargetSize ) then
	
		draw.RoundedBox( 4, 0, 16, self:GetWide(), self:GetTall() - 16, color )
		draw.RoundedBox( 4, 2, 16, self:GetWide()-4, self:GetTall() - 16 - 2, Color( 250, 250, 245, 255 ) )
		
		
	
	end
	
	
	
	draw.RoundedBox( 4, 0, 0, self:GetWide(), 36, color )
	draw.SimpleText( "Top Gangs","ScoreboardPlayerName", self:GetWide()/2, 18,Color(0,0,0,255),1,1 )
	
	for i,v in pairs(leaderboard) do
		local lvl = CalculateLevel(v[2])
		local frac = CalculateExperienceThisLevel(v[2])/level_experience[lvl+1]
		draw.RoundedBox( 4, 3, 12+i*25, self:GetWide()-6, 24, Color(50,50,50,255) )
		draw.SimpleText( i,"ScoreboardPlayerName", 5, 33+i*25,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		draw.SimpleText( v[1],"ScoreboardPlayerName", 35, 33+i*25,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		draw.SimpleText( "Lvl "..lvl,"ScoreboardPlayerName", 205, 33+i*25,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		draw.RoundedBox(4, 280, 12+i*25, 300, 24, Color(0,0,0,255) )
		draw.RoundedBox(0, 282, 14+i*25,frac*(296),20,Color(0,255,0,255))
	end
	return true

end

/*---------------------------------------------------------
   Name: UpdatePlayerData
---------------------------------------------------------*/
function PANEL:SetPlayer( ply )


end

function PANEL:CheckRating( name, count )


end

/*---------------------------------------------------------
   Name: UpdatePlayerData
---------------------------------------------------------*/
function PANEL:UpdatePlayerData()

end



/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:ApplySchemeSettings()

end

/*---------------------------------------------------------
   Name: PerformLayout
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
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:OpenInfo( bool )

	if ( bool ) then
		self.TargetSize = 170
		RunConsoleCommand("load_leaderboard")
	else
		self.TargetSize = 36
	end
	
	self.Open = bool

end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:Think()

	if ( self.Size != self.TargetSize ) then
	
		self.Size = math.Approach( self.Size, self.TargetSize, (math.abs( self.Size - self.TargetSize ) + 1) * 10 * FrameTime() )
		self:PerformLayout()
		SCOREBOARD:InvalidateLayout()
	//	self:GetParent():InvalidateLayout()
	
	end
end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()


	self:SetSize( self:GetWide(), self.Size )
	

	

end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:HigherOrLower( row )
	return false

end


vgui.Register( "ScoreLeaderboard", PANEL, "Button" )