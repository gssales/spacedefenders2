TestGround = Object:extend()

function TestGround:new ()
	camera.scale = 0.5

	self.area = Area(self)
	self.area:addPhysicsWorld()
	self.area.world:addCollisionClass('Player')
	self.area.world:addCollisionClass('Shield', {ignores = {'Player'}})

	self.main_canvas = love.graphics.newCanvas(gw, gh)

	shot_sprite = love.graphics.newImage('/resources/sprites/shot.png')

	self.player = self.area:addGameObject('Player', 0, 0)
	self.background = self.area:addGameObject('Background', 0, 0)
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
