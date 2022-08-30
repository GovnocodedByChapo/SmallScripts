script_name('ARZ Default Logo Changer')
script_author('chapo')

local ffi = require('ffi')
local inicfg = require('inicfg')
local imgui = require('mimgui')
local encoding = require('encoding')
encoding.default = 'CP1251'
u8 = encoding.UTF8
local directIni = '__ArizonaDefaultLogoChangerByChapo.ini'
local ini = inicfg.load(inicfg.load({
    main = {
        Title = u8'Конская',
        Name = u8'Залупа',
        ColorTitleShadow = encodeJson({0, 0, 0, 1}),
        ColorTitle = encodeJson({1, 0, 0, 1}),
        ColorNameShadow = encodeJson({0, 0, 0, 1}),
        ColorName = encodeJson({1, 1, 1, 1})
    },
}, directIni))
inicfg.save(ini, directIni)

local renderWindow = imgui.new.bool(false)
local Logo = {
    Title = imgui.new.char[128](ini.main.Title or 'Chapo'),
    Name = imgui.new.char[128](ini.main.Name or 'Ebanat'),
    ColorTitleShadow = imgui.new.float[4](table.unpack(decodeJson(ini.main.ColorTitleShadow))),
    ColorTitle = imgui.new.float[4](table.unpack(decodeJson(ini.main.ColorTitle))),
    ColorNameShadow = imgui.new.float[4](table.unpack(decodeJson(ini.main.ColorNameShadow))),
    ColorName = imgui.new.float[4](table.unpack(decodeJson(ini.main.ColorName))),
}

imgui.OnInitialize(function()
    imgui.GetIO().IniFilename = nil
    imgui.DarkTheme()
end)

local newFrame = imgui.OnFrame(
    function() return renderWindow[0] end,
    function(self)
        local resX, resY = getScreenResolution()
        local sizeX, sizeY = 300, 215
        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY), imgui.Cond.FirstUseEver)
        if imgui.Begin('ARZ Logo Editor (vk.com/chaposcripts)', renderWindow, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse) then
            imgui.PushItemWidth(290)
            imgui.CenterText(u8'Заголовок')
            imgui.InputText(u8'##Заголовок', Logo.Title, ffi.sizeof(Logo.Title)) 
            imgui.Text(u8'Цвет:') imgui.SameLine() imgui.ColorEdit4('##ColorTitle', Logo.ColorTitle, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.AlphaBar) 
            imgui.SameLine(225)
            imgui.Text(u8'Тень:') imgui.SameLine(270) imgui.ColorEdit4('##ColorTitleShadow', Logo.ColorTitleShadow, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.AlphaBar) 

            imgui.Separator()
            imgui.CenterText(u8'Название')
            imgui.InputText(u8'##Название', Logo.Name, ffi.sizeof(Logo.Name))
            imgui.Text(u8'Цвет:') imgui.SameLine() imgui.ColorEdit4('##ColorName', Logo.ColorName, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.AlphaBar) 
            imgui.SameLine(225)
            imgui.Text(u8'Тень:') imgui.SameLine(270) imgui.ColorEdit4('##ColorNameShadow', Logo.ColorNameShadow, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.AlphaBar) 
            imgui.PopItemWidth()
            if imgui.Button(u8'Сохранить и закрыть', imgui.ImVec2(290, 20)) then
                ini.main.Title = ffi.string(Logo.Title)
                ini.main.Name = ffi.string(Logo.Name)
                ini.main.ColorTitleShadow = encodeJson({Logo.ColorTitleShadow[0], Logo.ColorTitleShadow[1], Logo.ColorTitleShadow[2], Logo.ColorTitleShadow[3]})
                ini.main.ColorTitle = encodeJson({Logo.ColorTitle[0], Logo.ColorTitle[1], Logo.ColorTitle[2], Logo.ColorTitle[3]})
                ini.main.ColorNameShadow = encodeJson({Logo.ColorNameShadow[0], Logo.ColorNameShadow[1], Logo.ColorNameShadow[2], Logo.ColorNameShadow[3]})
                ini.main.ColorName = encodeJson({Logo.ColorName[0], Logo.ColorName[1], Logo.ColorName[2], Logo.ColorName[3]})
                inicfg.save(ini, directIni)
                renderWindow[0] = false
            end
            imgui.End()
        end
    end
)

