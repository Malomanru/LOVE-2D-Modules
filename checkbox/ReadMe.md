# Checkbox Module for LÖVE 2D

A simple, customizable checkbox UI module for [LÖVE 2D](https://love2d.org/), written in Lua.  
This module lets you easily create and manage checkbox components in your game or application.

## Features

- Customizable position, scale, angle, and sprites
- Easy creation and management of multiple checkboxes
- Supports toggling via mouse click
- Custom colors for checkbox frame and check mark
- Simple API for value retrieval and drawing

## Quick Start

1. **Copy the module**

   Place `checkbox.lua` and your desired sprites in your project, e.g.:
   ```
   src/sprites/ui/checkbox/check_mark.png - example
   src/sprites/ui/checkbox/checkbox_frame.png - example
   ```

2. **Require the module**
   ```lua
   local checkbox = require "checkbox.checkbox"
   ```

3. **Create a checkbox**
   ```lua
   local myCheckbox = checkbox.new {
       x = 200, y = 150,
       scaleX = 1, scaleY = 1,
       angle = 0,
       check_mark_sprite_color = {0, 1, 0},
       checkbox_frame_sprite_color = {1, 1, 1},
       visible = true,
       Enabled = true,
       value = false
   }
   ```

4. **Update, Draw, and Handle Input**
   In your main callbacks:
   ```lua
   function love.draw()
       for _, cb in ipairs(checkboxes) do
           cb:draw()
       end
   end

   function love.mousepressed(x, y, button)
       for _, cb in ipairs(checkboxes) do
           cb:mousepressed(x, y, button)
       end
   end
   ```

## API Reference

### `checkbox.new(params)`
Create a new checkbox.  
`params` (table) can include:
- `x`, `y`: Position
- `scaleX`, `scaleY`: Scale
- `angle`: Rotation angle (radians)
- `check_mark_sprite`: LÖVE Image for check mark
- `checkbox_frame_sprite`: LÖVE Image for frame
- `check_mark_sprite_color`, `checkbox_frame_sprite_color`: Color tables `{r,g,b}`
- `visible`: Show/hide checkbox
- `Enabled`: Enable/disable checkbox
- `value`: Initial checked state (`true`/`false`)

### `checkbox:toggle()`
Toggle the checkbox state.

### `checkbox:getValue()`
Returns current value (`true`/`false`).

### `checkbox:update(dt)`
Reserved for future logic (currently unused).

### `checkbox:draw()`
Draws the checkbox.

### `checkbox:mousepressed(x, y, btn)`
Handles mouse click events.

## Dependencies

- [LÖVE 2D](https://love2d.org/)
- Sprites for the checkbox frame and check mark

## Extending

- Add more features such as labels, keyboard support, or callbacks as needed.
- Customize the appearance by replacing the sprites.

## License

MIT License.  
Feel free to use and modify!

---

**Author:** [Malomanru](https://github.com/Malomanru)

