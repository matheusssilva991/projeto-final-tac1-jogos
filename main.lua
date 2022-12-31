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
    require "classes/hud/fimdejogo"
    require "classes/hud/ajuda"
    require "classes/hud/ranking"

    require "classes/objetos/tiro"
    require "classes/objetos/caixa"

    require "classes/personagens/personagem"
    require "classes/personagens/inimigo"
    require "classes/personagens/boss"

    require "cenas/jogo"

    start_menu = Start()
    game_over = GameOver()
    ajuda = Ajuda()
    ranking = Ranking()

    jogo = Jogo()
    cena_atual = "menu_inicial"
end

function love.update(dt)
    if cena_atual == "menu_inicial" then
        start_menu:update(dt)
    elseif cena_atual == "jogo" then
        jogo:update(dt)
    elseif cena_atual == "game_over" then
        game_over:update(dt)
    elseif cena_atual == "ajuda" then
        ajuda:update(dt)
    elseif cena_atual == "ranking" then
        ranking:update(dt)
    end
end

function love.draw()
    if cena_atual == "menu_inicial" then
        start_menu:draw()
    elseif cena_atual == "jogo" then
        jogo:draw()
    elseif cena_atual == "game_over" then
        game_over:draw()
    elseif cena_atual == "ajuda" then
        ajuda:draw()
    elseif cena_atual == "ranking" then
        ranking:draw()
    end

    --jogo:draw()
    --love.graphics.print("FPS: ".. love.timer.getFPS(), 10, 10)
end

