Fase2 = Classe:extend()

function Fase2:new()
    cam = camera()
    world = wf.newWorld(0, 0)

    bg = Background("mapa_fase_2")
    hud = InGameHud()
    start_menu = Start()
    
    caixa = Caixa()
    self.estado = 'nao finalizado'
    enfrentando_boss = false

    font = love.graphics.setNewFont("materials/fonts/Melted-Monster.ttf", 40)
    love.graphics.setBackgroundColor(0, 0.4, 0.4)

    -- Heroi - Personagem principal
    heroi = Personagem(13.84, 500)

    -- Zumbies normal
    tipos_inimigos = {{vel = Vector(40, 40), dano=8, vida=100, op=1, vel_max=100, raio=100},
                      {vel = Vector(30, 30), dano=12, vida=100, op=3, vel_max=80, raio=100},
                      {vel = Vector(25, 25), dano=17, vida=100, op=4, vel_max=60, raio=100}}

    inimigos = {Inimigo("inimigos", tipos_inimigos[1], Vector(340, 157)),
                Inimigo("inimigos", tipos_inimigos[2], Vector(530, 157)),
                Inimigo("inimigos", tipos_inimigos[3], Vector(700, 400)),
                Inimigo("inimigos", tipos_inimigos[2], Vector(345, 422)),
                Inimigo("inimigos", tipos_inimigos[3], Vector(460, 300)),
                Inimigo("inimigos", tipos_inimigos[1], Vector(676, 300)),
                Inimigo("inimigos", tipos_inimigos[2], Vector(806, 241)),
                Inimigo("inimigos", tipos_inimigos[2], Vector(910, 356)),
                Inimigo("inimigos", tipos_inimigos[1], Vector(1168, 425)),
                Inimigo("inimigos", tipos_inimigos[1], Vector(1194, 352)),
                Inimigo("inimigos", tipos_inimigos[3], Vector(1500, 300)),
                Inimigo("inimigos", tipos_inimigos[3], Vector(1412, 207)),
                Inimigo("inimigos", tipos_inimigos[2], Vector(1534, 472)),
                Inimigo("inimigos", tipos_inimigos[1], Vector(1859, 207))}

    -- Boss
    tipo_boss = {posicao=Vector(2325, 350), dano=30, dano_tiro=20, vida=1200, raio=70, raio_deteccao=200, vel=1000, vel_tiro=550, op=2}
    boss = Boss("inimigos", tipo_boss)

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

function Fase2:update(dt)
    heroi:update(dt)
    --caixa:update(dt)

    if boss ~= nil then
        boss:update(dt)
    else
        self.estado = 'finalizado'
    end

    for i=1, #inimigos do
        inimigos[i]:update(dt)
    end

    world:update(dt)

    -- Atualiza posicão dos personagens
    heroi.posicao.x = heroi.collider:getX() - heroi.largura/2
    heroi.posicao.y = heroi.collider:getY() - heroi.altura/1.2

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

function Fase2:draw()
    cam:attach()
    bg:draw()

    if boss ~= nil then
        boss:draw()
    end
    -- Desenha os inimigos que estão atrás da caixa
    for i=1, #inimigos do
        if inimigos[i].posicao.y <= caixa.y+50 then
            inimigos[i]:draw()
        end
    end

    if heroi.posicao.y > caixa.y then
        caixa:draw()
        heroi:draw()
    else
        heroi:draw()
        caixa:draw()
    end
    
    -- Desenha os inimigos que estão na frente da caixa
    for i=1, #inimigos do
        if inimigos[i].posicao.y > caixa.y+50 then
            inimigos[i]:draw()
        end
    end

    --world:draw()
    
    cam:detach()
    hud:draw()
    --love.graphics.print("Vida heroi: " .. heroi.vida, 10, 40)
    --love.graphics.print("Vida Boss: " .. boss.vida, 10, 80)
    --love.graphics.print("Vida: " .. heroi.vida, 10, 10)
end
