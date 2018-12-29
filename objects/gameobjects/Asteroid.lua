Asteroid = GameObject:extend()

function Asteroid:new (area, x, y, opts)
	Asteroid.super.new(self, area, x, y, opts)

	self.radius = 48 * self.s
	self.m = 50 * self.s
	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.radius)
	self.collider:setPosition(self.x, self.y)
	self.collider:setObject(self)
	self.collider:setMass(self.m)
	self.collider:setRestitution(0.5)
	self.collider:setFriction(1)
	self.collider:applyLinearImpulse(self.l_impulse * math.cos(self.r), self.l_impulse * math.sin(self.r))
	self.collider:applyAngularImpulse(self.a_impulse)

	self.animation = Animation(asteroid_sprite, asteroid_sprite:getWidth()/8, asteroid_sprite:getHeight()/8, 10, self.s, true)
	self.animation:play()
end

function Asteroid:update (dt)
	Asteroid.super.update(self, dt)

	self.animation:follow(self:getPosition())
	self.animation:update(dt)
end

function Asteroid:draw ()
	self.animation:draw()
end
