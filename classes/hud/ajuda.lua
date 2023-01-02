Ajuda = Classe:extend()

ALTURA_BOTAO = 50

local function newButton(text, fn, ajuda_text)
    return{
        text = text,
        fn = fn,
        ajuda_text = ajuda_text,

        now = false,
        last = false
    }
end

local botoes = {}
local botoes2 = {}

function Ajuda:new()
    opc = 0

    table.insert(botoes, newButton(
        "W",
        function()
            
        end,
        " =   ANDAR PARA CIMA"
    ))

    table.insert(botoes, newButton(
        "S",
        function()
            
        end,
        " =   ANDAR PARA BAIXO"
    ))

    table.insert(botoes, newButton(
        "A",
        function()
            
        end,
        " =   ANDAR PARA A ESQUERDA"
    ))

    table.insert(botoes, newButton(
        "D",
        function()
            
        end,
        " =   ANDAR PARA A DIREITA"
    ))

    table.insert(botoes, newButton(
        "BEM",
        function()
            
        end,
        " =   ATIRAR"
    ))

    table.insert(botoes, newButton(
        "ESC",
        function()
            
        end,
        " =   PAUSAR"
    ))

    table.insert(botoes2, newButton(
        "Voltar",
        function()
            cena_atual = "menu_inicial"
        end
    ))

    table.insert(botoes2, newButton(
        "<",
        function()
            cena_atual = "ajuda1"
        end,
        " "
    ))

    table.insert(botoes2, newButton(
        ">",
        function()
            cena_atual = "ajuda2"
        end,
        " "
    ))
end

function Ajuda:update(dt)
    if love.keyboard.isDown("left") then
        cena_atual = "ajuda1"
    elseif love.keyboard.isDown("right") then
        cena_atual = "ajuda2"
    end
end

function Ajuda:draw()
    local larg_botao = nil
    local margem = 20

    local total_altura = (ALTURA_BOTAO + margem) * #botoes + 100
    local cursor_y = 0

    for i, botao in ipairs(botoes) do
        botao.last = botao.now

        if botao.text == "Voltar" then
            larg_botao = 170
            margem = 0
        elseif botao.text == "ESC" then
            larg_botao = 100
            margem = 80
        elseif botao.text == "BEM" then
            larg_botao = 100
        else
            larg_botao = 50
        end

        local bx = 50
        local by = ((ALTURA_TELA * 0.5) - (total_altura * 0.5) + cursor_y) + 20

        if botao.text == "<" or botao.text == ">" then
            if botao.text == "<" then
                bx = 600
                by = by - ALTURA_BOTAO
            elseif botao.text == ">" then
                bx = 670
                by = by - ALTURA_BOTAO*2
            end
        end

        local color = {0.3, 0, 0.5, 1}
        local mx, my = love.mouse.getPosition()
        local hot = mx > bx and mx < bx + larg_botao and
                    my > by and my < by + ALTURA_BOTAO

        botao.now = love.mouse.isDown(1)

        if botao.now and not botao.last and hot then
            botao.fn()
        end

        love.graphics.setColor(unpack(color))
        love.graphics.rectangle(
            "fill",
            bx,
            by,
            larg_botao,
            ALTURA_BOTAO,
            20, 20)
        love.graphics.setColor(1, 1, 1)
        
        love.graphics.rectangle(
            "line",
            bx,
            by,
            larg_botao,
            ALTURA_BOTAO,
            20, 20)

        local textLarg = font:getWidth(botao.text)
        local textAlt = font:getHeight(botao.text)

        love.graphics.print(
            botao.text,
            font,
            50 + (larg_botao - textLarg) * 0.5,
            by + textAlt * 0.25
        )

        local font = love.graphics.setNewFont(25)
        local ty = font:getHeight()
        love.graphics.setColor(0, 0, 0)
        love.graphics.print(botao.ajuda_text, bx + larg_botao + 20, by + (ALTURA_BOTAO - ty) * 0.5 - 5)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(botao.ajuda_text, bx + larg_botao + 20 + 2, by + (ALTURA_BOTAO - ty) * 0.5 + - 3)
        local font = love.graphics.setNewFont("materials/fonts/Melted-Monster.ttf", 40)

        cursor_y = cursor_y + (ALTURA_BOTAO + margem)
    end

    for i, botao in ipairs(botoes2) do
        botao.last = botao.now

        if botao.text == "Voltar" then
            larg_botao = 170
            margem = 0
        elseif botao.text == "BEM" then
            larg_botao = 100
            margem = 80
        else
            larg_botao = 50
        end

        local bx = 50
        local by = ((ALTURA_TELA * 0.5) - (total_altura * 0.5) + cursor_y) + 20

        if botao.text == "<" or botao.text == ">" then
            if botao.text == "<" then
                bx = 600
                by = by - ALTURA_BOTAO
            elseif botao.text == ">" then
                bx = 670
                by = by - ALTURA_BOTAO*2
            end
        end

        local color = {0.3, 0, 0.5, 1}
        local mx, my = love.mouse.getPosition()
        local hot = mx > bx and mx < bx + larg_botao and
                    my > by and my < by + ALTURA_BOTAO

        if hot then
            color = {0, 0.4, 0, 1}
        end

        botao.now = love.mouse.isDown(1)

        if botao.now and not botao.last and hot then
            botao.fn()
        end

        love.graphics.setColor(unpack(color))
        love.graphics.rectangle(
            "fill",
            bx,
            by,
            larg_botao,
            ALTURA_BOTAO,
            20, 20)
        love.graphics.setColor(1, 1, 1)
        
        love.graphics.rectangle(
            "line",
            bx,
            by,
            larg_botao,
            ALTURA_BOTAO,
            20, 20)

        local textLarg = font:getWidth(botao.text)
        local textAlt = font:getHeight(botao.text)

        if botao.text == "voltar" then
            love.graphics.print(
            botao.text,
            font,
            50 + (larg_botao - textLarg) * 0.5,
            by + textAlt * 0.25
            )
        else
            love.graphics.print(
            botao.text,
            font,
            bx + (larg_botao - textLarg) * 0.5,
            by + textAlt * 0.25
            )
        end
        

        cursor_y = cursor_y + (ALTURA_BOTAO + margem)
    end

    local textAjuda = "Ajuda"
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(textAjuda, (LARGURA_TELA - font:getWidth(textAjuda))/2 - 1, 20 - 1)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(textAjuda, (LARGURA_TELA - font:getWidth(textAjuda))/2 + 1, 20 + 1)
end
