-- statemachine.lua
-- Luke Alderman
-- Creation Date: 21/02/15
-- Last Updated: 21/02/15
--[[
Usage:

]]--

Stack = require("src.struct.stack")
StateMachine = {}
StateMachine.__index = StateMachine

setmetatable(StateMachine, {
		__call = function (cls, ...)
    	local self = setmetatable({}, cls)
    	self:_init(...)
    	return self
	end,
})

-- Initialise the StateMachine
-- First parameter is a table of state classes and their names
function StateMachine:_init(states, initialState, player)
	self.stack = Stack()
	self.states = states
	self.player = player
	self:push(initialState)
end

function StateMachine:push(dest)
	self.stack:push(self.states[dest]())
	self.stack:top():onPush(self.player)
end

function StateMachine:pop()
	self.stack:top():onPop()
	self.stack:pop()
end

function StateMachine:draw()
	if (self.stack:isEmpty() ~= true) then
		self.stack:top():draw()
	end
end

function StateMachine:update(dt)
	if (self.stack:isEmpty() ~= true) then
		self.stack:top():update(dt)
		if (self.stack:top().machineAction == true) then
			local toDo = self.stack:top().machineToDo
			if (toDo == "push") then
				self.stack:top().machineAction = false
				self:push(self.stack:top().machineTo)
			
			elseif (toDo == "pop") then
				self.stack:top().machineAction = false
				self:pop()
			
			elseif (toDo == "switch") then
				self.stack:top().machineAction = false
				local dest = self.stack:top().machineTo
				self.stack:top():onPop()
				self:pop()
				self:push(dest)
			end

		end
	end
end

return StateMachine