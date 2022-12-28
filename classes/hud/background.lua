Background = Classe:extend()

function Background:new(nome_mapa)
    self.img = love.graphics.newImage("materials/background/" .. nome_mapa .. ".png")
    self.larg = self.img:getWidth()
    self.alt = self.img:getHeight()
    self.x = 0
    self.y = (ALTURA_TELA-self.alt)/2

end

function Background:update(dt)
end

function Background:draw()
    love.graphics.draw(self.img, self.x, self.y)
end
