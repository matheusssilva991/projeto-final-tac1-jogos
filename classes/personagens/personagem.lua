Personagem = Classe:extend()

function Personagem:new(x, y)
    self.nome = 'heroi'
    self.img = love.graphics.newImage("materials/chars/personagem.png")
    self.largura_animacao = self.img:getWidth()
    self.altura_animacao = self.img:getHeight()
    self.largura = self.largura_animacao/8
    self.altura = self.altura_animacao/5
    local grid = anim.newGrid(self.largura, self.altura, self.largura_animacao, self.altura_animacao)
    self.animation_andando = anim.newAnimation(grid('1-8', 3, '1-6', 4), 0.1)
    self.animation_parado = anim.newAnimation(grid('7-7', 4), 0.1)
    self.animation_morrendo = anim.newAnimation(grid('7-8', 4, '1-8', 5), 0.1)
    self.animation_morrendo_final = anim.newAnimation(grid('7-8', 5), 0.1)
    self.animation_atirando = anim.newAnimation(grid('1-5', 2), 0.1)

    self.estado = 'parado_dir'
    self.atirando = false
    self.posicao = Vector(x, y) + Vector(self.largura/2, self.altura/2)
    self.pos_real = Vector(x, y)
    self.tiros = {}
    self.delay_tiro = 0
    self.raio = 20
    self.raio_tiro = 450
    self.vida = 100
    self.vel = 230
    self.dano = 30

    self.estado_anterior = nil
    self.tempo_colisao = 0
    self.vetor_direcao = Vector(0, 0)

    self.collider = world:newBSGRectangleCollider(self.pos_real.x+30, self.pos_real.y+10, self.largura-60, self.altura-80, 10)
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
    if love.keyboard.isDown("a") and self.estado ~= 'colidindo' and self.vida > 0 then
        vx = self.vel * -1
        self.estado = 'andando_esq'

        if enfrentando_boss == true then
            if self.pos_real.x < 1600 then
                vx = 0
            end
        end
    elseif love.keyboard.isDown("d") and self.estado ~= 'colidindo' and self.vida > 0 then
        vx = self.vel
        self.estado = 'andando_dir'   
    end

    -- Verifica se está andando para cima ou para baixo
    if love.keyboard.isDown("w") and self.estado ~= 'colidindo' and self.vida > 0 then
        vy = self.vel * -1
        self:verifica_estado_andando()
    elseif love.keyboard.isDown("s") and self.estado ~= 'colidindo' and self.vida > 0 then
        vy = self.vel
        self:verifica_estado_andando()
    end

    -- verifica se o personagem estava atirando
    if self.atirando and self.delay_tiro > 0.45 then
        self.atirando = false
        self.delay_tiro = 0
    elseif self.atirando and self.delay_tiro <= 0.45 then
        self.delay_tiro = self.delay_tiro + dt
    end

    -- verifica se o personagem ainda está colidindo com o boss
    if self.tempo_colisao <= 0.30 and self.estado == 'colidindo' then
        self.tempo_colisao = self.tempo_colisao + dt
        vx = self.vetor_direcao.x * 4
        vy = self.vetor_direcao.y * 4

        if self.pos_real.x < 20  then
            vx = 0
        elseif self.pos_real.x >  bg.larg - 20 then
            vx = 0
        end  

        if self.pos_real.y > 425 then
            vy = 0
        elseif self.pos_real.y < 150 then
            vy = 0
        end
    elseif self.tempo_colisao > 0.30 and self.estado == 'colidindo' then
        self.tempo_colisao = 0
        self.estado = 'andando_dir'
    end

    if heroi.vida > 0 then
        self.collider:setLinearVelocity(vx, vy)
    end

    -- verifica se colidiu com algum zumbi
    for i=1, #inimigos do
        if verifica_colisao(heroi.posicao, heroi.raio, inimigos[i].posicao, inimigos[i].raio) then
            inimigos[i].colidindo = true
            if inimigos[i].delay_dano == 0 then
                inimigos[i].esta_atacando = true
                heroi.vida = math.max(heroi.vida - inimigos[i].dano, 0)
                inimigos[i].som_ataque:play()
            end
        end
    end

    -- Verifica se colidiu com o boss
    if boss ~= nil and verifica_colisao(self.posicao, self.raio, boss.posicao, boss.raio) and self.estado ~= 'colidindo' then
        self.estado_anterior = self.estado
        self.estado = 'colidindo'
        self.vetor_direcao = self.posicao - boss.posicao
        self.tipo_colisao = 'boss'

        if boss.delay_dano == 0 then
            self.vida = math.max(self.vida - boss.dano, 0) 
        end
    end

    -- Checa se o personagem  atirou
    local tmp_cond_parado = (self.estado == 'parado_esq' or self.estado == 'parado_dir')
    if love.mouse.isDown(1) and not self.atirando and tmp_cond_parado and mouse_delay <=0 then
        self.atirando = true

        local tiro
        -- Verifica para qual lado vai ser o tiro
        if self.estado == 'parado_esq' then
            tiro = Tiro(self.posicao.x, self.posicao.y, 'esquerda', 2, 'heroi', self.dano, 1000)
        elseif self.estado == 'parado_dir' then
            tiro = Tiro(self.posicao.x, self.posicao.y, 'direita', 2, 'heroi', self.dano, 1000)
        end
        table.insert(self.tiros, tiro)
    end

    -- Verifica colisão dos tiros
    local itens_mapa = {}

    for i=#inimigos, 1, -1 do
        table.insert(itens_mapa, inimigos[i])
    end

    for i=#caixas, 1, -1 do
        table.insert(itens_mapa, caixas[i])
    end

    if boss ~= nil then
        table.insert(itens_mapa, boss)
    end

    sort_posicao_x(itens_mapa)

    for i = #self.tiros, 1, -1 do
        self.tiros[i]:update(dt)
        local cond_loop = true
        local index_colisao = -1

        if self.tiros[i].direcao == 'direita' then
            local j = 1
            while j <= #itens_mapa and cond_loop do
                if verifica_colisao(itens_mapa[j].posicao, itens_mapa[j].raio, self.tiros[i].posicao, self.tiros[i].raio) then
                    index_colisao = j
                    cond_loop = false
                end
                j=j+1
            end
        elseif self.tiros[i].direcao == 'esquerda' then
            local j = #itens_mapa
            while j >= 1 and cond_loop do
                if verifica_colisao(itens_mapa[j].posicao, itens_mapa[j].raio, self.tiros[i].posicao, self.tiros[i].raio) then
                    index_colisao = j
                    cond_loop = false
                end
                j=j-1
            end
        end

        if index_colisao ~= -1 then
            if itens_mapa[index_colisao].nome == 'boss' then
                boss.vida = boss.vida - self.tiros[i].dano
                boss.heroi_visivel = true

                if boss.vida <= 0 then
                    boss = nil
                end
            elseif itens_mapa[index_colisao].nome == 'zumbi' then
                local cond_loop = true
                local j = #inimigos
                
                while j >= 1 and cond_loop do
                    if inimigos[j] == itens_mapa[index_colisao] then
                        inimigos[j].vida = inimigos[j].vida - self.tiros[i].dano
                        inimigos[j].barra_vida = inimigos[j].barra_vida * (inimigos[j].vida/inimigos[j].temp_vida)
                        inimigos[j].heroi_visivel = true
                        
                        if inimigos[j].vida <= 0 then
                            inimigos[j].collider:destroy()
                            table.remove(inimigos, j)
                        end
                    end

                    j=j-1
                end
            else
                local cond_loop = true
                local j = #caixas
                
                while j >= 1 and cond_loop do
                    if caixas[j] == itens_mapa[index_colisao] then
                        caixas[j].vida = caixas[j].vida - self.tiros[i].dano
                        caixas[j].numero_tiros = caixas[j].numero_tiros + 1
                        caixas[j].acertou = true

                        if caixas[j].vida <= 0 then
                            caixas[j].collider:destroy()
                            table.remove(caixas, j)
                        end
                    end

                    j=j-1
                end
            end

            table.remove(self.tiros, i)
        end

        if self.tiros[i] ~= nil and self.tiros[i].distancia_tiro >= 600 then
            table.remove(self.tiros, i)
        end
    end
    
    if self.vida <= 0 then
        if self.estado == 'andando_dir' or self.estado == 'parado_dir' then
            self.estado = 'morrendo_dir'
            self.estado_anterior = 'morrendo_dir'
        elseif self.estado == 'andando_esq' or self.estado == 'parado_esq' then
            self.estado = 'morrendo_esq'
            self.estado_anterior = 'morrendo_esq'
        end
    end
    
    self.animation_andando:update(dt)
    self.animation_parado:update(dt)
    self.animation_atirando:update(dt)
    self.animation_morrendo:update(dt)
    self.animation_morrendo_final:update(dt)
