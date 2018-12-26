TestGround = Object:extend()

function TestGround:new ()
	camera.scale = 0.5

	self.area = Area(self)
	self.area:addPhysicsWorld()
	self.area.world:addCollisionClass('Player')
	self.area.world:addCollisionClass('Shield', {ignores = {'Player'}})

	self.main_canvas = love.graphics.newCanvas(gw, gh)

	shot1_sprite = love.graphics.newImage('/resources/sprites/shot1.png')
	shot2_sprite = love.graphics.newImage('/resources/sprites/shot2.png')

	self.player = self.area:addGameObject('Player', 0, 0)
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
	shot1_sprite = nil
	shot2_sprite = nil
	self.area = nil
end
