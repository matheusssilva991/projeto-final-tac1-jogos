Pause = Classe:extend()

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

function Pause:new()
    self.larg = 300
    self.alt = 400
    self.x = (LARGURA_TELA - self.larg) / 2
    self.y = (ALTURA_TELA - self.alt) / 2

    tempo_mouse = 0

    font = love.graphics.setNewFont("materials/fonts/Melted-Monster.ttf", 40)
    botoes = {}

    table.insert(botoes, newButton(
        "Continuar",
        function()
            estado_pause = "false"
        end
    ))

    table.insert(botoes, newButton(
        "Sair",
        function()
            cena_atual = "menu_inicial"
        end
    ))

end

function Pause:update(dt)
    
end

function Pause:draw()
    -- DESENHA QUADRO DO MENU DE PAUSE
    if estado_pause == "true" then
        love.graphics.setColor(0, 0, 0, 0.8)
        love.graphics.rectangle("fill", 0, 0, LARGURA_TELA, ALTURA_TELA)
        love.graphics.setColor(0.3, 0, 0.5, 1)
        love.graphics.rectangle("fill", self.x, self.y, self.larg, self.alt, 15)
        love.graphics.setColor(0.3, 0, 0.8)
        love.graphics.rectangle("line", self.x, self.y, self.larg, self.alt, 15)
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf("Jogo Pausado", self.x + 19, self.y + 19, 260, "center")
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Jogo Pausado", self.x + 21, self.y + 21, 260, "center")
    
        local larg_botao = 200
        local margem = 20

        local total_altura = (ALTURA_BOTAO + margem) * #botoes
        local cursor_y = 0

        for _, botao in ipairs(botoes) do
            botao.last = botao.now

            local bx = (LARGURA_TELA * 0.5) - (larg_botao * 0.5)
            local by = (ALTURA_TELA * 0.5) - (total_altura * 0.5) + cursor_y

            local color = {0.3, 0, 0.5, 1}
            local mx, my = love.mouse.getPosition()
            local hot = mx > bx and mx < bx + larg_botao and
                        my > by and my < by + ALTURA_BOTAO

            if hot then
                color = {0, 0.4, 0, 1}
            end

            botao.now = love.mouse.isDown(1)

            if botao.now and not botao.last and hot then
                mouse_delay = 0.1
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
end