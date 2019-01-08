Enemy = GameObject:extend()

function Enemy:new (area, x, y, opts)
	Enemy.super.new(self, area, x, y, opts)

	self.m = opts.m or 100
	self.w = opts.w or 64
	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
	self.collider:setCollisionClass('Enemy')
	self.collider:setObject(self)
	self.collider:setRestitution(0.7)
	self.collider:setFriction(0.8)
	self.collider:setMass(self.m)

	self.r = 0
	self.rv = math.pi/3
	self.direction = 1

	self.v = 300
	self.last_behavior = 'follow'
	self.behavior = 'follow' -- follow, escape, forward, scout, slow, inertial
	--[[
	 * follow: turns towards the player and can shoot
	 * escape: turns away from the player and don't shoot
	 * forward: don't turn
	 * scout: slow, wide turn
	 * slow: briefly slow velocity
	 * inertial: can't set velocity
	]]

	self.can_shoot = true
	self.timer:after(randomFloat(3, 5), function () self.can_shoot = true end)
	self.shoot_angle = math.pi/6
	self.shoot_distance = 500

	self.integrity = 50

	self.sprite = enemy1
end

function Enemy:update (dt)
	Enemy.super.update(self, dt)

	if self.explosion then self.explosion.x, self.explosion.y = self.x, self.y end
	if self.dying then return end

	if self.integrity <= 0 then self:die() end

	if self.collider:enter('Player') then
		local collision_data = self.collider:getEnterCollisionData('Player')
		local object = collision_data.collider:getObject()

		if self.behavior ~= 'inertial' then self.last_behavior = self.behavior end
		self:setBehavior('inertial')
		if self.behavior_timer then self.timer:cancel(self.behavior_timer) end
		self.behavior_timer = self.timer:after(randomFloat(1, 2), function ()
			self:setBehavior(self.last_behavior)
		end)

		local contact = collision_data.contact
		local x, y, _, _ = contact:getPositions()
		local vx, vy = contact:getNormal()
		local r = math.acos(vx) + math.pi/2
		for i=1,love.math.random(4, 8) do
			local d = i%2 == 0 and math.pi or 0

			local color
			if i == 1 then color = colors.propeler_red else color = colors.propeler_blue end

			self.area:addGameObject('CollisionParticle', x, y, {r = r+d, color = color})
		end
		self.area:addGameObject('ExplosionEffect', x, y, {e = explosion1})

		object:hit(10)
		self:hit(10)
	elseif self.collider:enter('Enemy') then
		local collision_data = self.collider:getEnterCollisionData('Enemy')

		local contact = collision_data.contact
		local x, y, _, _ = contact:getPositions()
		local vx, vy = contact:getNormal()
		local r = math.acos(vx) + math.pi/2
		for i=1,love.math.random(4, 8) do
			local d = i%2 == 0 and math.pi or 0
			self.area:addGameObject('CollisionParticle', x, y, {r = r+d, color = colors.propeler_red})
		end

		self:setBehavior('slow')
		if self.behavior_timer then self.timer:cancel(self.behavior_timer) end
		self.behavior_timer = self.timer:after(randomFloat(0.5, 1), function ()
			self:setBehavior('follow')
		end)
	end

	if not current_room.player then self:setBehavior('forward') end

	if self.behavior == 'follow' then self:follow(dt)
	elseif self.behavior == 'escape' then self:escape(dt)
	elseif self.behavior == 'scout' then self:scout(dt)
	elseif self.behavior == 'slow' then self:slow(dt)
	elseif self.behavior == 'inertial' then self:inertial(dt)
	elseif self.behavior == 'forward' then self:forward(dt)
	end

end

function Enemy:draw ()
	love.graphics.draw(self.sprite, self.x, self.y, self.r+math.pi/2, 1, 1, self.sprite:getWidth()/2, self.sprite:getHeight()/2)
end

function Enemy:hit (damage)
	self.integrity = self.integrity - damage
end
function Enemy:die ()
	self.explosion = self.area:addGameObject('ExplosionEffect', self.x, self.y, {e = explosion4, s = 2})
	self.dying = true
	self.timer:after(0.5, function ()
		for i=1,love.math.random(6, 12) do
			self.area:addGameObject('ExplosionParticle', self.x, self.y)
		end
		self.dead = true
	end )
