Shot = GameObject:extend()

function Shot:new(area, x, y, opts)
	Shot.super.new(self, area, x, y, opts)
	self.depth = 45

	self.s = opts.s or 10
	self.v = opts.v or 1000
	self.pv = opts.pv or 0
	self.v = self.v + self.pv

	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.s)
	self.setCollisionClass('Shot')
	self.collider:setObject(self)
	self.collider:setLinearVelocity(self.v * math.cos(self.r-math.pi/2), self.v * math.sin(self.r-math.pi/2))

	self.timer:after(5, function ()
		self:die()
	end )

end

function Shot:update(dt)
	Shot.super.update(self, dt)

	self.collider:setLinearVelocity(self.v * math.cos(self.r-math.pi/2), self.v * math.sin(self.r-math.pi/2))
end

function Shot:draw()
	pushRotate(self.x, self.y, Vector(self.collider:getLinearVelocity()):angleTo()+math.pi/2)
	love.graphics.setColor(colors.white)
    love.graphics.draw(shot_sprite, self.x, self.y, 0, 0.75, 0.75,
		shot_sprite:getWidth()/2, shot_sprite:getHeight()/6)
    love.graphics.pop()
end

function Shot:die()
	self.dead = true;
end
