PropelerParticle = GameObject:extend()

function PropelerParticle:new (area, x, y, opts)
	PropelerParticle.super.new(self, area, x, y, opts)

	self.r = opts.r or randomFloat(4, 6)
	self.color = self.c1
	self.timer:after(0.01, function ()
		self.color = self.c2
		self.timer:after(0.05, function ()
			self.color = self.c3
		end )
	end )
	self.timer:tween(opts.d or randomFloat(0.3, 0.5), self, {r = 0}, 'linear', function ()
		self.dead = true
	end)
end

function PropelerParticle:update (dt)
	PropelerParticle.super.update(self, dt)

end

function PropelerParticle:draw ()
	love.graphics.setColor(self.color)
	love.graphics.circle('fill', self.x, self.y, self.r)
end
