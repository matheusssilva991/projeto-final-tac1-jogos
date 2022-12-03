Cano = Classe:extend()

function Cano:new(velocidade)
    self.img = imagem_cano
    self.largura, self.altura = self.img:getDimensions()

    self.xSup = largura_tela + self.largura
    self.xInf = largura_tela


    self.ySup =  love.math.random(0, 150) + 30
    self.yInf =  self.ySup + love.math.random(110, 180)

    self.velocidade = velocidade or -120
end

function Cano:update(dt)
    self.xSup = self.xSup + self.velocidade*dt
    self.xInf = self.xInf + self.velocidade*dt
end

function Cano:draw()
    love.graphics.draw(self.img, self.xSup, self.ySup, math.rad(180))
    love.graphics.draw(self.img, self.xInf, self.yInf)

    --Imprimir hitBox
    --love.graphics.setColor(1, 0, 0)
    --love.graphics.rectangle("line", self.xInf, self.yInf, self.largura, self.altura)
    --love.graphics.rectangle("line", self.xSup, self.ySup, self.largura, self.altura)
    --love.graphics.setColor(1, 1, 1)
end

function Cano:saiuDaTela()
    if self.xInf < -self.largura then
        return true
    end
end