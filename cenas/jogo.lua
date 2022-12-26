Jogo = Classe:extend()

function Jogo:new()
    cam = camera()

    bg = Background()
    hud = InGameHud()
    start_menu = Start()
    
    heroi = Personagem()
    caixa = Caixa()

    font = love.graphics.setNewFont("materials/fonts/Melted-Monster.ttf", 40)
    love.graphics.setBackgroundColor(0, 0.4, 0.4)
    --love.graphics.setBackgroundColor(0, 1, 0)

    tipos_inimigos = {{vel = Vector(40, 40), pos = Vector(-800, 200), dano=5, vida=100, op=1, vel_max=80, raio=150},
                      {vel = Vector(15, 15), pos = Vector(-800, 300), dano=5, vida=100, op=2, vel_max=30, raio=100},
                      {vel = Vector(30, 30), pos = Vector(-800, 400), dano=5, vida=100, op=3, vel_max=60, raio=120},
                      {vel = Vector(25, 25), pos = Vector(-800, 400), dano=15, vida=100, op=4, vel_max=50, raio=100}}

    heroi = Personagem(1600, 300)
    inimigos = {Inimigo("inimigos", tipos_inimigos[1]),
                Inimigo("inimigos", tipos_inimigos[2]),
                Inimigo("inimigos", tipos_inimigos[3]),
                Inimigo("inimigos", tipos_inimigos[4])}

    boss = Boss("inimigos", tipos_inimigos[2])
end

function Jogo:update(dt)
    heroi:update(dt)
    --caixa:update(dt)
    boss:update(dt)
    --[[ for i=1, #inimigos do
        inimigos[i]:update(dt)
    end ]]

    cam:lookAt(heroi.posicao.x+200, bg.y+(bg.alt/2))

    if cam.x < LARGURA_TELA/2 then
        cam.x = LARGURA_TELA/2
    end

    if cam.x > (bg.larg - LARGURA_TELA/2) then
        cam.x = (bg.larg - LARGURA_TELA/2)
    end
end

function Jogo:draw()
    cam:attach()
    bg:draw()
    --caixa:draw()
    heroi:draw()
    boss:draw()
    --[[ for i=1, #inimigos do
        inimigos[i]:draw()
    end ]]
    cam:detach()
    hud:draw()

    love.graphics.print("Vida: " .. heroi.vida, 10, 10)
end

function verifica_colisao(A, raio_1, B, raio_2)
    if A.dist(A, B) <= raio_1 + raio_2 then
        return true
    end
    return false
end