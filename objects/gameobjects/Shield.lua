Shield = GameObject:extend()

function Shield:new (area, x, y, opts)
	Shield.super.new(self, area, x, y, opts)
	self.depth = 60

	self.w = opts.w or 80
	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
	self.collider:setCollisionClass('Shield')
	self.collider:setObject(self)

end

function Shield:update (dt)
	Shield.super.update(self, dt)

	if self.player then
		self.x = self.player.x
		self.y = self.player.y
	end
end

function Shield:draw ()
	love.graphics.setColor(colors.propeler_blue)
	love.graphics.setLineWidth(4)
	love.graphics.circle('line', self.x, self.y, self.w)
	love.graphics.setLineWidth(1)
	love.graphics.setColor(colors.shield_blue)
	draft:bow(self.x, self.y, 1.8*self.w, 5*math.pi/6, math.pi/12, 3)
end
