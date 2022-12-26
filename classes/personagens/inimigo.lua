Inimigo = Classe:extend()

function Inimigo:new(nome_inimigo, tipos_inimigos)
    --Imagem
    self.img = love.graphics.newImage("/recursos/imagens/" .. nome_inimigo .. ".png")
    self.largura_animacao = self.img:getWidth()
    self.altura_animacao = self.img:getHeight()
    self.largura = 100
    self.altura = 100

    local g_inimigos = anim.newGrid(self.largura, self.altura, self.largura_animacao, self.altura_animacao)
    self.anim_inimigos = anim.newAnimation(g_inimigos('1-4', tipos_inimigos.op), 0.15)
    self.anim_inimigos_parado = anim.newAnimation(g_inimigos('1-1', tipos_inimigos.op), 0.15)

    --Status inimigo
    self.posicao = tipos_inimigos.pos
    self.velocidade = tipos_inimigos.vel
    self.dano = tipos_inimigos.dano
    self.vel_max = tipos_inimigos.vel_max
    self.raio_deteccao = tipos_inimigos.raio
    self.vida = tipos_inimigos.vida
    self.temp_vida = tipos_inimigos.vida
    self.barra_vida = 56
    self.raio = 40

    self.vel_desejada = Vector(0, 0)
    self.aceleracao = Vector(1, 1)
    self.direcao_max = 5
    self.direcao_des = Vector(0,0)
    self.massa = 5

    self.heroi_visivel = false
    self.estado = "parado"

    self.delay_dano = 0
    self.colidindo = false
end

function Inimigo:update(dt)
    self.anim_inimigos:update(dt)
    self.anim_inimigos_parado:update(dt)

    if self.delay_dano >= 0.80 then
        self.delay_dano = 0
        self.colidindo = false
    end

    -- Tempo para dar dano novamente no heroi
    if self.colidindo then
        self.delay_dano = self.delay_dano + dt
    end
    
    self.objetivo = heroi.posicao
    self.objetivo = self.objetivo + Vector(heroi.largura/2, heroi.altura/2)

    -- Definir qual lado o inimigo está olhando
    if self.heroi_visivel and self.objetivo.x >= self.posicao.x then
        self.estado = "olhando_dir"
    elseif self.heroi_visivel and self.objetivo.x < self.posicao.x then
        self.estado = "olhando_esq"
    end

    -- Verificar se o personagem(heroi) entrou na visão do inimigo
    if self:checa_visao(self.objetivo) or heroi.atirando then
        self.heroi_visivel = true
    end

    -- Coloca o zumbi para seguir se tem heroi visivel
    if self.heroi_visivel then
        self.vel_desejada = self.objetivo - self.posicao
        self.direcao_des = self.objetivo - (self.posicao + self.velocidade)
        self.direcao_des = self.direcao_des:limit(self.direcao_max / self.massa)

        self.velocidade = self.velocidade + self.direcao_des
        self.velocidade = self.velocidade:limit(self.vel_max)

        self.posicao = self.posicao + self.velocidade * dt
    end
end

function Inimigo:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("line", self.objetivo.x, self.objetivo.y, 5)
    love.graphics.setColor(0, 1, 0)
    love.graphics.circle("fill", self.posicao.x, self.posicao.y, 5)
    love.graphics.setColor(1, 1, 1)

    if self.estado == 'parado' then
        self.anim_inimigos_parado:draw(self.img, self.posicao.x - self.largura/2, self.posicao.y - self.altura/2, 0, 1, 1)
    elseif self.estado == "olhando_esq" then
        self.anim_inimigos:draw(self.img, self.posicao.x + self.largura/2, self.posicao.y - self.altura/2, 0, -1, 1)
    else
        self.anim_inimigos:draw(self.img, self.posicao.x - self.largura/2, self.posicao.y - self.altura/2, 0, 1, 1)
    end
    
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", self.posicao.x - 80 + self.largura/2, self.posicao.y - self.altura/2, 60, 10)
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", self.posicao.x - 78 + self.largura/2, self.posicao.y - self.altura/2, self.barra_vida, 6)
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("line", self.posicao.x, self.posicao.y, self.raio_deteccao)
    love.graphics.circle("line", self.posicao.x, self.posicao.y, self.raio)
end

function Inimigo:checa_visao(objeto)
    if self.posicao.dist(objeto, self.posicao) <= self.raio_deteccao then
        return true
    else
        return false
    end 
end
