LARGURA_TELA, ALTURA_TELA = love.graphics.getDimensions()

function love.load()
    Classe = require "classes/classic"
    Vector = require "classes/vector"
    camera = require "classes/camera"
    anim = require "classes/anim8"
    wf = require "classes/windfield"
    
    require "classes/hud/background"
    require "classes/hud/startmenu"
    require "classes/hud/ingamehud"

    require "classes/objetos/tiro"
    require "classes/objetos/caixa"

    require "classes/personagens/personagem"
    require "classes/personagens/inimigo"
    require "classes/personagens/boss"

    require "cenas/jogo"

    jogo = Jogo()
end

function love.update(dt)
    jogo:update(dt)
end

function love.draw()
    jogo:draw()
    --love.graphics.print("FPS: ".. love.timer.getFPS(), 10, 10)
end

