



------------- PATHFINDING DEMO -------------

-- Finds a path from the top-left corner of the grid to the bottom-right corner

-- A toggles between only allowing horizontal and vertical moves and also allowing diagonal moves

-- B creates or destroys a "wall" in the grid

--------------------------------------------


print("Press B to create or remove a barrier")
print("Press A to toggle diagonal moves")




import "CoreLibs/graphics"


local gfx = playdate.graphics
local abs = math.abs
local function generate2DGraph() end


local cursor = playdate.geometry.point.new(2, 2)

local w = 20
local h = 12

local useDiagonals = false

local grid = {1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
			  1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
			  1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
			  1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1,
			  1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1,
			  1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1,
			  1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1,
			  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1,
			  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1,
			  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1,
			  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1,
			  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1}
			  
local path, graph, startNode, endNode


local heuristicFunction = nil
-- an optional heuristic function can be passed to the findPath() function. 
-- If nil is passed instead a manhattan distance function will be used, which works for us in this case
-- for a different calculation is needed, you can provide a heuristic function of the following form:

--[[
local heuristicFunction = function(startNode, goalNode)

	return abs(startNode.x - goalNode.x) + abs(startNode.y - goalNode.y)
end
--]]



-- drawing

local function drawGrid()

	gfx.setColor(gfx.kColorBlack)
	gfx.setLineWidth(1)

	for x = 1, w do
		gfx.drawLine(x*20, 0, x*20, h*20)
	end
	
	for y = 1, h do
		gfx.drawLine(0, y*20, w*20, y*20)
	end

	for x = 0, w-1 do
		for y = 0, h-1 do
			if grid[((y)*w)+x+1] == 0 then
				gfx.fillRect(x*20, y*20, 20, 20)
			end
		end
	end

end


local function drawPath(nodes)
	
	gfx.setColor(gfx.kColorBlack)
	
	for i = 1, #nodes do
		local n = nodes[i]
		gfx.fillRoundRect((n.x-1)*20+6, (n.y-1)*20+6, 9, 9, 2)
	end
	
end



local function drawCursor()

	gfx.setColor(gfx.kColorBlack)
	gfx.setLineWidth(3)

	gfx.drawRect((cursor.x-1)*20, (cursor.y-1)*20, 21, 21)
end



local function drawNoPathError()
	
	local errorString = "*No Path Found*"
	local tw, th = gfx.getTextSize(errorString)
	local bw = tw + 30
	local bh = th + 30
	local dw, dh = playdate.display.getSize()

	gfx.setLineWidth(1)
	
	gfx.setColor(gfx.kColorBlack)
	gfx.fillRect((dw-bw)/2 + 3, (dh-bh)/2 + 3, bw, bh)
	
	gfx.setColor(gfx.kColorWhite)
	gfx.drawRect((dw-bw)/2 + 3, (dh-bh)/2 + 3, bw, bh)
	
	gfx.setColor(gfx.kColorWhite)
	gfx.fillRect((dw-bw)/2, (dh-bh)/2, bw, bh)
	
	gfx.setLineWidth(2)
	gfx.setColor(gfx.kColorBlack)
	gfx.drawRect((dw-bw)/2, (dh-bh)/2, bw, bh)
	
	gfx.drawText(errorString, (dw-bw)/2 + 15, (dh-bh)/2 + 15)
end



local function drawStartAndEndSquares()

	gfx.setColor(gfx.kColorBlack)
	gfx.fillRoundRect(2, 2, 16, 16, 2)
	gfx.fillRoundRect(w*20-17, h*20-17, 15, 15, 2)

	gfx.setImageDrawMode(gfx.kDrawModeInverted)
	gfx.drawText("s", 6, 0)
	gfx.drawText("e", w*20-13, h*20-20)
	gfx.setImageDrawMode(gfx.kDrawModeCopy)
end



-- graph manipulation

local function nodeIsActive(x, y)

	local index = (y * w) + x - w
	if grid[index] == 1 then
		return true
	end

	return false
end


local function flipGridAt(x, y)

	local index = ((y-1) * w + x-1) + 1
	
	if grid[index] == 1 then
		grid[index] = 0
	else
		grid[index] = 1
	end
end



-- connect node to the node at position x, y, if it exists and is active in the grid
local function connectNode(graph, node, x, y, weight)

	if x < 1 or x > w or y < y or y > h or nodeIsActive(x, y) == false then
		return
	end
	
	node:addConnectionToNodeWithXY(x, y, weight, true)
