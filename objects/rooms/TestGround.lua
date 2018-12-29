TestGround = Object:extend()

function TestGround:new ()
	camera.scale = 0.5

	self.area = Area(self)
	self.area:addPhysicsWorld()
	love.physics.setMeter(10)
	self.area.world:addCollisionClass('Player')
	self.area.world:addCollisionClass('Shield', {ignores = {'Player'}})
	self.area.world:addCollisionClass('Shot', {ignores = {'Player', 'Shield'}})
	self.area.world:addCollisionClass('Asteroid')

	self.main_canvas = love.graphics.newCanvas(gw, gh)

	asteroid_sprite = love.graphics.newImage('/resources/sprites/asteroid.png')
	shot_sprite = love.graphics.newImage('/resources/sprites/shot.png')

	self.player = self.area:addGameObject('Player', 0, 0)
	self.background = self.area:addGameObject('Background', 0, 0)

	input:bind('z', function ()
		local i = randomFloat(1000, 10000)
		local r = randomFloat(0, 2*math.pi)
		local s = randomFloat(0.3, 0.8)
		local a = randomFloat(500, 1000)
		self.area:addGameObject('Asteroid', 200, 200,
			{l_impulse = i, a_impulse = a, r = r, s = s})
	end)
end

function TestGround:update(dt)
	self.area:update(dt)
	self.background:follow(self.player:getPosition())
	camera:follow(self.player:getPosition())
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
	shot_sprite = nil
	self.area = nil
end
