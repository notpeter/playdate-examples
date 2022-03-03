--
-- Demonstrating of a way to fade between images using a pattern for good on-device performace
--

import 'CoreLibs/graphics.lua'

local gfx = playdate.graphics
playdate.display.setRefreshRate(50)

fnt =  gfx.getSystemFont()
gfx.setFont(fnt)

-- Create a White Image with an alpha mask
local frontImg = gfx.image.new(400, 240, gfx.kColorWhite)
frontImg:addMask(0)
gfx.lockFocus(frontImg)
gfx.drawTextAligned("*ONE*", 200, 100, kTextAlignment.center)
gfx.unlockFocus()

-- Fill the alpha mask with white which makes it fully opaque
local mask = frontImg:getMaskImage()
gfx.lockFocus(mask)
gfx.setColor(gfx.kColorWhite)
gfx.fillRect(0, 0, 400, 240)
gfx.unlockFocus()

-- Create a black background image
local backImg = gfx.image.new(400, 240, gfx.kColorBlack)
gfx.lockFocus(backImg)
gfx.setImageDrawMode(gfx.kDrawModeInverted)
gfx.drawTextAligned("*TWO*", 200, 130, kTextAlignment.center)
gfx.unlockFocus()

local lastTimeMilliseconds = 0
local ct = 0
local dt = 0

local FADE_TIME = 3000
local fade_timer = FADE_TIME
local pat
local alpha

-- Creates an 8x8 white image that's faded with the given alpha
local patternImg = gfx.image.new(8, 8)
local function patternWithOpacity(alpha)
    gfx.lockFocus(patternImg)
    gfx.setColor(gfx.kColorWhite)
    gfx.fillRect(0, 0, 8, 8)
    gfx.unlockFocus()
    return patternImg:fadedImage(alpha, gfx.image.kDitherTypeBayer8x8)
end

function playdate.update()

    ct = playdate.getCurrentTimeMilliseconds()
    if lastTimeMilliseconds > 0 then
        dt = ct - lastTimeMilliseconds
    end
    lastTimeMilliseconds = ct

    fade_timer = fade_timer - dt
    if fade_timer < 0 then fade_timer = 0 end

    backImg:draw(0, 0)

    if fade_timer > 0 then
        alpha = fade_timer / FADE_TIME

        -- draw the faded 8x8 image into the alpha mask. As more black pixels appear in the
        -- pattern the foreground image will appear to fade out

        gfx.lockFocus(mask)
        gfx.setColor(gfx.kColorBlack)
        gfx.fillRect(0, 0, 400, 240)
        pat = patternWithOpacity(alpha)
        pat:drawTiled(0, 0, 400, 240)
        gfx.unlockFocus()

        frontImg:draw(0, 0)

    else
        fade_timer = FADE_TIME
    end

    playdate.drawFPS(380, 0)
end