end

function Personagem:draw()
    -- Verifica o estado e qual direção o heroi está olhando
    if self.estado == 'parado_esq' or (self.estado_anterior == 'parado_esq' and self.estado == 'colidindo') then
        if self.atirando then 
            self.animation_atirando:draw(self.img, self.pos_real.x + self.largura, self.pos_real.y, 0, -1, 1)
        else
            self.animation_parado:draw(self.img, self.pos_real.x + self.largura, self.pos_real.y, 0, -1, 1)
        end
    elseif self.estado == 'parado_dir' or (self.estado_anterior == 'parado_dir' and self.estado == 'colidindo') then 
        if self.atirando then  
            self.animation_atirando:draw(self.img, self.pos_real.x, self.pos_real.y, 0, 1, 1)
        else
            self.animation_parado:draw(self.img, self.pos_real.x, self.pos_real.y, 0, 1, 1)
        end
    elseif self.estado == 'andando_esq' or (self.estado_anterior == 'andando_esq' and self.estado == 'colidindo') then 
        self.animation_andando:draw(self.img, self.pos_real.x + self.largura, self.pos_real.y, 0, -1, 1)
    elseif self.estado == 'andando_dir' or (self.estado_anterior == 'andando_dir' and self.estado == 'colidindo') then 
        self.animation_andando:draw(self.img, self.pos_real.x, self.pos_real.y, 0, 1, 1)
    elseif self.estado == 'morrendo_esq' then
        self.animation_morrendo:draw(self.img, self.pos_real.x + self.largura, self.pos_real.y, 0, -1, 1)
    elseif self.estado == 'morrendo_dir' then
        self.animation_morrendo:draw(self.img, self.pos_real.x, self.pos_real.y, 0, 1, 1)
    elseif self.estado == 'morrendo_esq_final' then
        self.animation_morrendo_final:draw(self.img, self.pos_real.x + self.largura, self.pos_real.y, 0, -1, 1)
    elseif self.estado == 'morrendo_dir_final' then
        self.animation_morrendo_final:draw(self.img, self.pos_real.x, self.pos_real.y, 0, 1, 1)
    end
    
    for i=1, #self.tiros do
        self.tiros[i]:draw()
    end

    --love.graphics.circle("line", self.posicao.x, self.posicao.y, 5)
end

function Personagem:verifica_estado_andando()
    if self.estado == 'parado_esq' or self.estado == 'andando_esq' then
        self.estado = 'andando_esq'
    elseif self.estado == 'parado_dir' or self.estado == 'andando_dir' then
        self.estado = 'andando_dir'
    end
end
