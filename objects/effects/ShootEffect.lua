ShootEffect = GameObject:extend()

function ShootEffect:new (area, x, y, opts)
	ShootEffect.super.new(self, area, x, y, opts)
	self.depth = 40

	self.w, self.h = 20, 0
	self.r = 20
	self.timer:tween(0.1, self, {w = 0, h = 80, r = 0}, 'linear', function ()
		self.dead = true
	end )
end

function ShootEffect:update (dt)
	ShootEffect.super.update(self, dt)

	if self.player then
		self.x = self.player.x + self.d*math.cos(self.player.r-math.pi/2)
		self.y = self.player.y + self.d*math.sin(self.player.r-math.pi/2)
	end
end

function ShootEffect:draw ()
	pushRotate(self.x, self.y, self.player.r)
	love.graphics.setColor(colors.propeler_yellow)
	love.graphics.rectangle('fill', self.x - self.w/2, self.y,
			self.w, -self.h)
	love.graphics.circle('fill', self.x, self.y - 10, self.r)
	love.graphics.pop()
end
