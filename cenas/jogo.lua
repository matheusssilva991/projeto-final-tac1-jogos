Jogo = Classe:extend()

function Jogo:new()
    require "cenas/fase1"
    require "cenas/fase2"
    require "cenas/fase3"

    estado_pause = "false"

    nivel_fase = 1
    trocou_fase = false
    tempo_jogo = 0
    fase = Fase1()
    delay_morte = 0

    som_ambiente = love.audio.newSource("/materials/audio/terror-ambience-7003.mp3", "stream")
    som_ambiente:setVolume(0.02)
    som_ambiente:play()
end

function Jogo:update(dt)

    if estado_pause == "true" then
        pause:update(dt)
    end

    if estado_pause == "false" then
        if delay_morte <= 0.6 then
            fase:update(dt)

            if fase.tempo <= 0 and boss ~= nil then
                tempo_jogo = tempo_jogo + dt
            end

            if fase.estado == 'finalizado' then
                if nivel_fase < 3 then
                    nivel_fase = nivel_fase + 1
                    trocou_fase = true
                elseif nivel_fase >= 3 then
                    table.insert(tabela_ranking, {nome='Jogador ' .. id_jogador, tempo_jogo=tonumber(string.format("%.2f", tempo_jogo))})
                    id_jogador = id_jogador + 1
                    cena_atual = "game_over"
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
        elseif delay_morte > 0.6 and delay_morte < 1.2 then
            if self.estado_anterior == 'morrendo_esq' then
                heroi.estado = 'morrendo_esq_final'
            elseif self.estado_anterior == 'morrendo_dir' then
                heroi.estado = 'morrendo_dir_final'
            end
        else
            cena_atual = "game_over"
            delay_morte = 0
        end
    end

    if heroi.vida <= 0 then
        delay_morte = delay_morte + dt
    end
end

function Jogo:draw()
    fase:draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.setColor(1, 1, 1)

    if fase.tempo <= 0 then
        love.graphics.setColor(0, 0, 0)
        love.graphics.print("tempo: " .. tonumber(string.format("%.2f", tempo_jogo)), 20, 10)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("tempo: " .. tonumber(string.format("%.2f", tempo_jogo)), 22, 12)
    end

    pause:draw()
end

function love.keypressed(key)
    if key == "escape" and estado_pause == "false" then
        estado_pause = "true"
    elseif key == "escape" and estado_pause == "true" then
        estado_pause = "false"
    end
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
        if table[a].posicao.y >= table[b].posicao.y then
            table[a], table[b] = table[b], table[a]
            return true
        end
    elseif table[a].nome == 'caixa' and table[b].nome == 'zumbi' then
        if table[a].posicao.y > table[b].posicao.y then
            table[a], table[b] = table[b], table[a]
            return true
        end
    elseif table[a].nome == 'heroi' and table[b].nome == 'caixa' then
        if table[a].posicao.y >= table[b].posicao.y then
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

function sort_posicao_x(obj)
    table.sort(obj, function(k1, k2) return k1.posicao.x < k2.posicao.x end)
end

function sort_ranking(obj) 
    table.sort(obj, function(k1, k2) return k1.tempo_jogo < k2.tempo_jogo end)
end
