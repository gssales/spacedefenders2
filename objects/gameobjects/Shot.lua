Shot = GameObject:extend()

function Shot:new(area, x, y, opts)
	Shot.super.new(self, area, x, y, opts)

	self.s = opts.s or 8
	self.v = opts.v or 1000
	self.pv = opts.pv or 0
	self.v = self.v + self.pv

	self.current_sprite = true

	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.s)
	self.collider:setObject(self)
	self.collider:setLinearVelocity(self.v * math.cos(self.r-math.pi/2), self.v * math.sin(self.r-math.pi/2))

	self.timer:after(5, function ()
		self:die()
	end )

	self.timer:every(0.05, function ()
		self.current_sprite = not self.current_sprite
	end )
end

function Shot:update(dt)
	Shot.super.update(self, dt)

	self.collider:setLinearVelocity(self.v * math.cos(self.r-math.pi/2), self.v * math.sin(self.r-math.pi/2))
end

function Shot:draw()
	pushRotate(self.x, self.y, Vector(self.collider:getLinearVelocity()):angleTo()+math.pi/2)
	love.graphics.setColor(colors.white)
	local i
	if self.current_sprite then i = shot1_sprite
	else i = shot2_sprite end
    love.graphics.draw(i, self.x, self.y, 0, 0.5, 0.5,
		i:getWidth()/2, i:getHeight()/2)
    love.graphics.pop()
end

function Shot:die()
	self.dead = true;
end
