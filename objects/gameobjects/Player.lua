Player = GameObject:extend()

function Player:new (area, x, y, opts)
	Player.super.new(self, area, x, y, opts)

	self.depth = 50

	self.m = 100
	self.w = 64
	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
	self.collider:setCollisionClass('Player')
	self.collider:setObject(self)
	self.collider:setRestitution(0.7)
	self.collider:setFriction(0.8)
	self.collider:setMass(self.m)

	self.r = 0
	self.rv = 1.66*math.pi
	self.v = 0
	self.max_v = 600
	self.a = 100

	self.can_shoot = true
	self.can_shield = true
	self.move = false

	self.sprite = love.graphics.newImage('resources/sprites/player_ship.png')

	self.propeler_r_min = 5
	self.propeler_r_max = 15
	self.propeler_c1 = colors.white
	self.propeler_c2 = colors.propeler_yellow
	self.propeler_c3 = colors.propeler_red
	self.timer:every(0.02, function ()
		local x1 = 36*math.cos(self.r-math.pi/2)-48*math.cos(self.r)
		local y1 = 36*math.sin(self.r-math.pi/2)-48*math.sin(self.r)
		local x2 = 36*math.cos(self.r-math.pi/2)+48*math.cos(self.r)
		local y2 = 36*math.sin(self.r-math.pi/2)+48*math.sin(self.r)
		self.area:addGameObject('PropelerParticle', self.x - x1, self.y - y1,
			{parent = self, r = randomFloat(self.propeler_r_min, self.propeler_r_max),
			d = randomFloat(0.15, 0.25), c1 = self.propeler_c1, c2 = self.propeler_c2, c3 = self.propeler_c3})
		self.area:addGameObject('PropelerParticle', self.x - x2, self.y - y2,
			{parent = self, r = randomFloat(self.propeler_r_min, self.propeler_r_max),
			d = randomFloat(0.15, 0.25), c1 = self.propeler_c1, c2 = self.propeler_c2, c3 = self.propeler_c3})
	end)

end

function Player:update (dt)
	Player.super.update(self, dt)

	if input:down('shoot') and self.can_shoot then
		self:shoot()
		self.can_shoot = false
		self.timer:after(0.5, function ()
			self.can_shoot = true
		end )
	end

	if input:down('shield') and self.can_shield then
		if self.shield_obj then
			self:unshield()
		else
			self:shield()
		end
		self.can_shield = false
		self.timer:after(0.1, function ()
			self.can_shield = true
		end )
	end

	if input:down('left') then
		self.move = true
		local vx, vy = self.collider:getLinearVelocity()
		self.v = math.sqrt(vx*vx + vy*vy)
		self.r = self.r - self.rv*dt
	end
	if input:down('right') then
		self.move = true
		local vx, vy = self.collider:getLinearVelocity()
		self.v = math.sqrt(vx*vx + vy*vy)
		self.r = self.r + self.rv*dt
	end
	if input:down('up') and not self.v_timer then
		self.move = true
		self.v = math.min(self.v + self.a*dt, self.max_v)
	end
	if input:down('down') and not self.v_timer then
		self.move = true
		self.v = math.max(self.v - self.a*dt, 100)
	end

	self.propeler_r_min = 10
	self.propeler_r_max = 15
	self.propeler_c1 = colors.white
	self.propeler_c2 = colors.propeler_yellow
	self.propeler_c3 = colors.propeler_red

	if input:down('boost') then
		self.move = true
		self.v = math.min(self.v + self.a*dt, 2*self.max_v)
		self.propeler_c1 = colors.propeler_blue
		self.propeler_c2 = colors.white
		self.propeler_c3 = colors.propeler_blue
	end
	if input:released('boost') and self.v > self.max_v then
		self.move = true
		self.v_timer = self.timer:tween(0.5, self, {v = self.max_v}, 'linear', function ()
			self.v_timer = nil
		end)
	end

	if self.v < 250 then
		self.propeler_r_min = 5
		self.propeler_r_max = 10
	end

	if self.move then
		self.move = false
		self.collider:setLinearVelocity(self.v * math.cos(self.r-math.pi/2), self.v * math.sin(self.r-math.pi/2))
	end
end

function Player:draw ()
	love.graphics.setColor(colors.white)
	love.graphics.draw(self.sprite, self.x, self.y, self.r, 1, 1, self.sprite:getWidth()/2, self.sprite:getHeight()/2)
end

function Player:shoot ()
	local d = self.w;

	self.area:addGameObject('ShootEffect',
		self.x + d * math.cos(self.r-math.pi/2), self.y + d * math.sin(self.r-math.pi/2),
		{player = self, d = d})
	self.area:addGameObject('Shot',
		self.x + d * math.cos(self.r-math.pi/2), self.y + d * math.sin(self.r-math.pi/2),
		{r = self.r, pv = self.v})
end

function Player:shield ()
	self.shield_obj = self.area:addGameObject('Shield', self.x, self.y, {w = 1.5*self.w})
	self.joint = self.area.world:addJoint('RevoluteJoint', self.collider, self.shield_obj.collider, self.x, self.y, false)
end
function Player:unshield ()
	self.area.world:removeJoint(self.joint)
	self.shield_obj:die()
	self.joint = nil
	self.shield_obj = nil
end
