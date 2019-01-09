LightJumper = Enemy:extend()

function LightJumper:new (area, x, y, opts)
	LightJumper.super.new(self, area, x, y, opts)

	self.r = opts.r or 0
	self.rv = math.pi
	self.v = 800
	self.integrity = 100
	self.shoot_angle = nil
	self.shoot_distance = nil

	self.sprite = enemy9

	self.target_x = randomFloat(-400, -400)
	self.target_y = randomFloat(-400, -400)
	print(self.target_x, self.target_y)

	self.timer:every(0.02, function ()
		local d = 32
		local x1 = -d*math.cos(self.r)
		local y1 = -d*math.sin(self.r)
		self.area:addGameObject('PropelerParticle', self.x + x1, self.y + y1,
			{parent = self, r = randomFloat(5, 10), d = randomFloat(0.15, 0.25),
			c1 = colors.white, c2 = colors.propeler_yellow, c3 = colors.propeler_red})
	end)
end

function LightJumper:follow (dt)
	local r = math.atan2(self.y-self.target_y, self.x-self.target_x) + math.pi
	local d = math.sqrt(math.pow(self.x-self.target_x, 2) + math.pow(self.y-self.target_y, 2))
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
	if self.can_shoot and d < 100 then
		self:shoot()
	end
	self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))
end

function Enemy:shoot ()
	local r = math.atan2(self.y-current_room.player.y, self.x-current_room.player.x) + math.pi
	local d = math.sqrt(math.pow(self.x-current_room.player.x, 2) + math.pow(self.y-current_room.player.y, 2))
	if true then
		self.area:addGameObject('EnemyChargeAttackEffect', self.x, self.y, {d = 32, enemy = self, duration = 1})
		self.v = self.v / 10
		self.target_x = current_room.player.x
		self.target_y = current_room.player.y
		self.timer:after(1, function ()
			local d = 32
			self.area:addGameObject('ShootEffect',
				self.x + d * math.cos(self.r), self.y + d * math.sin(self.r),
				{player = self, d = d})
			self.area:addGameObject('Shot',
				self.x + d * math.cos(self.r), self.y + d * math.sin(self.r),
				{r = self.r, pv = self.v, shooter = 'enemy'})
			self.timer:after(0.5, function () self.v = self.v * 10 end)
			self:setBehavior('escape')
			self.timer:after(0.5, function ()
				self.target_x = randomFloat(current_room.player.x-100, current_room.player.x+100)
				self.target_y = randomFloat(current_room.player.y-100, current_room.player.y+100)
				print(self.target_x, self.target_y)
				self:setBehavior('follow')
			end )
		end)
		self.can_shoot = false
		self.timer:after(randomFloat(2, 3), function ()
			self.can_shoot = true
		end )

	end
end
