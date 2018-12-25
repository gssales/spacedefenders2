Background = GameObject:extend()

function Background:new (area, x, y, opts)
	Background.super.new(self, area, x, y, opts)
	self.depth = 0

	self.backgroundImage = love.graphics.newImage('/resources/images/background10.png')
	self.px, self.py = 0, 0
	self.x, self.y = 0, 0
end

function Background:update (dt)
	Background.super.update(self, dt)

	self.x = math.floor(self.px / self.backgroundImage:getWidth())
	self.y = math.floor(self.py / self.backgroundImage:getHeight())
end

function Background:draw ()
	love.graphics.setColor(colors.white)
	for i=-1,2 do
		for j=-1,1 do
			love.graphics.draw(self.backgroundImage,
				(self.x + i) * self.backgroundImage:getWidth(),
				(self.y + j) * self.backgroundImage:getHeight())
		end
	end
end

function Background:follow (px, py)
	self.px, self.py = px, py
end
