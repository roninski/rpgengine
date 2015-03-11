-- mainmenu.lua
-- Luke Alderman
-- Creation Date: 21/02/15
-- Last Updated: 21/02/15
--[[
Usage:

]]--
-- Imports
State = require("src.state")

-- Initialisation
MainMenu = {}
MainMenu.__index = MainMenu

setmetatable(MainMenu, {
		__index = State, -- this is what makes the inheritance work
		__call = function (cls, ...)
	    local self = setmetatable({}, cls)
	    self:_init(...)
	    return self
  	end,
})

function MainMenu:_init()
	self.machineAction = false
	self.machineToDo = "surprise!"
	self.machineTo = "it's a state!"
	self.background = love.graphics.newImage("res/img/mainmenu/tallship.jpg")
	self.activeItem = 1
	self.numItems = 3
	self.keypressDelay = 0
end

function MainMenu:draw()
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(self.background,0,0)

	local items = self.numItems
	local x, y = 555, 575
	local border = 10
	local column_w = 150
	local fontsize = 25
	local padding = 8
	
	local rectangle_w = column_w + (border * 2)
	local rectangle_h = (items * (fontsize + padding)) + (border * 2)
	
	love.graphics.setFont(love.graphics.newFont(fontsize))
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.rectangle("fill", x, y, rectangle_w, rectangle_h)

	x = x + border; y = y + border
	
	-- New Game
	love.graphics.setColor(0,0,255,255)
	love.graphics.print("New Game", x, y)
	if self.activeItem == 1 then
		love.graphics.setColor(255,255,255,255)
		love.graphics.rectangle("line", x - (border / 2), y - (padding / 2), 
			column_w + border, fontsize + padding)
	end
	y = y + fontsize + padding

	-- New Game
	love.graphics.setColor(0,0,255,255)
	love.graphics.print("Load Game", x, y)
	if self.activeItem == 2 then
		love.graphics.setColor(255,255,255,255)
		love.graphics.rectangle("line", x - (border / 2), y - (padding / 2), 
			column_w + border, fontsize + padding)
	end
	y = y + fontsize + padding
	
	-- Quit Game
	love.graphics.setColor(0,0,255,255)
	love.graphics.print("Exit Game", x, y)
	if self.activeItem == 3 then
		love.graphics.setColor(255,255,255,255)
		love.graphics.rectangle("line", x - (border / 2), y - (padding / 2), 
			column_w + border, fontsize + padding)
	end
	y = y + fontsize + padding
end

function MainMenu:update(dt)
	--print (tostring(dt))
	if (self.keypressDelay > 0) then
		self.keypressDelay = self.keypressDelay - dt
	end

	local keyDelay = 0.14
	if (love.keyboard.isDown("up") and self.keypressDelay <= 0) then
		self.activeItem = self.activeItem - 1
		if (self.activeItem < 1) then
			self.activeItem = self.numItems
		end
		self.keypressDelay = keyDelay
	elseif (love.keyboard.isDown("down") and self.keypressDelay <= 0) then
		self.activeItem = self.activeItem + 1
		if (self.activeItem > self.numItems) then
			self.activeItem = 1
		end
		self.keypressDelay = keyDelay
	elseif (love.keyboard.isDown("z")) then
		if self.activeItem == 1 then
			self.machineAction = true
			self.machineToDo = "push"
			self.machineTo = "WorldMap"
		end
	end
end


return MainMenu