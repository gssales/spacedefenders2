ExplosionParticle = GameObject:extend()

function ExplosionParticle:new (area, x, y, opts)
	ExplosionParticle.super.new(self, area, x, y, opts)

	self.color = colors.white
	self.r = randomFloat(0, 2 * math.pi)
	self.s = opts.s or randomFloat(20, 30)
	self.v = opts.v or randomFloat(500, 800)
	self.line_width = 2

	self.timer:tween(randomFloat(0.3, 0.8), self, {s = 0, v = 0, line_width = 0}, 'out-in-cubic', function ()
		self.dead = true
	end)
end

function ExplosionParticle:update (dt)
	ExplosionParticle.super.update(self, dt)
	self.x = self.x + self.v*math.cos(self.r)*dt
	self.y = self.y + self.v*math.sin(self.r)*dt
end

function ExplosionParticle:draw ()
	pushRotate(self.x, self.y, self.r)
	love.graphics.setLineWidth(self.line_width)
	love.graphics.setColor(self.color)
	love.graphics.line(self.x - self.s, self.y, self.x + self.s, self.y)
	love.graphics.setLineWidth(1)
	love.graphics.pop()
end
