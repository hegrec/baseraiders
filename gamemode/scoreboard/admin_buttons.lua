 
local PANEL = {}

/*---------------------------------------------------------
   Name: 
---------------------------------------------------------*/
function PANEL:Init()

	self:SetCursor( "hand" )

end

/*---------------------------------------------------------
   Name: 
---------------------------------------------------------*/
function PANEL:DoClick( x, y )

	if ( !self:GetParent().Player || LocalPlayer() == self:GetParent().Player ) then return end

	self:DoCommand( self:GetParent().Player )
	timer.Simple( 0.1, SCOREBOARD.UpdateScoreboard, SCOREBOARD )

end

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Paint()
	
	local bgColor = Color( 0,0,0,10 )

	if ( self.Selected ) then
		bgColor = Color( 0, 200, 255, 255 )
	elseif ( self.Armed ) then
		bgColor = Color( 255, 255, 0, 255 )
	end
	
	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), bgColor )
	
	draw.SimpleText( self.Text, "DefaultSmall", self:GetWide() / 2, self:GetTall() / 2, Color(0,0,0,150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	return true

end


vgui.Register( "SpawnMenuAdminButton", PANEL, "Button" )



/*   PlayerKickButton */

PANEL = {}
PANEL.Text = "Kick"

/*---------------------------------------------------------
   Name: DoCommand
---------------------------------------------------------*/
function PANEL:DoCommand( ply )

	RunConsoleCommand( "kickid2", ply:UserID() )
	
end

vgui.Register( "PlayerKickButton", PANEL, "SpawnMenuAdminButton" )



/*   PlayerPermBanButton */

PANEL = {}
PANEL.Text = "PermBan"

/*---------------------------------------------------------
   Name: DoCommand
---------------------------------------------------------*/
function PANEL:DoCommand( ply )

	RunConsoleCommand( "banid2", "0", ply:UserID() )
	RunConsoleCommand( "kickid2", ply:UserID(), "Permabanned" )
	
end

vgui.Register( "PlayerPermBanButton", PANEL, "SpawnMenuAdminButton" )



/*   PlayerPermBanButton */

PANEL = {}
PANEL.Text = "1hr Ban"

/*---------------------------------------------------------
   Name: DoCommand
---------------------------------------------------------*/
function PANEL:DoCommand( ply )

	RunConsoleCommand( "banid2", "60", ply:UserID() )
	RunConsoleCommand( "kickid2", ply:UserID(), "Banned for 1 hour" )
	
end

vgui.Register( "PlayerBanButton", PANEL, "SpawnMenuAdminButton" )


