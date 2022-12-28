InGameHud = Classe:extend()

function InGameHud:new()
    self.img_vida = love.graphics.newImage("materials/hud/vida.png")
    self.img_vida2 = love.graphics.newImage("materials/hud/vida2.png")
    self.coracaoLarg = self.img_vida:getWidth()
    self.coracaoAlt = self.img_vida:getHeight()

end

function InGameHud:update(dt)
end

function InGameHud:draw()
    -- Moldura da hud
    love.graphics.setLineWidth(15)
    
    love.graphics.setColor(0.3, 0, 0.5)
    love.graphics.rectangle("line", 0, 0, LARGURA_TELA, ALTURA_TELA-70)
    love.graphics.rectangle("line", 0, 0, LARGURA_TELA, ALTURA_TELA-70, 30, 30) 
    love.graphics.setLineWidth(1)
    love.graphics.setColor(1, 1, 1)
    
    -- Painel da hud
    love.graphics.setColor(0.3, 0, 0.5)
    love.graphics.rectangle("fill", 0, ALTURA_TELA-80, LARGURA_TELA, 80)
    love.graphics.setColor(1, 1, 1)
    
    -- Barra de Vida
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 80, ALTURA_TELA-60, 200, 40, 5, 5)
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", 80, ALTURA_TELA-60, 2*heroi.vida, 40, 5, 5)
    love.graphics.setColor(0.3, 0, 1)
    love.graphics.rectangle("line", 80, ALTURA_TELA-60, 200, 40, 5, 5)
    love.graphics.setColor(1, 1, 1)

    -- Coração
    love.graphics.draw(self.img_vida2, (80-self.coracaoLarg)/2, ALTURA_TELA-60)
    love.graphics.draw(self.img_vida, (80-self.coracaoLarg)/2, ALTURA_TELA-60)
end
