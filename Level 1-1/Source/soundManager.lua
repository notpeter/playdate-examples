
local snd = playdate.sound

SoundManager = {}

SoundManager.kSoundBreakBlock = 'breakblock'
SoundManager.kSoundBump= 'bump'
SoundManager.kSoundCoin = 'coin'
SoundManager.kSoundJump = 'jump'
SoundManager.kSoundStomp = 'stomp'

local sounds = {}

for _, v in pairs(SoundManager) do
	sounds[v] = snd.sampleplayer.new('sfx/' .. v)
end

SoundManager.sounds = sounds

function SoundManager:playSound(name)
	self.sounds[name]:play(1)		
end


function SoundManager:stopSound(name)
	self.sounds[name]:stop()
end


function SoundManager:playBackgroundMusic()
	local filePlayer = snd.fileplayer.new('sfx/main_theme')
	filePlayer:play(0) -- repeat forever
end