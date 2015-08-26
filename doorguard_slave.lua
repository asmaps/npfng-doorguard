local config = require('config')

local function start()
    for i, pin in ipairs(config.PINS_REEDSWITCH) do
        gpio.mode(pin, gpio.INPUT, gpio.PULLUP)
    end
    local srv = net.createServer(net.TCP, 30)
    srv:listen(12345, function(sock)
        states = {}
        for i, pin in ipairs(config.PINS_REEDSWITCH) do
            table.insert(states, gpio.read(pin))
        end
        sock:send(cjson.encode({states=states}))
    end)
end

return {start = start}
