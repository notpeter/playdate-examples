-- Ported from http://flafla2.github.io/2014/08/09/perlinnoise.html to Lua by stevenf


-- NOTE: there is also a built-in perlin function (see Inside Playdate and other perlin examples in this folder)


perlin_inited = false

perlin_permutation = { 
	-- Hash lookup table as defined by Ken Perlin.  This is a randomly
	-- arranged array of all numbers from 0-255 perlin_inclusive.

	151, 160, 137, 91, 90, 15,  
	131, 13, 201, 95, 96, 53, 194, 233, 7, 225, 140, 36, 103, 30, 69, 142, 8, 99, 37, 240, 21, 10, 23,
	190, 6, 148, 247, 120, 234, 75,0, 26, 197, 62, 94, 252, 219, 203, 117, 35, 11, 32, 57, 177, 33,
	88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68, 175, 74, 165, 71, 134, 139, 48, 27, 166,
	77, 146, 158, 231, 83, 111, 229, 122, 60, 211, 133, 230, 220, 105, 92, 41, 55, 46, 245, 40, 244,
	102, 143, 54, 65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208, 89, 18, 169, 200, 196,
	135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64, 52, 217, 226, 250, 124, 123,
	5, 202, 38, 147, 118, 126, 255, 82, 85, 212, 207, 206, 59, 227, 47, 16, 58, 17, 182, 189, 28, 42,
	223, 183, 170, 213, 119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167, 43, 172, 9,
	129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185, 112, 104, 218, 246, 97, 228,
	251, 34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241, 81, 51, 145, 235, 249, 14, 239, 107,
	49, 192, 214, 31, 181, 199, 106, 157, 184, 84, 204, 176, 115, 121, 50, 45, 127, 4, 150, 254,
	138, 236, 205, 93, 222, 114, 67, 29, 24, 72, 243, 141, 128, 195, 78, 66, 215, 61, 156, 180
}

function perlin_fade(t) 
	-- perlin_fade function as defined by Ken Perlin.  This eases coordinate values
	-- so that they will ease towards integral values.  This ends up smoothing
	-- the final output.
	
	return t * t * t * (t * (t * 6 - 15) + 10) -- 6t^5 - 15t^4 + 10t^3
end

function perlin_inc(num, repeat_at) 
	num = num + 1
	
	if repeat_at > 0 then
		num = num % repeat_at
	end
	
	return num
end

function perlin_lerp(minVal, maxVal, f)
	-- Linear interpolate.  perlin_lerp(0, 255, 0.5) == 127.5
	return minVal + f * (maxVal - minVal)
end

function perlin_grad(the_hash, x, y, z)
	local h = bit32.band(the_hash, 0xf)
	
	if h == 0x0 then
		return x + y
		
	elseif h == 0x1 then
		return -x + y
		
	elseif h == 0x2 then
		return x - y
		
	elseif h == 0x3 then
		return -x - y
		
	elseif h == 0x4 then
		return x + z
		
	elseif h == 0x5 then
		return -x + z
		
	elseif h == 0x6 then
		return x - z
		
	elseif h == 0x7 then
		return -x - z
		
	elseif h == 0x8 then
		return y + z
		
	elseif h == 0x9 then
		return -y + z
		
	elseif h == 0xa then
		return y - z
		
	elseif h == 0xb then
		return -y - z
		
	elseif h == 0xc then
		return  y + x	
		
	elseif h == 0xd then
		return -y + z
		
	elseif h == 0xe then
		return  y - x
		
	elseif h == 0xf then
		return -y - z
	else
		return 0 -- never happens
	end
end

function perlin(x, y, z, repeat_at)
	if perlin_inited == false then
		perlin_p = {} -- 512 values, indexed 0-511

		for x = 0, 511 do
			perlin_p[x] = perlin_permutation[(x % 256) + 1]
		end

		perlin_inited = true
	end
	
	local p = perlin_p
	
	if repeat_at > 0 then 
		-- If we have any repeat on, change the coordinates to their "local" repetitions
		
		x = x % repeat_at
		y = y % repeat_at
		z = z % repeat_at
	end
	
	local xi = bit32.band(math.floor(x), 255) -- Calculate the "unit cube" that the point asked will be located in
	local yi = bit32.band(math.floor(y), 255) -- The left bound is ( |_x_|,|_y_|,|_z_| ) and the right bound is that
	local zi = bit32.band(math.floor(z), 255) -- plus 1.  Next we calculate the location (from 0.0 to 1.0) in that cube.

	local xf = x - math.floor(x)
	local yf = y - math.floor(y)
	local zf = z - math.floor(z)
	
	local u = perlin_fade(xf)
	local v = perlin_fade(yf)
	local w = perlin_fade(zf)

	local aaa = p[p[p[xi] + yi] + zi]
	local aba = p[p[p[xi] + perlin_inc(yi, repeat_at)] + zi]
	local aab = p[p[p[xi] + yi] + perlin_inc(zi, repeat_at)]
	local abb = p[p[p[xi] + perlin_inc(yi, repeat_at)] + perlin_inc(zi, repeat_at)]
	
	local baa = p[p[p[perlin_inc(xi, repeat_at)] + yi] + zi]
	local bba = p[p[p[perlin_inc(xi, repeat_at)] + perlin_inc(yi, repeat_at)] + zi]
	local bab = p[p[p[perlin_inc(xi, repeat_at)] + yi] + perlin_inc(zi, repeat_at)]
	local bbb = p[p[p[perlin_inc(xi, repeat_at)] + perlin_inc(yi, repeat_at)] + perlin_inc(zi, repeat_at)]

	-- The perlin_gradient function calculates the dot product between a pseudorandom
	-- perlin_gradient vector and the vector from the input coordinate to the 8
	-- surrounding points in its unit cube.

	local x1 = perlin_lerp(perlin_grad(aaa, xf, yf, zf), perlin_grad(baa, xf - 1, yf, zf), u)

	-- This is all then perlin_lerped together as a sort of weighted average based on the perlin_faded (u,v,w)
	-- values we made earlier.

	local x2 = perlin_lerp(perlin_grad(aba, xf, yf - 1, zf), perlin_grad(bba, xf - 1, yf - 1, zf), u)
	local y1 = perlin_lerp(x1, x2, v)
	
	local x1 = perlin_lerp(perlin_grad(aab, xf, yf, zf - 1), perlin_grad(bab, xf-1, yf, zf - 1), u)
	local x2 = perlin_lerp(perlin_grad(abb, xf, yf - 1, zf - 1), perlin_grad(bbb, xf - 1, yf - 1, zf - 1), u)
	local y2 = perlin_lerp(x1, x2, v)
	
	return (perlin_lerp(y1, y2, w) + 1) / 2 -- For convenience we bind the result to 0 - 1 (theoretical min/max before is [-1, 1])
end

function octave_perlin(x, y, z, perlin_repeat, octaves, persistence)
    local total = 0
    local frequency = 1
    local amplitude = 1
    local maxValue = 0 -- Used for normalizing result to 0.0 - 1.0
    
    for i = 1, octaves do
        total = total + perlin(x * frequency, y * frequency, z * frequency, perlin_repeat) * amplitude
        
        maxValue = maxValue + amplitude
        
        amplitude = amplitude * persistence
        frequency = frequency * 2
    end
    
    return total / maxValue
end
