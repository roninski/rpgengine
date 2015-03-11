-- WorldMap.lua
-- Luke Alderman
-- Creation Date: 21/02/15
-- Last Updated: 21/02/15
--[[
Usage:
Replace WorldMap with the name of the new state
]]--
-- Imports
State = require("src.state")
math = require("math")

-- Initialisation
WorldMap = {}
WorldMap.__index = WorldMap

setmetatable(WorldMap, {
		__index = State, -- this is what makes the inheritance work
		__call = function (cls, ...)
	    local self = setmetatable({}, cls)
	    self:_init(...)
	    return self
  	end,
})

function WorldMap:_init()
	self.machineAction = false
	self.machineToDo = "surprise!"
	self.machineTo = "it's a state!"
end

-- To be called immediately after the state is pushed
function WorldMap:onPush(player)
	self.player = player
	--self.mapsprites = love.graphics.newImage("res/img/sprites/placeholders.png")
	self.playersprites = love.graphics.newImage("res/img/sprites/boatsprites.png")
	self.mapPath = "res.map."..self.player.activeMap
	print (self.mapPath)
	self.map = require(self.mapPath)
	if (self.map.layers[1].data[0] ~= nil) then
		print ("0 is: "..self.map.layers[1].data[0])
	else
		print ("1 is: "..self.map.layers[1].data[1])
	end
	-- We're lazy and only doing layer 1
	-- These specify the x & y value of the central tile,
	-- i.e. the centrepoint of the camera, i.e. 
	self.cam_mid_x = math.floor(1280/self.map.tilesets[1].tilewidth) / 2
	if self.cam_mid_x % 1 ~= 0 then self.cam_mid_x = World.cam_mid_x + 0.5; end
	self.cam_mid_y = math.floor(720/self.map.tilesets[1].tilewidth) / 2
	if self.cam_mid_y % 1 ~= 0 then self.cam_mid_y = World.cam_mid_y + 0.5; end
	-- These will be the actual values used by the camera
	self.cam_x = 0
	self.cam_y = 0
	-- These will be the display coordinates of the ship
	-- Please work :D
	self.player_cam_x = (self.player.x - self.cam_x) * self.map.tilesets[1].tilewidth
    self.player_cam_y = (self.player.y - self.cam_y) * self.map.tilesets[1].tileheight
    -- Setup spritesheets
    self:setupMapSpritesheets()
    self:setupPlayerSpritesheet()

    -- Useful stuff
	self.moveSpeed = 0.05
	self.keypressDelay = 0
	self.keyBuffer = 0.05
	self.collideWith = {true, false, false, true, true}
	self.moved = false
	self.moveType = "camera" -- camera for when the camera moves, player when player moves
end

function WorldMap:setupMapSpritesheets()
	-- Map tileset
	self.tilesetImage = {}
	self.tilesetImage[1] = love.graphics.newImage(self.map.tilesets[1].image)
	local i = 1
	local x, y = 0, 0
	self.mapQuads = {}
	while y < self.map.tilesets[1].imageheight do
		while x < self.map.tilesets[1].imagewidth do
			self.mapQuads[i] = love.graphics.newQuad(x, y,
				self.map.tilesets[1].tilewidth, self.map.tilesets[1].tileheight,
				self.tilesetImage[1]:getWidth(), self.tilesetImage[1]:getHeight())
			x = x + self.map.tilesets[1].tilewidth
			i = i + 1
		end
		x = 0
		y = y + self.map.tilesets[1].tileheight
	end
	print (math.floor(1280/self.map.tilesets[1].tilewidth) + 2)
	self.mapSpriteBatch = love.graphics.newSpriteBatch(self.tilesetImage[1], 1000)
end

function WorldMap:setupPlayerSpritesheet()
	self.playerQuads = {}
	self.playerQuads["down"] = love.graphics.newQuad(0, 0, 32, 32, 
    		self.playersprites:getWidth(), self.playersprites:getHeight())
    self.playerQuads["up"] = love.graphics.newQuad(32, 0, 32, 32, 
    		self.playersprites:getWidth(), self.playersprites:getHeight())
    self.playerQuads["left"] = love.graphics.newQuad(64, 0, 32, 32, 
    		self.playersprites:getWidth(), self.playersprites:getHeight())
    self.playerQuads["right"] = love.graphics.newQuad(96, 0, 32, 32, 
    		self.playersprites:getWidth(), self.playersprites:getHeight())
