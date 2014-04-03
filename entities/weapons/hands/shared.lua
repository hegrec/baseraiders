if CLIENT then
	SWEP.PrintName = "Hands"
	SWEP.Author	= "Darkspider/Train"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
else
	AddCSLuaFile("shared.lua")
	resource.AddFile("models/weapons/w_fists.dx80.vtx");
	resource.AddFile("models/weapons/w_fists.dx90.vtx");
	resource.AddFile("models/weapons/w_fists.mdl");
	resource.AddFile("models/weapons/w_fists.phy");
	resource.AddFile("models/weapons/w_fists.sw.vtx");
	resource.AddFile("models/weapons/w_fists.vvd");
	resource.AddFile("models/weapons/v_fists.dx80.vtx");
	resource.AddFile("models/weapons/v_fists.dx90.vtx");
	resource.AddFile("models/weapons/v_fists.mdl");
	resource.AddFile("models/weapons/v_fists.sw.vtx");
	resource.AddFile("models/weapons/v_fists.vvd");
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

SWEP.ViewModel = Model( "models/weapons/v_fists.mdl" );
SWEP.WorldModel = Model( "models/weapons/w_fists.mdl" );

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	self.Weapon:SetNextSecondaryFire(CurTime() + 1)
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
end
function SWEP:SecondaryAttack() 
	self.Weapon:SetNextSecondaryFire(CurTime() + 1)
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
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
end
