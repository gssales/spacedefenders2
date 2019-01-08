CometLander = Enemy:extend()

function CometLander:new (area, x, y, opts)
	CometLander.super.new(self, area, x, y, opts)

	self.r = opts.r or 0
	self.rv = math.pi/2
	self.v = 300
	self.integrity = 50
	self.shoot_angle = math.pi/4
	self.shoot_distance = 500

	self.sprite = enemy2
end

function CometLander:shoot ()
	local r = math.atan2(self.y-current_room.player.y, self.x-current_room.player.x) + math.pi
	local d = math.sqrt(math.pow(self.x-current_room.player.x, 2) + math.pow(self.y-current_room.player.y, 2))
	if math.abs(self.r - r) < self.shoot_angle and d < self.shoot_distance then
		self.area:addGameObject('EnemyChargeAttackEffect', self.x, self.y, {d = 1.25*self.w, enemy = self, plus_r = -math.pi/2})
		self.area:addGameObject('EnemyChargeAttackEffect', self.x, self.y, {d = 1.25*self.w, enemy = self, plus_r = math.pi/2})
		self.timer:after(1.5, function ()
			local d = 1.25*self.w
			self.area:addGameObject('ShootEffect',
				self.x + d * math.cos(self.r+math.pi/2), self.y + d * math.sin(self.r+math.pi/2),
				{player = self, d = d, plus_r = math.pi/2})
			self.area:addGameObject('ShootEffect',
				self.x + d * math.cos(self.r-math.pi/2), self.y + d * math.sin(self.r-math.pi/2),
				{player = self, d = d, plus_r = -math.pi/2})
			self.area:addGameObject('Shot',
				self.x + d * math.cos(self.r-math.pi/2), self.y + d * math.sin(self.r-math.pi/2),
				{r = self.r, pv = self.v, shooter = 'enemy'})
			self.area:addGameObject('Shot',
				self.x + d * math.cos(self.r+math.pi/2), self.y + d * math.sin(self.r+math.pi/2),
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
