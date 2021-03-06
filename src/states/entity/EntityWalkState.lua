--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

EntityWalkState = Class{__includes = BaseState}

function EntityWalkState:init(entity, room)
    self.entity = entity
    self.entity:changeAnimation('walk-down')

    self.room = room

    -- used for AI control
    self.moveDuration = 0
    self.movementTimer = 0

    -- keeps track of whether we just hit a wall or a solid object
    self.bumped = false
end

function EntityWalkState:update(dt)
    
    -- assume we didn't hit a wall
    self.bumped = false
    
    if self.room ~= nil and self.entity:checkObjectsCollision(self.room.objects) then
        self.bumped = true
    end

    -- boundary checking on all sides, allowing us to avoid collision detection on tiles
    if self.entity.direction == 'left' then
        self.entity.x = self.entity.x - self.entity.walkSpeed * dt
        
        if self.entity.x <= MAP_LEFT_EDGE then 
            self.bumped = true
        end
    elseif self.entity.direction == 'right' then
        self.entity.x = self.entity.x + self.entity.walkSpeed * dt

        if self.entity.x + self.entity.width >= MAP_RIGHT_EDGE then
            self.bumped = true
        end
    elseif self.entity.direction == 'up' then
        self.entity.y = self.entity.y - self.entity.walkSpeed * dt

        if self.entity.y <= MAP_TOP_EDGE - self.entity.height / 2 then 
            self.bumped = true
        end
    elseif self.entity.direction == 'down' then
        self.entity.y = self.entity.y + self.entity.walkSpeed * dt

        if self.entity.y + self.entity.height >= MAP_BOTTOM_EDGE then
            self.bumped = true
        end
    end

end

function EntityWalkState:processAI(params, dt)
    local room = params.room
    local directions = {'left', 'up', 'right', 'down'}

    if self.moveDuration == 0 then
        
        -- set an initial move duration and direction
        self.moveDuration = math.random(5)
        self.entity.direction = directions[math.random(#directions)]
        self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
    elseif self.bumped then
        self:unstuck(dt)

        -- set an initial move duration and direction
        self.moveDuration = math.random(3)
        local newDirection = 2
        for k, direction in pairs(directions) do
            if directions[k] == self.entity.direction then
                newDirection = ((k + 1) % 4) + 1
            end
        end

        self.entity.direction = directions[newDirection]
        self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
    elseif self.movementTimer > self.moveDuration then
        self.movementTimer = 0

        -- chance to go idle
        if math.random(3) == 1 then
            self.entity:changeState('idle')
        else
            self.moveDuration = math.random(5)
            self.entity.direction = directions[math.random(#directions)]
            self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
        end
    end

    self.movementTimer = self.movementTimer + dt
end

function EntityWalkState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
    
    -- debug code
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end

function EntityWalkState:unstuck(dt)
    if self.entity.direction == 'left' then
        self.entity.x = self.entity.x + self.entity.walkSpeed * dt * 2
    elseif self.entity.direction == 'right' then
        self.entity.x = self.entity.x - self.entity.walkSpeed * dt * 2
    elseif self.entity.direction == 'up' then
        self.entity.y = self.entity.y + self.entity.walkSpeed * dt * 2
    elseif self.entity.direction == 'down' then
        self.entity.y = self.entity.y - self.entity.walkSpeed * dt * 2
    end
end