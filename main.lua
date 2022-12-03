LARGURA_TELA, ALTURA_TELA = love.graphics.getDimensions()

function love.load()
    Classe = require "classes/classic"
    Vector = require "classes/vector"
    anim = require "classes/anim8"

    personagem = require "classes/personagens/personagem"

    heroi = Personagem(100, 100)

end

function love.update(dt)
    heroi:update(dt)
end

function love.draw()
    heroi:draw()
end

