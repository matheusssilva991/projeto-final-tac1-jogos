Start = Classe:extend()

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

function Start:new()
    self.img_fundo = love.graphics.newImage("materials/background/fundo_menu.png")
    self.larg_img = self.img_fundo:getWidth()
    self.alt_img = self.img_fundo:getHeight()
    self.larg_frame = self.larg_img/3
    self.alt_frame = self.alt_img
    local grid = anim.newGrid(self.larg_frame, self.alt_frame, self.larg_img, self.alt_img)
    self.animation = anim.newAnimation(grid('1-3', 1), 0.1)

    font = love.graphics.setNewFont("materials/fonts/Melted-Monster.ttf", 40)
    botoes = {}

    table.insert(botoes, newButton(
        "Jogar",
        function()
            cena_atual = "jogo"
            jogo:new()
        end
    ))

    table.insert(botoes, newButton(
        "Ranking",
        function()
            cena_atual = "ranking"
        end
    ))

    table.insert(botoes, newButton(
        "Ajuda",
        function()
            cena_atual = "ajuda1"
        end
    ))

    table.insert(botoes, newButton(
        "Sair",
        function()
            love.event.quit(0)
        end
    ))

end

function Start:update(dt)
    self.animation:update(dt)
end

function Start:draw()
    self.animation:draw(self.img_fundo, 0, 0)
    font = love.graphics.setNewFont("materials/fonts/Dead-Kansas.ttf", 50)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("THE ALCKMIN DEADI", 0, 40, 800, "center")
    love.graphics.setColor(1, 1, 1, 0.2)
    love.graphics.printf("THE ALCKMIN DEADI", 0, 40, 800, "center")
    font = love.graphics.setNewFont("materials/fonts/Melted-Monster.ttf", 40)

    local larg_botao = 250
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

        if botao.now and mouse_delay <= 0 and not botao.last and hot then
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
