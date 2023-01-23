Boss = Classe:extend()

function Boss:new(nome_inimigo, tipo_boss)
    self.nome = 'boss'
    self.img = love.graphics.newImage("/materials/chars/" .. nome_inimigo .. ".png")
    self.largura_animacao = self.img:getWidth()
    self.altura_animacao = self.img:getHeight()
    self.largura = 100
    self.altura = 100

    local g_inimigos = anim.newGrid(self.largura, self.altura, self.largura_animacao, self.altura_animacao)
    self.anim_boss = anim.newAnimation(g_inimigos('1-4', tipo_boss.op), 0.15)
    self.anim_boss_parado = anim.newAnimation(g_inimigos('1-1', tipo_boss.op), 0.15)

    --Status inimigo
    self.posicao = tipo_boss.posicao
    self.dano = tipo_boss.dano
    self.dano_tiro = tipo_boss.dano_tiro
    self.vida = tipo_boss.vida
    self.raio = tipo_boss.raio
    self.raio_deteccao = tipo_boss.raio_deteccao
    self.vel = tipo_boss.vel
    self.vel_tiro = tipo_boss.vel_tiro

    self.estado_mov = 'descendo'
    self.estado_ataque = 'normal'
    self.direcao_olhando = 'direita'
    self.delay_ataque_tiro = 0 -- tempo entre os ataques de tiro
    self.delay_ataque_avanco = 0 -- tempo para ataque de avanço
    self.tempo_ataque = 2.25 -- tempo alternar modos de ataques
    self.tiros = {}
    self.posicao_heroi = heroi.posicao
    self.delay_dano = 0 -- tempo de espera para dar dano no heroi
    self.heroi_visivel = false
end

function Boss:update(dt)
    self.anim_boss:update(dt)
    self.anim_boss_parado:update(dt)

    -- Verifica se o heroi está atirando e se o boss escutou o tiro
    local escutou_tomou_tiro = verifica_colisao(heroi.posicao, heroi.raio_tiro, self.posicao, self.raio_deteccao)
    local viu_heroi = verifica_colisao(heroi.posicao, heroi.raio, self.posicao, self.raio_deteccao)
    if (heroi.atirando and escutou_tomou_tiro and heroi.posicao.x > 1600) or viu_heroi then
        if not self.heroi_visivel then
            self.direcao_olhando = 'esquerda'
        end
        self.heroi_visivel = true 
    end

    -- Atualiza os tempos de recarga se o boss viu o heroi
    if self.heroi_visivel then
        self.delay_ataque_avanco = self.delay_ataque_avanco + dt
        self.delay_ataque_tiro = self.delay_ataque_tiro + dt
        self.tempo_ataque = self.tempo_ataque + dt
    end
    
    -- Tempo para dar dano novamente no heroi
    if heroi.estado == 'colidindo' then
        self.delay_dano = self.delay_dano + dt
    elseif heroi.estado ~= 'colidindo' then
        self.delay_dano = 0
    end

    -- Verifica se já terminou o tempo de recarga do ataque de avanco
    if self.delay_ataque_avanco >= 12 and self.delay_ataque_avanco <= 13 then
        self.estado_ataque = 'carregar avanco'
        self.posicao_heroi = heroi.posicao
    elseif self.estado_ataque == 'carregar avanco' and self.delay_ataque_avanco > 14 then
        self.estado_ataque = 'avanco'
        self.tempo_ataque = 0
    end

    -- Alterna entre os estados de ataque tiro e normal caso avanço esteja em cd
    if 3.0 <= self.tempo_ataque and self.tempo_ataque < 5.00 and self.delay_ataque_avanco < 10 then
        self.estado_ataque = 'tiro'
    elseif self.tempo_ataque >= 5.00 and self.delay_ataque_avanco < 10 then
        self.estado_ataque = 'normal'
        self.tempo_ataque = 0
    end

    -- Verifica se está no modo de ataque tiro
    if self.delay_ataque_tiro >= 0.45 and self.estado_ataque == 'tiro' then
        if self.posicao.x >= heroi.posicao.x then
            table.insert(self.tiros, Tiro(self.posicao.x, self.posicao.y, 'esquerda', 40, 'boss', self.dano_tiro, self.vel_tiro))
        else
            table.insert(self.tiros, Tiro(self.posicao.x, self.posicao.y, 'direita', 40, 'boss', self.dano_tiro, self.vel_tiro))
        end
        self.delay_ataque_tiro = 0
    end

    -- Atualiza os tiros e verifica se está colidindo com o heroi
    for i = #self.tiros, 1, -1 do
        self.tiros[i]:update(dt)

        if verifica_colisao(heroi.posicao, heroi.raio, self.tiros[i].posicao, self.tiros[i].raio) then
            heroi.vida = math.max(heroi.vida - self.tiros[i].dano, 0)
            table.remove(self.tiros, i)
        end
    end

    -- Verifica se o heroi está subindo ou descendo se estiver no estado_ataque tiro
    if self.estado_ataque == 'normal' or self.estado_ataque == 'tiro' then
        if self.posicao.y > heroi.posicao.y then
            self.estado_mov = 'subindo'
        elseif self.posicao.y <= heroi.posicao.y then
            self.estado_mov = 'descendo'
        end
    elseif self.estado_ataque == 'carregar avanco' then
        if self.posicao.y > self.posicao_heroi.y then
            self.estado_mov = 'subindo'
        elseif self.posicao.y <= self.posicao_heroi.y then
            self.estado_mov = 'descendo'
        end
    end
    
    -- Atualiza a posição do heroi de acordo com o estado
    if self.estado_mov == 'descendo' and self.estado_ataque == 'tiro' then
        self.posicao = self.posicao + Vector(0, 0.80)
    elseif self.estado_mov == 'subindo' and self.estado_ataque == 'tiro' then
        self.posicao = self.posicao - Vector(0, 0.80)
    elseif self.estado_mov == 'descendo' and self.estado_ataque == 'avanco' then
        if self.direcao_olhando == 'direita' then
            self.posicao = self.posicao + Vector(self.vel, math.abs(self.posicao_heroi.y - self.posicao.y)) * dt
        elseif self.direcao_olhando == 'esquerda' then
            self.posicao = self.posicao - Vector(self.vel, -math.abs(self.posicao_heroi.y - self.posicao.y)) * dt
        end
    elseif self.estado_mov == 'subindo' and self.estado_ataque == 'avanco' then
        if self.direcao_olhando == 'direita' then
            self.posicao = self.posicao + Vector(self.vel, -math.abs(self.posicao_heroi.y - self.posicao.y)) * dt
        elseif self.direcao_olhando == 'esquerda' then
            self.posicao = self.posicao - Vector(self.vel, math.abs(self.posicao_heroi.y - self.posicao.y)) * dt
        end
    end

    -- Verifica se terminou o avanço
    if self.posicao.x <= 1675 and self.estado_ataque == 'avanco' and self.direcao_olhando == 'esquerda' then
        self.estado_ataque = 'normal'
        self.direcao_olhando = 'direita'
        self.delay_ataque_avanco = 0
        self.delay_ataque_tiro = 0
    elseif self.posicao.x >= 2325 and self.estado_ataque == 'avanco' and self.direcao_olhando == 'direita' then
        self.estado_ataque = 'normal'
        self.direcao_olhando = 'esquerda'
        self.delay_ataque_avanco = 0
        self.delay_ataque_tiro = 0
    end
