Asteroid = GameObject:extend()

function Asteroid:new (area, x, y, opts)
	Asteroid.super.new(self, area, x, y, opts)

	self.radius = 48 * self.s
	self.m = 50 * self.s
	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.radius)
	self.collider:setCollisionClass('Asteroid')
	self.collider:setPosition(self.x, self.y)
	self.collider:setObject(self)
	self.collider:setMass(self.m)
	self.collider:setRestitution(0.5)
	self.collider:setFriction(1)
	self.collider:applyLinearImpulse(self.l_impulse * math.cos(self.r), self.l_impulse * math.sin(self.r))
	self.collider:applyAngularImpulse(self.a_impulse)
	self.t = self.a_impulse/75

	-- TODO: spin Asteroids backwards
	self.animation = Animation(asteroid_sprite, asteroid_sprite:getWidth()/8, asteroid_sprite:getHeight()/8, self.t, self.s, false)
	self.animation:follow(self.x, self.y)
	self.animation:play()
end

function Asteroid:update (dt)
	Asteroid.super.update(self, dt)

	if self.collider:enter('Asteroid') then
		local contact = self.collider:getEnterCollisionData('Asteroid').contact

		local x, y, _, _ = contact:getPositions()
		local vx, vy = contact:getNormal()
		local r = math.acos(vx) + math.pi/2

		for i=1,love.math.random(2, 4) do
			local d = i%2 == 0 and math.pi or 0

			local i = love.math.random(1,4)
			local color
			if i == 1 then color = colors.asteroid_grey1 elseif i == 2 then color = colors.asteroid_grey2 else color = colors.asteroid_grey3 end

			self.area:addGameObject('CollisionParticle', x, y, {r = r+d, color = color})
		end

	elseif self.collider:enter('Player') then
		local contact = self.collider:getEnterCollisionData('Player').contact

		local x, y, _, _ = contact:getPositions()
		local vx, vy = contact:getNormal()
		local r = math.acos(vx) + math.pi/2

		for i=1,love.math.random(2, 4) do
			local d = i%2 == 0 and math.pi or 0

			local i = love.math.random(1,4)
			local color
			if i == 1 then color = colors.asteroid_grey1 elseif i == 2 then color = colors.asteroid_grey2 else color = colors.asteroid_grey3 end

			self.area:addGameObject('CollisionParticle', x, y, {r = r+d, color = color})
		end

	elseif self.collider:enter('Shield') then
		local contact = self.collider:getEnterCollisionData('Shield').contact

		local x, y, _, _ = contact:getPositions()
		local vx, vy = contact:getNormal()
		local r = math.acos(vx) + math.pi/2

		for i=1,love.math.random(2, 4) do
			local d = i%2 == 0 and math.pi or 0

			local i = love.math.random(1,4)
			local color
			if i == 1 then color = colors.asteroid_grey1 elseif i == 2 then color = colors.asteroid_grey2 else color = colors.asteroid_grey3 end

			self.area:addGameObject('CollisionParticle', x, y, {r = r+d, color = color})
		end
	end

	self.animation:follow(self:getPosition())
	self.animation:update(dt)
end

function Asteroid:draw ()
	-- IDEA: change Asteroid color
	love.graphics.setColor(colors.white)
	self.animation:draw()
end
