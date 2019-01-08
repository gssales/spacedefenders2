Shot = GameObject:extend()

function Shot:new(area, x, y, opts)
	Shot.super.new(self, area, x, y, opts)
	self.depth = 45

	self.s = opts.s or 10
	self.v = opts.v or 1000
	self.pv = opts.pv or 0
	self.v = self.v + self.pv

	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.s)
	if self.shooter == 'player' then
		self.collider:setCollisionClass('Shot')
		self.damage = 50
	else
		self.collider:setCollisionClass('EnemyShot')
		self.damage = 30
	end
	self.collider:setObject(self)
	self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))

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
		asteroid.timer:after(0.05, function ()
			asteroid:die()
		end)
		self:die()
	end
	if self.shooter == 'player' then
		if self.collider:enter('Enemy') then
			local collision_data = self.collider:getEnterCollisionData('Enemy')
			local object = collision_data.collider:getObject()
			local x, y, _, _ = collision_data.contact:getPositions()

			self.area:addGameObject('ExplosionEffect', x, y, {e = explosion1, d = 0.5})
			object:hit(self.damage)
			self:die()
		end
	else
		if self.collider:enter('Player') then
			local collision_data = self.collider:getEnterCollisionData('Player')
			local object = collision_data.collider:getObject()
			local x, y, _, _ = collision_data.contact:getPositions()

			self.area:addGameObject('ExplosionEffect', x, y, {e = explosion1, d = 0.5})
			object:hit(self.damage)
			self:die()
		end
	end

	self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))
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
