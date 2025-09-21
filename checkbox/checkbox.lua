checkbox = {}
checkbox.__index = checkbox

checkboxes = {}

function checkbox.new( ... )
    local params, self = nil, setmetatable({}, checkbox)

    if type(...) == "table" then
        params = ...
    else
        params = {...}
    end

    self.x, self.y = params.x or 100, params.y or 100
    self.scaleX, self.scaleY = params.scaleX or 1, params.scaleY or 1
    self.angle = params.angle or 0

    self.check_mark_sprite = params.check_mark_sprite or love.graphics.newImage('src/sprites/ui/checkbox/check_mark.png')
    self.checkbox_frame_sprite = params.checkbox_frame_sprite or love.graphics.newImage('src/sprites/ui/checkbox/checkbox_frame.png')

    self.check_mark_sprite_color = params.check_mark_sprite_color or {0,1,0}
    self.checkbox_frame_sprite_color = params.checkbox_frame_sprite_color or {1,1,1}

    self.visible = params.visible or true
    self.Enabled = params.Enabled or true

    self.value = params.value or false

    table.insert(checkboxes, self)

    return self
end

function checkbox:toggle()
    self.value = not self.value
end

function checkbox:getValue()
    return self.value
end

function checkbox:update(dt)
    local mx, my = love.mouse:getPosition()
end

function checkbox:draw()
    if not self.visible then return end

    love.graphics.setColor(self.checkbox_frame_sprite_color)
    love.graphics.draw(self.checkbox_frame_sprite, self.x - self.checkbox_frame_sprite:getWidth()/2, self.y - self.checkbox_frame_sprite:getHeight()/2, self.angle, self.scaleX, self.scaleY)

    if self.value == true then
        love.graphics.setColor(self.check_mark_sprite_color)
        love.graphics.draw(self.check_mark_sprite, self.x - self.check_mark_sprite:getWidth()/2, self.y - self.check_mark_sprite:getHeight()/2, self.angle, self.scaleX, self.scaleY)
    end

    love.graphics.setColor(1,1,1)
end

function checkbox:mousepressed(x, y, btn)
    if btn == 1 then
        local left = self.x - self.checkbox_frame_sprite:getWidth()/2 * self.scaleX
        local top = self.y - self.checkbox_frame_sprite:getHeight()/2 * self.scaleY
        local width = self.checkbox_frame_sprite:getWidth() * self.scaleX
        local height = self.checkbox_frame_sprite:getHeight() * self.scaleY

        if isCursorInRect(left, top, width, height) then
            self:toggle()
        end
    end
end
