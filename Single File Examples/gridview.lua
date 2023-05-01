

-- Demonstrates a grid-style list view with sections, and a simple list-style gridview

-- Navigate the grid views with the arrow buttons
-- Press A or B to switch control between the two grid views



import 'CoreLibs/ui/gridview.lua'
import 'CoreLibs/nineslice'

local gfx = playdate.graphics
gfx.clear()


local selectedGrid = 0


-- left grid view --

local gridFont = gfx.font.new('assets/blocky')
gridFont:setTracking(1)

local gridview = playdate.ui.gridview.new(44, 44)

gridview.backgroundImage = playdate.graphics.nineSlice.new('assets/shadowbox', 4, 4, 45, 45)
gridview:setNumberOfColumns(8)
gridview:setNumberOfRows(2, 4, 3, 5) -- number of sections is set automatically
gridview:setSectionHeaderHeight(28)
gridview:setContentInset(1, 4, 1, 4)
gridview:setCellPadding(4, 4, 4, 4)
gridview.changeRowOnColumnWrap = false



function gridview:drawCell(section, row, column, selected, x, y, width, height)

    if selected then
		gfx.setLineWidth(3)
        gfx.drawCircleInRect(x, y, width+1, height+1)
    else
		gfx.setLineWidth(0)
        gfx.drawCircleInRect(x+4, y+4, width-8, height-8)
    end
    local cellText = ""..row.."-"..column
    
    gfx.setFont(gridFont)
    gfx.drawTextInRect(cellText, x, y+18, width, 20, nil, nil, kTextAlignment.center)

end


function gridview:drawSectionHeader(section, x, y, width, height)

    gfx.drawText("*Section ".. section .. "*", x + 10, y + 8)

end



-- right list view --

local listFont = gfx.font.new('assets/Bitmore-Medieval')
listFont:setTracking(1)

local listviewHeight = 36
local lastDrawnListviewHeight = 0

local menuOptions = {"Sword", "Shield", "Arrow", "Sling", "Stone", "Longbow", "MorningStar", "Armour", "Dagger", "Rapier", "Skeggox", "War Hammer", "Battering Ram", "Catapult"}

local listview = playdate.ui.gridview.new(0, 10)
listview.backgroundImage = playdate.graphics.nineSlice.new("assets/scrollbg", 20, 22, 88, 28)
listview:setNumberOfRows(#menuOptions)
listview:setCellPadding(0, 0, 13, 10)
listview:setContentInset(24, 24, 13, 11)


function listview:drawCell(section, row, column, selected, x, y, width, height)
	
	if selected then
		gfx.setColor(gfx.kColorBlack)
		gfx.fillRoundRect(x, y, width, 20, 4)
		gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
	else
		gfx.setImageDrawMode(gfx.kDrawModeCopy)
	end
	gfx.setFont(listFont)
	gfx.drawTextInRect(menuOptions[row], x, y+6, width, height+2, nil, "...", kTextAlignment.center)
	
end



-- list view animation --

-- all that needs to be done is to animate the height at which the listview is drawn
-- because its background image is a nineslice, it redraws correctly at different sizes

local listviewTimer = nil


local function animateListviewOpen()
	
	listviewTimer = playdate.timer.new(300, listviewHeight, 200, playdate.easingFunctions.outCubic)
	
	listviewTimer.updateCallback = function(timer)
		listviewHeight = timer.value
	end
	
	listviewTimer.timerEndedCallback = function(timer)
		listviewHeight = timer.value
		listviewTimer = nil
	end
end


local function animateListviewClosed()

	listviewTimer = playdate.timer.new(300, listviewHeight, 36, playdate.easingFunctions.outCubic)
	
	listviewTimer.updateCallback = function(timer)
		listviewHeight = timer.value
	end
	
	listviewTimer.timerEndedCallback = function(timer)
		listviewHeight = timer.value
		listviewTimer = nil
	end
end


local function toggleSelection()
	
	if selectedGrid == 0 then
		selectedGrid = 1
		animateListviewOpen()
	else
		selectedGrid = 0
		animateListviewClosed()
	end
end



-- buttons --

function playdate.AButtonUp()
	toggleSelection()
end

function playdate.BButtonUp()
	toggleSelection()
end


function playdate.upButtonUp()

	if selectedGrid == 0 then
		gridview:selectPreviousRow(true)
	else
		listview:selectPreviousRow(false)
	end

end

function playdate.downButtonUp()

	if selectedGrid == 0 then
		gridview:selectNextRow(true)
	else
		listview:selectNextRow(false)
	end
	
end

function playdate.leftButtonUp()

	if selectedGrid == 0 then
		gridview:selectPreviousColumn(true)
	end

end

function playdate.rightButtonUp()

	if selectedGrid == 0 then
		gridview:selectNextColumn(true)
	end
end



-- main update function --

function playdate.update()
	
	playdate.timer.updateTimers()
	
	-- draw the left side grid view
	if gridview.needsDisplay == true then
		gridview:drawInRect(20, 20, 180, 200)
	end
	
	-- draw the right side list view (clear the area first to avoid animation smudges)
	if lastDrawnListviewHeight ~= listviewHeight or listview.needsDisplay == true then
		gfx.setColor(gfx.kColorWhite)
		gfx.fillRect(220, 20, 160, 200)
		listview:drawInRect(220, 20, 160, listviewHeight)
		lastDrawnListviewHeight = listviewHeight
	end
	
	-- draw the selection dot
	if selectedGrid == 0 then
		gfx.setColor(gfx.kColorWhite)
		gfx.fillCircleAtPoint(300, 10, 4)
		gfx.setColor(gfx.kColorBlack)
		gfx.fillCircleAtPoint(110, 10, 4)
	else
		gfx.setColor(gfx.kColorWhite)
		gfx.fillCircleAtPoint(110, 10, 4)
		gfx.setColor(gfx.kColorBlack)
		gfx.fillCircleAtPoint(300, 10, 4)
	end

end
