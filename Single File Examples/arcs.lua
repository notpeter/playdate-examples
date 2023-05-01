import 'CoreLibs/graphics'

gfx = playdate.graphics

gfx.clear()

startAngle = 0
ds = 0.2
endAngle = 0
de = 0.8
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
