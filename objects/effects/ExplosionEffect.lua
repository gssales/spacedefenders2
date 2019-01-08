ExplosionEffect = GameObject:extend()

function ExplosionEffect:new (area, x, y, opts)
	ExplosionEffect.super.new(self, area, x, y, opts)

	self.depth = opts.depth or 80

	self.r = opts.r or randomFloat(0, 2*math.pi)

	self.animation = Animation(opts.e or _G["explosion"..love.math.random(1,8)],
			256, 256, opts.d or randomFloat(0.75, 1.25), opts.s or randomFloat(1, 1.5), 1)
	self.animation:follow(self.x, self.y)
	self.animation:play()
end

function ExplosionEffect:update (dt)
	ExplosionEffect.super.update(self, dt)

	self.animation:follow(self.x, self.y)
	self.animation:update(dt)

	if not self.animation.playing then
		self.dead = true
	end
end

function ExplosionEffect:draw ()
	pushRotate(self.x, self.y, self.r)
	love.graphics.setColor(colors.white)
	self.animation:draw()
	love.graphics.pop()
end
