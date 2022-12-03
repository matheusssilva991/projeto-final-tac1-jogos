Inimigo = Classe:extend()

function Inimigo:new(nome_inimigo, tipos_inimigos)
    --Imagem
    self.img = love.graphics.newImage("/Sprites/personagens/" .. nome_inimigo .. ".png")
    self.largura_animacao = self.img:getWidth()
    self.altura_animacao = self.img:getHeight()
    local g_inimigos = anim.newGrid(100, 100, self.largura_animacao, self.altura_animacao)
    self.anim_inimigos = anim.newAnimation(g_inimigos('1-4', tipos_inimigos.op), 0.15)

    --Status inimigo
    self.posicao = Vector(LARGURA_TELA + 100, 80)
    self.velocidade = tipos_inimigos.velocidade
    self.dano = tipos_inimigos.dano
    self.vida = tipos_inimigos.vida
    self.temp_vida = tipos_inimigos.vida

    self.barra_vida = 56

    self.qtd_moeda_gerada = tipos_inimigos.qtd_moeda_gerada

    -- Localização mapa
    self.direcao = {"esq","esq", "baixo", "baixo", "baixo", "esq", "esq", "cima", "cima", "cima",
                    "esq", "esq", "baixo", "baixo", "baixo", "esq", "esq", "esq"}

    self.pos_objetivo = {800, 700, 180, 280, 380, 600, 500, 280, 180, 80, 400, 300, 180, 
                         280, 380, 200, 100, 0}
    self.i = 1
end

function Inimigo:update(dt)
    self.anim_inimigos:update(dt)

    if self.direcao[self.i] == "esq" and self.posicao.x > self.pos_objetivo[self.i] then
        self.posicao.x = self.posicao.x - self.velocidade * dt
    elseif self.direcao[self.i] == "cima" and self.posicao.y > self.pos_objetivo[self.i] then
        self.posicao.y = self.posicao.y - self.velocidade * dt
    elseif self.direcao[self.i] == "baixo" and self.posicao.y < self.pos_objetivo[self.i] then
        self.posicao.y = self.posicao.y + self.velocidade * dt
    elseif self.i < #self.direcao then
        self.i = self.i + 1
    end

end

function Inimigo:draw()
    self.anim_inimigos:draw(self.img, self.posicao.x, self.posicao.y, 0, -1, 1)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", self.posicao.x - 80, self.posicao.y - 10, 60, 10)
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", self.posicao.x - 78, self.posicao.y - 8, self.barra_vida, 6)
    love.graphics.setColor(1, 1, 1)
    --love.graphics.circle("line", self.posicao.x - 50, self.posicao.y + 50, 150)
    --love.graphics.print("vida: " ..self.vida, 10, 10)
end
