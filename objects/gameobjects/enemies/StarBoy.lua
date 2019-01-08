StarBoy = Enemy:extend()

function StarBoy:new (area, x, y, opts)
	StarBoy.super.new(self, area, x, y, opts)

	self.r = opts.r or 0
	self.rv = math.pi/3
	self.v = 300
	self.integrity = 50
	self.shoot_angle = math.pi/6
	self.shoot_distance = 400
end
