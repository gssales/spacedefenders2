Mine = GameObject:extend()

function Mine:new (area, x, y, opts)
	Mine.super.new(self, area, x, y, opts)

	self.r = randomFloat(0, 2*math.pi)
	self.rv = randomFloat(-math.pi/2, math.pi/2)

	self.on = false
	self.sprite = mine
	self.timer:every(0.5, function ()
		self.on = not self.on
	end)

	self.timer:after(randomFloat(3, 3.5), function () self:die() end)
end

function Mine:update (dt)
	Mine.super.update(self, dt)

	if self.explosion then self.explosion.x, self.explosion.y = self.x, self.y end
	if self.dying then return end

	self.r = self.r + self.rv * dt
end

function Mine:draw ()
	if self.on then
		love.graphics.setColor(colors.propeler_red)
	else
		love.graphics.setColor(colors.white)
	end
	love.graphics.draw(self.sprite, self.x, self.y, self.r, 0.25, 0.25,
		self.sprite:getWidth()/2, self.sprite:getHeight()/2)
end

function Mine:die ()
	self.area:addGameObject('ExplosionEffect', self.x, self.y, {e = explosion1, s = 2})
	self.area:addGameObject('Shot', self.x, self.y, {r = self.r, shooter = 'enemy', damage = 15})
	self.area:addGameObject('Shot', self.x, self.y, {r = self.r + math.pi/4, shooter = 'enemy', damage = 15})
	self.area:addGameObject('Shot', self.x, self.y, {r = self.r + math.pi/2, shooter = 'enemy', damage = 15})
	self.area:addGameObject('Shot', self.x, self.y, {r = self.r + 3*math.pi/4, shooter = 'enemy', damage = 15})
	self.area:addGameObject('Shot', self.x, self.y, {r = self.r + math.pi, shooter = 'enemy', damage = 15})
	self.area:addGameObject('Shot', self.x, self.y, {r = self.r + 5*math.pi/4, shooter = 'enemy', damage = 15})
	self.area:addGameObject('Shot', self.x, self.y, {r = self.r + 3*math.pi/2, shooter = 'enemy', damage = 15})
	self.area:addGameObject('Shot', self.x, self.y, {r = self.r + 7*math.pi/4, shooter = 'enemy', damage = 15})
	self.dead = true
end
