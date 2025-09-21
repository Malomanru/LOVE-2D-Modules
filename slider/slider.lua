Slider = {}
Slider.__index = Slider

Sliders = {}

function Slider.new( ... )
    local self, params = setmetatable({}, Slider), ...

    self.x = params.x
    self.y = params.y
    self.width = params.width
    self.height = params.height
    self.min = params.min or 0
    self.max = params.max or 100
    self.value = params.initial or self.min

    self.bgOutline = params.bgOutline or {}
    self.bgColor = params.bgColor or {0.3, 0.3, 0.3, 1}

    self.fgColor = params.fgColor or {0.5, 0.8, 1, 1}

    self.knobColor = params.knobColor or {1, 1, 1, 1}
    self.KnobOutline = params.KnobOutline or {}
    self.knobWidth = params.knobWidth or 10
    self.knobHeight = params.knobHeight or self.height + 8

    self.dragging = false

    table.insert(Sliders, self)

    return self
end

function Slider:update(dt)
    if self.dragging then
        local x, y = love.mouse.getPosition()
        self:setValueFromPosition(x)
    end
end

function Slider:draw()
    love.graphics.setColor(self.bgColor)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    local fillWidth = ((self.value - self.min) / (self.max - self.min)) * self.width
    love.graphics.setColor(self.fgColor)
    love.graphics.rectangle("fill", self.x, self.y, fillWidth, self.height)

    local knobX = self.x + fillWidth - self.knobWidth/2
    local knobY = self.y - (self.knobHeight - self.height)/2

    love.graphics.setColor(self.knobColor)
    love.graphics.rectangle("fill", knobX, knobY, self.knobWidth, self.knobHeight)

    love.graphics.setColor(1, 1, 1)
    love.graphics.print(string.format("%.0f", self.value).."%", self.x + self.width + 10, self.y)
end

function Slider:mousepressed(x, y, button)
    if button == 1 then
        local knobX = self.x + ((self.value - self.min) / (self.max - self.min)) * self.width
        local knobY = self.y + self.height/2

        if math.abs(x - knobX) < self.knobWidth/2 + 5 and
           math.abs(y - knobY) < self.knobHeight/2 then
            self.dragging = true
        elseif x >= self.x and x <= self.x + self.width and
               y >= self.y and y <= self.y + self.height then
            self:setValueFromPosition(x)
            self.dragging = true
        end
    end
end

function Slider:mousereleased(x, y, button)
    if button == 1 then
        self.dragging = false
    end
end

function Slider:setValueFromPosition(x)
    local relativeX = math.max(0, math.min(self.width, x - self.x))
    self.value = self.min + (relativeX / self.width) * (self.max - self.min)
    return self.value
end

function Slider:getValue()
    return self.value
end

function Slider:setValue(newValue)
    self.value = math.max(self.min, math.min(self.max, newValue))
end
