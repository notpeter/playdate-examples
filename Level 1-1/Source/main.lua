--[[
	
	
	
	
	This version of the demo uses the newer built-in collision functions.
	


Files:

level.lua
	- contains the main logic for the game including sprite movement and background tilemap drawing.
		
levelLoader.lua
	- helper class for level.lua that handles reading from the Tiled JSON file.
	
animations.lua
	- responsible for creating and drawing animations such as brick breaks and question box bumps

player.lua
	- responsible for moving the player sprite to it's desired location based on game-physics. Does not handle collisions except to notify Level about coin and enemy collisions when notified by the sprite system.
	
coin.lua
	- coin sprites
	
enemy.lua
	- example enemy sprite
	
input.lua
	- button input handler
	
level.json
	- json exported from Tiled.app
	
soundManager
	- responsible for loading and playing sound effects
	


Notes:
	- Layers in the Tiled file have a custom property to specify their tile map images so they can be imported automatically. This might actually be more complicated than convenient.
	- Graphics and sprites are all too small for the actual device.
	- There is no vertical scrolling, but it would be fairly easy to add.
	- Enemy behavior is very simple. There is only one enemy type. Enemies can't collide with each other, and they don't move vertically at all.
	- The maximum velocities used are calculated so that the player is never moving fast enough to move through an entire tile in one frame, and the code depends on this being true.


--]]



import 'CoreLibs/frameTimer'
import 'CoreLibs/easing'
import 'CoreLibs/sprites'
import 'level'
import 'player'
import 'soundManager'

playdate.display.setRefreshRate(20)

-- local references
local FrameTimer_update = playdate.frameTimer.updateTimers
local spritelib = playdate.graphics.sprite

-- create our level (only one here for demo purposes!)
local level = Level('level_1-1.json')


function playdate.update()

	spritelib.update()
	
	FrameTimer_update()

end
