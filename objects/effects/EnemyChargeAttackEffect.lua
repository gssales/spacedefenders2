EnemyChargeAttackEffect = GameObject:extend()

function EnemyChargeAttackEffect:new (area, x, y, opts)
	EnemyChargeAttackEffect.super.new(self, area, x, y, opts)
	self.depth = 8

	self.r = randomFloat(0, 2*math.pi)
	self.plus_r = opts.plus_r or 0

	self.animation = Animation(explosion1, 256, 256, 1.5, 1.5, 1, true)
	self.animation:follow(self.x+self.d*math.cos(self.enemy.r+self.plus_r), self.y+self.d*math.sin(self.enemy.r+self.plus_r))
	self.animation:play()
end

function EnemyChargeAttackEffect:update (dt)
	EnemyChargeAttackEffect.super.update(self, dt)
	self.x, self.y = self.enemy.x, self.enemy.y
	self.animation:update(dt)
	self.animation:follow(self.x+self.d*math.cos(self.enemy.r+self.plus_r), self.y+self.d*math.sin(self.enemy.r+self.plus_r))
	if not self.animation.playing then
		self.dead = true
	end
end

function EnemyChargeAttackEffect:draw ()
	pushRotate(self.x+self.d*math.cos(self.enemy.r+self.plus_r), self.y+self.d*math.sin(self.enemy.r+self.plus_r), self.r)
	love.graphics.setColor(colors.white)
	self.animation:draw()
	love.graphics.pop()
end
