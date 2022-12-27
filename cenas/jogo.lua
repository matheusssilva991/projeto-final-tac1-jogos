Jogo = Classe:extend()

function Jogo:new()
    require "cenas/fase1"
    require "cenas/fase2"
    require "cenas/fase3"

    nivel_fase = 1
    trocou_fase = false

    fase = Fase1()
end

function Jogo:update(dt)
    fase:update(dt)

    if fase.estado == 'finalizado' then
        nivel_fase = nivel_fase + 1
        trocou_fase = true
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
    love.graphics.print("estado: " .. fase.estado, 10, 10)
    love.graphics.print("nivel fase: " .. nivel_fase, 10, 40)
    love.graphics.setColor(1, 1, 1)
end

function verifica_colisao(A, raio_1, B, raio_2)
    if A.dist(A, B) <= raio_1 + raio_2 then
        return true
    end
    return false
end