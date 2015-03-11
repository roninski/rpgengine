-- state.lua
-- Class base for different states
--[[
Using State:
State has three primary variables to be accessed from outside of the State class:
State.machineAction	|	This flag determines whether an action should be made by the
						state machine to change state. If true, we change state.
State.machineToDo	|	This string has three states: push, pop and switch.
						Push pushes on machineTo's state
						Pop pops this state off the stack and returns to last state
						Switch pops this state off then pushes on machineTo's state
State.machineTo		|	This string holds the destination state for push and switch

Here is the interface for State:
State:onPush()		|	This is called immediately after pushing onto the state
						machine before any other actions are made
State:update()		|	The update function for the state, to be called by the
						parent update function
State:draw()		|	This draw function for the state, to be called by the parent
						draw function
State:onPop()		|	This is called immediately before popping the state off the
						state machine
]]--

State = {}
State.__index = State

setmetatable(State, {
		__call = function (cls, ...)
    	local self = setmetatable({}, cls)
    	self:_init(...)
    	return self
	end,
})

-- Create a new state
function State:_init()
	self.machineAction = false
	self.machineToDo = "none"
	self.machineTo = "none"
end

-- To be called immediately after the state is pushed
function State:onPush()

end

-- To be called by the parent update function
function State:update(dt)

end

-- To be called by the parent draw function
function State:draw()

end

-- To be called immediately before the state is popped
function State:onPop()

end

-- Testing function
function State:debug()
	print ("machine action: "..tostring(self.machineAction))
	print ("machine to do:  "..self.machineToDo)
	print ("machine to:     "..self.machineTo)
end

return State
