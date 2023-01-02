Ajuda2 = Classe:extend()

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

function Ajuda2:new()
    opc = 0

    table.insert(botoes, newButton(
        "Voltar",
        function()
            cena_atual = "menu_inicial"
        end
    ))

    table.insert(botoes, newButton(
        "<",
        function()
            cena_atual = "ajuda1"
        end
    ))

    table.insert(botoes, newButton(
        ">",
        function()
            cena_atual = "ajuda2"
        end
    ))
end

function Ajuda2:update(dt)
    if love.keyboard.isDown("left") then
        cena_atual = "ajuda1"
    elseif love.keyboard.isDown("right") then
        cena_atual = "ajuda2"
    end
end

function Ajuda2:draw()
    local larg_botao = nil
    local margem = 20

    local total_altura = (ALTURA_BOTAO + margem) * #botoes-580
    local cursor_y = 0

    for i, botao in ipairs(botoes) do
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

    local txts = {"- Passar muito perto de um zumbi fará com que ele detecte a tua presença e comece a te seguir.",
                "- Ao atirar, você fará com que os zumbis mais próximos comecem a te seguir.",
                "- Os zumbis continuarão te seguindo mesmo durante o combate contra os chefões.",
                "- Quebre as caixas para desobstruir o caminho até o fim do mapa.",
                "- Sua vida será restaurada sempre que você passar de fase."
                }

    local altTxt = 80
    local bx = 50
    local margem = 40

    for i, txt in ipairs(txts) do
        local font = love.graphics.setNewFont(25)
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(txt, bx, altTxt, 700)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(txt, bx+2, altTxt+2, 700)
        local font = love.graphics.setNewFont("materials/fonts/Melted-Monster.ttf", 40)
        altTxt = altTxt + margem*2
    end

    local textAjuda = "Ajuda"
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(textAjuda, (LARGURA_TELA - font:getWidth(textAjuda))/2 - 1, 20 - 1)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(textAjuda, (LARGURA_TELA - font:getWidth(textAjuda))/2 + 1, 20 + 1)
end