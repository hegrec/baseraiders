 AddCSLuaFile( "cl_init.lua" ) 
 AddCSLuaFile( "shared.lua" ) 
   
 include('shared.lua') 
   
 local schdChase = ai_schedule.New( "AIFighter Chase" ) 
   
 	 
 	//schdChase:AddTask( "PlaySequence", 				{ Name = "deathpose_front", Speed = 10 } ) 
 	 
 	// Run away randomly 
 	schdChase:EngTask( "TASK_GET_PATH_TO_RANDOM_NODE", 	128 ) 
 	schdChase:EngTask( "TASK_RUN_PATH", 				0 ) 
 	schdChase:EngTask( "TASK_WAIT_FOR_MOVEMENT", 	0 ) 
 	schdChase:AddTask( "PlaySequence", 				{ Name = "cheer1", Speed = 0.5 } ) 
 	 
 	// Find an enemy and run to it 
 	schdChase:AddTask( "FindEnemy", 		{ Class = "prop_physics", Radius = 512 } ) 
 	schdChase:EngTask( "TASK_GET_PATH_TO_RANGE_ENEMY_LKP_LOS", 	0 ) 
 	schdChase:EngTask( "TASK_RUN_PATH", 				0 ) 
 	schdChase:EngTask( "TASK_WAIT_FOR_MOVEMENT", 	0 ) 
 	 
 	// Shoot it 
 	schdChase:EngTask( "TASK_STOP_MOVING", 			0 ) 
 	schdChase:EngTask( "TASK_FACE_ENEMY", 			0 ) 
 	//schdChase:EngTask( "TASK_SET_ACTIVITY", 		ACT_IDLE_ANGRY ) 
 	schdChase:EngTask( "TASK_ANNOUNCE_ATTACK", 			0 ) 
 	schdChase:EngTask( "TASK_RANGE_ATTACK1", 		0 ) 
 	schdChase:EngTask( "TASK_RELOAD", 		0 ) 
 	 
   
 function ENT:Initialize() 

 	 
 	self:SetHullType( HULL_HUMAN ); 
 	self:SetHullSizeNormal(); 
	timer.Simple(5,function()self:SetPos(self:GetPos()+Vector(0,0,1)) end)
 	 
 	self:SetSolid( SOLID_BBOX ) 
 	self:SetMoveType( MOVETYPE_NONE ) 
 	 
 	self:CapabilitiesAdd( CAP_ANIMATEDFACE) 

 end 
function ENT:UpdateTransmitState()
	return TRANSMIT_PVS 
end
 /*--------------------------------------------------------- 
    Name: SelectSchedule 
 ---------------------------------------------------------*/ 
 function ENT:SelectSchedule() 
   
 	//self:SetSchedule( SCHED_STAND_IDLE ) 
   
 	//self:StartSchedule( schdChase ) 
   
 end
 
function ENT:CanChat()

	return IsValid(self.ChatHover)

end

function ENT:EnableChat()
	if IsValid(self.ChatHover) then return end
	self.ChatHover = ents.Create("sent_chat")
	
	self.ChatHover:SetNWEntity("target",self)
	self.ChatHover:SetPos(self:GetPos()+Vector(0,0,100))
	self.ChatHover:Spawn()
	self.ChatHover:Activate()
	
end