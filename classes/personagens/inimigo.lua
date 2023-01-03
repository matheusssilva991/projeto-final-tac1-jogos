Inimigo = Classe:extend()

function Inimigo:new(nome_inimigo, tipos_inimigos, posicao)
    --Imagem
    self.nome = 'zumbi'
    self.img = love.graphics.newImage("/materials/chars/" .. nome_inimigo .. ".png")
    self.largura_animacao = self.img:getWidth()
    self.altura_animacao = self.img:getHeight()
    self.largura = 100
    self.altura = 100

    --Audio
    self.som_grunhido = love.audio.newSource("/materials/audio/zombie-growl-3-6863.mp3", "static")
    self.som_grunhido:setVolume(0.03)
    self.som_ataque = love.audio.newSource("/materials/audio/zombie-6851.mp3", "static")
    self.som_ataque:setVolume(0.03)

    local g_inimigos = anim.newGrid(self.largura, self.altura, self.largura_animacao, self.altura_animacao)
    self.anim_inimigos = anim.newAnimation(g_inimigos('1-4', tipos_inimigos.op), 0.15)
    self.anim_inimigos_parado = anim.newAnimation(g_inimigos('1-1', tipos_inimigos.op), 0.15)

    --Status inimigo
    self.posicao = posicao
    self.velocidade = tipos_inimigos.vel
    self.dano = tipos_inimigos.dano
    self.vel_max = tipos_inimigos.vel_max
    self.raio_deteccao = tipos_inimigos.raio
    self.vida = tipos_inimigos.vida
    self.temp_vida = tipos_inimigos.vida
    self.barra_vida = 56
    self.raio = 35

    self.esta_atacando = false

    self.objetivo = Vector(0, 0)
    self.vel_desejada = Vector(0, 0)
    self.aceleracao = Vector(1, 1)
    self.direcao_max = 10
    self.direcao_des = Vector(0,0)
    self.massa = 5

    self.heroi_visivel = false
    self.estado = "parado"

    self.delay_dano = 0
    self.colidindo = false
    self.collider = world:newBSGRectangleCollider(self.posicao.x, self.posicao.y, self.largura-60, self.altura-80, 0)
    self.collider:setFixedRotation(true)
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

    -- Definir qual lado o inimigo está olhando
    if self.heroi_visivel and self.objetivo.x >= self.posicao.x then
        self.estado = "olhando_dir"
    elseif self.heroi_visivel and self.objetivo.x < self.posicao.x then
        self.estado = "olhando_esq"
    end

    -- Verificar se o personagem(heroi) entrou na visão do inimigo
    local viu_heroi = verifica_colisao(heroi.posicao, heroi.raio, self.posicao, self.raio_deteccao)
    local escutou_tiro = (heroi.atirando and verifica_colisao(heroi.posicao, heroi.raio_tiro, self.posicao, self.raio_deteccao))
    if (viu_heroi or escutou_tiro) and not self.esta_atacando then
        self.heroi_visivel = true
        self.som_grunhido:play()
    end

    local vx, vy = 0, 0
    -- Coloca o zumbi para seguir se tem heroi visivel
    if self.heroi_visivel then
        self.vel_desejada = self.objetivo - self.posicao
        self.direcao_des = self.objetivo - (self.posicao + self.velocidade)
        self.direcao_des = self.direcao_des:limit(self.direcao_max / self.massa)

        self.velocidade = self.velocidade + self.direcao_des
        self.velocidade = self.velocidade:limit(self.vel_max)

        vx = self.velocidade.x
        vy = self.velocidade.y
    end

    self.collider:setLinearVelocity(vx, vy)
end

function Inimigo:draw()
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
