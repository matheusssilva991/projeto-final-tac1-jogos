Jogo = Classe:extend()

function Jogo:new()
    require "cenas/fase1"
    require "cenas/fase2"
    require "cenas/fase3"

    id_jogador = 1
    nivel_fase = 1
    trocou_fase = false
    tempo_jogo = 0
    fase = Fase1()
    tabela_ranking = {}
end

function Jogo:update(dt)
    fase:update(dt)
    tempo_jogo = tempo_jogo + dt

    if fase.estado == 'finalizado' then
        if nivel_fase < 3 then
            nivel_fase = nivel_fase + 1
            trocou_fase = true
        else
            table.insert(tabela_ranking, {nome='Jogador' .. id_jogador, tempo_jogo=tonumber(string.format("%.2f", tempo_jogo))})
        end
    end

    if nivel_fase == 2 and trocou_fase then
        trocou_fase = false
        fase = Fase2()  
    elseif nivel_fase == 3 and trocou_fase then
        trocou_fase = false
        fase = Fase3()
    else
        fase.estado = 'nao finalizado'
    end
end

function Jogo:draw()
    fase:draw()
    love.graphics.setColor(0, 0, 0)
    --love.graphics.print("tempo jogo: " .. math.floor(tempo_jogo), 10, 10)
    love.graphics.print("tempo jogo: " .. tonumber(string.format("%.2f", tempo_jogo)), 10, 10)
    love.graphics.setColor(1, 1, 1)
end

function verifica_colisao(A, raio_1, B, raio_2)
    if A.dist(A, B) <= raio_1 + raio_2 then
        return true
    end
    return false
end
