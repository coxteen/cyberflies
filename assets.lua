local Config = require("config")

local Assets = {}

function Assets.load(windowWidth)
    love.graphics.setBackgroundColor(200 / 255, 200 / 255, 200 / 255)

    local fontSize = windowWidth / Config.SCALE_FACTOR

    love.mouse.setVisible(false)

    return {
        fontSize = fontSize,
        font = love.graphics.newFont("resources/fonts/font.otf", fontSize),
        cursorTexture = love.graphics.newImage("resources/textures/cursor.png"),
        backgroundTexture = love.graphics.newImage("resources/textures/background.png"),
        playerTexture = love.graphics.newImage("resources/textures/player.png"),
        bulletTexture = love.graphics.newImage("resources/textures/bullet.png"),
        enemyTexture = love.graphics.newImage("resources/textures/enemy.png"),
        enemyDieSound = love.audio.newSource("resources/sounds/enemyDie.wav", "static"),
        shootSound = love.audio.newSource("resources/sounds/shoot.wav", "static"),
        loseSound = love.audio.newSource("resources/sounds/lose.wav", "static"),
        music = love.audio.newSource("resources/sounds/music.mp3", "stream")
    }
end

return Assets