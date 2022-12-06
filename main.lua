LARGURA_TELA, ALTURA_TELA = love.graphics.getDimensions()

Vector = require "classes/vector"

tipos_inimigos = {{vel = Vector(40, 40), pos = Vector(700, 50), dano=5, vida=100, op=1, vel_max=80, raio=150},
                  {vel = Vector(15, 15), pos = Vector(300, 300), dano=20, vida=400, op=2, vel_max=30, raio=100},
                  {vel = Vector(30, 30), pos = Vector(500, 400), dano=10, vida=200, op=3, vel_max=60, raio=120},
                  {vel = Vector(25, 25), pos = Vector(500, 500), dano=15, vida=300, op=4, vel_max=50, raio=60}}

function love.load()
    Classe = require "classes/classic"
    anim = require "classes/anim8"

    tiro = require "classes/personagens/tiro"
    personagem = require "classes/personagens/personagem"
    zumbi = require "classes/personagens/inimigo"

    heroi = Personagem(100, 100)
    inimigos = {Inimigo("inimigos", tipos_inimigos[1]),
                Inimigo("inimigos", tipos_inimigos[2]),
                Inimigo("inimigos", tipos_inimigos[3])}
end

function love.update(dt)
    heroi:update(dt)
    
    for i=1, #inimigos do
        inimigos[i]:update(dt)
    end
end

function love.draw()
    heroi:draw()
    for i=1, #inimigos do
        inimigos[i]:draw()
    end
end

