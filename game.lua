local Assets = require("assets")
local Config = require("config")
local Entities = require("entities")
local Renderer = require("renderer")

local Game = {}
local game = {}

function Game.load()
    math.randomseed(os.time())

    game.width = love.graphics.getWidth()
    game.height = love.graphics.getHeight()
    game.assets = Assets.load(game.width)
    game.player = {
        x = game.width / 2,
        y = game.height / 2,
        speed = 0,
        angle = 0,
        scale = nil,
        texture = game.assets.playerTexture
    }
    game.player.scale = math.min(
        game.width / game.player.texture:getWidth() / 10,
        game.height / game.player.texture:getHeight() / 10
    )

    game.bullets = {}
    game.enemies = {}
    game.enemySpawnCooldown = 1
    game.enemyTimer = 0
    game.score = 0
    game.state = "menu"

    game.bulletPrototype = {
        texture = game.assets.bulletTexture,
        speed = Config.BULLET_SPEED,
        scale = game.player.scale
    }

    game.assets.music:setLooping(true)
    game.assets.music:play()
end

function Game.restart()
    love.audio.play(game.assets.loseSound)

    game.state = "menu"
    game.assets.music:setVolume(0.3)
    game.score = 0
    game.player.health = 3
    game.player.x = game.width / 2
    game.player.y = game.height / 2

    Entities.clear(game)
end

function Game.update(dt)
    local mouseX, mouseY = love.mouse.getPosition()
    local dx, dy = mouseX - game.player.x, mouseY - game.player.y
    local distance = math.sqrt(dx * dx + dy * dy)

    if love.keyboard.isDown("w") and distance > Config.STOP_THRESHOLD then
        dx, dy = dx / distance, dy / distance
        game.player.speed = math.min(
            game.player.speed + Config.PLAYER_ACCELERATION * dt,
            Config.PLAYER_MAX_SPEED
        )
        game.player.x = game.player.x + dx * game.player.speed * dt
        game.player.y = game.player.y + dy * game.player.speed * dt
    else
        game.player.speed = game.player.speed * Config.PLAYER_FRICTION
    end

    game.player.x = math.max(0, math.min(game.player.x, game.width))
    game.player.y = math.max(0, math.min(game.player.y, game.height))

    Entities.update(game, dt, Game.restart)
end

function Game.keypressed(key)
    if key == "escape" and game.state == "menu" then
        love.event.quit()
    end
end

function Game.mousepressed(x, y, button)
    if button == 1 and game.state == "menu" then
        game.state = "playing"
        game.assets.music:setVolume(0.6)
    else
        local dx, dy = x - game.player.x, y - game.player.y
        local angle = math.atan2(dy, dx)
        local bulletX = game.player.x + game.player.texture:getWidth() * game.player.scale * math.cos(angle)
        local bulletY = game.player.y + game.player.texture:getWidth() * game.player.scale * math.sin(angle)

        table.insert(game.bullets, {
            x = bulletX,
            y = bulletY,
            angle = angle,
            speed = game.bulletPrototype.speed,
            texture = game.bulletPrototype.texture,
            scale = game.bulletPrototype.scale
        })

        love.audio.play(game.assets.shootSound)
    end
end

function Game.draw()
    Renderer.draw(game)
end

return Game