Fase1 = Classe:extend()

function Fase1:new()
    cam = camera()
    world = wf.newWorld(0, 0)

    bg = Background()
    hud = InGameHud()
    start_menu = Start()
    
    heroi = Personagem()
    caixa = Caixa()
    self.estado = 'nao finalizado'

    font = love.graphics.setNewFont("materials/fonts/Melted-Monster.ttf", 40)
    love.graphics.setBackgroundColor(0, 0.4, 0.4)
    --love.graphics.setBackgroundColor(0, 1, 0)

    -- Heroi - Personagem principal
    heroi = Personagem(140, 220)

    -- Zumbies normal
    tipos_inimigos = {{vel = Vector(40, 40), dano=5, vida=100, op=1, vel_max=80, raio=100},
                      {vel = Vector(30, 30), dano=5, vida=100, op=3, vel_max=60, raio=100},
                      {vel = Vector(25, 25), dano=15, vida=100, op=4, vel_max=50, raio=100}}

    inimigos = {Inimigo("inimigos", tipos_inimigos[1], Vector(400, 210)),
                Inimigo("inimigos", tipos_inimigos[2], Vector(70, 450)),
                Inimigo("inimigos", tipos_inimigos[3], Vector(700, 400)),
                Inimigo("inimigos", tipos_inimigos[3], Vector(1100, 167)),
                Inimigo("inimigos", tipos_inimigos[2], Vector(1381, 446)),
                Inimigo("inimigos", tipos_inimigos[1], Vector(1605, 157))}
                --Inimigo("inimigos", tipos_inimigos[4], Vector(420, 286))}

    -- Boss
    tipo_boss = {posicao=Vector(2325, 350), dano=20, dano_tiro=10, vida=1000, raio=70, raio_deteccao=450, op=2}
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
    if love.keyboard.isDown("x") then
        self.estado = 'finalizado'
    end

    heroi:update(dt)
    --caixa:update(dt)
    boss:update(dt)
    for i=1, #inimigos do
        inimigos[i]:update(dt)
    end

    world:update(dt)

    heroi.posicao.x = heroi.collider:getX() - heroi.largura/2
    heroi.posicao.y = heroi.collider:getY() - heroi.altura/1.2

    for i=#inimigos, 1, -1 do
        inimigos[i].posicao.x = inimigos[i].collider:getX() - inimigos[i].largura/20
        inimigos[i].posicao.y = inimigos[i].collider:getY() - inimigos[i].altura/2.5
    end

    -- Camera
    cam:lookAt(heroi.posicao.x+200, bg.y+(bg.alt/2))

    if cam.x < LARGURA_TELA/2 then
        cam.x = LARGURA_TELA/2
    end

    if cam.x > (bg.larg - LARGURA_TELA/2) then
        cam.x = (bg.larg - LARGURA_TELA/2)
    end
end

function Fase1:draw()
    cam:attach()
    bg:draw()

    boss:draw()

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
