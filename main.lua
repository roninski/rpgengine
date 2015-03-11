debug = true
-- Imports
-- States:
StateMachine = require("src.statemachine")
State = require("src.state")
MainMenu = require("src.states.mainmenu")
WorldMap = require("src.states.worldmap")
-- Data Structures:
Stack = require("src.struct.stack")
-- Player
Player = require("src.player")

-- Load Functions
function love.load()
	--debug()
	stateList = {}
	stateList["MainMenu"] = MainMenu
	stateList["WorldMap"] = WorldMap
	sm = StateMachine(stateList, "MainMenu", Player(35,35))
end

-- Update Functions
function love.update(dt)
	sm:update(dt)
end

-- Drawing Functions
function love.draw()
	sm:draw()
end
 
-- Button Press Buttons
function love.mousepressed(x, y, button)

end
 
function love.mousereleased(x, y, button)

end
 
function love.keypressed(key, unicode)

end
 
function love.keyreleased(key)

end

function love.textinput(text)

end

function debug()
	print ("-- State Test Begin --")
	test1 = State()
	test2 = State()
	test3 = MainMenu()
	stacktest1 = Stack()
	test2.machineAction = true
	test2.machineToDo = "push"
	test2.machineTo = "tester"
	test1:debug()
	test2:debug()
	test3:debug()
	print(" ")
	print("-- Stack Test Begin --")
	-- Print 1-2-3 with top()
	stacktest1:push(test3)
	stacktest1:push(test2)
	stacktest1:push(test1)
	while (stacktest1:isEmpty() ~= true) do
		stacktest1:top():debug()
		stacktest1:pop()
	end
	-- Print 3-2-1 with pop()
	stacktest1:push(test1)
	stacktest1:push(test2)
	stacktest1:push(test3)
	while (stacktest1:isEmpty() ~= true) do
		stacktest1:pop():debug()
	end
end
