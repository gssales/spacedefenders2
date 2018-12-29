CollisionParticle = GameObject:extend()

function CollisionParticle:new (area, x, y, opts)
	CollisionParticle.super.new(self, area, x, y, opts)

	self.w = randomFloat(8, 12)
	self.v = opts.v or randomFloat(200, 400)
	self.r = randomFloat(self.r - math.pi/12, self.r + math.pi/12)
	self.timer:tween(randomFloat(1, 3), self, {w = 0, v = 0}, 'out-in-cubic', function ()
		self.dead = true
	end)
end

function CollisionParticle:update (dt)
	CollisionParticle.super.update(self, dt)
	self.x = self.x + self.v*math.cos(self.r)*dt
	self.y = self.y + self.v*math.sin(self.r)*dt
end

function CollisionParticle:draw ()
	love.graphics.setColor(self.color)
	love.graphics.rectangle('fill', self.x, self.y, self.w, self.w)
end
