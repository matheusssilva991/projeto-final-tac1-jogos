Tiro = Classe:extend()

function Tiro:new(x, y, direcao)
    self.posicao = Vector(x + 20, y - 18) -- menos 18 para alinhar tiro com sprite
    self.raio = 2
    self.direcao = direcao
end

function Tiro:update(dt)
    if self.direcao == 'esquerda' then
        self.posicao = self.posicao - Vector(260, 0) * dt
    elseif self.direcao == 'direita' then
        self.posicao = self.posicao + Vector(260, 0) * dt
    end
    
end

function Tiro:draw()
    love.graphics.circle("fill", self.posicao.x, self.posicao.y, self.raio)
end