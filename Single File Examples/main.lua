
-- Uncomment the import for the example you'd like to run --

-- import 'animator'
-- import 'arcs'
-- import 'audio'
-- import 'balls'
-- import 'blurdither'
-- import 'collisions'
-- import 'crank'
-- import 'drawmode'
-- import 'drawSampled'
-- import 'drawSampled2'
-- import 'fast_fade'
-- import 'file'
-- import 'gridview'
-- import 'icosohedron'
-- import 'imagesample'
-- import 'pachinko'
-- import 'perlin-distribution'
-- import 'perlin1'
-- import 'perlin2'
-- import 'perlin3'
-- import 'perlin4'
-- import 'perlinfield'
-- import 'sndtest'
-- import 'spritescaling'
-- import 'stencil'
-- import 'synth'
-- import 'tilemaptest'
-- import 'tonewheel'
-- import 'zorder'


if playdate.update == nil then
	playdate.update = function() end
	playdate.graphics.drawText("Please uncomment one of the import statements.", 15, 100)
end
