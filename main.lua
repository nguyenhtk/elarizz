local gamera = require('gamera.gamera') -- 
local parallax = require('parallax.parallax')
local layers = {}
local player = {}
local camera


function love.load()
   love.window.setMode(650, 650)
   love.window.setTitle("elyrizz")

   camera = gamera.new(0,0,2000,650)
   layers.near = parallax.new(camera, 1)
   player.x = camera.ww / 2
   player.y = camera.wh / 2
   player.width = 10
   player.half = player.width / 2
   player.speed = 500
end

local function draw_all(l,t,w,h)
   local rect_w = 50
   local offset = camera.ww * 2

   -- Draw the game here
   love.graphics.setColor(1,1,1,1)
   love.graphics.rectangle('fill', player.x - player.half, player.y - player.half, player.width, player.width)

   layers.near:draw(function()
      -- Draw something near the camera here.
      love.graphics.setColor(1,0,0,1)
          love.graphics.rectangle('fill',0 , camera.wh* 2 /3 , camera.ww,  camera.wh/3)
          love.graphics.setColor(0,0,1,1)
          love.graphics.rectangle('fill',camera.ww/2 , camera.wh* 2 /3  , camera.ww,  camera.wh/3)
  end)
end
function love.update(dt)
   if player.x > camera.ww then
      player.x = 0
   end
   if player.x < 0 then
      player.x = camera.ww
   end
   if love.keyboard.isDown("d") then
      player.x = player.x + player.speed * dt
   end
   if love.keyboard.isDown("q") then
      player.x = player.x - player.speed * dt
   end

   camera:setPosition(player.x, player.y)

end

function love.draw()
   love.graphics.clear()
   love.graphics.print(camera.ww .. " " .. camera.wh)
   camera:draw(draw_all)
end


