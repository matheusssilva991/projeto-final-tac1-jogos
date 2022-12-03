Fundo = Classe:extend()

function Fundo:new(x, y, objImg, velocidade)
    self.img = objImg
    self.largura, self.altura = self.img:getDimensions()
    
    self.x = x or 0
    self.y = y or 0
    self.velocidade = velocidade or -20 
end

function Fundo:update(dt)
    --Solução para corrigir espaço entre os backgrounds (fórum love2D)
    self.x = (self.x + self.velocidade*dt) % self.largura
end

function Fundo:draw()
    love.graphics.draw(self.img, self.x, self.y)
    love.graphics.draw(self.img, self.x-self.largura, self.y)
end