Player = {}
Player.__index = Player

setmetatable(Player, {
		__call = function (cls, ...)
    	local self = setmetatable({}, cls)
    	self:_init(...)
    	return self
	end,
})

-- Initialise the Player
-- First parameter is a table of state classes and their names
function Player:_init(x, y)
	self.gold  = 100
	self.ship  = nil
	self.goods = {}
	self.x     = x
	self.y     = y
	self.dir = "down"
	self.activeMap = "testmap"
end

function Player:changemap(newmap)
	if (newmap ~= nil) then
		self.activemap = newmap
	end
end

return Player