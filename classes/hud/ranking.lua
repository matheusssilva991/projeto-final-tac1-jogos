Ranking = Classe:extend()

ALTURA_BOTAO = 50

local function newButton(text, fn)
    return{
        text = text,
        fn = fn,

        now = false,
        last = false
    }
end

local botoes = {}
local font = nil

function Ranking:new()
    font = love.graphics.setNewFont("materials/fonts/Melted-Monster.ttf", 40)

    table.insert(botoes, newButton(
        "Voltar",
        function()
            cena_atual = "menu_inicial"
        end
    ))
end

function Ranking:update(dt)
end

function Ranking:draw()
    local ranking_y = 20
    local ranking_alt = font:getHeight()

    for i, rank in ipairs(tabela_ranking) do
        love.graphics.setColor(0, 0, 0)
        love.graphics.print(tabela_ranking[i].nome .. " : " .. tabela_ranking[i].tempo_jogo, 10, ranking_y)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(tabela_ranking[i].nome .. " : " .. tabela_ranking[i].tempo_jogo, 11, ranking_y + 1)

        ranking_y = ranking_y + ranking_alt * 2
    end

    local larg_botao = 150
    local margem = 20

    local total_altura = (ALTURA_BOTAO + margem) * #botoes
    local cursor_y = 0

    for i, botao in ipairs(botoes) do
        botao.last = botao.now

        local bx = (LARGURA_TELA * 0.5) - (larg_botao * 0.5)
        local by = (ALTURA_TELA * 0.5) - (total_altura * 0.5) + cursor_y + 250

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
            (LARGURA_TELA * 0.5) - textLarg * 0.5,
            by + textAlt * 0.25
        )

        cursor_y = cursor_y + (ALTURA_BOTAO + margem)
    end
end
