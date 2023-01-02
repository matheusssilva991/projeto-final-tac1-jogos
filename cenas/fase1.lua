Fase1 = Classe:extend()

function Fase1:new()
    cam = camera()
    world = wf.newWorld(0, 0)

    bg = Background("mapa_fase_1")
    hud = InGameHud()
    start_menu = Start()

    
    love.graphics.setBackgroundColor(0, 0.4, 0.4)
    
    -- Status Fase
    self.estado = 'nao finalizado'
    self.delay_mudar_fase = 0
    self.alpha = 0

    self.tempo = 30
    self.alpha2 = 1
    self.alphaTxt = 1

    self.skipPulse = 1
    self.var = 0
    
    -- Heroi - Personagem principal
    heroi = Personagem(140, 220)
    enfrentando_boss = false

    -- Zumbies normal
    tipos_inimigos = {{vel = Vector(50, 50), dano=5, vida=100, op=1, vel_max=120, raio=100},
                      {vel = Vector(40, 40), dano=10, vida=100, op=3, vel_max=100, raio=100},
                      {vel = Vector(35, 35), dano=15, vida=100, op=4, vel_max=60, raio=100}}

    inimigos = {Inimigo("inimigos", tipos_inimigos[1], Vector(400, 210)),
                Inimigo("inimigos", tipos_inimigos[2], Vector(70, 450)),
                Inimigo("inimigos", tipos_inimigos[3], Vector(700, 400)),
                Inimigo("inimigos", tipos_inimigos[2], Vector(925, 226)),
                Inimigo("inimigos", tipos_inimigos[3], Vector(1100, 167)),
                Inimigo("inimigos", tipos_inimigos[2], Vector(1134, 452)),
                Inimigo("inimigos", tipos_inimigos[2], Vector(1381, 446)),
                Inimigo("inimigos", tipos_inimigos[1], Vector(1388, 204)),
                Inimigo("inimigos", tipos_inimigos[1], Vector(1605, 157))}

    -- Boss
    tipo_boss = {posicao=Vector(2325, 350), dano=16, dano_tiro=16, vida=1, raio=70, raio_deteccao=450, vel=700, vel_tiro=350, op=2}
    boss = Boss("inimigos", tipo_boss)
    vida_boss_pctg = 200/tipo_boss.vida

    -- Caixas
    caixas = {Caixa(Vector(220, 330)),
              Caixa(Vector(275, 330)),
              Caixa(Vector(420, 330))}

    --DEFINE LIMITES DO MAPA
    local paredeEsq = world:newRectangleCollider(-10, 0, 10, 600)
    local paredeDir = world:newRectangleCollider(2400, 0, 10, 600)
    local paredeCima = world:newRectangleCollider(0, 0, 2400, 230)
    local paredeBaixo = world:newRectangleCollider(0, 520, 2400, 10)
    paredeEsq:setType('static')
    paredeDir:setType('static')
    paredeCima:setType('static')
    paredeBaixo:setType('static')

    --DEFINE COLISAO COM DECORACOES DO MAPA
    local planta1 = world:newRectangleCollider(55, 160, 35, 90)
    local planta2 = world:newRectangleCollider(281, 160, 35, 90)
    planta1:setType('static')
    planta2:setType('static')

    local colunasBanco1 = world:newRectangleCollider(1650, 160, 140, 80)
    local colunasBanco2 = world:newRectangleCollider(1900, 160, 140, 80)
    colunasBanco1:setType('static')
    colunasBanco2:setType('static')
end

