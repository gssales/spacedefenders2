StarBoy = Enemy:extend()

function StarBoy:new (area, x, y, opts)
	StarBoy.super.new(self, area, x, y, opts)

	self.r = opts.r or 0
	self.rv = math.pi/3
	self.v = 300
	self.integrity = 50
	self.shoot_angle = math.pi/6
	self.shoot_distance = 400

	self.sprite = enemy1

	self.timer:every(0.03, function ()
		local d = math.sqrt(36*36+48*48)
		local x1 = -d*math.cos(self.r+math.acos(36/d))
		local y1 = -d*math.sin(self.r+math.acos(36/d))
		local x2 = -d*math.cos(self.r-math.acos(36/d))
		local y2 = -d*math.sin(self.r-math.acos(36/d))
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
