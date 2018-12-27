Animation = Object:extend()

function Animation:new (image, width, height, duration, scale)

	self.image = image
	self.w, self.h = width, height
	self.x, self.y = 0, 0
	self.scale = scale or 1

	self.quads = {}
	for y = 0, image:getHeight() - height, height do
		for x = 0, image:getWidth() - width, width do
			table.insert(self.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
		end
	end

	self.duration = duration
	self.currentTime = 0

	self.playing = false
end

function Animation:update (dt)
	if self.playing then
		self.currentTime = self.currentTime + dt
		if self.currentTime > self.duration then
			self.currentTime = self.currentTime - self.duration
		end
	end
end

function Animation:draw ()
	local i = math.floor(self.currentTime / self.duration * #self.quads) + 1
	love.graphics.draw(self.image, self.quads[i], self.x, self.y, 0, self.scale, self.scale, self.w/2, self.h/2)
end

function Animation:play ()
	self.playing = true
end
function Animation:stop ()
	self.playing = false
end

function Animation:follow (x, y)
	self.x, self.y = x, y
end
