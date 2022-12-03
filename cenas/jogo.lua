Jogo = Classe:extend()

function Jogo:new()
    passaro = Passaro(imagem_passaro)

    tabelaCanos = {}
    tempoCanos = 1

    pontos = 0

    tabelaItens = {}
    tempoItens = 15
end

function Jogo:update(dt)
    passaro:update(dt)

    tempoCanos = tempoCanos - dt -- atualiza tempo dos canos
    tempoItens = tempoItens - dt -- atualiza tempo dos itens
    if tempoCanos <= 0 then
        local cano = Cano()

        table.insert(tabelaCanos, cano)
        tempoCanos = 1.5

        if tempoItens <= 0 then
            local item = Item(cano.xInf + cano.largura)

            table.insert(tabelaItens, item)
            tempoItens = 15
        end
    end

    --percorre tabela de canos
    for i=#tabelaCanos, 1, -1 do
        tabelaCanos[i]:update(dt)

        if verificaColisao(passaro, tabelaCanos[i]) then
            som_bateu:play()
            som_perdeu:play()
            cenaAtual = "fimDeJogo"
        end

        if tabelaCanos[i]:saiuDaTela() then
            pontos = pontos + 1
            som_ponto:play()
            table.remove(tabelaCanos, i) 
        end
    end
    
    --percorre tabela de itens
    for i=1, #tabelaItens do
        tabelaItens[i]:update(dt)   

        if passaro:verificaColisao(tabelaItens[i]) then
            passaro:mudaEnergia(20)
            som_item:play()
            table.remove(tabelaItens, i)
        else
            if tabelaItens[i]:saiuDaTela() then
                table.remove(tabelaItens, i)
            end
        end

    end
end

function Jogo:draw() 
    for i, cano in pairs(tabelaCanos) do
        cano:draw()
    end
    base:draw() 
    
    for i=1, #tabelaItens do
        tabelaItens[i]:draw()
    end

    passaro:draw()

    love.graphics.setFont(fonte_img)
    if math.floor(pontos/100) < 1 then
        love.graphics.print(string.format("%02d", pontos), largura_tela/2-30, 50)
    else
        love.graphics.print(math.min(pontos, 999), largura_tela/2-45, 50)
    end
end

--Colisão AABB especial por conta dos canos rotacionados
function verificaColisao(passaro, cano) 
    if passaro.x < cano.xSup and
    passaro.x + passaro.largura > cano.xSup - cano.largura and
    passaro.y < cano.ySup and --passaro.y < cano.ySup + cano.altura - cano.altura
    passaro.y + passaro.altura > cano.ySup - cano.altura then -- passaro.y + passaro.altura > cano.ySup
        return true
    elseif passaro.x < cano.xInf + cano.largura and
    passaro.x + passaro.largura > cano.xInf and
    passaro.y < cano.yInf + cano.altura and
    passaro.y + passaro.altura > cano.yInf then
        return true
    end
end