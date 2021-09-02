--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerWalkPotState = Class{__includes = EntityWalkState}

function PlayerWalkPotState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite; negated in render function of state
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerWalkPotState:update(dt)
    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('walk-pot-left')
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('walk-pot-right')
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('walk-pot-up')
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        self.entity:changeAnimation('walk-pot-down')
    else
        self.entity:changeState('idle-pot')
    end

    if love.keyboard.wasPressed('space') then
        self.entity:throwPot()
    end

    -- perform base collision detection
    EntityWalkState.update(self, dt)
    if self.entity:checkObjectsCollision(self.dungeon.currentRoom.objects) then
        self.bumped = true
    end
    
    -- if we bumped something when checking collision, check any object collisions
    if self.bumped then
        if self.entity.direction == 'left' then
            -- temporarily adjust position into the wall, since bumping pushes outward
            self.entity.x = self.entity.x - PLAYER_WALK_SPEED * dt
            -- readjust
            self.entity.x = self.entity.x + PLAYER_WALK_SPEED * dt * 2
        elseif self.entity.direction == 'right' then
            -- temporarily adjust position
            self.entity.x = self.entity.x + PLAYER_WALK_SPEED * dt
            -- readjust
            self.entity.x = self.entity.x - PLAYER_WALK_SPEED * dt * 2
        elseif self.entity.direction == 'up' then
            -- temporarily adjust position
            self.entity.y = self.entity.y - PLAYER_WALK_SPEED * dt
            -- readjust
            self.entity.y = self.entity.y + PLAYER_WALK_SPEED * dt * 2
        else
            -- temporarily adjust position
            self.entity.y = self.entity.y + PLAYER_WALK_SPEED * dt
            -- readjust
            self.entity.y = self.entity.y - PLAYER_WALK_SPEED * dt * 2
        end
    end
end

--[[ function PlayerWalkPotState:checkDoorwayCollision(direction)
    
    for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
        if self.entity:collides(doorway) and doorway.open then

            -- shift entity to center of door to avoid phasing through wall
            if direction == 'shift-up' or direction == 'shift-down' then
                self.entity.y = doorway.y + 4
            else
                self.entity.x = doorway.x + 8
            end

            Event.dispatch(direction)
        end
    end
end ]]