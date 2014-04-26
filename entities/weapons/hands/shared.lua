if CLIENT then
	SWEP.PrintName = "Hands"
	SWEP.Author	= "Darkspider/Train"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
else
	AddCSLuaFile("shared.lua")
end
function SWEP:Initialize()
	if( SERVER ) then
		self:SetWeaponHoldType( "normal" )
	end
end
SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = -1;
SWEP.Primary.Automatic = false;
SWEP.Primary.Ammo = "none";
SWEP.HoldType = "normal"
SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = -1;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.Ammo = "none"; 
SWEP.Instructions = "Left click: Punch. Right Click: Knock.";
SWEP.Purpose = "Punch and knock";

SWEP.ViewModel = Model( "models/weapons/c_arms_citizen.mdl" );
SWEP.WorldModel = ""
SWEP.ViewModelFOV		= 52
SWEP.UseHands	= true
SWEP.RightPunch = true
function SWEP:SetupDataTables()

	self:NetworkVar( "Float", 1, "NextIdle" )
	
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.6)
	self.Weapon:SetNextSecondaryFire(CurTime() + 0.6)
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	self.Weapon:EmitSound("npc/vort/claw_swing2.wav")
	self.Owner:RestartGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST)
	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = tr.start + (self.Owner:GetAimVector()*70)
	tr.filter = self.Owner
	tr = util.TraceLine(tr)
	if IsValid(tr.Entity) and tr.HitNonWorld then
		if(tr.MatType  == MAT_GLASS)then
			self.Weapon:EmitSound("physics/glass/glass_cup_break1.wav")
			if SERVER then tr.Entity:Fire("shatter") end
		elseif(tr.MatType == MAT_FLESH)then
			self.Weapon:EmitSound("physics/flesh/flesh_impact_bullet5.wav")
				local effect = EffectData()
				effect:SetOrigin(tr.HitPos)
				util.Effect("BloodImpact", effect) 
				if SERVER then tr.Entity:TakeDamage(1,self.Owner,self.Weapon) end
		else
			self.Weapon:EmitSound("physics/flesh/flesh_impact_bullet5.wav")
		end
	elseif(tr.HitWorld)then
		self.Weapon:EmitSound("physics/flesh/flesh_impact_hard5.wav")
	end
	self.RightPunch = !self.RightPunch
	local anim = "fists_left"
	if (self.RightPunch) then
		anim = "fists_right"
	end
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )
	self:UpdateNextIdle()
	
end
function SWEP:SecondaryAttack() 
	self.Weapon:SetNextSecondaryFire(CurTime() + 0.6)
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.6)
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	self.Weapon:EmitSound("npc/vort/claw_swing2.wav")
	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = tr.start + (self.Owner:GetAimVector()*70)
	tr.filter = self.Owner
	tr = util.TraceLine(tr)
	if tr.Entity:IsValid() and tr.Entity:IsDoor() then
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		self.Weapon:EmitSound("physics/plastic/plastic_box_impact_hard4.wav",100,70)
	end
	
	local anim = "fists_right"
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )
	self:UpdateNextIdle()
end

function SWEP:UpdateNextIdle()

	local vm = self.Owner:GetViewModel()
	self:SetNextIdle( CurTime() + vm:SequenceDuration() )
	
end

function SWEP:Deploy()

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_draw" ) )
	
	self:UpdateNextIdle()
	
	return true

end

function SWEP:Think()
	
	local vm = self.Owner:GetViewModel()
	local curtime = CurTime()
	local idletime = self:GetNextIdle()
	
	if ( idletime > 0 && CurTime() > idletime ) then

		vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_idle_0" .. math.random( 1, 2 ) ) )
		
		self:UpdateNextIdle()

	end
	
end
