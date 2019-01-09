TestGround = Object:extend()

function TestGround:new ()
	camera.scale = 0.5
	camera:setFollowStyle('LOCKON')
	camera:setFollowLerp(0.2)
	camera:setFollowLead(10)

	self.area = Area(self)
	self.area:addPhysicsWorld()
	love.physics.setMeter(10)
	self.area.world:addCollisionClass('Player')
	self.area.world:addCollisionClass('Shield', {ignores = {'Player'}})
	self.area.world:addCollisionClass('Shot', {ignores = {'Player', 'Shield', 'Shot'}})
	self.area.world:addCollisionClass('Enemy')
	self.area.world:addCollisionClass('EnemyShot', {ignores = {'Enemy', 'EnemyShot'}})
	self.area.world:addCollisionClass('Asteroid')

	self.main_canvas = love.graphics.newCanvas(gw, gh)

	shot_sprite = love.graphics.newImage('/resources/sprites/shot.png')
	asteroid_sprite = love.graphics.newImage('/resources/sprites/asteroid.png')
	mine = love.graphics.newImage('/resources/sprites/mine_on.png')
	explosion1 = love.graphics.newImage('/resources/sprites/explosion1.png')
	explosion2 = love.graphics.newImage('/resources/sprites/explosion2.png')
	explosion4 = love.graphics.newImage('/resources/sprites/explosion4.png')
	explosion6 = love.graphics.newImage('/resources/sprites/explosion6.png')
	explosion7 = love.graphics.newImage('/resources/sprites/explosion7.png')
	enemy1 = love.graphics.newImage('/resources/sprites/enemy_ship1.png')
	enemy2 = love.graphics.newImage('/resources/sprites/enemy_ship2.png')
	enemy3 = love.graphics.newImage('/resources/sprites/enemy_ship3.png')
	enemy4 = love.graphics.newImage('/resources/sprites/enemy_ship4.png')
	enemy5 = love.graphics.newImage('/resources/sprites/enemy_ship5.png')
	enemy6 = love.graphics.newImage('/resources/sprites/enemy_ship6.png')
	enemy7 = love.graphics.newImage('/resources/sprites/enemy_ship7.png')
	enemy8 = love.graphics.newImage('/resources/sprites/enemy_ship8.png')

	self.player = self.area:addGameObject('Player', 0, 0)
	self.background = self.area:addGameObject('Background', 0, 0)

	self.ui = LevelUI(self)

	input:bind('z', function ()
		local i = randomFloat(1000, 10000)
		local r = randomFloat(0, 2*math.pi)
		local s = randomFloat(0.5, 1.5)
		local a = randomFloat(500, 1000)
		self.area:addGameObject('Asteroid', 200, 200,
			{l_impulse = i, a_impulse = a, r = r, s = s})
	end)
	self.area:addGameObject('VenusianCloud', -400, -400)

	slow(0.1, 60)
end

function TestGround:update(dt)
	self.area:update(dt)
	self.background:follow(self.player:getPosition())
	camera:follow(self.player:getPosition())
	self.ui:update(dt)
end

function TestGround:draw()
	love.graphics.setCanvas(self.main_canvas)
	love.graphics.clear()
	camera:attach()
		self.area:draw()
	camera:detach()
	self.ui:draw()
	love.graphics.setCanvas()

	love.graphics.setColor(colors.white)
	love.graphics.setBlendMode('alpha', 'premultiplied')
	love.graphics.draw(self.main_canvas, 0, 0, 0, sx, xy)
	love.graphics.setBlendMode('alpha')
end

function TestGround:destroy()
	self.area:destroy()
	self.area = nil
	shot_sprite = nil
	asteroid_sprite = nil
	explosion1 = nil
	explosion2 = nil
	explosion6 = nil
	explosion7 = nil
end
