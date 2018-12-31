Shot = GameObject:extend()

function Shot:new(area, x, y, opts)
	Shot.super.new(self, area, x, y, opts)
	self.depth = 45

	self.s = opts.s or 10
	self.v = opts.v or 1000
	self.pv = opts.pv or 0
	self.v = self.v + self.pv

	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.s)
	self.collider:setCollisionClass('Shot')
	self.collider:setObject(self)
	self.collider:setLinearVelocity(self.v * math.cos(self.r-math.pi/2), self.v * math.sin(self.r-math.pi/2))

	self.timer:after(5, function ()
		self:die()
	end )

end

function Shot:update(dt)
	Shot.super.update(self, dt)

	if self.collider:enter('Asteroid') then
		local collision_data = self.collider:getEnterCollisionData('Asteroid')
		local asteroid = collision_data.collider:getObject()
		local vx, vy = asteroid.x-self.x, asteroid.y-self.y
		local n = math.sqrt(vx*vx+vy*vy)
		local angle = math.acos(vx/n) * (vy/n < 0 and -1 or 1) + math.pi
		local s = randomFloat(1, 1.5)
		local d = asteroid.radius + 48*s
		self.area:addGameObject('ExplosionEffect', asteroid.x + math.cos(angle)*d, asteroid.y + math.sin(angle)*d, {e = explosion2, r = angle, s = s})
		self.area:addGameObject('ExplosionEffect', asteroid.x - math.cos(angle), asteroid.y - math.sin(angle), {e = explosion7, s = 1.5 * asteroid.s})
		asteroid.timer:after(0.05, function ()
			asteroid:die()
		end)
		self:die()
	end

	self.collider:setLinearVelocity(self.v * math.cos(self.r-math.pi/2), self.v * math.sin(self.r-math.pi/2))
end

function Shot:draw()
	pushRotate(self.x, self.y, Vector(self.collider:getLinearVelocity()):angleTo()+math.pi/2)
	love.graphics.setColor(colors.white)
    love.graphics.draw(shot_sprite, self.x, self.y, 0, 0.75, 0.75,
		shot_sprite:getWidth()/2, shot_sprite:getHeight()/6)
    love.graphics.pop()
end

function Shot:die()
	self.dead = true;
end
