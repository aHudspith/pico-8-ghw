pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
function _init()
	game_over=false
	make_cave()
	make_player()
end

function _update()
 if (not game_over) then
  update_cave()
  move_player()
  check_hit()
 else
  if (btnp(5)) _init() --restart game
 end
end

function _draw()
	cls()
	draw_cave()
 draw_player()
 
 if (game_over) then
  print("game over!", 44, 44, 7)
  print("your score:"..player.score, 34, 54, 7)
  print("press ❎ to play again!", 18, 72, 6)
 else
  print("score:"..player.score, 2, 2, 7)
 end
end

-->8
function make_player()
	player={}
	
	--position
	player.x=24
	player.y=60
	
	--fall speed
	player.dy=0
	
	--sprites
	player.rise=1
	player.fall=2
	player.dead=3
	
	--swim speed
	player.speed=2
	
	--score
	player.score=0
end

function draw_player()
 if (game_over) then
  spr(player.dead, player.x, player.y)
 elseif (player.dy<0) then
  spr(player.rise, player.x, player.y)
 else
  spr(player.fall, player.x, player.y)
 end
end

function move_player()
 gravity=0.2
 player.dy+=gravity
 --more gravity = faster fall
 
 --jump
 if (btnp(2)) then
  player.dy-=5
 end
 -- -ive gravity = go up
 
 --move to next position
 player.y+=player.dy
 
 --update score
 player.score+=player.speed
end

function check_hit()
 for i=player.x, player.x+7 do
  if (cave[i+1].top>player.y
  or cave[i+1].btm<player.y+7) then
  	game_over=true
 	end
	end
end


-->8
function make_cave()
 cave={{["top"]=5,["btm"]=119}}
 top=45 --max drop for ceiling
 btm=85 --max height for floor
end

function update_cave()

 --remove left of cave
 if (#cave>player.speed) then
  for i=1, player.speed do
   del(cave, cave[1])
  end
 end
 
 --add right of cave
 while (#cave<128) do
  local col={}
  
  local up=flr(rnd(7)-3)
  local dwn=flr(rnd(7)-3)
  
  col.top=mid(3, cave[#cave].top+up, top)
  col.btm=mid(btm, cave[#cave].btm+dwn, 124)
  
  add(cave, col)
 end
end

function draw_cave()
 top_colour=5
 btm_colour=5
 
 for i=1, #cave do
  line(i-1, 0, i-1, cave[i].top, top_colour)
  line(i-1, 127, i-1, cave[i].btm, btm_colour)
 end
end

__gfx__
00000000000dd0000000000000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000deed0000dddd0008999980000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000deeeed00deeeed089999998000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000deeeed0deeeeeed89999998000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000dddd00deeeeeed08888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070000d00d000dddddd008008080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000d00d000d00d0d080080008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000d00d00d00d000d08008080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