end



-- activate or deactive a square in the grid
local function flipSelectedSquare()
	
	local node = graph:nodeWithXY(cursor.x, cursor.y)
	

	-- flip the square at the current path position, and recalculate the path

	if nodeIsActive(cursor.x, cursor.y) then		
		node:removeAllConnections()
	else
		-- add connections to neighbour nodes
		-- weights of 10 for horizontal and 14 for diagonal nodes tends to produce nicer paths than all equal weights
		connectNode(graph, node, cursor.x-1, cursor.y, 10)
		connectNode(graph, node, cursor.x+1, cursor.y, 10)
		connectNode(graph, node, cursor.x, cursor.y-1, 10)
		connectNode(graph, node, cursor.x, cursor.y+1, 10)
		
		if useDiagonals then
			connectNode(graph, node, cursor.x-1, cursor.y-1, 14)
			connectNode(graph, node, cursor.x+1, cursor.y+1, 14)
			connectNode(graph, node, cursor.x+1, cursor.y-1, 14)
			connectNode(graph, node, cursor.x-1, cursor.y+1, 14)
		end

	end
	
	flipGridAt(cursor.x, cursor.y)

	path = graph:findPath(startNode, endNode, heuristicFunction)

end



-- this method is not necesary for this demo, but demonstrates how a different type of graph could be created
-- here, it's creating the same type of graph returned by playdate.pathfinder.graph.new2DGrid(), and takes the same parameters
-- performance will be a LOT slower than using the built-in function


generate2DGraph = function(w, h, useDiagonals, grid)

	local g = playdate.pathfinder.graph.new()
	
	local nodes = g:addNewNodes(w*h)

	for r = 1, h do
		for c = 1, w do

			local index = (r * w) + c - w
			local newNode = nodes[index]
			newNode:setXY(c, r)
			
			if nodeIsActive(c, r) then
				
				connectNode(g, newNode, c-1, r, 10)	-- left
				connectNode(g, newNode, c, r-1, 10) 	-- top
			
				if useDiagonals then
					connectNode(g, newNode, c-1, r-1, 14) -- top left
					connectNode(g, newNode, c+1, r-1, 14) -- top right
				end
			end
		end
	end
	
	return g
end




-- input

-- move cursor left
function playdate.leftButtonDown()
	
	if cursor.x == 1 then return end
	if cursor.x - 1 == 1 and cursor.y == 1 then return end

	cursor.x = cursor.x - 1
end

-- move cursor right
function playdate.rightButtonDown()

	if cursor.x == w then return end
	if cursor.x + 1 == w and cursor.y == h then return end
	cursor.x = cursor.x + 1
end


-- move cursor down
function playdate.upButtonDown()
	if cursor.y == 1 then return end
	if cursor.y - 1 == 1 and cursor.x == 1 then return end
	cursor.y = cursor.y - 1
end


--  move cursor up
function playdate.downButtonDown()
	if cursor.y == h then return end
	if cursor.x == w and cursor.y + 1 == h then return end
	cursor.y = cursor.y + 1
end


-- flips the grid to using diagonals. Recreates the entire grid from scratch.
function playdate.AButtonDown()

	useDiagonals = not useDiagonals
	graph = playdate.pathfinder.graph.new2DGrid(w, h, useDiagonals, grid)
	startNode = graph:nodeWithXY(1, 1)
	endNode = graph:nodeWithXY(w, h)
	path = graph:findPath(startNode, endNode, heuristicFunction)

end

-- connects or dissconnects a node in the grid
function playdate.BButtonDown()
	flipSelectedSquare()
end




-- initialize the graph

local now = playdate.getCurrentTimeMilliseconds()

graph = playdate.pathfinder.graph.new2DGrid(w, h, useDiagonals, grid)

-- much slower lua function to create the same graph as the built-in function, provided as an example
-- graph = generate2DGraph(w, h, useDiagonals, grid)



-- find the path

startNode = graph:nodeWithXY(1, 1)
endNode = graph:nodeWithXY(w, h)
path = graph:findPath(startNode, endNode, heuristicFunction)


function playdate.update()

	gfx.clear()

	drawGrid()
	
	if path ~= nil then
		drawPath(path)
	else
		drawNoPathError()
	end
	
	drawStartAndEndSquares()
	drawCursor()

end



