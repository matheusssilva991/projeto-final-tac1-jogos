Personagem = Classe:extend()

function Personagem:new(x, y)
    self.img = love.graphics.newImage("materials/chars/personagem.png")
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
    self.raio_tiro = 300
    self.vida = 100
    self.vel = 300

    self.estado_anterior = nil
    self.tempo_colisao = 0
    self.vetor_direcao = Vector(0, 0)

    self.collider = world:newBSGRectangleCollider(self.posicao.x+30, self.posicao.y+10, self.largura-60, self.altura-80, 10)
    self.collider:setFixedRotation(true)
end

function Personagem:update(dt)
    -- verifica se está parado olhando para esquerda ou direita
    if self.estado == 'andando_dir' or self.estado == 'parado_dir' then
        self.estado = 'parado_dir'
    elseif self.estado == 'andando_esq' or self.estado == 'parado_esq' then
        self.estado = 'parado_esq'
    end

    local vx = 0
    local vy = 0
    
    -- Verifica se está andando pra esquerda ou direita
    if love.keyboard.isDown("a") and self.estado ~= 'colidindo' then
        vx = self.vel * -1
        self.estado = 'andando_esq'
    elseif love.keyboard.isDown("d") and self.estado ~= 'colidindo' then
        vx = self.vel
        self.estado = 'andando_dir'   
    end

    -- Verifica se está andando para cima ou para baixo
    if love.keyboard.isDown("w") and self.estado ~= 'colidindo' then
        vy = self.vel * -1
        self:verifica_estado_andando()
    elseif love.keyboard.isDown("s") and self.estado ~= 'colidindo' then
        vy = self.vel
        self:verifica_estado_andando()
    end

    -- verifica se o personagem estava atirando
    if self.atirando and self.delay_tiro > 0.60 then
        self.atirando = false
        self.delay_tiro = 0
    elseif self.atirando and self.delay_tiro <= 0.60 then
        self.delay_tiro = self.delay_tiro + dt
    end

    -- verifica se o personagem ainda está colidindo com o boss
    if self.tempo_colisao <= 0.30 and self.estado == 'colidindo' then
        self.tempo_colisao = self.tempo_colisao + dt
        vx = self.vetor_direcao.x * 4
        vy = self.vetor_direcao.y * 4

        if self.posicao.x < 20  then
            vx = 0
        elseif self.posicao.x >  bg.larg - 20 then
            vx = 0
        end  

        if self.posicao.y > 425 then
            vy = 0
        elseif self.posicao.y < 150 then
            vy = 0
        end
    elseif self.tempo_colisao > 0.30 and self.estado == 'colidindo' then
        self.tempo_colisao = 0
        self.estado = 'andando_dir'
    end

    self.collider:setLinearVelocity(vx, vy)

    -- verifica se colidiu com algum zumbi
    for i=1, #inimigos do
        if verifica_colisao(heroi:get_posicao_normalizada(), heroi.raio, inimigos[i].posicao, inimigos[i].raio) then
            inimigos[i].colidindo = true
            if inimigos[i].delay_dano == 0 then
                heroi.vida = math.max(heroi.vida - inimigos[i].dano, 0)
            end
        end
    end

    -- Verifica se colidiu com o boss
    if boss ~= nil and verifica_colisao(self:get_posicao_normalizada(), self.raio, boss.posicao, boss.raio) and self.estado ~= 'colidindo' then
        self.estado_anterior = self.estado
        self.estado = 'colidindo'
        self.vetor_direcao = self:get_posicao_normalizada() - boss.posicao
        self.tipo_colisao = 'boss'

        if boss.delay_dano == 0 then
            self.vida = math.max(self.vida - boss.dano, 0) 
        end
    end

    -- Checa se o personagem  atirou
    local tmp_cond_parado = (self.estado == 'parado_esq' or self.estado == 'parado_dir')
    if love.mouse.isDown(1) and not self.atirando and tmp_cond_parado then
        self.atirando = true
        
        local tiro
        -- Verifica para qual lado vai ser o tiro
        if self.estado == 'parado_esq' then
           tiro = Tiro(self.posicao.x + self.largura/2, self.posicao.y + self.altura/2, 'esquerda', 2, 'heroi', 35)
        elseif self.estado == 'parado_dir' then
            tiro = Tiro(self.posicao.x + self.largura/2, self.posicao.y + self.altura/2, 'direita', 2, 'heroi', 35)
        end
        table.insert(self.tiros, tiro)
    end

    -- Verifica colisão dos tiros
    for i = #self.tiros, 1, -1 do
        self.tiros[i]:update(dt)
    
        local cond_loop = true
        local j = 1
        local colisao_boss = false
        local colisao_zumbi = false

        if boss ~= nil and verifica_colisao(self.tiros[i].posicao, self.tiros[i].raio, boss.posicao, boss.raio) then
            colisao_boss = true
        end

        -- Verifica se o tiro colidiu com algum zumbi
        while j <= #inimigos and cond_loop do
            if verifica_colisao(self.tiros[i].posicao, self.tiros[i].raio, inimigos[j].posicao, inimigos[j].raio) then
                if self.tiros[i].direcao == 'direita' and colisao_boss then --Verifica quem o tiro acertou primeiro direita
                    if boss ~= nil and boss.posicao.x < inimigos[i].posicao.x then
                        boss.vida = math.max(boss.vida - self.tiros[i].dano, 0)
                        boss.heroi_visivel = true
                    else
                        inimigos[j].vida = math.max(inimigos[j].vida - self.tiros[i].dano, 0)
                        inimigos[j].barra_vida = inimigos[j].barra_vida * (inimigos[j].vida/inimigos[j].temp_vida)
                        colisao_zumbi = true
                        inimigos[j].heroi_visivel = true    
                    end
                elseif self.tiros[i].direcao == 'esquerda' and colisao_boss then --Verifica quem o tiro acertou primeiro esq
                    if boss ~= nil and boss.posicao.x > inimigos[i].posicao.x then
                        boss.vida = math.max(boss.vida - self.tiros[i].dano, 0)
                        boss.heroi_visivel = true
                    else
                        inimigos[j].vida = math.max(inimigos[j].vida - self.tiros[i].dano, 0)
                        inimigos[j].barra_vida = inimigos[j].barra_vida * (inimigos[j].vida/inimigos[j].temp_vida)
                        colisao_zumbi = true  
                        inimigos[j].heroi_visivel = true 
                    end
                else -- não atingiu boss, apenas zumbi
                    inimigos[j].vida = math.max(inimigos[j].vida - self.tiros[i].dano, 0)
                    inimigos[j].barra_vida = inimigos[j].barra_vida * (inimigos[j].vida/inimigos[j].temp_vida)
                    colisao_zumbi = true  
                    inimigos[j].heroi_visivel = true 
                end  

                if inimigos[j].vida <= 0 then
                    inimigos[j].collider:destroy()
                    table.remove(inimigos, j)
                end

                if boss ~= nil and boss.vida <= 0 then
                    boss = nil
                end

                cond_loop = false
                table.remove(self.tiros, i)   
            end
            j=j+1
        end
        
        if colisao_boss and not colisao_zumbi then
            boss.vida = math.max(boss.vida - self.tiros[i].dano, 0)
            table.remove(self.tiros, i)  
            boss.heroi_visivel = true

            if boss ~= nil and boss.vida <= 0 then
                boss = nil
            end
        elseif not colisao_boss and not colisao_zumbi and self.tiros[i].distancia_tiro >= 800 then
            table.remove(self.tiros, i)
        end
    end
    
    self.animation_andando:update(dt)
    self.animation_parado:update(dt)
    self.animation_atirando:update(dt)
