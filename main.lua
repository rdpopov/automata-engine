automata = require("automata")
space_utils = require("elements")
i = 0
draw_start = 0

local square_side = math.min(love.graphics.getHeight( ),love.graphics.getWidth( )) - 20
local board_dimensions = {x = square_side,y = square_side, cell_x = 60 , cell_y = 60}

local colors = {
 [0] = {0,0,0},
 [1] = {0.5,0,0},
 [2] = {0,0.5,0},
 [3] = {0,0,0.5},
 [4] = {0.5,0,0.5},
 [5] = {0,0.5,0.5},
 [6] = {0.5,0.5,0},
 [7] = {0.5,0.5,0.5},
 [8] = {1,1,1},
}

local global_state = {
    pause = true,
    steps = 0,
    current_color = 0,
    renderables = {},
    actionables = {key = {},mouse = {}},
    generation = 0,
    updates_per_second = 1,
}
function register_mouse_action(item)
  if item ~= nil and item.mouse_action ~= nil then
    table.insert(global_state.actionables.mouse,item)
  end
end

function register_renderable(item)
  if item ~= nil and  item.render ~= nil then
    table.insert(global_state.renderables,item)
  end
end

-- board
local board_size = {x = board_dimensions.cell_x,y = board_dimensions.cell_y}
local board,spare = automata.generate_boards(board_size.x,board_size.y)
local automata_container = {
  box = space_utils.create_box(10,10,board_dimensions.x + 10, board_dimensions.y + 10),
  board_size = board_size,
  colors_table = colors,
  main_board = board,
  spare_board = spare,
  -- tr_table = automata.Wireworld_transition_table(),
  tr_table = automata.GoL_transition_table(),
  render = function (self)
    local x = self.box.x1
    local y = self.box.y1
    local dx = self.box.dx
    local dy = self.box.dy
    local cell_h = (dx/#self.main_board)
    local cell_w = (dy/(#self.main_board[1]))

    if global_state.pause then
      love.graphics.setColor({0.3,0.3,0.3})
    else
      love.graphics.setColor({0.0,0.6,0.0})
    end
    love.graphics.rectangle("line",self.box.x1-1,self.box.y1-1 ,self.box.dx+2,self.box.dy+2)

    for i = 1,#self.main_board,1 do
        for j = 1,#self.main_board[i],1 do
           love.graphics.setColor(self.colors_table[self.main_board[i][j]])
           love.graphics.rectangle("fill", x + (i-1)*(cell_h),y + (j-1)*(cell_w),cell_h,cell_w)
           love.graphics.setColor({0.1,0.1,0.1})
           love.graphics.rectangle("line", x + (i-1)*(cell_h),y + (j-1)*(cell_w),cell_h,cell_w)
       end
    end
  end,
  mouse_action = function (self,x,y,btn)
    if space_utils.in_box(self.box,{x,y}) and global_state.pause == true then
      local cx = math.floor(((x - self.box.x1)/(self.box.dx/self.board_size.x))) + 1
      local cy = math.floor(((y - self.box.y1)/(self.box.dy/self.board_size.y))) + 1
      self.main_board[cx][cy] = global_state.current_color
      -- print("clicked ",global_state.current_color,board[cx][cy])
    end
  end

}
automata.GoL_glider(automata_container.main_board)
-- automata.Wireworld_donut(automata_container.main_board)
register_renderable(automata_container)
register_mouse_action(automata_container)
 -- Palete buttons
local button_geometry = {
  x = board_dimensions.x + 20,
  y = 10,
  dx = 40,
  dy = 40,
  space = 10,
}
-- Color palete buttons
local buttons = space_utils.automata_create_palete_buttons(button_geometry,
automata_container.colors_table,
automata_container.tr_table.states,
function (self)
  if global_state.current_color == self.label then 
    love.graphics.setColor({0.3,0.3,0.3})
  else
    love.graphics.setColor({0.1,0.1,0.1})
  end
  love.graphics.rectangle("line",self.box.x1-1,self.box.y1-1 ,self.box.dx+2,self.box.dy+2)
  love.graphics.setColor(self.color)
  love.graphics.rectangle("fill",self.box.x1,self.box.y1 ,self.box.dx,self.box.dy)
end,
function (self,x,y,btn)
  if space_utils.in_box(self.box,{x,y}) then
    global_state.current_color = self.label
  end
end)

local generation_label = {
  box = space_utils.box_next_g(button_geometry,{x = 0,y = 0}),
  generation = 0,
  render = function (self)
    love.graphics.setColor({1,1,1})
    love.graphics.print("Gen:", self.box.x1,self.box.y1)
    love.graphics.print(self.generation, self.box.x1,self.box.y1 + 12)
    -- TODO : Make size of box adjust dynamically beased on text
    love.graphics.setColor({.3,.3,.3})
    love.graphics.rectangle("line",self.box.x1-1,self.box.y1-1 ,self.box.dx+2,self.box.dy+2)
  end,
  mouse_action = function (self,x,y,btn)
    if space_utils.in_box(self.box,{x,y}) then
      self.generation = 0
    end
  end,
}

table.insert(buttons,generation_label)

local speed_controler = {
  box = space_utils.box_next_g(button_geometry,{x = 0,y = 1}),
  per_second = 3,
  render = function (self)
    love.graphics.setColor({1,1,1})
    love.graphics.print("Upd/s:", self.box.x1,self.box.y1)
    love.graphics.print(self.per_second, self.box.x1,self.box.y1 + 12)
    -- TODO : Make size of box adjust dynamically beased on text
    love.graphics.setColor({.3,.3,.3})
    love.graphics.rectangle("line",self.box.x1-1,self.box.y1-1 ,self.box.dx+2,self.box.dy+2)
  end,
  mouse_action = function (self,x,y,btn)
    if space_utils.in_box(self.box,{x,y}) then
      if btn == 1 then
        self.per_second = self.per_second +1
      else
        self.per_second = self.per_second -1
        if self.per_second == 0 then
            self.per_second = 1
        end
      end
    end
  end,
}
table.insert(buttons,speed_controler)

local reset_button = {
  box = space_utils.box_next_g(button_geometry,{x = 0,y = 1}),
  render = function (self)
    love.graphics.setColor({1,1,1})
    love.graphics.print("RESET", self.box.x1,self.box.y1 + 12)
    love.graphics.setColor({.3,.3,.3})
    love.graphics.rectangle("line",self.box.x1-1,self.box.y1-1 ,self.box.dx+2,self.box.dy+2)
  end,
  mouse_action = function (self,x,y,btn)
    if space_utils.in_box(self.box,{x,y}) then
        generation_label.generation = 0
        speed_controler.per_second = 3
        automata_container.main_board = automata.generate_board(board_size.x,board_size.y)
        global_state.pause = true
    end
  end,
}

table.insert(buttons,reset_button)

for _,i in pairs(buttons) do
  register_renderable(i)
  register_mouse_action(i)
end



function love.draw()
  for _,ren in pairs(global_state.renderables) do
    ren.render(ren)
  end
end

local since_last_update = 0
function love.update(dt)
    if dt < 1/60 then
        love.timer.sleep((1/60 - dt))
    end
    since_last_update = since_last_update + 1/60
    local framerate = 1/speed_controler.per_second
    love.timer.sleep((framerate))
    if global_state.pause == false or global_state.steps > 0 and since_last_update >= 1/speed_controler.per_second then
      generation_label.generation = generation_label.generation + 1
      automata_container.main_board, automata_container.spare_board = automata.advance_board(automata_container.main_board, automata_container.spare_board,automata_container.tr_table)
      global_state.steps = 0
      since_last_update = since_last_update - 1/speed_controler.per_second
    end
  -- end
    love.graphics.clear()
end

function love.keypressed(key, scancode, isrepeat)
   if key == "escape" then
      love.event.quit()
   end
   if key == "n" then
      global_state.steps = 1
   end
   if key == "space" then
       global_state.pause = not global_state.pause
   end
end

function love.mousepressed( x, y, button, istouch, presses )
  for _,mac in pairs(global_state.actionables.mouse) do
    mac.mouse_action(mac,x,y,button)
  end
end
