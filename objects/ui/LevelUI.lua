LevelUI = Object:extend()

function LevelUI:new (room, color)
	self.room = room
	self.timer = Timer()

	self.integrity_late_w = 256
	self.integrity_w = 256

	self.boost_w = 256

	self.font = fonts.m5x7_32
end

function LevelUI:update (dt)
	self.timer:update(dt)

	self.boost_w = 256*self.room.player.boost/self.room.player.max_boost

	self.font = fonts.m5x7_32
	love.graphics.setFont(self.font)

end

function LevelUI:draw ()
	love.graphics.setColor(96/255, 0/255, 0/255)
	love.graphics.rectangle('fill', gw/2-264, gh-48, self.integrity_late_w, 16)
	love.graphics.setColor(110/255, 0, 0)
	love.graphics.rectangle('fill', gw/2-264, gh-48, self.integrity_w, 16)
	love.graphics.setColor(192/255, 0, 0)
	love.graphics.rectangle('fill', gw/2-264, gh-48, self.integrity_w, 8)
	love.graphics.setColor(255/255, 16/255, 16/255)
	love.graphics.rectangle('fill', gw/2-264, gh-44, self.integrity_w, 8)
	love.graphics.print('INTEGRITY', gw/2 - 132, gh - 48, 0, 1, 1,
		math.floor(self.font:getWidth('INTEGRITY')/2), self.font:getHeight())
	local text = self.room.player.integrity..'/'..self.room.player.max_integrity
	love.graphics.print(text, gw/2 - 132, gh - 32, 0, 1, 1,
		math.floor(self.font:getWidth(text)/2), 0)
	love.graphics.setColor(128/255, 16/255, 16/255)
	love.graphics.rectangle('line', gw/2-264, gh-48, 256, 16)

	love.graphics.setColor(0, 0, 110/255)
	love.graphics.rectangle('fill', gw/2+8, gh-48, self.boost_w, 16)
	love.graphics.setColor(0, 0, 192/255)
	love.graphics.rectangle('fill', gw/2+8, gh-48, self.boost_w, 8)
	love.graphics.setColor(64/255, 64/255, 255/255)
	love.graphics.rectangle('fill', gw/2+8, gh-44, self.boost_w, 8)
	love.graphics.print('BOOST', gw/2 + 132, gh - 48, 0, 1, 1,
		math.floor(self.font:getWidth('BOOST')/2), self.font:getHeight())
	local text = math.floor(self.room.player.boost)..'/'..self.room.player.max_boost
	love.graphics.print(text, gw/2 + 132, gh - 32, 0, 1, 1,
		math.floor(self.font:getWidth(text)/2), 0)
	love.graphics.setColor(16/255, 16/255, 128/255)
	love.graphics.rectangle('line', gw/2+8, gh-48, 256, 16)

end

function LevelUI:integrityHit ()
	if self.integrity_timer then self.timer:cancel(self.integrity_timer) end
	self.integrity_timer = self.timer:tween(0.1, self,
			{integrity_w = 256*self.room.player.integrity/self.room.player.max_integrity}, 'linear', function ()
		self.integrity_timer = self.timer:tween(1, self,
				{integrity_late_w = 256*self.room.player.integrity/self.room.player.max_integrity}, 'in-out-cubic')
	end)
end