end

function Personagem:draw()
    -- Verifica o estado e qual direção o heroi está olhando
    if self.estado == 'parado_esq' or (self.estado_anterior == 'parado_esq' and self.estado == 'colidindo') then
        if self.atirando then 
            self.animation_atirando:draw(self.img, self.posicao.x + self.largura, self.posicao.y, 0, -1, 1)
        else
            self.animation_parado:draw(self.img, self.posicao.x + self.largura, self.posicao.y, 0, -1, 1)
        end
    elseif self.estado == 'parado_dir' or (self.estado_anterior == 'parado_dir' and self.estado == 'colidindo') then 
        if self.atirando then  
            self.animation_atirando:draw(self.img, self.posicao.x, self.posicao.y, 0, 1, 1)
        else
            self.animation_parado:draw(self.img, self.posicao.x, self.posicao.y, 0, 1, 1)
        end
    elseif self.estado == 'andando_esq' or (self.estado_anterior == 'andando_esq' and self.estado == 'colidindo') then 
        self.animation_andando:draw(self.img, self.posicao.x + self.largura, self.posicao.y, 0, -1, 1)
    elseif self.estado == 'andando_dir' or (self.estado_anterior == 'andando_dir' and self.estado == 'colidindo') then 
        self.animation_andando:draw(self.img, self.posicao.x, self.posicao.y, 0, 1, 1)
    end
    
    for i=1, #self.tiros do
        self.tiros[i]:draw()
    end

    love.graphics.circle("line", self.posicao.x + self.largura/2, self.posicao.y + self.altura/2, self.raio)
    --love.graphics.circle("line", self.posicao.x + self.largura/2, self.posicao.y + self.altura/2, self.raio_tiro)
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
