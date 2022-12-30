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
    if heroi.vida > 0 then
        fase:update(dt)
        tempo_jogo = tempo_jogo + dt

        if fase.estado == 'finalizado' then
            if nivel_fase < 3 then
                nivel_fase = nivel_fase + 1
                trocou_fase = true
            else
                table.insert(tabela_ranking, {nome='Jogador' .. id_jogador, tempo_jogo=tonumber(string.format("%.2f", tempo_jogo))})
                id_jogador = id_jogador + 1
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
end

function Jogo:draw()
    fase:draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("tempo jogo: " .. tonumber(string.format("%.2f", tempo_jogo)), 10, 10)
    love.graphics.setColor(1, 1, 1)
end

function verifica_colisao(A, raio_1, B, raio_2)
    if A.dist(A, B) <= raio_1 + raio_2 then
        return true
    end
    return false
end

function swap(a, b, table)
    if table[a] == nil or table[b] == nil then
        return false
    end

    if table[a].nome == 'zumbi' and table[b].nome == 'caixa' then
        if table[a].posicao.y >= table[b].posicao.y+50 then
            table[a], table[b] = table[b], table[a]
            return true
        end
    elseif table[a].nome == 'caixa' and table[b].nome == 'zumbi' then
        if table[a].posicao.y+50 > table[b].posicao.y then
            table[a], table[b] = table[b], table[a]
            return true
        end
    elseif table[a].nome == 'heroi' and table[b].nome == 'caixa' then
        if table[a]:get_posicao_normalizada().y >= table[b].posicao.y+50 then
            table[a], table[b] = table[b], table[a]
            return true
        end   
    else 
        if table[a].posicao.y > table[b].posicao.y then
            table[a], table[b] = table[b], table[a]
            return true
        end
    end

    return false
end

function bubblesort(array)
    for i=1,table.maxn(array) do

        local ci = i
        ::redo::
        if swap(ci, ci+1, array) then
            ci = ci - 1
            goto redo
        end
    end
end
