local gamera = require('gamera.gamera') -- 
local parallax = require('parallax.parallax')
local wavuSequence1 = {"d","s","sd"}
local wavuSequence2 = {"sd","d","s"}
local wavuSequence3 = {"s","sd","d"}
local inputBuffer = {}
local inputCount = 1
local layers = {}
local player = {}
local camera   
local stance = 0

local function arrayEqual(a1, a2)
   -- Check length, or else the loop isn't valid.
   if #a1 ~= #a2 then
     return false
   end
 
   -- Check each element.
   for i, v in ipairs(a1) do
     if v ~= a2[i] then
       return false
     end
   end
   
   -- We've checked everything.
   return true
 end
 
function love.load()
   love.window.setMode(650, 650)
   love.window.setTitle("elyrizz")
   Elyas = love.graphics.newImage("assets/image/elyas.png")
   ElyasDown = love.graphics.newImage("assets/image/elyas2.png")
   Bg = love.graphics.newImage("assets/image/bg.png")
   BgmSource = love.audio.newSource("assets/music/bgm.mp3","static")
   BgmSource:setVolume(0.1)
   NyonSource = love.audio.newSource("assets/sound_effect/nyon.mp3","static")
   NyonSource:setVolume(0.3)
   camera = gamera.new(0,0,2000,650)
   layers.near = parallax.new(camera, 1)
   layers.far = parallax.new(camera, 1.6)
   player.x = camera.ww / 2
   player.y = camera.wh / 2
   player.width = 10
   player.half = player.width / 2
   player.speed = 500
end

local function draw_all(l,t,w,h)
   local rect_w = 50
   local offset = camera.ww * 2

   love.graphics.setBackgroundColor(0,0,0)
   layers.far:draw(function()
      love.graphics.setColor(1,1,1,1)
      love.graphics.draw(Bg,0 , 0)
   end)
   layers.near:draw(function()
      -- Draw something near the camera here.
      love.graphics.setColor(1,0,0,1)
          love.graphics.rectangle('fill',0 , camera.wh* 2 /3 , camera.ww,  camera.wh/3)
          love.graphics.setColor(0,0,1,1)
          love.graphics.rectangle('fill',camera.ww/2 , camera.wh* 2 /3  , camera.ww,  camera.wh/3)
  end)
   -- Draw the game here
   love.graphics.setColor(1,1,1,1)
   if stance == 0 then
      love.graphics.draw(Elyas,player.x - player.half, player.y - player.half)
   else
      love.graphics.draw(ElyasDown,player.x - player.half, player.y - player.half)
   end
end
function love.update(dt)
   
   -- music
   if not BgmSource:isPlaying() then
      love.audio.play(BgmSource)
   end

   -- mouvement
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

   if arrayEqual(inputBuffer,wavuSequence1) or arrayEqual(inputBuffer,wavuSequence2 or arrayEqual(inputBuffer,wavuSequence3)) then

      stance=1
      player.x = player.x + player.speed*100 * dt

         love.audio.play(NyonSource)
      inputBuffer[1] = "?"
      inputBuffer[2] = "?"
      inputBuffer[3] = "?"
   end

   camera:setPosition(player.x, player.y)

end

function love.draw()

   love.graphics.print(inputCount)
   camera:draw(draw_all)

end

function love.keypressed(key, scancode, isrepeat)
   stance=0
   if key == "d" then

      inputBuffer[inputCount] = "d"
   end
   if key == "s" then

      inputBuffer[inputCount] = "s"
   end
   if key == "d" and love.keyboard.isDown("s") then

      inputBuffer[inputCount] = "sd"
   end
   inputCount = inputCount + 1
   if inputCount == 4 then
      inputCount = 1
   end
end

