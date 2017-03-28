--- api interface ABSTRACT
-- (MIXED lua)
-- store functions implemented in CoronaApi, LoveApi and any others.
-- Looks dirty :P
-- There is no intention to make a full framework, just interfacing the needed apis
-- implementing each function when is needed.

-- Benefits: 
-- In order to port this game to any other SDK or engine that use Lua, 
-- you only need to implement a new api (like current loveapi.lua) with the basics defined on this interface,
-- later you can continue exending it or just using direct calls to your sdk if you want.

-- Graphics: Assuming all visual objects need two functions: "make" for initialization 
-- and "draw" for drawing. This gerelalize better the way different SDKs works, like
-- corona SDK and Love2D. 


local api = {}

-- Dirty trick to detect if Corona SDK or Love ;)
-- first time we require this module it will be inialized with the current detected SDK
if display~=nil then
  -- maybe is corona sdk
  if display.newImage~=nil then
    -- pretty sure it is
    print "Running: Corona SDK"
    api = require('code.coronaapi')     
  end
elseif love~=nil then
  -- maybe is löve
  if love.graphics~=nil then
    -- pretty sure it is löve
    print 'Running: Löve'
    api = require('code.loveapi')    
  end
end

--override this events on main.lua
api.onLoad = nil
api.onUpdate = nil
api.onDraw = nil

-- Events functions primised to be called from each api sdk;

--- Called when application begins
function api.load()
  if api.onLoad~=nil then api.onLoad() end
end

--- Called each frame to update game data, dt is delta time between frames
function api.update()
  if api.onUpdate~=nil then api.onUpdate() end
end

--- Called each frame to draw the visuals
function api.draw()
  if api.onDraw~=nil then api.onDraw() end
end

--- call this from main lua to inform apis things has started;
-- sdks like corona doesn't provide Load event like Löve so it need this to call api.load();
function api.start()
  api.started()  
end

-- Check the "abstract" functions and properties, if they aren't implemented is a fatal error

-- starting with a formality, the name:
if api.exitGame==nil then print "ERROR: api.exitGame() undefined" end
if api.name==nil then print "ERROR: api.name string not defined" end
if api.started==nil then print 'ERROR: api.started() undefined' end
if api.newCircle==nil then print "ERROR: api.makeCircle(x,y,radious) undefined" end
if api.drawCircle==nil then print "ERROR: api.drawCircle(circle) undefined" end
--- call from main.lua some SDKs like corona doesn't have a begin event. 

return api