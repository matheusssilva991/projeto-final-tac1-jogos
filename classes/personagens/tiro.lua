Tiro = Classe:extend()

function Tiro:new(x, y, direcao, raio, tipo_tiro)
    self.posicao = Vector(x + 20, y - 18) -- menos 18 para alinhar tiro com sprite
    self.raio = raio
    self.direcao = direcao
    self.dano = 35
    self.tipo_tiro = tipo_tiro

    -- Verifica direção do tiro - Cima, baixo ou reto
    if heroi:get_posicao_normalizada().y >= y and direcao == 'esquerda' then -- Tiro baixo esquerda
        self.vel_y_tiro = -(heroi:get_posicao_normalizada().y - y)
    elseif heroi:get_posicao_normalizada().y >= y and direcao == 'direita' then -- Tiro baixo direita
        self.vel_y_tiro = heroi:get_posicao_normalizada().y - y
    elseif heroi:get_posicao_normalizada().y <= y and direcao == 'esquerda' then -- tiro cima esquerda
        self.vel_y_tiro = y - heroi:get_posicao_normalizada().y
    elseif heroi:get_posicao_normalizada().y <= y and direcao == 'direita' then -- tiro cima direita
        self.vel_y_tiro = -heroi:get_posicao_normalizada().y - y
    end
end

function Tiro:update(dt)
    if self.direcao == 'esquerda' and self.tipo_tiro == 'heroi' then
        self.posicao = self.posicao - Vector(1000, 0) * dt
    elseif self.direcao == 'esquerda' and self.tipo_tiro == 'boss' then
        self.posicao = self.posicao - Vector(800, self.vel_y_tiro) * dt
    elseif self.direcao == 'direita' and self.tipo_tiro == 'heroi' then
        self.posicao = self.posicao + Vector(1000, 0) * dt
    elseif self.direcao == 'direita' and self.tipo_tiro == 'boss' then
        self.posicao = self.posicao + Vector(800, self.vel_y_tiro) * dt
    end 
end

function Tiro:draw()
    love.graphics.circle("fill", self.posicao.x, self.posicao.y, self.raio)
end