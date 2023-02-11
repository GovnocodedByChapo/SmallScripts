script_author('chapo')
local inicfg = require('inicfg')
local directIni = 'SimpleWeatherAndTimeChangerByChapo.ini'
local ini = inicfg.load({
    main = {
        blockTime = false,
        blockWeather = false,
        time = 9,
        weather = 0
    }
}, directIni)
inicfg.save(ini, directIni)

function main()
    while not isSampAvailable() do wait(0) end
    sampRegisterChatCommand('/time', function(arg)
        local num = tonumber(arg)
        if not num or num > 23 or num < 0 then
            return sampAddChatMessage('>> {ffffff}Ошибка, введите число (от 0 до 23)', 0xFFff004d)
        end
        ini.main.time = num
        inicfg.save(ini, directIni)
        local bs = raknetNewBitStream()
        raknetBitStreamWriteInt8(bs, num)
        raknetEmulRpcReceiveBitStream(94, bs)
        raknetDeleteBitStream(bs)
    end)
    sampRegisterChatCommand('/weather', function(arg)
        local num = tonumber(arg)
        if not num or num < 0 or num > 45 then
            return sampAddChatMessage('>> {ffffff}Ошибка, введите число (от 0 до 45)', 0xFFff004d)
        end
        ini.main.weather = num
        inicfg.save(ini, directIni)
        local bs = raknetNewBitStream()
		raknetBitStreamWriteInt8(bs, num)
		raknetEmulRpcReceiveBitStream(152, bs)
		raknetDeleteBitStream(bs)
    end)
    sampRegisterChatCommand('/blocktime', function(arg)
        sampAddChatMessage('>> {ffffff}Блокировка изменения времени сервером '..(ini.main.blockTime and 'включена' or 'выключена'), 0xFFff004d)
        ini.main.blockTime = not ini.main.blockTime
        inicfg.save(ini, directIni)
    end)
    sampRegisterChatCommand('/blockweather', function(arg)
        sampAddChatMessage('>> {ffffff}Блокировка изменения погоды сервером '..(ini.main.blockWeather and 'включена' or 'выключена'), 0xFFff004d)
        ini.main.blockWeather = not ini.main.blockWeather
        inicfg.save(ini, directIni)
    end)
    wait(-1)
end

addEventHandler('onReceiveRpc', function(id)
    if (id == 152 and ini.main.blockWeather) or (id == 94 and ini.main.blockTime) then 
        return false 
    end
end)