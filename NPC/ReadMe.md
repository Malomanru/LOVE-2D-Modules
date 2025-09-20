# NPC Module Implementation for Love2D

A flexible and extensible system for creating, animating, and interacting with non-player characters (NPCs) in [Love2D](https://love2d.org/) games.

---

## Features

- **Easy NPC Creation:** Instantiate NPCs with customizable properties.
- **Animation & Movement:** Built-in support for movement, sprite animation, and smooth transitions.
- **Behavior & AI:** Assign targets, move NPCs, and trigger actions or dialogue.
- **Event Handling:** React to game events, player proximity, or custom triggers.
- **State Management:** Switch between states (aggressive, neutral, friendly, etc.).
- **Dialog System (optional):** Built-in methods for dialogue and interaction.

---

## Example Usage

```lua
local NPC = require("path.to.npc.module") -- Adjust the path as needed

-- Load resources (in actual implementation, these would be preloaded)
local function load_sprite()
    return love.graphics.newImage("assets/npc_guard.png")
end

local function load_sound()
    return love.audio.newSource("assets/npc_greet.wav", "static")
end

-- Example interaction function
local function greetPlayer()
    print("Guard says: Welcome to the city!")
end

-- Create an NPC (e.g., a Guard)
guard = NPC.new({
    name = "Guard",
    x = 200,
    y = 150,
    sprite = load_sprite(),
    health = 150,
    speed = 60,
    state = "neutral",
    visible = true,
    onInteract = greetPlayer,
    greetSound = load_sound(),
    dialogue = {
        "Halt! Who goes there?",
        "Stay out of trouble."
    }
})

return guard
```

---

## Customization

- **Sprite:** Replace `"assets/npc_guard.png"` with your own character image.
- **Sounds:** Use any `.wav` file for greetings, alerts, or actions.
- **States:** Set initial or dynamic states (e.g. `"aggressive"`, `"friendly"`, `"neutral"`).
- **Behavior:** Assign custom functions for interaction, movement, AI, or dialogue.
- **Properties:** Configure health, speed, position, and more.

---

## Requirements

- [Love2D](https://love2d.org/) 11.0 or newer
- Your own NPC module at `path.to.npc.module`

---

## License

MIT © [Malomanru](https://github.com/Malomanru)
