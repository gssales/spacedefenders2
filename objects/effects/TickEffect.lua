TickEffect = GameObject:extend()

function TickEffect:new (area, x, y, opts)
	TickEffect.super.new(self, area, x, y, opts)

	self.r = 0
	self.l = 16
	self.alpha = 255
	self.timer:tween(0.25, self, {r = 100, l = 0, alpha = 0}, 'in-out-quad', function ()
		self.dead = true
	end )
end

function TickEffect:update (dt)
	TickEffect.super.update(self, dt)
	if self.player then
		self.x = self.player.x + self.player.w*math.cos(self.player.r)
		self.y = self.player.y + self.player.w*math.sin(self.player.r)
	end
end

function TickEffect:draw ()
	love.graphics.setColor(1, 1, 1, self.alpha/255)
	love.graphics.setLineWidth(self.l)
	love.graphics.circle('line', self.x, self.y, self.r)
	love.graphics.setLineWidth(1)
end
