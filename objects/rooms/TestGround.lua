TestGround = Object:extend()

function TestGround:new ()
	camera.scale = 0.5

	self.area = Area(self)
	self.area:addPhysicsWorld()

	self.main_canvas = love.graphics.newCanvas(gw, gh)

	self.player = self.area:addGameObject('Player', gw/2, gh/2)
end

function TestGround:update(dt)
	self.area:update(dt)
	camera:follow(self.player.x, self.player.y)
end

function TestGround:draw()
	love.graphics.setCanvas(self.main_canvas)
	love.graphics.clear()
	camera:attach()
		draft:rhombus(-1000, -1000, 100, 200, 'line')
		draft:rhombus(-1000, -500, 100, 200, 'line')
		draft:rhombus(-1000, 0, 100, 200, 'line')
		draft:rhombus(-1000, 500, 100, 200, 'line')
		draft:rhombus(-1000, 1000, 100, 200, 'line')
		draft:rhombus(-500, -1000, 200, 100, 'line')
		draft:rhombus(-500, -500, 200, 100, 'line')
		draft:rhombus(-500, 0, 200, 100, 'line')
		draft:rhombus(-500, 500, 200, 100, 'line')
		draft:rhombus(-500, 1000, 200, 100, 'line')
		draft:rhombus(0, -1000, 100, 200, 'line')
		draft:rhombus(0, -500, 100, 200, 'line')
		draft:rhombus(0, 0, 100, 200, 'line')
		draft:rhombus(0, 500, 100, 200, 'line')
		draft:rhombus(0, 1000, 100, 200, 'line')
		draft:rhombus(500, -1000, 200, 100, 'line')
		draft:rhombus(500, -500, 200, 100, 'line')
		draft:rhombus(500, 0, 200, 100, 'line')
		draft:rhombus(500, 500, 200, 100, 'line')
		draft:rhombus(500, 1000, 200, 100, 'line')
		draft:rhombus(1000, -1000, 100, 200, 'line')
		draft:rhombus(1000, -500, 100, 200, 'line')
		draft:rhombus(1000, 0, 100, 200, 'line')
		draft:rhombus(1000, 500, 100, 200, 'line')
		draft:rhombus(1000, 1000, 100, 200, 'line')

		self.area:draw()
	camera:detach()
	love.graphics.setCanvas()

	love.graphics.setColor(colors.white)
	love.graphics.setBlendMode('alpha', 'premultiplied')
	love.graphics.draw(self.main_canvas, 0, 0, 0, sx, xy)
	love.graphics.setBlendMode('alpha')
end

function TestGround:destroy()
	self.area:destroy()
	self.area = nil
end
