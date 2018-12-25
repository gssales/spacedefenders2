TestGround = Object:extend()

function TestGround:new ()
	camera.scale = 1

	self.area = Area(self)
	self.area:addPhysicsWorld()

	self.main_canvas = love.graphics.newCanvas(gw, gh)

	propeler_sprite = love.graphics.newImage('/resources/sprites/propeler1.png')

	self.player = self.area:addGameObject('Player', gw/2, gh/2)
	self.background = self.area:addGameObject('Background', 0, 0)
end

function TestGround:update(dt)
	self.area:update(dt)
	self.background:follow(self.player.x, self.player.y)
	camera:follow(self.player.x, self.player.y)
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
	propeler_sprite = nil
	self.area = nil
end
