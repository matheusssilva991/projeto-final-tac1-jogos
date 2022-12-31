Fase3 = Classe:extend()

function Fase3:new()
    cam = camera()
    world = wf.newWorld(0, 0)

    bg = Background("mapa_fase_3")
    hud = InGameHud()
    start_menu = Start()

    font = love.graphics.setNewFont("materials/fonts/Melted-Monster.ttf", 40)
    love.graphics.setBackgroundColor(0, 0.4, 0.4)
    
    -- Status Fase
    self.estado = 'nao finalizado'
    self.delay_mudar_fase = 0
    self.alpha = 0
    
    -- Heroi - Personagem principal
    heroi = Personagem(13.84, 500)
    enfrentando_boss = false

    -- Zumbies normal
    tipos_inimigos = {{vel = Vector(40, 40), dano=8, vida=100, op=1, vel_max=100, raio=100},
                      {vel = Vector(30, 30), dano=12, vida=100, op=3, vel_max=80, raio=100},
                      {vel = Vector(25, 25), dano=17, vida=100, op=4, vel_max=60, raio=100}}

    inimigos = {Inimigo("inimigos", tipos_inimigos[3], Vector(340, 157)),
                Inimigo("inimigos", tipos_inimigos[2], Vector(630, 157)),
                Inimigo("inimigos", tipos_inimigos[1], Vector(749, 420)),
                Inimigo("inimigos", tipos_inimigos[3], Vector(460, 300)),
                Inimigo("inimigos", tipos_inimigos[1], Vector(676, 300)),
                Inimigo("inimigos", tipos_inimigos[2], Vector(806, 241)),
                Inimigo("inimigos", tipos_inimigos[2], Vector(910, 396)),
                Inimigo("inimigos", tipos_inimigos[1], Vector(1168, 425)),
                Inimigo("inimigos", tipos_inimigos[1], Vector(1194, 352)),
                Inimigo("inimigos", tipos_inimigos[3], Vector(1500, 300)),
                Inimigo("inimigos", tipos_inimigos[3], Vector(1412, 207)),
                Inimigo("inimigos", tipos_inimigos[2], Vector(1534, 472)),
                Inimigo("inimigos", tipos_inimigos[1], Vector(1926, 426)),
                Inimigo("inimigos", tipos_inimigos[1], Vector(1859, 207))}

    -- Boss
    tipo_boss = {posicao=Vector(2325, 350), dano=20, dano_tiro=20, vida=1200, raio=70, raio_deteccao=200, vel=1300, vel_tiro=500, op=2}
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
end

function Fase3:update(dt)
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

function Fase3:draw()
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

    bubblesort_y(objetos_personagens_mapa)

    for i=1, #objetos_personagens_mapa do
        objetos_personagens_mapa[i]:draw()
    end

    --world:draw()
    cam:detach()
    hud:draw()

    if boss == nil and self.delay_mudar_fase < 1 then
        love.graphics.setColor(0, 0, 0, self.alpha)
        love.graphics.rectangle("fill", 0, 0, 2400, 600)
        love.graphics.setColor(1, 1, 1)
    end
end
