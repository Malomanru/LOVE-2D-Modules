local npc = {}
npc.__index = npc

function npc.new(sprite, x, y, map_colliders)
    local v = setmetatable({}, npc)

    v.Name = "Test"

    v.sprite = love.graphics.newImage('src/sprites/NPCs/'..sprite..'.png')
    v.sprite1 = sprite
    
    v.collider = world:newCircleCollider(x,y,5)
    v.collider:setType("kinematic")
    v.collider:setFixedRotation(true)
    v.collider:setCollisionClass("NPC")

    v.map_colliders = map_colliders or {}
    v.map = gameMap
    v.path = {}
    v.current_target_index = 1
    v.speed = 70
    v.size = 16
    v.x = x
    v.y = y
    v.path_cache = {}

    v.dirX, v.dirY = 0,0
    v.state = "idle"
    v.direction = "down"

    v.InteractZone = {x = 20, y = 20}

    v.grid = anim8.newGrid(16, 32, v.sprite:getWidth(), v.sprite:getHeight())

    v.animations = {
        idle_down       = anim8.newAnimation(v.grid('1-8', 1), 0.2),
        idle_up         = anim8.newAnimation(v.grid('9-16', 1), 0.2),
        idle_left_down  = anim8.newAnimation(v.grid('1-8', 2), 0.2),
        idle_right_down = anim8.newAnimation(v.grid('9-16', 2), 0.2),
        idle_left_up    = anim8.newAnimation(v.grid('1-8', 3), 0.2),
        idle_right_up   = anim8.newAnimation(v.grid('9-16', 3), 0.2),

        walk_down       = anim8.newAnimation(v.grid('1-8', 4), 0.1),
        walk_up         = anim8.newAnimation(v.grid('9-16', 4), 0.1),
        walk_left_down  = anim8.newAnimation(v.grid('1-8', 5), 0.1),
        walk_right_down = anim8.newAnimation(v.grid('9-16', 5), 0.1),
        walk_right_up   = anim8.newAnimation(v.grid('1-8', 6), 0.1),
        walk_left_up    = anim8.newAnimation(v.grid('9-16', 6), 0.1),
    }

    v.anim = v.animations[v.state.."_"..v.direction]

    return v
end

function npc:is_point_in_collider(px, py)
    for _, collider in ipairs(self.map_colliders) do
        if px >= collider.x and px <= collider.x + collider.width and
           py >= collider.y and py <= collider.y + collider.height then
            return true
        end
    end
    return false
end

function npc:is_valid_position(x, y)
    if self:is_point_in_collider(x, y) then
        return false
    end

    local map_width = gameMap.width * gameMap.tilewidth
    local map_height = gameMap.height * gameMap.tileheight
    
    if x < 0 or x > map_width or y < 0 or y > map_height then
        return false
    end

    local colliders = world:queryRectangleArea(
        x - self.size/2,
        y - self.size,
        self.size,
        self.size * 2,
        {'Wall', 'Object'}
    )

    if #colliders > 0 then
        return false
    end
    
    return true
end

function npc:heuristic(a, b)
    return math.sqrt((a.x - b.x)^2 + (a.y - b.y)^2)
end

function npc:get_neighbors(pos, grid_size)
    local neighbors = {}
    local directions = {
        {x = 0, y = -grid_size},    -- up
        {x = grid_size, y = 0},     -- right
        {x = 0, y = grid_size},     -- down
        {x = -grid_size, y = 0},    -- left
    }
    
    for _, dir in ipairs(directions) do
        local nx, ny = pos.x + dir.x, pos.y + dir.y
        if self:is_valid_position(nx, ny) then
            table.insert(neighbors, {x = nx, y = ny})
        end
    end
    
    return neighbors
end

function npc:pos_to_key(pos)
    return string.format("%d,%d", math.floor(pos.x), math.floor(pos.y))
end

function npc:reconstruct_path(came_from, current)
    local path = {}
    while current do
        table.insert(path, 1, current)
        current = came_from[self:pos_to_key(current)]
    end
    return path
end

