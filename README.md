--[[
    Play Button Implementation
    A beautifully animated button with hover effects and sound feedback
    Designed for Love2D game framework
]]

local Button = require("path.to.button.module") -- Adjust path as needed

-- Load resources (in actual implementation, these would be preloaded)
local function load_sprite()
    return love.graphics.newImage("assets/button_sprite.png")
end

local function load_sound()
    return love.audio.newSource("assets/button_sound.wav", "static")
end

-- Game loading function
local function loadGame()
    -- Implementation for loading the game
    print("Loading game...")
end

-- Create the Play button
play = Button.new({
    x = 170, 
    y = love.graphics.getWidth() / 2 + 5,
    width = 150, 
    height = 60,
    mode = "sprite",
    sprite = load_sprite(),
    text = "Play",
    font = love.graphics.newFont(18),
    textColor = {1, 1, 1, 1}, -- White text
    color = {0.2, 0.6, 1, 1}, -- Blue button
    hoverColor = {0.3, 0.7, 1, 1}, -- Lighter blue on hover
    hoverMode = "expand_smooth",
    enabled = true,
    expandSmoothSpeed = 12,
    visible = true,
    clickSoundEffect = load_sound(),
    hoverSoundEffect = load_sound(),
    onClick = loadGame
})

return play
