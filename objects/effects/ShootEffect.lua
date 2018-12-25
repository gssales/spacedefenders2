ShootEffect = GameObject:extend()

function ShootEffect:new (area, x, y, opts)
	ShootEffect.super.new(self, area, x, y, opts)

	self.w, self.h = 10, 0
	self.timer:tween(0.1, self, {w = 0, h = 80}, 'linear', function ()
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
	love.graphics.setColor(colors.white)
	love.graphics.rectangle('fill', self.x - self.w/2, self.y,
			self.w, -self.h)
	love.graphics.pop()

	pushRotate(self.x, self.y, self.player.r+math.pi/3)
	love.graphics.setColor(colors.white)
	love.graphics.rectangle('fill', self.x - self.w/4, self.y,
			self.w/2, -self.h/2)
	love.graphics.pop()

	pushRotate(self.x, self.y, self.player.r-math.pi/3)
	love.graphics.setColor(colors.white)
	love.graphics.rectangle('fill', self.x - self.w/4, self.y,
			self.w/2, -self.h/2)
	love.graphics.pop()
end
