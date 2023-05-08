-- TODO: create a module
local M = {}
function get_filled_array(size,value)
    local ret = {}
    for i = 1, size, 1 do
        ret[i] = value
    end
    return ret
end

function dump_impl(offs ,o)
   if type(o) == 'table' then
      local s = '{\n'
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. offs ..'  ['..k..'] = ' .. dump_impl(offs..' ',v) .. ',\n'
      end
      return s .. offs .. '}'
   else
      return tostring(o)
   end
end

function dump(o)
  return dump_impl('',o)
end
M.dump = dump

function generate_board(size_x,size_y)
    local res = {}
    for i = 1, size_y, 1 do
        res[i] = get_filled_array(size_x,0)
    end
    return res
end

M.generate_board = generate_board

function generate_boards(size_x,size_y)
    return generate_board(size_x,size_y), generate_board(size_x,size_y)
end
M.generate_boards = generate_boards

local function show_board_term(board,translation)
    for i = 1, #board, 1 do
        for j = 1,#board[i], 1 do
            io.write(translation[board[i][j]])
        end
        print("")
    end
end

local function get_adjaicent(board,_x,_y,adj,states)
    for _,v in pairs(states) do
        adj[v] = 0
    end
    for dx=-1,1,1 do
        for dy=-1,1,1 do
            if dx ~=0 or dy ~= 0 then
                local x = (_x + dx)% #board
                local y = (_y + dy)% #board
                if x == 0 then x = #board end
                if y == 0 then y = #board end
                adj[board[x][y]] = adj[board[x][y]] + 1
            end
        end
    end
    local res = ""
    for _,v in pairs(states) do
        res = res .. adj[v]
    end
    return res
end

local function advance_board(brd,spare,trans_table)
    local adj = {}
    for _,v in pairs(trans_table["states"]) do
        adj[v] = 0
    end
    for i = 1, #brd, 1 do
        for j = 1,#brd[i], 1 do
            local key = get_adjaicent(brd,i,j,adj,trans_table["states"])
            spare[i][j] = trans_table[brd[i][j]][key]
        end
    end
    return spare,brd
end
M.advance_board = advance_board
local function wildcard_table_select (tbl,key)
        local res = nil
        for k,v in pairs(tbl) do
            if string.match(key,k) then
                return v
            end
        end
        return tbl.default
end

local function tr(tbl)
    return setmetatable(tbl,{__index = wildcard_table_select})
end
M.tr = tr

local DEAD = 0
local ALIVE = 1


local EMPTY = 0
local CONNECTOR = 1
local ELECTRON_TAIL = 2
local ELECTRON_HEAD = 3


function glider(brd)
    brd[1][2] = ALIVE
    brd[2][3] = ALIVE
    brd[3][1] = ALIVE
    brd[3][2] = ALIVE
    brd[3][3] = ALIVE
end
M.GoL_glider = glider

local function GoL_transition_table()
    return {
        states = {DEAD,ALIVE},
        [DEAD] = tr({
            [".3"]  =  ALIVE,
            ["default"] = DEAD
        }),
        [ALIVE] = tr({
            [".2"]  =  ALIVE,
            [".3"]  =  ALIVE,
            ["default"] = DEAD
        })
    }
end
M.GoL_transition_table = GoL_transition_table

local function Wireworld_donut(brd)
    brd[2][1] = ELECTRON_HEAD
    brd[3][1] = CONNECTOR
    brd[4][1] = CONNECTOR
    brd[5][1] = CONNECTOR
    brd[6][1] = CONNECTOR

    brd[1][2] = ELECTRON_TAIL
    brd[7][2] = ELECTRON_TAIL

    brd[2][3] = CONNECTOR
    brd[3][3] = CONNECTOR
    brd[4][3] = CONNECTOR
    brd[5][3] = CONNECTOR
    brd[6][3] = ELECTRON_HEAD
end

M.Wireworld_donut = Wireworld_donut
local function Wireworld_transition_table()
    return {
        states = {EMPTY,CONNECTOR,ELECTRON_TAIL,ELECTRON_HEAD},
        [EMPTY] = tr({
            ["default"] = EMPTY
        }),
        [CONNECTOR] = tr({
            -- these can be replaced with ...[12] but that would take away alignment if there were others
            ["...1"]  =  ELECTRON_HEAD,
            ["...2"]  =  ELECTRON_HEAD,
            ["default"] = CONNECTOR
        }),
        [ELECTRON_HEAD] = tr({
            ["default"] = ELECTRON_TAIL
        }),
        [ELECTRON_TAIL] = tr({
            ["default"] = CONNECTOR
        })
    }
end

M.Wireworld_transition_table = Wireworld_transition_table



local function test()
    local tr_table = GoL_transition_table()
    local board_size = 10
    local brd = generate_board(board_size,board_size)
    local spare = generate_board(board_size,board_size)
    glider(brd,ALIVE)
    -- print(brd)
    -- show_board_term(brd,{[DEAD] = '.',[ALIVE] = '#'})
    while true do
        brd,spare = advance_board(brd,spare,tr_table)
        -- show_board_term(brd,{[DEAD] = '.',[ALIVE] = '#'})
    end
end

local function test_wildcard_transition()
    local t = tr({["[12]."] = 10,["2."] = 21, ["11"] = 11, ["20"] = 20, ["default"]  = 5})
    print(t["10"])
    print(t["20"])
    print(t["22"])
end
-- test()
test_wildcard_transition()
return M
