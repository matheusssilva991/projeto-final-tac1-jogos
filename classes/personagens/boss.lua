Boss = Classe:extend()

function Boss:new(nome_inimigo, tipo_boss)
    self.img = love.graphics.newImage("/recursos/imagens/" .. nome_inimigo .. ".png")
    self.largura_animacao = self.img:getWidth()
    self.altura_animacao = self.img:getHeight()
    self.largura = 100
    self.altura = 100

    local g_inimigos = anim.newGrid(self.largura, self.altura, self.largura_animacao, self.altura_animacao)
    self.anim_boss = anim.newAnimation(g_inimigos('1-4', tipo_boss.op), 0.15)
    self.anim_boss_parado = anim.newAnimation(g_inimigos('1-1', tipo_boss.op), 0.15)

    --Status inimigo
    self.posicao = Vector(700, 300)
    self.velocidade = tipo_boss.vel
    self.dano = tipo_boss.dano
    self.vida = tipo_boss.vida
    self.temp_vida = tipo_boss.vida
    self.barra_vida = 56
    self.raio = 40

    self.estado_mov = 'descendo'
    self.estado_ataque = 'normal'
    self.estado_direcao = 'esquerda'
    self.delay_ataque_tiro = 0 -- tempo entre os ataques de tiro
    self.delay_ataque_avanco = 10 -- tempo para ataque de avanço
    self.tempo_ataque = 0 -- tempo alternar modos de ataques
    self.tiros = {}
    self.posicao_heroi = heroi:get_posicao_normalizada()
end

function Boss:update(dt)
    self.anim_boss:update(dt)
    self.anim_boss_parado:update(dt)

    self.delay_ataque_avanco = self.delay_ataque_avanco + dt
    self.delay_ataque_tiro = self.delay_ataque_tiro + dt
    self.tempo_ataque = self.tempo_ataque + dt

    -- Verifica se já terminou o tempo de recarga do ataque de avanco
    if self.delay_ataque_avanco >= 13 and self.delay_ataque_avanco <= 14 then
        self.estado_ataque = 'carregar avanco'
        self.posicao_heroi = heroi:get_posicao_normalizada()
    elseif self.estado_ataque == 'carregar avanco' and self.delay_ataque_avanco > 15 then
        self.estado_ataque = 'avanco'
        self.tempo_ataque = 0
    end

    -- Alterna entre os estados de ataque tiro e normal caso avanço esteja em cd
    if 4.0 <= self.tempo_ataque and self.tempo_ataque < 6.00 and self.delay_ataque_avanco < 12 then
        self.estado_ataque = 'tiro'
    elseif self.tempo_ataque >= 6.00 and self.delay_ataque_avanco < 12 then
        self.estado_ataque = 'normal'
        self.tempo_ataque = 0
    end

    -- Verifica se está no modo de ataque tiro
    if self.delay_ataque_tiro >= 0.30 and self.estado_ataque == 'tiro' then
        if self.posicao.x >= heroi:get_posicao_normalizada().x then
            table.insert(self.tiros, Tiro(self.posicao.x, self.posicao.y, 'esquerda', 20, 'boss'))
        else
            table.insert(self.tiros, Tiro(self.posicao.x, self.posicao.y, 'direita', 20, 'boss'))
        end
        self.delay_ataque_tiro = 0
    end

    for i = #self.tiros, 1, -1 do
        self.tiros[i]:update(dt)
    end

    if self.estado_ataque == 'normal' or self.estado_ataque == 'tiro' then
        if self.posicao.y > heroi:get_posicao_normalizada().y then
            self.estado_mov = 'subindo'
        elseif self.posicao.y <= heroi:get_posicao_normalizada().y then
            self.estado_mov = 'descendo'
        end
    end
    
    if self.estado_mov == 'descendo' and self.estado_ataque == 'tiro' then
        self.posicao = self.posicao + Vector(0, 0.80)
    elseif self.estado_mov == 'subindo' and self.estado_ataque == 'tiro' then
        self.posicao = self.posicao - Vector(0, 0.80)
    elseif self.estado_mov == 'descendo' and self.estado_ataque == 'avanco' then
        if self.estado_direcao == 'direita' then
            self.posicao = self.posicao + Vector(700, math.abs(self.posicao_heroi.y - self.posicao.y)) * dt
        elseif self.estado_direcao == 'esquerda' then
            self.posicao = self.posicao - Vector(700, -math.abs(self.posicao_heroi.y - self.posicao.y)) * dt
        end
    elseif self.estado_mov == 'subindo' and self.estado_ataque == 'avanco' then
        if self.estado_direcao == 'direita' then
            self.posicao = self.posicao + Vector(700, -math.abs(self.posicao_heroi.y - self.posicao.y)) * dt
        elseif self.estado_direcao == 'esquerda' then
            self.posicao = self.posicao - Vector(700, math.abs(self.posicao_heroi.y - self.posicao.y)) * dt
        end
    end

    -- Verifica se terminou o avanço
    if self.posicao.x <= 50 and self.estado_ataque == 'avanco' and self.estado_direcao == 'esquerda' then
        self.estado_ataque = 'normal'
        self.estado_direcao = 'direita'
        self.delay_ataque_avanco = 0
        self.delay_ataque_tiro = 0
    elseif self.posicao.x >= 700 and self.estado_ataque == 'avanco' and self.estado_direcao == 'direita' then
        self.estado_ataque = 'normal'
        self.estado_direcao = 'esquerda'
        self.delay_ataque_avanco = 0
        self.delay_ataque_tiro = 0
    end