end

-- To be called by the parent update function
function WorldMap:update(dt)
	self.keypressDelay = self.keypressDelay - dt
	if self.keypressDelay <= 0 then self.moved = false; end
	local mapData = self.map.layers[1].data

	-- Calculation for relative tile: (self.player.y) * 100 + (self.player.x) + 1
	-- This adjusts for the lack of 0 entry in the array
	if (love.keyboard.isDown("up") and self.keypressDelay <= 0 
			and self.player.y > 0) then
		if self.keypressDelay > - self.keyBuffer then self.player.dir = "up"; end
		if self.player.dir == "up" and self.collideWith[
				mapData[(self.player.y - 1)*100 + (self.player.x) + 1]] == false then
			self.player.y = self.player.y - 1
			self.moved = true
		end
		self.player.dir = "up"
		self.keypressDelay = self.moveSpeed
	
	elseif (love.keyboard.isDown("down") and self.keypressDelay <= 0 
			and self.player.y < self.map.layers[1].height - 1) then
		if self.keypressDelay > -self.keyBuffer then self.player.dir = "down"; end
		if self.player.dir == "down" and self.collideWith[
				mapData[(self.player.y + 1)*100 + (self.player.x) + 1]] == false then
			self.player.y = self.player.y + 1
			self.moved = true
		end
		self.player.dir = "down"
		self.keypressDelay = self.moveSpeed
	
	elseif (love.keyboard.isDown("left") and self.keypressDelay <= 0
			and self.player.x > 0) then
		if self.keypressDelay > -self.keyBuffer then self.player.dir = "left"; end
		if self.player.dir == "left" and self.collideWith[
				mapData[(self.player.y)*100 + (self.player.x - 1) + 1]] == false then
			self.player.x = self.player.x - 1
			self.moved = true
		end
		self.player.dir = "left"
		self.keypressDelay = self.moveSpeed
	
	elseif (love.keyboard.isDown("right") and self.keypressDelay <= 0
			and self.player.x < self.map.layers[1].width - 1) then
		if self.keypressDelay > -self.keyBuffer then self.player.dir = "right"; end
		if self.player.dir == "right" and self.collideWith[
				mapData[(self.player.y)*100 + (self.player.x + 1) + 1]] == false then
			self.player.x = self.player.x + 1
			self.moved = true
		end
		self.player.dir = "right"
		self.keypressDelay = self.moveSpeed
	end
	self:updateCamera()
	if self.moved == true then
		print (self.moveType)
	end
end

-- To be called by the parent draw function
function WorldMap:draw()
	love.graphics.setColor(255,255,255,255)
	self:displayMap()
	self:displayPlayer()
	love.graphics.setColor(56,88,97,255)
	love.graphics.print("Gold: "..self.player.gold, 1120, 34)
end

-- To be called immediately before the state is popped
function WorldMap:onPop()

end