end

function Enemy:setBehavior (behavior)
	self.behavior = behavior
	print(self.behavior)
	if behavior == 'scout' or behavior == 'inertial' or behavior == 'slow' then
		self.direction = love.math.random(0, 1) == 0 and -1 or 1
	end
end

function Enemy:follow (dt)
	local player = current_room.player
	local r = math.atan2(self.y-player.y, self.x-player.x) + math.pi
	local d = math.sqrt(math.pow(self.x-player.x, 2) + math.pow(self.y-player.y, 2))
	if r < self.r then
		if self.r - r < r - self.r + 2*math.pi then
			if d < 1.5*self.v/self.rv and self.r - r > 5*math.pi/12 and self.r - r > 7*math.pi/12 then
				self:turn(dt, 1)
			else
				self:turn(dt, -1)
			end
		else
			if d < 1.5*self.v/self.rv and r - self.r + 2*math.pi > 5*math.pi/12 and r - self.r + 2*math.pi > 7*math.pi/12 then
				self:turn(dt, -1)
			else
				self:turn(dt, 1)
			end
		end
	else
		if r - self.r < self.r - r + 2*math.pi then
			if d < 1.5*self.v/self.rv and r - self.r > 5*math.pi/12 and r - self.r > 7*math.pi/12 then
				self:turn(dt, -1)
			else
				self:turn(dt, 1)
			end
		else
			if d < 1.5*self.v/self.rv and self.r - r + 2*math.pi > 5*math.pi/12 and self.r - r + 2*math.pi > 7*math.pi/12 then
				self:turn(dt, 1)
			else
				self:turn(dt, -1)
			end
		end
	end
	if self.can_shoot then
		self:shoot()
	end
	self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))
end
function Enemy:escape (dt)
	local player = current_room.player
	local r = math.atan2(self.y-player.y, self.x-player.x) + math.pi
	if r < self.r then
		if self.r - r < r - self.r + 2*math.pi then
			self:turn(dt, 1)
		else
			self:turn(dt, -1)
		end
	else
		if r - self.r < self.r - r + 2*math.pi then
			self:turn(dt, -1)
		else
			self:turn(dt, 1)
		end
	end

	self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))
end
function Enemy:forward (dt)
	self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))
end
function Enemy:scout (dt)
	self:turn(dt, 1/6 * self.direction)
	self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))
end
function Enemy:slow (dt)
	self.collider:setLinearVelocity(self.v * 1/6 * math.cos(self.r), self.v * 1/6 * math.sin(self.r))
end
function Enemy:inertial (dt)
	self:turn(dt, randomFloat(1, 2)*self.direction)
end

function Enemy:turn (dt, multiplier)
	self.r = self.r + self.rv*dt*multiplier
	if self.r > 2*math.pi then self.r = self.r - 2*math.pi end
	if self.r < 0 then self.r = self.r + 2*math.pi end
end

function Enemy:shoot ()
	local r = math.atan2(self.y-current_room.player.y, self.x-current_room.player.x) + math.pi
	local d = math.sqrt(math.pow(self.x-current_room.player.x, 2) + math.pow(self.y-current_room.player.y, 2))
	if math.abs(self.r - r) < self.shoot_angle and d < self.shoot_distance then
		self.area:addGameObject('EnemyChargeAttackEffect', self.x, self.y, {d = self.w, enemy = self})
		self.timer:after(1.5, function ()
			local d = self.w
			self.area:addGameObject('ShootEffect',
				self.x + d * math.cos(self.r), self.y + d * math.sin(self.r),
				{player = self, d = d})
			self.area:addGameObject('Shot',
				self.x + d * math.cos(self.r), self.y + d * math.sin(self.r),
				{r = self.r, pv = self.v, shooter = 'enemy'})
			self:setBehavior('escape')
			self.timer:after(2, function ()
				self:setBehavior('follow')
			end )
		end)
		self.can_shoot = false
		self.timer:after(randomFloat(2, 3), function ()
			self.can_shoot = true
		end )

	end
end
