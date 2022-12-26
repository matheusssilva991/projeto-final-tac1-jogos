Start = Classe:extend()

ALTURA_BOTAO = 50

function newButton(text, fn)
    return{
        text = text,
        fn = fn
    }
end

local butoes = {}

function Start:new()

    table.insert(butoes, newButton(
        "Jogar",
        function()
            print("Iniciando jogo")
        end
    ))

    table.insert(butoes, newButton(
        "Ranking",
        function()
            print("Abrindo Ranking")
        end
    ))

    table.insert(butoes, newButton(
        "Ajuda",
        function()
            print("Abrindo Ajuda")
        end
    ))

    table.insert(butoes, newButton(
        "Sair",
        function()
            love.event.quit(0)
        end
    ))
    --[[ --self.forma_x = posicao_mouse.x
    --self.forma_y = posicao_mouse.y
    self.startScreenX = (LARGURA_TELA - 300)/2
    self.startScreenY = (ALTURA_TELA - 500)/2

    self.btnX = self.startScreenX + 25
    self.btnLarg = 250
    self.btnAlt = 50 ]]

end

function Start:update(dt)
end

function Start:draw()
    local larg_botao = 250

    for i, butoes in ipairs(butoes) do
        love.graphics.rectangle(
            "fill",
            (LARGURA_TELA*0.5) - (larg_botao*0.5),
            (ALTURA_TELA*0.5) - (ALTURA_BOTAO*0.5),
            larg_botao,
            ALTURA_BOTAO,
            20, 20)
    end

    --[[ love.graphics.setColor(0.3, 0, 0.5)
    love.graphics.rectangle("fill", self.startScreenX, self.startScreenY, 300, 500, 20, 20)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", self.startScreenX, self.startScreenY, 300, 500, 20, 20)
    font:getHeight()

    love.graphics.setColor(0.3, 0, 1)
    love.graphics.rectangle("fill", self.btnX, self.startScreenY+200, self.btnLarg, self.btnAlt, 20, 20)
    love.graphics.rectangle("fill", self.btnX, self.startScreenY+200+self.btnAlt+20, self.btnLarg, self.btnAlt, 20, 20)
    love.graphics.rectangle("fill", self.btnX, self.startScreenY+200+self.btnAlt*2+20*2, self.btnLarg, self.btnAlt, 20, 20)
    love.graphics.setColor(1, 1, 1)

    love.graphics.rectangle("line", self.btnX, self.startScreenY+200, self.btnLarg, self.btnAlt, 20, 20)
    love.graphics.print("Jogar", self.btnX+(250-font:getWidth("Jogar"))/2, self.startScreenY+210)

    love.graphics.rectangle("line", self.btnX, self.startScreenY+200+self.btnAlt+20, self.btnLarg, self.btnAlt, 20, 20)
    love.graphics.print("Ajuda", self.btnX+(250-font:getWidth("Ajuda"))/2, self.startScreenY+210+self.btnAlt+20)

    love.graphics.rectangle("line", self.btnX, self.startScreenY+200+self.btnAlt*2+20*2, self.btnLarg, self.btnAlt, 20, 20)
    love.graphics.print("Sair", self.btnX+(250-font:getWidth("Sair"))/2, self.startScreenY+210+self.btnAlt*2+20*2) ]]
end