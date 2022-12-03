Item = Classe:extend()

function Item:new(xCano, velocidade)
    self.img = imagem_item
    self.largura, self.altura = self.img:getDimensions()

    self.x = xCano + 40 --posiciona o item 40px após o cano

    self.yInicial = love.math.random(20, 350)

    self.velocidade = velocidade or -120
    self.angulo = 0
end

function Item:update(dt)
    self.x = self.x + self.velocidade*dt
    self.angulo = self.angulo + 100*dt
    
    --faz o item ficar flutuando
    self.y = math.sin(math.rad(self.angulo))
    self.y = self.y + 1
    self.y = self.y * 10

    self.y = self.y + self.yInicial
end

function Item:draw()
    love.graphics.draw(self.img, self.x, self.y)
end

function Item:saiuDaTela()
    if self.x < -self.largura then
        return true
    end
end