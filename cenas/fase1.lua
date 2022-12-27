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

    tipos_inimigos = {{vel = Vector(40, 40), dano=5, vida=100, op=1, vel_max=80, raio=150},
                      {vel = Vector(15, 15), dano=5, vida=100, op=2, vel_max=30, raio=100},
                      {vel = Vector(30, 30), dano=5, vida=100, op=3, vel_max=60, raio=120},
                      {vel = Vector(25, 25), dano=15, vida=100, op=4, vel_max=50, raio=100}}

    heroi = Personagem(140, 220)
    inimigos = {Inimigo("inimigos", tipos_inimigos[1], Vector(400, 210)),
                Inimigo("inimigos", tipos_inimigos[3], Vector(70, 450)),
                Inimigo("inimigos", tipos_inimigos[4], Vector(500, 400))}
                --Inimigo("inimigos", tipos_inimigos[4], Vector(420, 286))}

    boss = Boss("inimigos", tipos_inimigos[2])

    --DEFINE LIMITES DO MAPA
    local paredeEsq = world:newRectangleCollider(-10, 0, 10, 600)
    local paredeDir = world:newRectangleCollider(2400, 0, 10, 600)
    local paredeCima = world:newRectangleCollider(0, 0, 2400, 160)
    local paredeBaixo = world:newRectangleCollider(0, 520, 2400, 10)
    paredeEsq:setType('static')
    paredeDir:setType('static')
    paredeCima:setType('static')
    paredeBaixo:setType('static')

    --DEFINE COLISAO COM DECORACOES DO MAPA
    local planta1 = world:newRectangleCollider(55, 160, 35, 20)
    local planta2 = world:newRectangleCollider(281, 160, 35, 20)
    planta1:setType('static')
    planta2:setType('static')

    local colunasBanco1 = world:newRectangleCollider(1650, 160, 140, 20)
    local colunasBanco2 = world:newRectangleCollider(1900, 160, 140, 20)
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
    for i=1, #inimigos do
        inimigos[i]:draw()
    end

    if heroi.posicao.y > caixa.y then
        caixa:draw()
        heroi:draw()
    else
        heroi:draw()
        caixa:draw()
    end
    
    
    world:draw()
    
    cam:detach()
    hud:draw()
    --love.graphics.print("Vida heroi: " .. heroi.vida, 10, 40)
    --love.graphics.print("Vida Boss: " .. boss.vida, 10, 80)
    --love.graphics.print("Vida: " .. heroi.vida, 10, 10)
end
