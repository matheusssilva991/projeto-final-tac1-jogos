largura_tela, altura_tela = love.graphics.getDimensions()

require "_recursos"

--sorteia um dos três pássaros
local n = love.math.random(1,3)
    if n == 1 then
        imagem_passaro = imagem_passaro_azul
    elseif n == 2 then
        imagem_passaro = imagem_passaro_amarelo
    elseif n == 3 then
        imagem_passaro = imagem_passaro_vermelho
    else
end

function love.load()
    Classe = require "classes/classic"
    require "classes/passaro"
    require "classes/fundo"
    require "classes/cano"
    require "classes/item"
    ---
    require "cenas/introducao"
    require "cenas/jogo"
    require "cenas/telaInicial"
    require "cenas/fimDeJogo"
    require "_recursos"

    cenas = {}
    cenaAtual = "introducao"

    introducao = Introducao()
    jogo = Jogo()
    telaInicial = TelaInicial()
    fimDeJogo = FimDeJogo()

    cenas["introducao"] = introducao
    cenas["jogo"] = jogo
    cenas["telaInicial"] = telaInicial
    cenas["fimDeJogo"] = fimDeJogo

    --Dependendo do horário o background muda
    if tonumber(os.date("%H")) >= 6 and tonumber(os.date("%H")) < 18 then 
        fundo = Fundo(0, 0, imagem_fundo)
    else
        fundo = Fundo(0, 0, imagem_fundo_noite)
    end
    base = Fundo(0, 400, imagem_base, -120)
end

function love.update(dt)
    fundo:update(dt)
    base:update(dt)
    cenas[cenaAtual]:update(dt)
end

function love.draw()
    fundo:draw() 

    cenas[cenaAtual]:draw()
end

