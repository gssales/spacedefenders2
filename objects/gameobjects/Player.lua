Player = GameObject:extend()

function Player:new (area, x, y, opts)
	Player.super.new(self, area, x, y, opts)

	self.w = 64
	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
	self.collider:setPosition(self.x, self.y)
	self.collider:setObject(self)
	self.collider:setFixedRotation(false)
	self.collider:setMass(1000)

	self.r = 0
	self.vr = 1.66*math.pi
	self.v = 0
	self.max_v = 200
	self.a = 100
	self.f = 0

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
		self.f = self.a*self.collider:getMass()
		self.collider:applyForce(math.cos(self.r-math.pi/2) * self.f,
			math.sin(self.r-math.pi/2) * self.f)
	end
end

function Player:draw ()
	love.graphics.draw(self.sprite, self.x, self.y, self.r, 1, 1, self.sprite:getWidth()/2, self.sprite:getHeight()/2)
	love.graphics.circle('line', self.x, self.y, self.w)
end
