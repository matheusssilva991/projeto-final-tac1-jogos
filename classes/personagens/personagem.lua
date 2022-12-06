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

    self.estado_mov = 'parado_dir'
    self.estado_atirando = false
    self.posicao = Vector(x, y)
    self.tiros = {}
    self.delay_tiro = 0
end

function Personagem:update(dt)
    -- verifica se está parado olhando para esquerda ou direita
    if self.estado_mov == 'andando_dir' or self.estado_mov == 'parado_dir' then
        self.estado_mov = 'parado_dir'
    elseif self.estado_mov == 'andando_esq' or self.estado_mov == 'parado_esq' then
        self.estado_mov = 'parado_esq'
    end
    
    -- Verifica se está andando pra esquerda ou direita
    if love.keyboard.isDown("a") then
        if self.posicao.x + self.largura / 2 - 150 * dt >= 0 then
            self.posicao.x = self.posicao.x - 150 * dt
        end
        self.estado_mov = 'andando_esq'
    elseif love.keyboard.isDown("d") then
        self.posicao.x = self.posicao.x + 150 * dt
        self.estado_mov = 'andando_dir'   
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
    if self.estado_atirando and self.delay_tiro > 0.60 then
        self.estado_atirando = false
        self.delay_tiro = 0
    elseif self.estado_atirando and self.delay_tiro <= 0.60 then
        self.delay_tiro = self.delay_tiro + dt
    end

    -- Checa se o personagem está atirou
    local tmp_cond_parado = (self.estado_mov == 'parado_esq' or self.estado_mov == 'parado_dir')
    if love.mouse.isDown(1) and not self.estado_atirando and tmp_cond_parado then
        self.estado_atirando = true
        
        local tiro
        -- Verifica para qual lado vai ser o tiro
        if self.estado_mov == 'parado_esq' then
           tiro = Tiro(self.posicao.x + self.largura/2, self.posicao.y + self.altura/2, 'esquerda')
        elseif self.estado_mov == 'parado_dir' then
            tiro = Tiro(self.posicao.x + self.largura/2, self.posicao.y + self.altura/2, 'direita')
        end
        table.insert(self.tiros, tiro)
    end

    for i=1, #self.tiros do
        self.tiros[i]:update(dt)
    end

    self.animation_andando:update(dt)
    self.animation_parado:update(dt)
    self.animation_atirando:update(dt)
end

function Personagem:draw()
    if self.estado_mov == 'parado_esq' then -- Verifica se está parado olhando para esquerda
        if self.estado_atirando then   -- Verifica se está atirando para a esquerda
            self.animation_atirando:draw(self.img, self.posicao.x + self.largura, self.posicao.y, 0, -1, 1)
        else
            self.animation_parado:draw(self.img, self.posicao.x + self.largura, self.posicao.y, 0, -1, 1)
        end
    elseif self.estado_mov == 'parado_dir' then -- Verifica se está parado olhando para direita
        if self.estado_atirando then   -- Verifica se está atirando para a direita
            self.animation_atirando:draw(self.img, self.posicao.x, self.posicao.y, 0, 1, 1)
        else
            self.animation_parado:draw(self.img, self.posicao.x, self.posicao.y, 0, 1, 1)
        end
    elseif self.estado_mov == 'andando_esq' then -- Verifica se está andando olhando para esquerda
        self.animation_andando:draw(self.img, self.posicao.x + self.largura, self.posicao.y, 0, -1, 1)
    elseif self.estado_mov == 'andando_dir' then -- Verifica se está andando olhando para direita
        self.animation_andando:draw(self.img, self.posicao.x, self.posicao.y, 0, 1, 1)
    end
    
    for i=1, #self.tiros do
        self.tiros[i]:draw()
    end

    love.graphics.print("Qtd_tiros: " .. #self.tiros, 10, 10)
end

function Personagem:verifica_estado_andando()
    if self.estado_mov == 'parado_esq' or self.estado_mov == 'andando_esq' then
        self.estado_mov = 'andando_esq'
    elseif self.estado_mov == 'parado_dir' or self.estado_mov == 'andando_dir' then
        self.estado_mov = 'andando_dir'
    end
end
