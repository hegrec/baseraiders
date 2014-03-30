if CLIENT then
	SWEP.PrintName = "Lockpick"
	SWEP.Author	= "Darkspider"
	SWEP.Slot = 3
	SWEP.SlotPos = 1
end



SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = -1;
SWEP.Primary.Automatic = false;
SWEP.Primary.Ammo = "none";
SWEP.HoldType = "melee"
SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = -1;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.Ammo = "none"; 
SWEP.Instructions = "Use on a door. WARNING: You have 3% chance times Security level to unlock. If failed, you will lose the lockpick!";
SWEP.Purpose = "Attempts to unlock doors";

SWEP.ViewModel = Model( "models/weapons/v_crowbar.mdl" );
SWEP.WorldModel = Model( "models/weapons/w_crowbar.mdl" );


function SWEP:PrimaryAttack()
end
function SWEP:SecondaryAttack() 
end