function npc:find_path(start_x, start_y, target_x, target_y)
    local grid_size = 16 
    
    local start = {
        x = math.floor(start_x / grid_size) * grid_size + grid_size/2, 
        y = math.floor(start_y / grid_size) * grid_size + grid_size/2
    }
    local goal = {
        x = math.floor(target_x / grid_size) * grid_size + grid_size/2, 
        y = math.floor(target_y / grid_size) * grid_size + grid_size/2
    }
    
    local cache_key = self:pos_to_key(start) .. "->" .. self:pos_to_key(goal)
    if self.path_cache[cache_key] then
        return self.path_cache[cache_key]
    end
    
    if not self:is_valid_position(goal.x, goal.y) then
        return nil
    end
    
    local open_set = {}
    local came_from = {}
    local g_score = {}
    local f_score = {}
    
    local start_key = self:pos_to_key(start)
    g_score[start_key] = 0
    f_score[start_key] = self:heuristic(start, goal)
    table.insert(open_set, {pos = start, f = f_score[start_key]})
    
    local iterations = 0
    local max_iterations = 1000
    
    while #open_set > 0 and iterations < max_iterations do
        iterations = iterations + 1
        
        -- We sort and take the path with the smallest number of points
        table.sort(open_set, function(a, b) return a.f < b.f end)
        local current = table.remove(open_set, 1)
        
        if math.abs(current.pos.x - goal.x) < grid_size and 
           math.abs(current.pos.y - goal.y) < grid_size then
            local path = self:reconstruct_path(came_from, current.pos)
            self.path_cache[cache_key] = path
            return path
        end
        
        local neighbors = self:get_neighbors(current.pos, grid_size)
        for _, neighbor in ipairs(neighbors) do
            local neighbor_key = self:pos_to_key(neighbor)
            local move_cost = self:heuristic(current.pos, neighbor)
            local tentative_g_score = g_score[self:pos_to_key(current.pos)] + move_cost
            
            if g_score[neighbor_key] == nil or tentative_g_score < g_score[neighbor_key] then
                came_from[neighbor_key] = current.pos
                g_score[neighbor_key] = tentative_g_score
                f_score[neighbor_key] = tentative_g_score + self:heuristic(neighbor, goal)
                
                -- We check if this node is already in open_set
                local in_open_set = false
                for i, node in ipairs(open_set) do
                    if math.abs(node.pos.x - neighbor.x) < 1 and 
                       math.abs(node.pos.y - neighbor.y) < 1 then
                        in_open_set = true
                        if tentative_g_score < g_score[neighbor_key] then
                            open_set[i].f = f_score[neighbor_key]
                        end
                        break
                    end
                end
                
                if not in_open_set then
                    table.insert(open_set, {pos = neighbor, f = f_score[neighbor_key]})
                end
            end
        end
    end
    
    return nil
end

function npc:move_to_position(target_x, target_y)
    local path = self:find_path(self.x, self.y, target_x, target_y)
    if path and #path > 0 then
        self.path = path
        self.current_target_index = 1
    else
        self.path = {}
    end
end

function npc:clear_path()
    self.path = {}
    self.current_target_index = 1
    self.collider:setLinearVelocity(0, 0)
end

function npc:updateAnimation(dt)
    local animKey = self.state .. "_" .. self.direction
    local anim = self.animations[animKey] or self.animations["idle_down"]

    if self.anim ~= anim then
        self.anim = anim
        self.anim:gotoFrame(1)
    end
    self.anim:update(dt)
end

function npc:resolve_direction(dx, dy)
    if dx == 0 and dy == 0 then
        return self.direction or "down"
    end

    local angle = math.atan2(dy, dx)

    local deg = math.deg(angle)

    if deg < 0 then deg = deg + 360 end

    if deg >= 45 and deg < 135 then
        return "down"
    elseif deg >= 135 and deg < 225 then
        return "left_down"
    elseif deg >= 225 and deg < 315 then
        return "up"
    else
        return "right_down"
    end
end

function npc:update(dt)
    if self.collider then
        self.x = self.collider:getX()
        self.y = self.collider:getY()
    end

    local target_dx, target_dy = 0, 0

    if #self.path > 0 and self.current_target_index <= #self.path then
        local target = self.path[self.current_target_index]
        local dx = target.x - self.x
        local dy = target.y - self.y
        local distance = math.sqrt(dx * dx + dy * dy)
        
        if distance < 12 then
            self.current_target_index = self.current_target_index + 1
            if self.current_target_index > #self.path then
                self:clear_path()
            end
        else
            target_dx = dx / distance
            target_dy = dy / distance
        end
    end

    local vx, vy = self.collider:getLinearVelocity()

    local desired_vx = target_dx * self.speed
    local desired_vy = target_dy * self.speed

    local smooth = 5 -- smoothing factor (higher = sharper turns)
    local new_vx = vx + (desired_vx - vx) * math.min(1, smooth * dt)
    local new_vy = vy + (desired_vy - vy) * math.min(1, smooth * dt)

    self.collider:setLinearVelocity(new_vx, new_vy)

    if math.abs(new_vx) > 5 or math.abs(new_vy) > 5 then
        self.state = "walk"
    else
        self.state = "idle"
    end

    self.direction = self:resolve_direction(new_vx, new_vy)

    local dx = player.collider:getX() - self.x
    local dy = player.collider:getY() - self.y

    if dx*dx + dy*dy <= (self.InteractZone.x * self.InteractZone.y) then
        player.nearNpc = self
    else
        if player.nearNpc == self then
            player.nearNpc = nil
        end
    end

    self:updateAnimation(dt)
end

function npc:draw()
    if self.anim then
        love.graphics.draw(resources.sprites.shadow, self.x, self.y,0,1,1, 8.5, 2)
        self.anim:draw(self.sprite, self.x, self.y, 0, 1, 1, 8.5, 22)
    end

    if _G.debugMode.drawNPCsPaths == true then
        love.graphics.setColor(0, 1, 0, 0.5)
        for i, point in ipairs(self.path) do
            love.graphics.circle("line", point.x, point.y, 3)
            if i > 1 then
                love.graphics.line(self.path[i-1].x, self.path[i-1].y, point.x, point.y)
            end
        end
        
        if #self.path > 0 and self.current_target_index <= #self.path then
            love.graphics.setColor(1, 0, 0)
            love.graphics.circle("fill", self.path[self.current_target_index].x, 
                                self.path[self.current_target_index].y, 5)
        end
        love.graphics.setColor(1, 1, 1)
    end

    if _G.debugMode.drawQueryAreas == true then
        love.graphics.setColor(1,0,0)
        love.graphics.circle("line", self.x, self.y, self.InteractZone.x, self.InteractZone.y)
        love.graphics.setColor(1,1,1)
    end
end

return npc