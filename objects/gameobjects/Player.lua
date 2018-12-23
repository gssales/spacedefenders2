Player = GameObject:extend()

function Player:new (area, x, y, opts)
	Player.super.new(self, area, x, y, opts)

	self.w = 64
	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
	self.collider:setPosition(self.x, self.y)
	self.collider:setObject(self)
	self.collider:setFixedRotation(false)

	self.r = 0
	self.vr = 1.66*math.pi
	self.v = 0
	self.max_v = 200
	self.a = 100

	self.sprite = love.graphics.newImage('resources/sprites/player_ship.png')
end

function Player:update (dt)
	Player.super.update(self, dt)

	if input:down('left') then
		self.r = self.r - self.vr*dt
	end
	if input:down('right') then
		self.r = self.r + self.vr*dt
	end

	if input:down('up') then
		self.v = math.min(self.v + self.a*dt, self.max_v)
	end
	if input:down('down') then
		self.v = math.max(self.v - self.a*dt, 0)
	end

	self.collider:setLinearVelocity(math.cos(self.r-math.pi/2) * self.v, math.sin(self.r-math.pi/2) * self.v)
end

function Player:draw ()
	love.graphics.draw(self.sprite, self.x, self.y, self.r, 1, 1, self.sprite:getWidth()/2, self.sprite:getHeight()/2)
	love.graphics.circle('line', self.x, self.y, self.w)
end
