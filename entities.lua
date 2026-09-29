local Config = require("config")

local Entities = {}

local function distance(first, second)
    if not first or not second then
        return 0
    end

    local dx = first.x - second.x
    local dy = first.y - second.y

    return math.sqrt(dx * dx + dy * dy)
end

local function spawnEnemy(game)
    local side = math.random(4)
    local newX, newY

    if side == 1 then
        newX = math.random(0, game.width)
        newY = -Config.OUT_OF_SCREEN_DIFFERENCE
    elseif side == 2 then
        newX = math.random(0, game.width)
        newY = game.height + Config.OUT_OF_SCREEN_DIFFERENCE
    elseif side == 3 then
        newX = -Config.OUT_OF_SCREEN_DIFFERENCE
        newY = math.random(0, game.height)
    else
        newX = game.width + Config.OUT_OF_SCREEN_DIFFERENCE
        newY = math.random(0, game.height)
    end

    table.insert(game.enemies, {
        x = newX,
        y = newY,
        speed = Config.ENEMY_SPEED,
        texture = game.assets.enemyTexture,
        scale = game.player.scale
    })
end

function Entities.clear(game)
    for i = #game.enemies, 1, -1 do
        table.remove(game.enemies, i)
    end
    for i = #game.bullets, 1, -1 do
        table.remove(game.bullets, i)
    end
end

function Entities.update(game, dt, restartGame)
    for i = #game.bullets, 1, -1 do
        local bullet = game.bullets[i]
        bullet.x = (bullet.x + bullet.speed * math.cos(bullet.angle) * dt) % game.width
        bullet.y = (bullet.y + bullet.speed * math.sin(bullet.angle) * dt) % game.height
    end

    game.enemyTimer = game.enemyTimer + dt
    if game.enemyTimer > game.enemySpawnCooldown then
        game.enemyTimer = 0
        game.enemySpawnCooldown = game.enemySpawnCooldown + 0.05
        for i = 1, game.score / 10 + 1 do
            spawnEnemy(game)
        end
    end

    for i = #game.enemies, 1, -1 do
        local enemy = game.enemies[i]

        if enemy == nil then
            table.remove(game.enemies, i)
        else
            local dx, dy = game.player.x - enemy.x, game.player.y - enemy.y
            local length = math.sqrt(dx * dx + dy * dy)

            if length > game.player.texture:getWidth() * game.player.scale / 2 then
                dx, dy = dx / length, dy / length
                enemy.x = enemy.x + dx * enemy.speed * dt
                enemy.y = enemy.y + dy * enemy.speed * dt
            else
                restartGame()
            end

            local enemyAngle = math.atan2(dy, dx)
            enemy.scaleX = enemy.scale
            if enemyAngle > math.pi / 2 or enemyAngle < -math.pi / 2 then
                enemy.scaleX = -enemy.scale
            end
        end
    end

    for i = #game.bullets, 1, -1 do
        local bullet = game.bullets[i]

        if bullet == nil then
            table.remove(game.bullets, i)
        else
            if distance(game.player, bullet) < (game.player.texture:getWidth() * game.player.scale) / 2 then
                restartGame()
            end

            for j = #game.enemies, 1, -1 do
                local enemy = game.enemies[j]

                if distance(enemy, bullet) < (enemy.texture:getWidth() * enemy.scale) / 2 then
                    table.remove(game.bullets, i)
                    table.remove(game.enemies, j)
                    game.score = game.score + 1

                    love.audio.play(game.assets.enemyDieSound)
                    break
                end
            end
        end
    end
end

return Entities