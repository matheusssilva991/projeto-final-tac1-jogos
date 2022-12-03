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
    self.estado = 'parado_dir'

    self.posicao = Vector(x, y)
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

    self.animation_andando:update(dt)
    self.animation_parado:update(dt)
end

function Personagem:draw()
    if self.estado == 'parado_esq' then
        self.animation_parado:draw(self.img, self.posicao.x + self.largura, self.posicao.y, 0, -1, 1)
    elseif self.estado == 'parado_dir' then
        self.animation_parado:draw(self.img, self.posicao.x, self.posicao.y, 0, 1, 1)
    elseif self.estado == 'andando_esq' then
        self.animation_andando:draw(self.img, self.posicao.x + self.largura, self.posicao.y, 0, -1, 1)
    elseif self.estado == 'andando_dir' then
        self.animation_andando:draw(self.img, self.posicao.x, self.posicao.y, 0, 1, 1)
    end     
end

function Personagem:verifica_estado_andando()
    if self.estado == 'parado_esq' or self.estado == 'andando_esq' then
        self.estado = 'andando_esq'
    elseif self.estado == 'parado_dir' or self.estado == 'andando_dir' then
        self.estado = 'andando_dir'
    end
end