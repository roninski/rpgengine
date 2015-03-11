-- StateTemplate.lua
-- Luke Alderman
-- Creation Date: 21/02/15
-- Last Updated: 21/02/15
--[[
Usage:
Replace StateTemplate with the name of the new state
]]--
-- Imports
State = require("src.state")

-- Initialisation
StateTemplate = {}
StateTemplate.__index = StateTemplate

setmetatable(StateTemplate, {
		__index = State, -- this is what makes the inheritance work
		__call = function (cls, ...)
	    local self = setmetatable({}, cls)
	    self:_init(...)
	    return self
  	end,
})

function StateTemplate:_init()
	self.machineAction = false
	self.machineToDo = "surprise!"
	self.machineTo = "it's a state!"
	self.background = love.graphics.newImage("res/img/StateTemplate/surprise.png")
end

-- To be called immediately after the state is pushed
function State:onPush()

end

-- To be called by the parent update function
function State:update(dt)

end

-- To be called by the parent draw function
function StateTemplate:draw()
	love.graphics.draw(self.background,0,0)
end

-- To be called immediately before the state is popped
function State:onPop()

end

return StateTemplate