if CLIENT then
	SWEP.PrintName = "Hatchet"
	SWEP.Author	= "Darkspider"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
else
	AddCSLuaFile("shared.lua")
	resource.AddModel("models/weapons/v_stone_hatchet")
	resource.AddModel("models/weapons/w_stone_hatchet")
	resource.AddMaterial("materials/models/weapons/hatchet/stone/axe")
	resource.AddMaterial("materials/models/weapons/hatchet/stone/stone")
	resource.AddMaterial("materials/models/weapons/hatchet/stone/stone_n")
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
SWEP.Instructions = "Harvest wood from trees around the map";
SWEP.Purpose = "Harvests wood";

SWEP.ViewModel = Model( "models/weapons/v_stone_hatchet.mdl" );
SWEP.WorldModel = Model( "models/weapons/w_stone_hatchet.mdl" );

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	self.Weapon:SetNextSecondaryFire(CurTime() + 1)
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	self.Weapon:EmitSound("npc/vort/claw_swing2.wav")
	self.Owner:RestartGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST)
	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = tr.start + (self.Owner:GetAimVector()*100)
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
	elseif(tr.HitWorld and tr.MatType == MAT_WOOD and tr.HitTexture == "**studio**")then
		self.Weapon:EmitSound("physics/flesh/flesh_impact_hard5.wav")
		hook.Call("OnHatchet",GAMEMODE,self.Owner,tr)
	end
end
function SWEP:SecondaryAttack() 

end
