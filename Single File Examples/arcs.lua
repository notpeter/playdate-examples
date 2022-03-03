import 'CoreLibs/graphics'

gfx = playdate.graphics

gfx.clear()

startAngle = 0
ds = 0.4
endAngle = 0
de = 2
radius = 120
nrings = 12

gfx.setStrokeLocation(gfx.kStrokeOutside)

function playdate.update()
	
	gfx.clear()
	
	gfx.setColor(gfx.kColorWhite);
	gfx.drawRect(200 - radius, 120 - radius, radius * 2 + 1, radius * 2 + 1)

	startAngle = startAngle + ds
	endAngle = endAngle + de

	gfx.setColor(gfx.kColorBlack);
	
	for i=1,nrings-1
	do
		local innerRadius = i * radius/nrings
		local outerRadius = (i+1) * radius/nrings
		gfx.setLineWidth(outerRadius - innerRadius)
		gfx.drawArc(200, 120, innerRadius, (nrings - i) * startAngle, (nrings - i) * endAngle)
	end
	
end


function drawarc()
	gfx.setColor(gfx.kColorWhite);
	gfx.drawRect(0, 0, 400, 240)
	
	gfx.setColor(gfx.kColorXOR)
	gfx.setLineWidth(outerRadius - innerRadius)
	gfx.drawArc(200, 120, innerRadius, startAngle, endAngle)
	playdate.display.flush()
end


function playdate.upButtonDown()
	startAngle = startAngle + 10
	drawarc()
end

function playdate.downButtonDown()
	startAngle = startAngle - 10
	drawarc()
end

function playdate.leftButtonDown()
	endAngle = endAngle - 10
	drawarc()
end

function playdate.rightButtonDown()
	endAngle = endAngle + 10
	drawarc()
end

function playdate.AButtonDown()
	innerRadius = math.random(120)
	outerRadius = math.random(120)
	drawarc()
end

function playdate.BButtonDown()
	innerRadius = 50
	outerRadius = 100
	drawarc()
end
