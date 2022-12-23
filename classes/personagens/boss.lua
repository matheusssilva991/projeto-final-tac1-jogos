Boss = Classe:extend()

function Boss:new(nome_inimigo, tipo_boss)
    self.img = love.graphics.newImage("/recursos/imagens/" .. nome_inimigo .. ".png")
    self.largura_animacao = self.img:getWidth()
    self.altura_animacao = self.img:getHeight()
    self.largura = 100
    self.altura = 100

    local g_inimigos = anim.newGrid(self.largura, self.altura, self.largura_animacao, self.altura_animacao)
    self.anim_inimigos = anim.newAnimation(g_inimigos('1-4', tipo_boss.op), 0.15)
    self.anim_inimigos_parado = anim.newAnimation(g_inimigos('1-1', tipo_boss.op), 0.15)

    --Status inimigo
    self.posicao = Vector(700, 300)
    self.velocidade = tipo_boss.vel
    self.dano = tipo_boss.dano
    self.vel_max = tipo_boss.vel_max
    self.raio_deteccao = tipo_boss.raio
    self.vida = tipo_boss.vida
    self.temp_vida = tipo_boss.vida
    self.barra_vida = 56
    self.raio = 40

    self.estado_mov = 'descendo'
    self.estado_ataque = 'normal'
    self.delay_ataque = 0 -- tempo entre os ataques
    self.tempo_ataque = 0 -- tempo para ataque de avanço
    self.tiros = {}
end

function Boss:update(dt)
    self.anim_inimigos:update(dt)
    self.anim_inimigos_parado:update(dt)

    self.tempo_ataque = self.tempo_ataque + dt
    self.delay_ataque = self.delay_ataque + dt

    if self.delay_ataque >= 0.40 then
        table.insert(self.tiros, Tiro(self.posicao.x, self.posicao.y, 'esquerda', 20, 'boss'))

        self.delay_ataque = 0
    end

    for i = #self.tiros, 1, -1 do
        self.tiros[i]:update(dt)
    end

    if self.estado_mov == 'descendo' then
        self.posicao = self.posicao + Vector(0, 0.80)
    elseif self.estado_mov == 'subindo' then
        self.posicao = self.posicao - Vector(0, 0.80)
    end

    if self.posicao.y >= heroi:get_posicao_normalizada().y then
        self.estado_mov = 'subindo'
    elseif self.posicao.y <= heroi:get_posicao_normalizada().y then
        self.estado_mov = 'descendo'
    end
end

function Boss:draw()
    local posicao_heroi = heroi:get_posicao_normalizada()

    for i = #self.tiros, 1, -1 do
        self.tiros[i]:draw()
    end

    love.graphics.push()
    love.graphics.scale(2, 2)

    -- Linha de ataque frontal
    love.graphics.setColor(1, 0, 0, 0.20)
    love.graphics.setLineWidth(100)
    love.graphics.line(0, posicao_heroi.y/2, self.posicao.x/2 + 40, self.posicao.y/2 + 10)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(1, 1, 1)

    self.anim_inimigos:draw(self.img, self.posicao.x/2 + self.largura/4 + 20, self.posicao.y/2 - self.altura/4 - 25, 0, -1, 1)
    love.graphics.circle("line", self.posicao.x/2, self.posicao.y/2, 10)

    love.graphics.pop()  
end