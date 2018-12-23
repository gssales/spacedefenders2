Player = GameObject:extend()

function Player:new (area, x, y, opts)
	Player.super.new(self, area, x, y, opts)

	self.w = 64
	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
	self.collider:setPosition(self.x, self.y)
	self.collider:setObject(self)
	self.collider:setFixedRotation(false)
	self.m = 100
	self.collider:setMass(self.m)

	self.r = 0
	self.rv = 1.66*math.pi
	self.ra = 0
	self.v = 0
	self.max_v = 600
	self.a = 300

	self.sprite = love.graphics.newImage('resources/sprites/player_ship.png')
end

function Player:update (dt)
	Player.super.update(self, dt)

	if input:down('left') then
		self.r = self.r - self.rv*dt
	end
	if input:down('right') then
		self.r = self.r + self.rv*dt
	end
	if input:down('up') then
		self.v = math.min(self.v + self.a*dt, self.max_v)
		if self.turn_timer then
			self.timer:cancel(self.turn_timer)
		end
		self.turn_timer = self.timer:tween(0.2, self, {ra = self.r}, 'linear')
	end
	if input:down('down') then
		self.v = math.max(self.v - self.a*dt, 0)
	end
	self.collider:setLinearVelocity(self.v * math.cos(self.ra-math.pi/2), self.v * math.sin(self.ra-math.pi/2))

end

function Player:draw ()
	love.graphics.draw(self.sprite, self.x, self.y, self.r, 1, 1, self.sprite:getWidth()/2, self.sprite:getHeight()/2)
	love.graphics.circle('line', self.x, self.y, self.w)
end
