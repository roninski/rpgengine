-- mainmenu.lua
-- Luke Alderman
-- Creation Date: 21/02/15
-- Last Updated: 21/02/15
--[[
Usage:
Stack:push()	|	Add an item to the stack	
Stack:pop()		|	Remove an item from the stack and return it
Stack:top()		|	Return the item at the top of the stack
Stack:isEmpty()	|	Return true if stack is empty, otherwise false
]]--
Stack = {}
Stack.__index = Stack

setmetatable(Stack, {
		__call = function (cls, ...)
    	local self = setmetatable({}, cls)
    	self:_init(...)
    	return self
	end,
})

-- Create a new Stack
function Stack:_init()
	self.index = 0
end

-- Push an item onto the stack
function Stack:push(toPush)
	self.index = self.index + 1
	self[self.index] = toPush
end

-- Pop off the stack and return the result
function Stack:pop()
	local temp = self[self.index]
	self[self.index] = nil
	self.index = self.index - 1
	return temp
end

-- Return the top item on the stack
function Stack:top()
	return self[self.index]
end

-- Return true if stack is empty, else false
function Stack:isEmpty()
	if self.index == 0 then
		return true
	end
	return false
end

return Stack