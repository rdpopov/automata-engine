local M = {}
M.utils = {}


-- Usually obejct orientation is bad for games, cos it's slow
-- but, simialar data would be grouped, one off objects and ui
-- elements are going to be objects

--- empty_unit interface - just for a description
---@return unit
function M.empty_unit()
    local unit = {}
    -- geometry - geometry and otehr information
    unit.g = {
        x = 0,
        y = 0,
        w = 0,
        h = 0,
        z = 0,
        active = false,
    }
    unit.d = nil         -- data     - custom data for the object 
    unit.m = {           -- methods  - base interface
        render = nil,  -- maybe take a canvas
        mouse_action = nil,
        key_action = nil,
        update = nil,
    }
    return unit
end

--- new_unit - fills missng pieces 
---@return unit
function M.new_unit(geom,data,meth)
    local unit = M.empty_unit()
    -- geometry
    for k,v in pairs(unit['g']) do
        unit['g'][k] = geom[k] or unit['g'][k]
    end
    -- data
    unit.d = data
    -- methods
    for k,v in pairs(unit['m']) do
        unit['m'][k] = meth[k] or unit['m'][k]
    end
    return unit
end


function M.utils.inside(g,p)
    if  g.x <= p.x and p.x <= g.x + g.w and
        g.y <= p.y and p.y <= g.y + g.w then
        return true
    end
end

return M
