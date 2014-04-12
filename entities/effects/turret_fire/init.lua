

local BloodSprite = Material( "sprites/orangecore1" )

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )

		self.startPos = data:GetStart()
		self.endPos = data:GetOrigin()
		self.direction = (self.endPos-self.startPos):GetNormal()
		self.currentPos = self.startPos
		self.NextThink = CurTime()
	
end


/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )

	// Returning false kills the effect
	self.currentPos = self.currentPos+self.direction*FrameTime()*1000
	
	return self.currentPos:Distance(self.endPos)>10
	
end


/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()

	render.SetMaterial( BloodSprite )

	render.DrawSprite( self.currentPos, 20,20, Color(255,255,255,255))

	
	
end



