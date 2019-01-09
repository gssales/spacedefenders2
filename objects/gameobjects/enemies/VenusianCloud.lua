VenusianCloud = Enemy:extend()

function VenusianCloud:new (area, x, y, opts)
	VenusianCloud.super.new(self, area, x, y, opts)

	self.r = opts.r or 0
	self.rv = math.pi/2
	self.v = 500
	self.integrity = 120
	self.shoot_angle = math.pi/2
	self.shoot_distance = 700

	self.sprite = enemy8

	self.timer:every(0.03, function ()
		local d = math.sqrt(48*48+48*48)
		local x1 = -d*math.cos(self.r+math.acos(48/d))
		local y1 = -d*math.sin(self.r+math.acos(48/d))
		local x2 = -d*math.cos(self.r-math.acos(48/d))
		local y2 = -d*math.sin(self.r-math.acos(48/d))
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

function VenusianCloud:shoot ()
	local r = math.atan2(self.y-current_room.player.y, self.x-current_room.player.x) + math.pi
	local d = math.sqrt(math.pow(self.x-current_room.player.x, 2) + math.pow(self.y-current_room.player.y, 2))
	if math.abs(self.r - r) < self.shoot_angle and d < self.shoot_distance then
		self.area:addGameObject('EnemyChargeAttackEffect', self.x, self.y, {d = 1.25*self.w, enemy = self})
		self.timer:after(1.5, function ()
			local d = self.w
			self.area:addGameObject('ShootEffect',
				self.x + d * math.cos(self.r), self.y + d * math.sin(self.r),
				{player = self, d = d, direction = self.r+math.pi/6})
			self.area:addGameObject('ShootEffect',
				self.x + d * math.cos(self.r), self.y + d * math.sin(self.r),
				{player = self, d = d, direction = self.r+math.pi/3})
			self.area:addGameObject('ShootEffect',
				self.x + d * math.cos(self.r), self.y + d * math.sin(self.r),
				{player = self, d = d})
			self.area:addGameObject('ShootEffect',
				self.x + d * math.cos(self.r), self.y + d * math.sin(self.r),
				{player = self, d = d, direction = self.r+2*math.pi/3})
			self.area:addGameObject('ShootEffect',
				self.x + d * math.cos(self.r), self.y + d * math.sin(self.r),
				{player = self, d = d, direction = self.r+5*math.pi/6})
			self.area:addGameObject('Shot',
				self.x + d * math.cos(self.r), self.y + d * math.sin(self.r),
				{r = self.r+math.pi/3, pv = self.v, shooter = 'enemy'})
			self.area:addGameObject('Shot',
				self.x + d * math.cos(self.r), self.y + d * math.sin(self.r),
				{r = self.r+math.pi/6, pv = self.v, shooter = 'enemy'})
			self.area:addGameObject('Shot',
				self.x + d * math.cos(self.r), self.y + d * math.sin(self.r),
				{r = self.r, pv = self.v, shooter = 'enemy'})
			self.area:addGameObject('Shot',
				self.x + d * math.cos(self.r), self.y + d * math.sin(self.r),
				{r = self.r-math.pi/3, pv = self.v, shooter = 'enemy'})
			self.area:addGameObject('Shot',
				self.x + d * math.cos(self.r), self.y + d * math.sin(self.r),
				{r = self.r-math.pi/6, pv = self.v, shooter = 'enemy'})
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
