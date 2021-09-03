GAME_PROJECTILE_DEFS = {
    ['pot'] = {
        type = 'pot',
        speed = 200,
        maxDistance = 64,
        damage = 1,
        texture = 'tiles',
        frame = POT_FRAME,
        breakSound = 'pot-break',
        width = 16,
        height = 16,
        solid = true,
        defaultState = 'flying',
        states = {
            ['flying'] = {
                frame = POT_FRAME
            }
        }
    }
}