-- Town.lua
-- Luke Alderman
-- Creation Date: 21/02/15
-- Last Updated: 21/02/15
--[[
Usage:
Replace Town with the name of the new state
]]--
-- Imports
State = require("src.state")

-- Initialisation
Town = {}
Town.__index = Town

setmetatable(Town, {
		__index = State, -- this is what makes the inheritance work
		__call = function (cls, ...)
	    local self = setmetatable({}, cls)
	    self:_init(...)
	    return self
  	end,
})

function Town:_init()
	self.machineAction = false
	self.machineToDo = "surprise!"
	self.machineTo = "it's a state!"
	self.background = love.graphics.newImage("res/img/mainmenu/surprise.png")
end

-- To be called immediately after the state is pushed
function State:onPush(player)
	self.player = player
end

-- To be called by the parent update function
function State:update(dt)
	if love.keyboard.isDown("x") then
		self.machineAction = true
		self.machineToDo = "pop"
	end
end

-- To be called by the parent draw function
function Town:draw()
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(self.background,0,0)
	love.graphics.print("Welcome to the Hotel "..self.player.activeTown, 40, 40)
end

-- To be called immediately before the state is popped
function State:onPop()

end

return Town