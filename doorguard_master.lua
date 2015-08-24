local config = require('config')
local slaves = {"192.168.178.45"}

local function getStates()
    for i, ip in ipairs(slaves) do
        local sock = net.createConnection(net.TCP, 0)
        sock:on("receive", function(sck, c)
            print("states: ")
            for i, v in ipairs(cjson.decode(c)["states"]) do
                if v == 1 then
                    print(i.." => ok")
                else
                    print(i.." => bad")
                end
            end
            sck:close()
        end)
        print("Connecting to "..ip)
        sock:connect(12345, ip)
        sock:send("x")
    end
end

local function start()
    gpio.mode(3, gpio.INT, gpio.PULLUP)
    gpio.trig(3, "down", getStates)
end

return {start = start}