function WorldMap:displayMap()
	love.graphics.setColor(255,255,255,255)
	-- We need to adjust the viewport to be around the ship
	-- Display the map
	self.mapSpriteBatch:bind()
	self.mapSpriteBatch:clear()
	local mapData = self.map.layers[1].data
	local mapWidth = self.map.layers[1].width
	local mapHeight = self.map.layers[1].height
	local tileHeight = self.map.tilesets[1].tileheight
	local tileWidth = self.map.tilesets[1].tilewidth
	--for y = 1, math.floor(720 / tileHeight + 1) do
	--	for x = 1, math.floor(1280 / tileWidth) do
	--		-- print (mapData[((y-1)*mapWidth) + x])
	--		self.mapSpriteBatch:add(self.mapQuads[mapData[((y-1+self.cam_y)*mapWidth) + self.cam_x + x]], 
	--			tileWidth*(x-1), tileHeight*(y-1))
	--	end
	--end
	self.mapSpriteBatch:unbind()
	if self.moved and self.moveType == "camera" then
		local xAdjust = 0
		local yAdjust = 0
		local yStart = 1
		local yEnd = math.floor(720 / tileHeight + 1)
		local xStart = 1
		local xEnd = math.floor(1280 / tileWidth)
		if self.player.dir == "up" then
			yEnd = yEnd + 1
			yAdjust = -32*(self.keypressDelay/self.moveSpeed)
		elseif self.player.dir == "down" then
			yStart = yStart - 1
			yAdjust =  32*(self.keypressDelay/self.moveSpeed)
		elseif self.player.dir == "left" then
			xEnd = xEnd + 1
			xAdjust = -32*(self.keypressDelay/self.moveSpeed)
		elseif self.player.dir == "right" then
			xStart = xStart - 1
			xAdjust =  32*(self.keypressDelay/self.moveSpeed)
		end
		for y = yStart, yEnd do
			for x = xStart, xEnd do
				-- print (mapData[((y-1)*mapWidth) + x])
				self.mapSpriteBatch:add(self.mapQuads[mapData[((y-1+self.cam_y)*mapWidth) + self.cam_x + x]], 
					tileWidth*(x-1), tileHeight*(y-1))
			end
		end
		self.mapSpriteBatch:unbind()
		love.graphics.draw(self.mapSpriteBatch, xAdjust, yAdjust)
		
		--love.graphics.draw(self.mapSpriteBatch, 0, 0)
	else
		for y = 1, math.floor(720 / tileHeight + 1) do
			for x = 1, math.floor(1280 / tileWidth) do
				-- print (mapData[((y-1)*mapWidth) + x])
				self.mapSpriteBatch:add(self.mapQuads[mapData[((y-1+self.cam_y)*mapWidth) + self.cam_x + x]], 
					tileWidth*(x-1), tileHeight*(y-1))
			end
		end
		self.mapSpriteBatch:unbind()
		love.graphics.draw(self.mapSpriteBatch, 0, 0)
	end
end

function WorldMap:displayPlayer()
	love.graphics.setColor(255,255,255,255)
	-- Adjust for ship movement
	if self.moved and self.moveType == "player" then
		if self.player.dir == "up" then
			love.graphics.draw(self.playersprites, self.playerQuads[self.player.dir], 
					self.player_cam_x, 
					self.player_cam_y + 32*(self.keypressDelay/self.moveSpeed))
		elseif self.player.dir == "down" then
			love.graphics.draw(self.playersprites, self.playerQuads[self.player.dir], 
					self.player_cam_x, 
					self.player_cam_y - 32*(self.keypressDelay/self.moveSpeed))
		elseif self.player.dir == "left" then
			love.graphics.draw(self.playersprites, self.playerQuads[self.player.dir], 
					self.player_cam_x + 32*(self.keypressDelay/self.moveSpeed), 
					self.player_cam_y)
		elseif self.player.dir == "right" then
			love.graphics.draw(self.playersprites, self.playerQuads[self.player.dir], 
					self.player_cam_x - 32*(self.keypressDelay/self.moveSpeed), 
					self.player_cam_y)
		end
	else
		love.graphics.draw(self.playersprites, self.playerQuads[self.player.dir], 
				self.player_cam_x, self.player_cam_y)
	end
end

function WorldMap:updateCamera()
	-- World.x -> self.cam_x
	-- World.display_w -> math.floor(1280/tileWidth + 1)
	-- World.w -> self.map.layers[1].width
	local tileHeight = self.map.tilesets[1].tileheight
	local tileWidth = self.map.tilesets[1].tilewidth
	local oldX, oldY = self.cam_x, self.cam_y
	self.cam_x = self.player.x - self.cam_mid_x + 1
    if self.cam_x < 0 then self.cam_x = 0; end
    if self.cam_x > self.map.layers[1].width - math.floor(1280/tileWidth) then 
    	self.cam_x = self.map.layers[1].width - math.floor(1280/tileWidth) 
    end

    self.cam_y = self.player.y - self.cam_mid_y + 1
    if self.cam_y < 0 then self.cam_y = 0; end
    if self.cam_y > self.map.layers[1].height - math.floor(720/tileHeight + 1) then 
    	self.cam_y = self.map.layers[1].height - math.floor(720/tileHeight + 1) 
    end

    self.player_cam_x = (self.player.x - self.cam_x) * self.map.tilesets[1].tilewidth
    self.player_cam_y = (self.player.y - self.cam_y) * self.map.tilesets[1].tileheight

    -- If something moves, return that it moved
    if self.keypressDelay == self.moveSpeed then
	    if self.cam_x ~= oldX or self.cam_y ~= oldY then 
	    	self.moveType = "camera"
	    else
	    	self.moveType = "player"
	    end
	end
end


return WorldMap