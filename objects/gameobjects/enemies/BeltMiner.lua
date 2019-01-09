BeltMiner = Enemy:extend()

function BeltMiner:new (area, x, y, opts)
	BeltMiner.super.new(self, area, x, y, opts)

	self.r = opts.r or 0
	self.rv = math.pi/3
	self.v = 400
	self.integrity = 50
	self.shoot_angle = math.pi/3
	self.shoot_distance = 500

	self.sprite = enemy5

	self.timer:every(0.03, function ()
		local d = self.w*0.9
		local x = -d*math.cos(self.r)
		local y = -d*math.sin(self.r)
		self.area:addGameObject('PropelerParticle', self.x + x, self.y + y,
			{parent = self, r = randomFloat(10, 15),
			d = randomFloat(0.15, 0.25), c1 = colors.white, c2 = colors.propeler_yellow,
			c3 = colors.propeler_red})
	end)
end

function BeltMiner:follow (dt)
	local player = current_room.player
	local r = math.atan2(self.y-player.y, self.x-player.x) + math.pi
	local px = player.x+400*math.cos(r + (math.pi/2 * self.direction))
	local py = player.y+400*math.sin(r + (math.pi/2 * self.direction))
	r = math.atan2(self.y-py, self.x-px) + math.pi
	local d = math.sqrt(math.pow(self.x-px, 2) + math.pow(self.y-py, 2))
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

function BeltMiner:shoot ()
	local r = math.atan2(self.y-current_room.player.y, self.x-current_room.player.x) + math.pi
	local d = math.sqrt(math.pow(self.x-current_room.player.x, 2) + math.pow(self.y-current_room.player.y, 2))
	if d < self.shoot_distance then
		self.v = self.v / 2
		self.timer:after(1, function ()
			local d = 1.25*self.w
			self.area:addGameObject('Mine', self.x, self.y)
		end)
		self.timer:after(1.5, function ()
			self.direction = love.math.random(0, 1) == 0 and -1 or 1
			self.v = self.v * 2
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
