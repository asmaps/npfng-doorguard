local config = require('config')

local function showResult(good, bad)
    if bad > 0 then
        print("some bad! => "..bad)
        print("good: "..good)
        if config.PIN_RGB_LED then
            ws2812.write(config.PIN_RGB_LED, string.char(0, 50, 0))
        end
    else
        print("all good! => "..good)
        print("bad: "..bad)
        if config.PIN_RGB_LED then
            ws2812.write(config.PIN_RGB_LED, string.char(50, 0, 0))
        end
    end
    if config.PIN_RGB_LED then
        tmr.alarm(1, 1000, 0, function ()
            ws2812.write(config.PIN_RGB_LED, string.char(0, 0, 0))
        end)
    end
end

local function getStates()
    local bad = 0
    local good = 0
    local received = 0
    local expReceived = 0
    local allScheduled = false
    if config.PIN_RGB_LED then
        ws2812.write(config.PIN_RGB_LED, string.char(50, 50, 0))
    end
    for i, ip in ipairs(config.SLAVE_IPS) do
        local sock = net.createConnection(net.TCP, 0)
        sock:on("receive", function(sck, c)
            print("states: "..c)
            for i, v in ipairs(cjson.decode(c)["states"]) do
                if v == 0 then
                    print(i.." => ok")
                    good = good + 1
                else
                    print(i.." => bad")
                    bad = bad + 1
                end
            end
            sck:close()
            received = received + 1
            if received == expReceived and allScheduled then
                showResult(good, bad)
            end
        end)
        print("Connecting to "..ip)
        expReceived = expReceived + 1
        sock:connect(12345, ip)
        sock:send("x")
    end
    allScheduled = true
end

local function start()
    gpio.mode(3, gpio.INT, gpio.PULLUP)
    gpio.trig(3, "down", getStates)
end

return {start = start}
