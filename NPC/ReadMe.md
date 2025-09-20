# NPC Module Implementation for Love2D

A flexible and extensible system for creating, animating, and interacting with non-player characters (NPCs) in [Love2D](https://love2d.org/) games.

---

## Features

- **Easy NPC Creation:** Instantiate NPCs with customizable properties.
- **Sprite Animation:** Idle and walking animations for multiple directions.
- **Pathfinding & Movement:** Built-in grid-based A* pathfinding and smooth movement.
- **Collision Handling:** Works with external world and map colliders.
- **Interaction Zones:** NPCs can detect and interact with nearby players.
- **Debug Visualization:** Optional path and collision area visualization.

---

## Example Usage

```lua
local NPC = require("src.modules.npc") -- Adjust the path as needed

local guard = NPC.new("guard_sprite", 200, 150, map_colliders)

function love.update(dt)
    guard:update(dt)
end

function love.draw()
    guard:draw()
end

-- Move the guard to a position
guard:move_to_position(400, 300)

-- Check for player near NPC in your game logic:
if player.nearNpc == guard then
    -- Show interaction prompt, dialogue, etc.
end
```

---

## Customization

- **Sprite:** Place your character sprite (sheet) in `src/sprites/NPCs/` and pass the name (without extension).
- **Animations:** Supports idle and walking in six directions (down, up, left_down, right_down, left_up, right_up).
- **Speed & Size:** Modify `.speed` and `.size` parameters for each NPC.
- **Interaction:** Use `.InteractZone` to set the proximity required for player-NPC interaction.
- **Pathfinding:** NPCs can move to any valid position using grid-based pathfinding.
- **Collision:** NPCs avoid map obstacles and walls automatically.

---

## Requirements

- [Love2D](https://love2d.org/) 11.0 or newer
- Your own physics world and map colliders (compatible with Simple Tiled Implementation, bump, or similar)
- The [anim8](https://github.com/kikito/anim8) animation library
- NPC module file (see example above)

---

## License

MIT © [Malomanru](https://github.com/Malomanru)
