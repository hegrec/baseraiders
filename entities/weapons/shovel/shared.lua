if CLIENT then
	SWEP.PrintName = "Shovel"
	SWEP.Author	= "Darkspider"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
else
	AddCSLuaFile("shared.lua")
	resource.AddFile("models/weapons/w_shovel.dx80.vtx");
	resource.AddFile("models/weapons/w_shovel.dx90.vtx");
	resource.AddFile("models/weapons/w_shovel.mdl");
	resource.AddFile("models/weapons/w_shovel.phy");
	resource.AddFile("models/weapons/w_shovel.sw.vtx");
	resource.AddFile("models/weapons/w_shovel.vvd");
	resource.AddFile("models/weapons/v_shovel.dx80.vtx");
	resource.AddFile("models/weapons/v_shovel.dx90.vtx");
	resource.AddFile("models/weapons/v_shovel.mdl");
	resource.AddFile("models/weapons/v_shovel.sw.vtx");
	resource.AddFile("models/weapons/v_shovel.vvd");
	resource.AddMaterial("materials/models/weapons/shovel/shovel1")
	resource.AddMaterial("materials/models/weapons/shovel/shovel1_n")
	resource.AddMaterial("materials/models/weapons/shovel/shovel2")
	resource.AddMaterial("materials/models/weapons/shovel/shovel2_n")
	resource.AddMaterial("materials/models/weapons/shovel/shovel3")
	resource.AddMaterial("materials/models/weapons/shovel/shovel3_n")
	resource.AddMaterial("materials/models/weapons/shovel/shovel3_old") 
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
SWEP.Instructions = "Used for harvesting from the ground";
SWEP.Purpose = "Harvesting raw materials";

SWEP.ViewModel = Model( "models/weapons/v_shovel.mdl" );
SWEP.WorldModel = Model( "models/weapons/w_shovel.mdl" );

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
	elseif(tr.HitWorld and tr.MatType == MAT_DIRT and tr.HitTexture != "**studio**")then
		self.Weapon:EmitSound("physics/flesh/flesh_impact_hard5.wav")
		hook.Call("OnShovel",GAMEMODE,self.Owner,tr)
	end
end
function SWEP:SecondaryAttack() 
end
