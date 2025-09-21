# Slider Module for LOVE2D

![Slider Demo](https://raw.githubusercontent.com/Malomanru/LOVE-2D-Modules/main/slider/demo.gif) <!-- Add your own gif if available -->

## Description

This module provides a simple yet customizable horizontal slider for your [LOVE2D](https://love2d.org/) projects.  
It’s easy to integrate, supports multiple sliders, and allows users to select values within a specified range.

## Features

- **Flexible customization:** Position, size, colors, value range, initial value.
- **Mouse interaction:** Drag the knob, click the bar.
- **Displays current value.**
- **Supports multiple simultaneous sliders.**

## Usage

1. **Include the file:**  
   Add `slider.lua` to your project.

   ```lua
   local Slider = require("slider.slider")
   ```

2. **Create a slider:**

   ```lua
   local mySlider = Slider.new{
     x = 100,
     y = 50,
     width = 200,
     height = 20,
     min = 0,
     max = 100,
     initial = 50,
     bgColor = {0.3, 0.3, 0.3, 1},
     fgColor = {0.5, 0.8, 1, 1},
     knobColor = {1, 1, 1, 1},
     knobWidth = 12,
     knobHeight = 28
   }
   ```

3. **Call methods in LOVE2D callbacks:**

   ```lua
   function love.update(dt)
     mySlider:update(dt)
   end

   function love.draw()
     mySlider:draw()
   end

   function love.mousepressed(x, y, button)
     mySlider:mousepressed(x, y, button)
   end

   function love.mousereleased(x, y, button)
     mySlider:mousereleased(x, y, button)
   end
   ```

4. **Get the slider value:**

   ```lua
   local value = mySlider:getValue()
   ```

## Constructor Parameters

| Parameter       | Type      | Description                                  |
|-----------------|-----------|----------------------------------------------|
| `x`, `y`        | number    | Top-left position of the slider              |
| `width`         | number    | Width of the slider bar                      |
| `height`        | number    | Height of the slider bar                     |
| `min`, `max`    | number    | Value range                                  |
| `initial`       | number    | Initial slider value                         |
| `bgColor`       | table     | Background color `{r, g, b, a}`              |
| `fgColor`       | table     | Fill color `{r, g, b, a}`                    |
| `knobColor`     | table     | Knob color `{r, g, b, a}`                    |
| `knobWidth`     | number    | Knob width                                   |
| `knobHeight`    | number    | Knob height                                  |

## Example

```lua
local Slider = require("slider.slider")
local s = Slider.new{x=100, y=100, width=300, height=24, min=0, max=100, initial=25}

function love.update(dt)
  s:update(dt)
end

function love.draw()
  s:draw()
  love.graphics.print("Value: " .. math.floor(s:getValue()), 100, 150)
end

function love.mousepressed(x, y, button)
  s:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
  s:mousereleased(x, y, button)
end
```

## License

MIT

---

**Author:** [Malomanru](https://github.com/Malomanru)

Feel free to open issues or pull requests for suggestions or bug reports!
