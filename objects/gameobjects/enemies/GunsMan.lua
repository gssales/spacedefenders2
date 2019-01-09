GunsMan = Enemy:extend()

function GunsMan:new (area, x, y, opts)
	GunsMan.super.new(self, area, x, y, opts)

	self.r = opts.r or 0
	self.rv = 3*math.pi/4
	self.v = 400
	self.integrity = 70
	self.shoot_angle = math.pi/6
	self.shoot_distance = 700

	self.sprite = enemy4

	self.timer:every(0.03, function ()
		local d = math.sqrt(56*56+24*24)
		local x1 = -d*math.cos(self.r+math.acos(56/d))
		local y1 = -d*math.sin(self.r+math.acos(56/d))
		local x2 = -d*math.cos(self.r-math.acos(56/d))
		local y2 = -d*math.sin(self.r-math.acos(56/d))
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

function GunsMan:shoot ()
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
				{r = self.r, pv = self.v, shooter = 'enemy'})
			self.timer:after(0.5, function ()
				local d = 1.25*self.w
				self.area:addGameObject('ShootEffect',
					self.x + d * math.cos(self.r), self.y + d * math.sin(self.r),
					{player = self, d = d})
				self.area:addGameObject('Shot',
					self.x + d * math.cos(self.r), self.y + d * math.sin(self.r),
					{r = self.r, pv = self.v, shooter = 'enemy'})
				self.timer:after(0.5, function ()
					local d = 1.25*self.w
					self.area:addGameObject('ShootEffect',
						self.x + d * math.cos(self.r), self.y + d * math.sin(self.r),
						{player = self, d = d})
					self.area:addGameObject('Shot',
						self.x + d * math.cos(self.r), self.y + d * math.sin(self.r),
						{r = self.r, pv = self.v, shooter = 'enemy'})
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
