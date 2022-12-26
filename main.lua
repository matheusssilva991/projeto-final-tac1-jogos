LARGURA_TELA, ALTURA_TELA = love.graphics.getDimensions()

Vector = require "classes/vector"

tipos_inimigos = {{vel = Vector(40, 40), pos = Vector(100, 500), dano=5, vida=100, op=1, vel_max=80, raio=150},
                  {vel = Vector(15, 15), pos = Vector(300, 400), dano=5, vida=100, op=2, vel_max=30, raio=100},
                  {vel = Vector(30, 30), pos = Vector(600, 300), dano=5, vida=100, op=3, vel_max=60, raio=120},
                  {vel = Vector(25, 25), pos = Vector(400, 100), dano=15, vida=100, op=4, vel_max=50, raio=100}}

function love.load()
    Classe = require "classes/classic"
    anim = require "classes/anim8"

    tiro = require "classes/personagens/tiro"
    personagem = require "classes/personagens/personagem"
    zumbi = require "classes/personagens/inimigo"
    chefao = require "classes/personagens/boss"

    heroi = Personagem(100, 300)
    inimigos = {Inimigo("inimigos", tipos_inimigos[1]),
                Inimigo("inimigos", tipos_inimigos[2]),
                Inimigo("inimigos", tipos_inimigos[3]),
                Inimigo("inimigos", tipos_inimigos[4])}

    boss = Boss("inimigos", tipos_inimigos[2])
end

function love.update(dt)
    heroi:update(dt)
    boss:update(dt)
    
    for i=1, #inimigos do
        inimigos[i]:update(dt)
    end

end

function love.draw()
    boss:draw()
    heroi:draw()
    
    for i=1, #inimigos do
        inimigos[i]:draw()
    end

    love.graphics.print("Vida: " .. heroi.vida, 10, 10)
end

function verifica_colisao(A, raio_1, B, raio_2)
    if A.dist(A, B) <= raio_1 + raio_2 then
        return true
    end
    return false
end