function Fase1:update(dt)
    self.tempo = self.tempo - dt

    self.var = self.var + 0.8

    self.skipPulse = 0.3 + math.sin(math.rad(self.var)) * 0.2

    if self.tempo < 1 then
        self.alphaTxt = self.alphaTxt - dt
    end

    if love.keyboard.isDown("space") and self.tempo > 0 then
        self.tempo = 0
    end
    

    if self.tempo < 0 then
        self.alpha2 = self.alpha2 - dt * 0.3
        heroi:update(dt)

        for i=#caixas, 1, -1 do
            caixas[i]:update(dt)
        end

        if boss ~= nil then
            boss:update(dt)
        elseif boss == nil and self.delay_mudar_fase < 1 then
            self.delay_mudar_fase = self.delay_mudar_fase + dt
            self.alpha = self.alpha + dt
        else
            self.estado = 'finalizado'
        end

        for i=1, #inimigos do
            inimigos[i]:update(dt)
        end

        world:update(dt)

        -- Atualiza posicão dos personagens
        heroi.pos_real.x = heroi.collider:getX() - heroi.largura/2
        heroi.pos_real.y = heroi.collider:getY() - heroi.altura/1.2
        heroi.posicao = heroi.pos_real + Vector(heroi.largura/2, heroi.altura/2)

        for i=#inimigos, 1, -1 do
            inimigos[i].posicao.x = inimigos[i].collider:getX() - inimigos[i].largura/20
            inimigos[i].posicao.y = inimigos[i].collider:getY() - inimigos[i].altura/2.5
        end

        -- Camera
        if enfrentando_boss ~= true then
            cam:lookAt(heroi.posicao.x+200, bg.y+(bg.alt/2))
        end

        if cam.x < LARGURA_TELA/2 then
            cam.x = LARGURA_TELA/2
        end

        if cam.x > (bg.larg - LARGURA_TELA/2) then
            cam.x = (bg.larg - LARGURA_TELA/2)
        end

        if heroi.posicao.x >= 1600 then
            enfrentando_boss = true
            cam:lockX(2000, camera.smooth.linear(350))
            --cam:zoomTo(2)
        end
    end
end

function Fase1:draw()
    if self.alpha <= 1 then
        cam:attach()
        bg:draw()

        if boss ~= nil then
            boss:draw()
        end

        -- Todos os objetos e personagens do mapa
        local objetos_personagens_mapa = {}

        for i=#inimigos, 1, -1 do
            table.insert(objetos_personagens_mapa, inimigos[i])
        end

        for i=#caixas, 1, -1 do
            table.insert(objetos_personagens_mapa, caixas[i])
        end

        table.insert(objetos_personagens_mapa, heroi)

        bubblesort(objetos_personagens_mapa)

        for i=1, #objetos_personagens_mapa do
            objetos_personagens_mapa[i]:draw()
        end

        --world:draw()
        cam:detach()
        hud:draw()
    else
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", 0, 0, LARGURA_TELA, ALTURA_TELA)
        love.graphics.setColor(1, 1, 1)
    end

    if boss == nil and self.delay_mudar_fase < 1 then
        love.graphics.setColor(0, 0, 0, self.alpha)
        love.graphics.rectangle("fill", 0, 0, LARGURA_TELA, ALTURA_TELA)
        love.graphics.setColor(1, 1, 1, self.alpha)
    end

    if self.alpha2 > 0 then
        love.graphics.setColor(0, 0, 0, self.alpha2)
        love.graphics.rectangle("fill", 0, 0, LARGURA_TELA, ALTURA_TELA)
        love.graphics.setColor(1, 1, 1, self.alpha2)
    end

    font = love.graphics.setNewFont(30)
    love.graphics.setColor(1, 1, 1, self.alphaTxt)
    if self.tempo > 0 then
        font = love.graphics.setNewFont("materials/fonts/Melted-Monster.ttf", 40)
        love.graphics.printf("Capítulo 1: O despertar", 0, 30, 800, "center")
        font = love.graphics.setNewFont(30)
        love.graphics.printf("A ex-policial Luiza Inarcia acorda de um coma no hospital após um grave acidente na metalúrgica em que trabalhava."..
                            " Ao procurar ajuda dos profissionais do hospital, percebe que não há ninguém naquele andar... nem no resto edifício."..
                            " Ao olhar pela janela percebe uma estranha movimentação na rua. Descendo para o térreo encontra um policial morto junto com um rifle.",
                            100, 100, 600, "center")
        love.graphics.setColor(1, 1, 1, self.skipPulse)
        love.graphics.printf("Pressione ESPAÇO para pular", 100, 550, 600, "center")
        love.graphics.setColor(0, 0, 0, self.skipPulse)
    end
    font = love.graphics.setNewFont("materials/fonts/Melted-Monster.ttf", 40)
end
