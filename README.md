-- { button Example } --

  play = Button.new{
      x = 170, y = love.graphics.getWidth()/2 + 5,
      w = 150, h = 60,
      mode = "sprite",
      sprite = [load_sprite],
      text = "Play",
      hoverMode = "expand_smooth",
      Enabled = true,
      expand_smooth_speed = 12,
      visible = true,
      click_sound_effect = [load_sound],
      hover_sound_effect = [load_sound],
      func = function ()
          loadGame()
      end

  },
