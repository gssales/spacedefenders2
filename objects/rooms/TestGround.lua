TestGround = Object:extend()

function TestGround:new ()
	camera.scale = 0.3

	self.area = Area(self)
	self.area:addPhysicsWorld()

	self.main_canvas = love.graphics.newCanvas(gw, gh)

	self.player = self.area:addGameObject('Player', gw/2, gh/2)
end

function TestGround:update(dt)
	self.area:update(dt)
end

function TestGround:draw()
	love.graphics.setCanvas(self.main_canvas)
	love.graphics.clear()
	camera:attach()
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
