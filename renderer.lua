local Config = require("config")

local Renderer = {}

function Renderer.draw(game)
    local assets = game.assets
    local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
    local bgWidth, bgHeight = assets.backgroundTexture:getWidth(), assets.backgroundTexture:getHeight()

    love.graphics.draw(
        assets.backgroundTexture,
        0,
        0,
        0,
        screenWidth / bgWidth,
        screenHeight / bgHeight
    )
    love.graphics.setFont(assets.font)

    if game.state == "menu" then
        love.graphics.printf(Config.START_MESSAGE, 0, game.height / 2 - assets.fontSize, game.width, "center")
        love.graphics.printf(Config.EXIT_MESSAGE, 0, game.height / 2 + assets.fontSize, game.width, "center")
        love.graphics.printf(Config.TUTORIAL_MESSAGE, 0, game.height - 2 * assets.fontSize, game.width, "center")
    elseif game.state == "playing" then
        local mouseX, mouseY = love.mouse.getPosition()
        local dx, dy = mouseX - game.player.x, mouseY - game.player.y
        game.player.angle = math.atan2(dy, dx) + Config.MAGIC_ANGLE_DIFFERENCE

        for _, bullet in ipairs(game.bullets) do
            love.graphics.draw(
                bullet.texture,
                bullet.x,
                bullet.y,
                bullet.angle,
                bullet.scale,
                bullet.scale,
                bullet.texture:getWidth() / 2,
                bullet.texture:getHeight() / 2
            )
        end

        love.graphics.draw(
            game.player.texture,
            game.player.x,
            game.player.y,
            game.player.angle,
            game.player.scale,
            game.player.scale,
            game.player.texture:getWidth() / 2,
            game.player.texture:getHeight() / 2
        )

        for _, enemy in ipairs(game.enemies) do
            love.graphics.draw(
                enemy.texture,
                enemy.x,
                enemy.y,
                0,
                enemy.scaleX,
                enemy.scale,
                enemy.texture:getWidth() / 2,
                enemy.texture:getHeight() / 2
            )
        end

        love.graphics.print(game.score, game.width / 2 - assets.fontSize / 2, assets.fontSize)
    end

    local x, y = love.mouse.getPosition()
    love.graphics.draw(
        assets.cursorTexture,
        x,
        y,
        0,
        game.player.scale,
        game.player.scale,
        assets.cursorTexture:getWidth() / 2,
        assets.cursorTexture:getHeight() / 2
    )
end

return Renderer