end

function Boss:draw()
    for i = #self.tiros, 1, -1 do
        self.tiros[i]:draw()
    end

    love.graphics.push()
    love.graphics.scale(2, 2)

    -- Linha de ataque avanço frontal
    if self.estado_ataque == 'carregar avanco' or self.estado_ataque == 'avanco' then
        love.graphics.setColor(1, 0, 0, 0.20)
        love.graphics.setLineWidth(100)

        if self.estado_direcao == 'esquerda' then -- Boss está olhando pra esquerda
            love.graphics.line(0, self.posicao_heroi.y/2, self.posicao.x/2 + 40, self.posicao.y/2 + 10)
        elseif self.estado_direcao == 'direita' then -- Boss olhando para direita
            love.graphics.line(self.posicao.x/2, self.posicao.y/2 + 10, 800, self.posicao_heroi.y/2)
        end
        
        love.graphics.setLineWidth(1)
        love.graphics.setColor(1, 1, 1)
    end
    
    -- Desenha o Boss
    if self.estado_direcao == 'direita' then
        if self.estado_ataque == 'carregar avanco' then
            self.anim_boss_parado:draw(self.img, self.posicao.x/2 - self.largura/4, self.posicao.y/2 - self.altura/4-25, 0, 1, 1)
        else
            self.anim_boss:draw(self.img, self.posicao.x/2 - self.largura/4, self.posicao.y/2 - self.altura/4 - 25, 0, 1, 1)
        end
        love.graphics.circle("line", self.posicao.x/2, self.posicao.y/2, 10)
    elseif self.estado_direcao == 'esquerda' then
        if self.estado_ataque == 'carregar avanco'then
            self.anim_boss_parado:draw(self.img, self.posicao.x/2+self.largura/4+20, self.posicao.y/2-self.altura/4-25, 0, -1, 1)
        else
            self.anim_boss:draw(self.img, self.posicao.x/2 + self.largura/4 + 20, self.posicao.y/2 - self.altura/4-25, 0, -1, 1)
        end
        
        love.graphics.circle("line", self.posicao.x/2, self.posicao.y/2, 10)
    end
    
    love.graphics.pop()  
end