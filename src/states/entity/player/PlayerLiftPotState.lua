--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerLiftPotState = Class{__includes = BaseState}

function PlayerLiftPotState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon

    self:checkPotCollision()
    self.entity:changeAnimation('lift-pot-' .. self.entity.direction)
end

function PlayerLiftPotState:enter(params)
    --gSounds['sword']:play()
end

function PlayerLiftPotState:update(dt)
    -- if we've fully elapsed through one cycle of animation, change back to idle state
    if self.entity.currentAnimation.timesPlayed > 0 then
        self.entity.currentAnimation.timesPlayed = 0
        if self.pot == nil then
            self.entity:changeState('idle')
        else
            self:grabPot(self.pot)
            self.entity:changeState('idle-pot')
        end
    end
end

function PlayerLiftPotState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
end

function PlayerLiftPotState:checkPotCollision()
    local displacemetSize = 2
    -- temporarily adjust position
    if self.entity.direction == 'left' then
        self.entity.x = self.entity.x - displacemetSize
    elseif self.entity.direction == 'right' then
        self.entity.x = self.entity.x + displacemetSize
    elseif self.entity.direction == 'up' then
        self.entity.y = self.entity.y - displacemetSize
    else
        self.entity.y = self.entity.y + displacemetSize
    end

    
    local collidingObject = self.entity:getObjectsCollision(self.dungeon.currentRoom.objects)
    if(collidingObject ~= nil and collidingObject.type == 'pot') then
        self.pot = collidingObject
    end

    
    -- readjust
    if self.entity.direction == 'left' then
        self.entity.x = self.entity.x + displacemetSize
    elseif self.entity.direction == 'right' then
        self.entity.x = self.entity.x - displacemetSize
    elseif self.entity.direction == 'up' then
        self.entity.y = self.entity.y + displacemetSize
    else
        self.entity.y = self.entity.y - displacemetSize
    end
end

function PlayerLiftPotState:grabPot(pot)
    pot.solid = false
    self.entity.pot = pot
end
