local M = {}
function M.in_box(box,co)
  return box.x1 <= co[1] and co[1] <= box.x2 and
  box.y1 <= co[2] and co[2] <= box.y2
end

function M.create_box(x1,y1,x2,y2)
  return {
    x1 = x1,
    y1 = y1,
    x2 = x2,
    y2 = y2,
    dx = x2 - x1,
    dy = y2 - y1,
  }
end

function M.create_button(box,render_func,action_func,action_args)
  box.render = function ()
    render_func(box)
  end
  box.action = function ()
    action_func(box,action_args)
  end
end

function M.automata_create_palete_buttons(geometry,colors,automata_states,render_func,mouse_func)
  local ret = {}
  local x = geometry.x
  local y = geometry.y
  local dx = geometry.dx
  local dy = geometry.dy
  local space = geometry.space
  for i,state in pairs(automata_states) do
    table.insert(ret, {
      box = M.create_box(x,y,x+dx,y+dy),
      color = colors[state],
      label = automata_states[i],
      render = render_func,
      mouse_action = mouse_func,
    })
    y = y + dy + space
  end
  return ret
end


return M
