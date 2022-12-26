Tiro = Classe:extend()

function Tiro:new(x, y, direcao, raio, tipo_tiro, dano)
    self.posicao_inicial = Vector(x + 20, y - 18)
    self.posicao = Vector(x + 20, y - 18) -- menos 18 para alinhar tiro com sprite
    self.posicao_boss = Vector(x, y)
    self.posicao_heroi = heroi:get_posicao_normalizada()
    self.raio = raio
    self.direcao = direcao
    self.dano = dano
    self.tipo_tiro = tipo_tiro
    self.vel_y_tiro = math.abs(heroi:get_posicao_normalizada().y - y)
    self.distancia_tiro = 0
end

function Tiro:update(dt)
    if self.direcao == 'esquerda' and self.tipo_tiro == 'heroi' then
        self.posicao = self.posicao - Vector(1000, 0) * dt
    elseif self.direcao == 'direita' and self.tipo_tiro == 'heroi' then
        self.posicao = self.posicao + Vector(1000, 0) * dt

    -- Verifica tiros do boss
    elseif self.direcao == 'esquerda' and self.tipo_tiro == 'boss' then
        if self.posicao_heroi.y >= self.posicao_boss.y then -- Tiro baixo esquerda
            self.posicao = self.posicao - Vector(500, -self.vel_y_tiro) * dt
        elseif self.posicao_heroi.y < self.posicao_boss.y then -- Tiro cima esquerda
            self.posicao = self.posicao - Vector(500, self.vel_y_tiro) * dt
        end   
    elseif self.direcao == 'direita' and self.tipo_tiro == 'boss' then
        if self.posicao_heroi.y >= self.posicao_boss.y then -- Tiro baixo direita
            self.posicao = self.posicao + Vector(500, self.vel_y_tiro) * dt
        elseif self.posicao_heroi.y < self.posicao_boss.y then -- Tiro cima direita
            self.posicao = self.posicao + Vector(500, -self.vel_y_tiro) * dt  
        end
    end 

    self.distancia_tiro = self.posicao.dist(self.posicao_inicial, self.posicao)
end

function Tiro:draw()
    love.graphics.circle("fill", self.posicao.x, self.posicao.y, self.raio)
end