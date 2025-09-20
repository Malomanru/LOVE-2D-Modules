Button = {}

function Button.new(params)
    local self = {}
    self.x = params.x or 0
    self.y = params.y or 0
    self.w = params.w or 100
    self.h = params.h or 50

    -- Режим отображения: "sprite", "text", "rect", "quad"
    self.mode = params.mode or "rect"

    self.text = params.text or "Button"
    self.font = params.font or love.graphics.getFont()
    self.textScale = params.textScale or 1
    self.hv_textScale = params.hv_textScale or 5

    self.sprite = params.sprite or nil
    self.quad = params.quad or nil

    -- Цвет фона
    self.color = params.color or {0.2, 0.2, 0.2, 1}
    self.background = params.background

    -- Эффект при наведении
    self.hoverMode = params.hoverMode or "expand_smooth"
    self.hv_w = params.hv_w or (self.w * 1.2)
    self.hv_h = params.hv_h or (self.h * 1.2)

    -- Текущие размеры для плавного перехода
    self.cur_w = self.w
    self.cur_h = self.h

    -- Other
    self.func = params.func or function () return end
    self.expand_smooth_speed = params.expand_smooth_speed
    self.visible = params.visible
    self.Enabled = params.Enabled

    self.click_sound_effect = params.click_sound_effect
    self.hover_sound_effect = params.hover_sound_effect

    self.selected = false

    return setmetatable(self, {__index = Button})
end

function Button:isHovered(mx, my)
    return mx >= self.x - self.cur_w/2 and mx <= self.x + self.cur_w/2
       and my >= self.y - self.cur_h/2 and my <= self.y + self.cur_h/2
end
function Button:update(dt, mx, my)
    if self.Enabled and self.Enabled == false then return end

    local wasHovered = self.hovered
    self.hovered = self:isHovered(mx, my)
    
    local justStartedHovering = self.hovered and not wasHovered
    
    if justStartedHovering then
        if self.hover_sound_effect then 
            self:playHoverSound()
        end
        self.selected = true
    elseif not self.hovered then
        self.selected = false
    end

    if self.hoverMode == "expand_instant" then
        if self.hovered then
            self.cur_w, self.cur_h = self.hv_w, self.hv_h
        else
            self.cur_w, self.cur_h = self.w, self.h
        end
    elseif self.hoverMode == "expand_smooth" then
        local target_w = self.hovered and self.hv_w or self.w
        local target_h = self.hovered and self.hv_h or self.h
        local speed = self.expand_smooth_speed
        self.cur_w = self.cur_w + (target_w - self.cur_w) * speed * dt
        self.cur_h = self.cur_h + (target_h - self.cur_h) * speed * dt
        
    elseif self.hoverMode == "expand_smooth_text" then
        local targetScale = self.hovered and self.hv_textScale or 1
        local speed = self.expand_smooth_speed
        self.textScale = self.textScale + (targetScale - self.textScale) * speed * dt
    elseif self.hoverMode == "expand_smooth_both" then
        -- кнопка
        local target_w = self.hovered and self.hv_w or self.w
        local target_h = self.hovered and self.hv_h or self.h
        local speed = self.expand_smooth_speed
        self.cur_w = self.cur_w + (target_w - self.cur_w) * speed * dt
        self.cur_h = self.cur_h + (target_h - self.cur_h) * speed * dt

        -- текст
        local targetScale = self.hovered and self.hv_textScale or 1
        self.textScale = self.textScale + (targetScale - self.textScale) * speed * dt
    end
end

function Button:playHoverSound()
    -- Останавливаем все предыдущие звуки наведения этой кнопки
    if self.current_hover_sound then
        self.current_hover_sound:stop()
    end
    
    -- Создаем новый источник звука из данных
    local sound = self.hover_sound_effect
    sound:setVolume(0.7) -- Опционально: регулировка громкости
    love.audio.play(sound)
    self.current_hover_sound = sound
end

function Button:draw(debugMode)
    if self.visible ~= true then return end

    love.graphics.push()
    love.graphics.translate(self.x, self.y)

    if self.mode == "sprite" and self.sprite then
        local sx = self.cur_w / self.sprite:getWidth()
        local sy = self.cur_h / self.sprite:getHeight()
        love.graphics.draw(
            self.sprite, 0, 0, 0,
            sx, sy,
            self.sprite:getWidth()/2,
            self.sprite:getHeight()/2
        )

    elseif self.mode == "text" then
        if self.background == true then
            love.graphics.setColor(self.color)
            love.graphics.rectangle("fill", -self.cur_w/2, -self.cur_h/2, self.cur_w, self.cur_h, 8)
            love.graphics.setColor(1,1,1,1)
        end
        
        love.graphics.setFont(self.font)
        local tw = self.font:getWidth(self.text)
        local th = self.font:getHeight()

        love.graphics.push()
        love.graphics.scale(self.textScale, self.textScale)
        love.graphics.print(self.text, -tw/2, -th/2)
        love.graphics.pop()
    
    elseif self.mode == "rect" then
        love.graphics.setColor(self.color)
        love.graphics.rectangle("fill", -self.cur_w/2, -self.cur_h/2, self.cur_w, self.cur_h, 8)
        love.graphics.setColor(1,1,1,1)

    elseif self.mode == "quad" then
        local qx, qy, qw, qh = self.quad:getViewport()
        local sx = self.cur_w / qw
        local sy = self.cur_h / qh
        
        love.graphics.draw(
            self.sprite, self.quad, 0, 0, 0,
            sx, sy,
            qw/2, qh/2
        )
    end

    love.graphics.pop()

    if debugMode then
        love.graphics.setColor(1,0,0,1)
        love.graphics.rectangle("line", self.x - self.cur_w/2, self.y - self.cur_h/2, self.cur_w, self.cur_h)
        love.graphics.setColor(1,1,1,1)
    end
end

function Button:mousepressed(x, y, btn)
    if btn == 1 and self:isHovered(x, y) and self.func and self.Enabled ~= false then
        if self.click_sound_effect then love.audio.play(self.click_sound_effect) end
        self.func()
    end
end