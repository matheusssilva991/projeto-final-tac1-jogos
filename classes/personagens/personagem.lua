Personagem = Classe:extend()

function Personagem:new(x, y)
    self.img = love.graphics.newImage("recursos/imagens/personagem.png")
    self.largura_animacao = self.img:getWidth()
    self.altura_animacao = self.img:getHeight()
    self.largura = self.largura_animacao/8
    self.altura = self.altura_animacao/5
    local grid = anim.newGrid(self.largura, self.altura, self.largura_animacao, self.altura_animacao)
    self.animation_andando = anim.newAnimation(grid('1-8', 3, '1-6', 4), 0.1)
    self.animation_parado = anim.newAnimation(grid('7-7', 4), 0.1)
    self.animation_atirando = anim.newAnimation(grid('1-8', 2), 0.1)

    self.estado = 'parado_dir'
    self.atirando = false
    self.posicao = Vector(x, y)
    self.tiros = {}
    self.delay_tiro = 0
    self.raio = 35
    self.vida = 100

end

function Personagem:update(dt)
    -- verifica se está parado olhando para esquerda ou direita
    if self.estado == 'andando_dir' or self.estado == 'parado_dir' then
        self.estado = 'parado_dir'
    elseif self.estado == 'andando_esq' or self.estado == 'parado_esq' then
        self.estado = 'parado_esq'
    end
    
    -- Verifica se está andando pra esquerda ou direita
    if love.keyboard.isDown("a") then
        if self.posicao.x + self.largura / 2 - 150 * dt >= 0 then
            self.posicao.x = self.posicao.x - 150 * dt
        end
        self.estado = 'andando_esq'
    elseif love.keyboard.isDown("d") then
        self.posicao.x = self.posicao.x + 150 * dt
        self.estado = 'andando_dir'   
    end

    -- Verifica se está andando para cima ou para baixo
    if love.keyboard.isDown("w") then
        self.posicao.y = self.posicao.y - 150 * dt
        self:verifica_estado_andando()
    elseif love.keyboard.isDown("s") then
        self.posicao.y = self.posicao.y + 150 * dt
        self:verifica_estado_andando()
    end

    -- verifica se o personagem estava atirando
    if self.atirando and self.delay_tiro > 0.60 then
        self.atirando = false
        self.delay_tiro = 0
    elseif self.atirando and self.delay_tiro <= 0.60 then
        self.delay_tiro = self.delay_tiro + dt
    end

    -- Checa se o personagem  atirou
    local tmp_cond_parado = (self.estado == 'parado_esq' or self.estado == 'parado_dir')
    if love.mouse.isDown(1) and not self.atirando and tmp_cond_parado then
        self.atirando = true
        
        local tiro
        -- Verifica para qual lado vai ser o tiro
        if self.estado == 'parado_esq' then
           tiro = Tiro(self.posicao.x + self.largura/2, self.posicao.y + self.altura/2, 'esquerda')
        elseif self.estado == 'parado_dir' then
            tiro = Tiro(self.posicao.x + self.largura/2, self.posicao.y + self.altura/2, 'direita')
        end
        table.insert(self.tiros, tiro)
    end

    -- Verifica colisão dos tiros
    for i = #self.tiros, 1, -1 do
        self.tiros[i]:update(dt)
    
        local cond_loop = true
        local j = 1

        -- Verifica se o tiro colidiu com algum inimigo
        while j <= #inimigos and cond_loop do
            if verifica_colisao(self.tiros[i].posicao, self.tiros[i].raio, inimigos[j].posicao, inimigos[j].raio) then
                inimigos[j].vida = inimigos[j].vida - self.tiros[i].dano
                inimigos[j].barra_vida = inimigos[j].barra_vida * (inimigos[j].vida/inimigos[j].temp_vida)

                cond_loop = false
                table.remove(self.tiros, i)

                if inimigos[j].vida < 0 then
                    table.remove(inimigos, j)
                end
            end
            j=j+1
        end
    end
    
    self.animation_andando:update(dt)
    self.animation_parado:update(dt)
    self.animation_atirando:update(dt)
end

function Personagem:draw()
    if self.estado == 'parado_esq' then -- Verifica se está parado olhando para esquerda
        if self.atirando then   -- Verifica se está atirando para a esquerda
            self.animation_atirando:draw(self.img, self.posicao.x + self.largura, self.posicao.y, 0, -1, 1)
        else
            self.animation_parado:draw(self.img, self.posicao.x + self.largura, self.posicao.y, 0, -1, 1)
        end
    elseif self.estado == 'parado_dir' then -- Verifica se está parado olhando para direita
        if self.atirando then   -- Verifica se está atirando para a direita
            self.animation_atirando:draw(self.img, self.posicao.x, self.posicao.y, 0, 1, 1)
        else
            self.animation_parado:draw(self.img, self.posicao.x, self.posicao.y, 0, 1, 1)
        end
    elseif self.estado == 'andando_esq' then -- Verifica se está andando olhando para esquerda
        self.animation_andando:draw(self.img, self.posicao.x + self.largura, self.posicao.y, 0, -1, 1)
    elseif self.estado == 'andando_dir' then -- Verifica se está andando olhando para direita
        self.animation_andando:draw(self.img, self.posicao.x, self.posicao.y, 0, 1, 1)
    end
    
    for i=1, #self.tiros do
        self.tiros[i]:draw()
    end

    love.graphics.circle("line", self.posicao.x + self.largura/2, self.posicao.y + self.altura/2, self.raio)
end

function Personagem:verifica_estado_andando()
    if self.estado == 'parado_esq' or self.estado == 'andando_esq' then
        self.estado = 'andando_esq'
    elseif self.estado == 'parado_dir' or self.estado == 'andando_dir' then
        self.estado = 'andando_dir'
    end
end

function Personagem:get_posicao_normalizada()
    local x, y

    x = self.posicao.x + self.largura/2
    y = self.posicao.y + self.altura/2

    return Vector(x, y)
end