function imgui.CenterText(text)
    imgui.SetCursorPosX(imgui.GetWindowSize().x / 2 - imgui.CalcTextSize(text).x / 2)
    imgui.Text(text)
end

function main()
    while not isSampAvailable() do wait(0) end
    sampRegisterChatCommand('adlogo', function()
        renderWindow[0] = not renderWindow[0]
    end)
    while true do
        wait(0)
        for id = 0, 4096 do
            if sampTextdrawIsExists(id) then
                local x, y = sampTextdrawGetPos(id)
                if x == 550 and y == 1 then
                    sampTextdrawSetString(id, RusToGame(u8:decode(ffi.string(Logo.Title))):sub(1, 1))
                    sampTextdrawSetLetterSizeAndColor(id,  0.54999899864197,   2.7999980449677, join_argb(Logo.ColorTitle[3]*255, Logo.ColorTitle[0]*255, Logo.ColorTitle[1]*255, Logo.ColorTitle[2]*255))
                    sampTextdrawSetOutlineColor(id, 1, join_argb(Logo.ColorTitleShadow[3]*255, Logo.ColorTitleShadow[0]*255, Logo.ColorTitleShadow[1]*255, Logo.ColorTitleShadow[2]*255))
                elseif x == 565 and y == 6 then
                    sampTextdrawSetString(id, RusToGame(u8:decode(string.sub(ffi.string(Logo.Title), 2, #ffi.string(Logo.Title)))))
                    sampTextdrawSetLetterSizeAndColor(id,  0.31999799609184,   1.1999980211258, join_argb(Logo.ColorTitle[3]*255, Logo.ColorTitle[0]*255, Logo.ColorTitle[1]*255, Logo.ColorTitle[2]*255))
                    sampTextdrawSetOutlineColor(id, 1, join_argb(Logo.ColorTitleShadow[3]*255, Logo.ColorTitleShadow[0]*255, Logo.ColorTitleShadow[1]*255, Logo.ColorTitleShadow[2]*255))
                elseif x == 563 and y == 14 then
                    sampTextdrawSetString(id, RusToGame(u8:decode(ffi.string(Logo.Name))))
                    sampTextdrawSetLetterSizeAndColor(id, 0.16999900341034, 1.3999990224838, join_argb(Logo.ColorName[3]*255, Logo.ColorName[0]*255, Logo.ColorName[1]*255, Logo.ColorName[2]*255))
                    sampTextdrawSetOutlineColor(id, 1, join_argb(Logo.ColorNameShadow[3]*255, Logo.ColorNameShadow[0]*255, Logo.ColorNameShadow[1]*255, Logo.ColorNameShadow[2]*255))
                end
            end
        end
    end
end

function join_argb(a, r, g, b)
    local argb = b  -- b
    argb = bit.bor(argb, bit.lshift(g, 8))  -- g
    argb = bit.bor(argb, bit.lshift(r, 16)) -- r
    argb = bit.bor(argb, bit.lshift(a, 24)) -- a
    return argb
end

function RusToGame(text)
    local convtbl = {[230]=155,[231]=159,[247]=164,[234]=107,[250]=144,[251]=168,[254]=171,[253]=170,[255]=172,[224]=97,[240]=112,[241]=99,[226]=162,[228]=154,[225]=151,[227]=153,[248]=165,[243]=121,[184]=101,[235]=158,[238]=111,[245]=120,[233]=157,[242]=166,[239]=163,[244]=63,[237]=174,[229]=101,[246]=36,[236]=175,[232]=156,[249]=161,[252]=169,[215]=141,[202]=75,[204]=77,[220]=146,[221]=147,[222]=148,[192]=65,[193]=128,[209]=67,[194]=139,[195]=130,[197]=69,[206]=79,[213]=88,[168]=69,[223]=149,[207]=140,[203]=135,[201]=133,[199]=136,[196]=131,[208]=80,[200]=133,[198]=132,[210]=143,[211]=89,[216]=142,[212]=129,[214]=137,[205]=72,[217]=138,[218]=167,[219]=145}
    local result = {}
    for i = 1, #text do
        local c = text:byte(i)
        result[i] = string.char(convtbl[c] or c)
    end
    return table.concat(result)
end

function imgui.DarkTheme()
    imgui.SwitchContext()
    --==[ STYLE ]==--
    imgui.GetStyle().WindowPadding = imgui.ImVec2(5, 5)
    imgui.GetStyle().FramePadding = imgui.ImVec2(5, 5)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(5, 5)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2, 2)
    imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
    imgui.GetStyle().IndentSpacing = 0
    imgui.GetStyle().ScrollbarSize = 10
    imgui.GetStyle().GrabMinSize = 10

    --==[ BORDER ]==--
    imgui.GetStyle().WindowBorderSize = 1
    imgui.GetStyle().ChildBorderSize = 1
    imgui.GetStyle().PopupBorderSize = 1
    imgui.GetStyle().FrameBorderSize = 1
    imgui.GetStyle().TabBorderSize = 1

    --==[ ROUNDING ]==--
    imgui.GetStyle().WindowRounding = 5
    imgui.GetStyle().ChildRounding = 5
    imgui.GetStyle().FrameRounding = 5
    imgui.GetStyle().PopupRounding = 5
    imgui.GetStyle().ScrollbarRounding = 5
    imgui.GetStyle().GrabRounding = 5
    imgui.GetStyle().TabRounding = 5

    --==[ ALIGN ]==--
    imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().SelectableTextAlign = imgui.ImVec2(0.5, 0.5)
    
    --==[ COLORS ]==--
    imgui.GetStyle().Colors[imgui.Col.Text]                   = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
    imgui.GetStyle().Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Border]                 = imgui.ImVec4(0.25, 0.25, 0.26, 0.54)
    imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.00, 0.00, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.51, 0.51, 0.51, 1.00)
    imgui.GetStyle().Colors[imgui.Col.CheckMark]              = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Button]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Header]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.47, 0.47, 0.47, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Separator]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(1.00, 1.00, 1.00, 0.25)
    imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(1.00, 1.00, 1.00, 0.67)
    imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(1.00, 1.00, 1.00, 0.95)
    imgui.GetStyle().Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.28, 0.28, 0.28, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabUnfocused]           = imgui.ImVec4(0.07, 0.10, 0.15, 0.97)
    imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]     = imgui.ImVec4(0.14, 0.26, 0.42, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.61, 0.61, 0.61, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(1.00, 0.43, 0.35, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.90, 0.70, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(1.00, 0.60, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(1.00, 0.00, 0.00, 0.35)
    imgui.GetStyle().Colors[imgui.Col.DragDropTarget]         = imgui.ImVec4(1.00, 1.00, 0.00, 0.90)
    imgui.GetStyle().Colors[imgui.Col.NavHighlight]           = imgui.ImVec4(0.26, 0.59, 0.98, 1.00)
    imgui.GetStyle().Colors[imgui.Col.NavWindowingHighlight]  = imgui.ImVec4(1.00, 1.00, 1.00, 0.70)
    imgui.GetStyle().Colors[imgui.Col.NavWindowingDimBg]      = imgui.ImVec4(0.80, 0.80, 0.80, 0.20)
    imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.00, 0.00, 0.00, 0.70)
end