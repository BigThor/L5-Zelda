--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)
    self.pot = nil
end

function Player:update(dt)
    Entity.update(self, dt)

    if self.pot ~= nil then
        self:potFollowPlayer()
    end
end

function Player:collides(target)
    local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2
    
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                selfY + selfHeight < target.y or selfY > target.y + target.height)
end

function Player:render()
    Entity.render(self)
    
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end

function Player:potFollowPlayer()
    self.pot.x = self.x
    self.pot.y = self.y - self.height/2 + 2
end

function Player:throwPot(room)
    room:generateProjectile(
        GAME_PROJECTILE_DEFS['pot'],
        {
            direction = self.direction,
            x = self.x,
            y = self.y
        }
    )
    local pot = self.pot
    pot.destroyed = true
    self.pot = nil
    self:changeState('idle')
    return pot
end