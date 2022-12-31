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
local font = nil

function Ajuda:new()
    font = love.graphics.setNewFont("materials/fonts/Melted-Monster.ttf", 40)
    opc = 0

    table.insert(botoes, newButton(
        "W",
        function()
            
        end,
        "ANDAR PARA CIMA"
    ))

    table.insert(botoes, newButton(
        "S",
        function()
            
        end,
        "ANDAR PARA BAIXO"
    ))

    table.insert(botoes, newButton(
        "A",
        function()
            
        end,
        "ANDAR PARA A ESQUERDA"
    ))

    table.insert(botoes, newButton(
        "D",
        function()
            
        end,
        "ANDAR PARA A DIREITA"
    ))

    table.insert(botoes, newButton(
        "BEM",
        function()
            
        end,
        "ATIRAR"
    ))

    table.insert(botoes, newButton(
        "Voltar",
        function()
            cena_atual = "menu_inicial"
        end
    ))
end

function Ajuda:update(dt)
    
end

function Ajuda:draw()
    local larg_botao = nil
    local margem = 20

    local total_altura = (ALTURA_BOTAO + margem) * #botoes
    local cursor_y = 0

    for i, botao in ipairs(botoes) do
        botao.last = botao.now

        if botao.text == "Voltar" then
            larg_botao = 170
        elseif botao.text == "BEM" then
            larg_botao = 100
            margem = 120
        else
            larg_botao = 50
        end

        local bx = 50
        local by = ((ALTURA_TELA * 0.5) - (total_altura * 0.5) + cursor_y) - 40

        

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

        love.graphics.print(
            botao.text,
            font,
            50 + (larg_botao - textLarg) * 0.5,
            by + textAlt * 0.25
        )

        if botao.text ~= "Voltar" then
            local font = nil
            font = love.graphics.setNewFont(30)
            local ty = font:getHeight()
            love.graphics.setColor(0, 0, 0)
            love.graphics.print("=  " .. botao.ajuda_text, bx + larg_botao + 20, by + (ALTURA_BOTAO - ty) * 0.5)
            love.graphics.setColor(1, 1, 1)
            love.graphics.print("=  " .. botao.ajuda_text, bx + larg_botao + 20 + 1, by + (ALTURA_BOTAO - ty) * 0.5 + 1)
        end

        cursor_y = cursor_y + (ALTURA_BOTAO + margem)
    end
end