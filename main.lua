require 'libraries/utf8/utf8'
Object = require 'libraries/classic/classic'
Timer = require 'libraries/chrono/Timer'
Camera = require 'libraries/stalker-x/Camera'
Physics = require 'libraries/windfield'
Input = require 'libraries/boipushy/Input'
M = require "libraries/Moses/moses"
Draft = require "libraries/draft/draft"
Vector = require "libraries/hump/vector"
require 'logic/utils'

function love.load()
	--love.graphics.setDefaultFilter('nearest')
	--love.graphics.setLineStyle('rough')

	camera = Camera()
	timer = Timer()
	draft = Draft()
	input = Input()

	bindInputMap(input, require('logic/input_map'))
	colors = mapColors(require('logic/colors'))

	local obj_files = {}
	recursiveEnumerate('objects', obj_files)
	requireFiles(obj_files)

	local font_files = {}
	recursiveEnumerate('resources/fonts', font_files)
	fonts = loadFonts(font_files)

	slow_motion = 1
	current_room = nil
	changeRoom('TestGround')

	input:bind('escape', function() love.event.quit() end)
	input:bind('f1', function () changeRoom('TestGround') end)
	input:bind('f3', function () dump_garbage() end)
end

function love.update(dt)
	timer:update(dt * slow_motion)
	camera:update(dt * slow_motion)
	if current_room then
		current_room:update(dt * slow_motion)
	end
end

function love.draw()
	if current_room then
		current_room:draw()
	end

	if flash_frames then
		flash_frames = flash_frames -1
		if flash_frames == -1 then flash_frames = nil end
	end
	if flash_frames then
		love.graphics.setColor(colors.black)
		love.graphics.rectangle('fill', 0, 0, sx*gw, sy*gh)
		love.graphics.setColor(colors.white)
	end
end

function changeRoom(room, ...)
	if current_room and current_room.destroy then
		current_room:destroy()
	end
	current_room = _G[room](...)
end

function slow(amount, duration)
	slow_motion = amount
	timer:tween(duration, _G, {slow_motion = 1}, 'in-out-cubic', 'slow')
end

function flash(frames)
	flash_frames = frames
end
