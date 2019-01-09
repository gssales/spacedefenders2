AsteroidDigger = Enemy:extend()

function AsteroidDigger:new (area, x, y, opts)
	AsteroidDigger.super.new(self, area, x, y, opts)

	self.r = opts.r or 0
	self.rv = math.pi/3
	self.v = 400
	self.integrity = 50
	self.shoot_angle = math.pi/4
	self.shoot_distance = 200

	self.sprite = enemy6

	self.timer:every(0.03, function ()
		local d = math.sqrt(42*42+32*32)
		local x1 = -d*math.cos(self.r+math.acos(42/d))
		local y1 = -d*math.sin(self.r+math.acos(42/d))
		local x2 = -d*math.cos(self.r-math.acos(42/d))
		local y2 = -d*math.sin(self.r-math.acos(42/d))
		self.area:addGameObject('PropelerParticle', self.x + x1, self.y + y1,
			{parent = self, r = randomFloat(10, 15),
			d = randomFloat(0.15, 0.25), c1 = colors.white, c2 = colors.propeler_yellow,
			c3 = colors.propeler_red})
		self.area:addGameObject('PropelerParticle', self.x + x2, self.y + y2,
			{parent = self, r = randomFloat(10, 15),
			d = randomFloat(0.15, 0.25), c1 = colors.white, c2 = colors.propeler_yellow,
			c3 = colors.propeler_red})
	end)
end

function AsteroidDigger:shoot ()
	local r = math.atan2(self.y-current_room.player.y, self.x-current_room.player.x) + math.pi
	local d = math.sqrt(math.pow(self.x-current_room.player.x, 2) + math.pow(self.y-current_room.player.y, 2))
	if math.abs(self.r - r) < self.shoot_angle and d < self.shoot_distance then
		self.area:addGameObject('EnemyChargeAttackEffect', self.x, self.y, {d = 1.25*self.w, enemy = self})
		self.v = self.v/4
		self.timer:after(1.5, function ()
			local d = 1.25*self.w
			self.area:addGameObject('ShootEffect',
				self.x + d * math.cos(self.r), self.y + d * math.sin(self.r),
				{player = self, d = d})
			self.area:addGameObject('Shot',
				self.x + d * math.cos(self.r), self.y + d * math.sin(self.r),
				{r = self.r, pv = self.v, shooter = 'enemy', damage = 20})
			self.timer:after(0.1, function ()
				local d = 1.25*self.w
				self.area:addGameObject('ShootEffect',
					self.x + d * math.cos(self.r), self.y + d * math.sin(self.r),
					{player = self, d = d})
				self.area:addGameObject('Shot',
					self.x + d * math.cos(self.r), self.y + d * math.sin(self.r),
					{r = self.r, pv = self.v, shooter = 'enemy', damage = 20})
				self.timer:after(0.1, function ()
					local d = 1.25*self.w
					self.area:addGameObject('ShootEffect',
						self.x + d * math.cos(self.r), self.y + d * math.sin(self.r),
						{player = self, d = d})
					self.area:addGameObject('Shot',
						self.x + d * math.cos(self.r), self.y + d * math.sin(self.r),
						{r = self.r, pv = self.v, shooter = 'enemy', damage = 20})
					self.v = self.v * 4
					self:setBehavior('escape')
					self.timer:after(2, function ()
						self:setBehavior('follow')
					end )
				end)
			end)
		end)
		self.can_shoot = false
		self.timer:after(randomFloat(6, 8), function ()
			self.can_shoot = true
		end )

	end
end
