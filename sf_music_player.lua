--@name lalala
--@author kitsune.
--@client

//Garry's Mod Starfall chip that plays music from Discord link
//Links from Discord or other supported by Starfall sources.

local url = "https://cdn.discordapp.com/attachments/1151063343742849024/1151063541625917460/Jumping_Heart_-_Heavy_Metal_Ver..mp3?ex=6593c176&is=65814c76&hm=55651e84c77ea5fdee0565d4830ecd4648ab127c197ab2b50082c8f74144adbc&"
local music = nil
local vol = 0.1
local distance = 1200

cube = hologram.create(Vector(), Angle(), "models/hiroko/ohota_krepkoe.mdl", Vector(0.5, 0.5, 0.5))

hook.add("tick", "AddHologram", function()
    playerAimVector = owner():getAimVector()
    playerEyePos = owner():getEyePos()
    cube:setPos(playerAimVector * 10 + playerEyePos + Vector(0, -10, 20))
    cube:setAngles(Angle(0, timer.curtime() * 30, 0))
end)

local function play(object)
    object:setPos(chip():getPos())
    object:setVolume(vol)
    object:setLooping(1)
    object:setFade(600, 1000)
    object:play()
    music = object
end

bass.loadURL(url,"3d noblock",function(m) play(m,m:getLength())end)

hook.add("Think","while"..owner():getSteamID64(),function()
    
    if music == nil  then return end
    
    if !music:isValid() then return end
    
    music:setPos(cube:getPos())
    
    if owner():getPos():getDistance(player():getPos()) > distance then music:setVolume(0) end
    if owner():getPos():getDistance(player():getPos()) <= distance then music:setVolume(vol) end
    
end)

hook.add("PlayerChat","discordMP3PlayerChat"..owner():getSteamID64(),function(ply,txt)
    
    if ply ~= owner() then return end
    
    if txt == "!pause" or txt == "!stop" then music:pause() return end
    
    if txt == "!play" then music:play() return end
    
    if string.startWith(txt,"!volume") then 
        vol = tonumber(string.replace(string.split(txt,"!volume")[2]," ",""))
        if vol > 1 then vol = vol / 100 end
        music:setVolume(vol)
    return end
    
    if string.startWith(txt,"!change") then 
        url = string.replace(string.split(txt,"!change")[2]," ","")
        music:destroy()
        bass.loadURL(url,"3d noblock",function(m) play(m)end)    
    return end
    
end)