end

function Boss:draw()
    --[[ for i = #self.tiros, 1, -1 do
        self.tiros[i]:draw()
    end ]]

    local escala = 1.5
    love.graphics.push()
    love.graphics.scale(escala, escala)

    -- Linha de ataque avanço frontal
    if self.estado_ataque == 'carregar avanco' or self.estado_ataque == 'avanco' then
        love.graphics.setColor(1, 0, 0, 0.20)
        love.graphics.setLineWidth(100)

        if self.direcao_olhando == 'esquerda' then -- Boss está olhando pra esquerda
            love.graphics.line(self.posicao.x/escala + 40, self.posicao.y/escala, 1600/escala, self.posicao_heroi.y/escala)
        elseif self.direcao_olhando == 'direita' then -- Boss olhando para direita
            love.graphics.line(self.posicao.x/escala - 40, self.posicao.y/escala, 2400/escala, self.posicao_heroi.y/escala)
        end
        
        love.graphics.setLineWidth(1)
        love.graphics.setColor(1, 1, 1)
    end
    
    -- Desenha o Boss
    if self.direcao_olhando == 'direita' then
        if self.estado_ataque == 'carregar avanco' then
            self.anim_boss_parado:draw(self.img, self.posicao.x/escala - self.largura/2*escala + 25, self.posicao.y/escala - self.altura/2*escala + 25, 0, 1, 1)
        else
            self.anim_boss:draw(self.img, self.posicao.x/escala - self.largura/2*escala + 25, self.posicao.y/escala - self.altura/2*escala + 25, 0, 1, 1)
        end
        love.graphics.circle("line", self.posicao.x/escala, self.posicao.y/escala, self.raio/escala)
        love.graphics.circle("line", self.posicao.x/escala, self.posicao.y/escala, self.raio_deteccao/escala)
    elseif self.direcao_olhando == 'esquerda' then
        if self.estado_ataque == 'carregar avanco'then
            self.anim_boss_parado:draw(self.img, self.posicao.x/escala + self.largura/2*escala - 25, self.posicao.y/escala - self.altura/2*escala + 25, 0, -1, 1)
        else
            self.anim_boss:draw(self.img, self.posicao.x/escala + self.largura/2*escala - 25, self.posicao.y/escala - self.altura/2*escala + 25, 0, -1, 1)
        end
        love.graphics.circle("line", self.posicao.x/escala, self.posicao.y/escala, self.raio_deteccao/escala)
        love.graphics.circle("line", self.posicao.x/escala, self.posicao.y/escala, self.raio/escala)
    end
    love.graphics.pop()

    for i = #self.tiros, 1, -1 do
        self.tiros[i]:draw()
    end
end
