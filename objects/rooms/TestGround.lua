TestGround = Object:extend()

function TestGround:new ()

	self.area = Area(self)
	self.area:addPhysicsWorld()

	self.main_canvas = love.graphics.newCanvas(gw, gh)

	self.points = createIrregularPolygon(32, 16)
	timer:every(0.05, function  ()
		self.points = M.map(createIrregularPolygon(32, 8), function (c, k)
			if k % 2 == 0 then
				return c + gh/2
			else
				return c + gw/2
			end
		end )
	end)
end

function TestGround:update(dt)
	self.area:update(dt)

end

function TestGround:draw()
	love.graphics.setCanvas(self.main_canvas)
	love.graphics.clear()
	camera:attach()
		self.area:draw()
		love.graphics.polygon('line', self.points)
	camera:detach()
	love.graphics.setCanvas()

	love.graphics.setColor(colors.white)
	love.graphics.setBlendMode('alpha', 'premultiplied')
	love.graphics.draw(self.main_canvas, 0, 0, 0, sx, xy)
	love.graphics.setBlendMode('alpha')
end

function TestGround:destroy()
	self.area:destroy()
	self.area = nil
end
