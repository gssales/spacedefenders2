Shield = GameObject:extend()

function Shield:new (area, x, y, opts)
	Shield.super.new(self, area, x, y, opts)
	self.depth = 60

	self.w = opts.w or 80
	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
	self.collider:setCollisionClass('Shield')
	self.collider:setMass(1)
	self.collider:setObject(self)

	self.sprite = love.graphics.newImage('/resources/sprites/shield.png')

end

function Shield:update (dt)
	Shield.super.update(self, dt)
end

function Shield:draw ()
	love.graphics.setColor(colors.propeler_blue)
	love.graphics.draw(self.sprite, self.x, self.y, 0, 0.8, 0.8, self.sprite:getWidth()/2, self.sprite:getHeight()/2)
end

function Shield:die ()
	self.dead = true
end
