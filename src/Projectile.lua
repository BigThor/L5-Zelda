--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Projectile = Class{__includes = GameObject}

function Projectile:init(def, params)
    self.direction = params.direction
    self.x = params.x
    self.y = params.y

    if self.direction == 'left' then
        self.dx = -def.speed
        self.dy = 0
    elseif self.direction == 'right' then
        self.dx = def.speed
        self.dy = 0
    elseif self.direction == 'up' then
        self.dx = 0
        self.dy = -def.speed
    else
        self.dx = 0
        self.dy = def.speed
    end

    self.maxDistance = def.maxDistance
    self.damage = def.damage

    self.texture = def.texture
    self.frame = def.frame or 1

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states or {}

    self.startingX = self.x
    self.startingY = self.y

    -- dimensions
    self.width = def.width
    self.height = def.height

    -- default empty collision callback
    self.onCollide = function() end
    self.breakSound = def.breakSound
    self.broken = false
end

function Projectile:update(dt, entities)
    if self.broken then
        return
    end

    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    if self:isWallColliding() or self:checkMaxDistanceReached()  then
        self:breakProjectile()
    end
    local entityCollided = self:getEntitiesCollision(entities)
    if entityCollided ~= nil then
        entityCollided:damage(self.damage)
        self:breakProjectile()
    end
end


function Projectile:render(adjacentOffsetX, adjacentOffsetY)
    if self.broken then
        return
    end

    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
        self.x + adjacentOffsetX, self.y + adjacentOffsetY)
end

--[[
    AABB with some slight shrinkage of the box on the top side for perspective.
]]
function Projectile:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function Projectile:getEntitiesCollision(entities)
    for k, entity in pairs(entities) do
        if self:collides(entity) and not entity.dead then
            return entity
        end
    end
    return nil
end

function Projectile:isWallColliding()
    local x = self.x
    local y = self.y

    return (x < MAP_LEFT_EDGE - self.width / 2 or x > MAP_RIGHT_EDGE - self.width / 2
        or y < MAP_TOP_EDGE - self.height or y > MAP_BOTTOM_EDGE - self.height / 2
    )
end


function Projectile:checkMaxDistanceReached()
    return (math.abs(self.x - self.startingX) > self.maxDistance or 
        math.abs(self.y - self.startingY) > self.maxDistance)
end

function Projectile:breakProjectile()
    self.broken = true
    gSounds[self.breakSound]:play()
end