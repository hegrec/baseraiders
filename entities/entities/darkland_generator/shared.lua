ENT.Type = "anim"
ENT.Base = "base_anim" 

function ENT:GetWattsLeft()
	return self:GetNWInt("WattsAvailable")
end
function ENT:GetGallons()
	self:GetDTInt(4)
end
sound.Add( {
	name = "generator_idle",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = {95, 110},
	sound = "ambient/machines/engine1.wav"
} )