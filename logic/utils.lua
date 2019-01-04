
--[[ AUXILIARY FUNCTION ]]--

-- creates a list of vertices of a polygon
function createIrregularPolygon (size, point_amount)
	local point_amount = point_amount or 8
	local points = {}
	for i = 1, point_amount do
		local angle_interval = 2*math.pi/point_amount
		local distance = size + randomFloat(-size/4, size/4)
		local angle = (i-1)*angle_interval + randomFloat(-angle_interval/4, angle_interval/4)
		table.insert(points, distance*math.cos(angle))
		table.insert(points, distance*math.sin(angle))
	end
	return points
end

-- loads all the fonts listed in the files table
function loadFonts(files)
	local fonts = {}
	for _, file in ipairs(files) do
		print(_, file)
		local font = love.graphics.newFont(file, 16)
		local font_name = file:sub(17, -5)..'_16'
		fonts[font_name] = font
		local font = love.graphics.newFont(file, 32)
		local font_name = file:sub(17, -5)..'_32'
		fonts[font_name] = font
	end
	return fonts
end

-- picks a random element from a table
function table.random (t)
	return t[love.math.random(1, #t)]
end

-- generates random float number in range (min, max)
function randomFloat(min, max)
	return min + math.random() * (max - min)
end

-- pushes the canvas, rotates r degres in the x,y center, and scale by factor sx,sy
function pushRotateScale(x, y, r, sx, sy)
	love.graphics.push()
	love.graphics.translate(x, y)
	love.graphics.rotate(r or 0)
	love.graphics.scale(sx or 1, sy or sx or 1)
	love.graphics.translate(-x, -y)
end

-- pushes the canvas and rotates r degres in the x,y center
function pushRotate(x, y, r)
	love.graphics.push()
	love.graphics.translate(x, y)
	love.graphics.rotate(r or 0)
	love.graphics.translate(-x, -y)
end

-- resize canvas
function resize(s)
	love.window.setMode(s*gw, s*gh)
	sx, sy = s, s
end

-- Generates id for gameobjects
function UUID()
	local fn = function(x)
		local r = love.math.random(16) - 1
		r = (x == "x") and (r + 1) or (r % 4) + 9
		return ('0123456789abcdef'):sub(r, r)
	end
	return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]", fn))
end

-- Convert all colors in the colors list to range from 0..1 instead of 0..255
function mapColors(colors)
	return M.map(colors, function(c)
		return M.map(c, function(v)
			return v/255
		end )
	end )
end

-- Maps keyboard input, binding keys
function bindInputMap(input, map)
	M.each(map, function(inputs, action)
		return M.each(inputs, function(key)
			input:bind(key, action)
		end )
	end )
--[[
	for action, inputs in ipairs(map) do
		for _, key in pairs(inputs) do
			input:bind(key, action)
		end
	end]]
end

-- Access folder recursively, listing files path in a table
function recursiveEnumerate(folder, file_list)
	local items = love.filesystem.getDirectoryItems(folder)
	for _, item in ipairs(items) do
		local file = folder .. '/' .. item
		if love.filesystem.getInfo(file, 'file') then
			table.insert(file_list, file)
		elseif love.filesystem.getInfo(file, 'directory') then
			recursiveEnumerate(file, file_list)
		end
	end
end

-- Requires all the files listed in the files table
function requireFiles(files)
	for _, file in ipairs(files) do
		print(_, file)
		local file = file:sub(1, -5)
		require(file)
	end
end

--[[ COUNT GARBAGE]]--
	function count_all(f)
		local seen = {}
		local count_table
		count_table = function(t)
			if seen[t] then return end
			f(t)
			seen[t] = true
			for k,v in pairs(t) do
				if type(v) == 'table' then
					count_table(v)
				elseif type(v) == 'userdata' then
					f(v)
				end
			end
		end
		count_table(_G)
	end
	function type_count()
		local counts = {}
		local enumerate = function(o)
			local t = type_name(o)
			counts[t] = (counts[t] or 0) + 1
		end
		count_all(enumerate)
		return counts
	end
	global_type_table = nil
	function type_name(o)
		if global_type_table == nil then
			global_type_table = {}
			for k,v in pairs(_G) do
				global_type_table[v] = k
			end
			global_type_table[0] = 'table'
		end
		return global_type_table[getmetatable(o) or 0] or 'Unknown'
	end
	function dump_garbage()
		print('Before collection: '..collectgarbage('count')/1024)
		collectgarbage()
		print('After collection: '..collectgarbage('count')/1024)
		print('Object count: ')
		local counts = type_count()
		for k,v in pairs(counts) do
			print(k, v)
		end
		print('------------------------------------')
	end
--[[]]--
