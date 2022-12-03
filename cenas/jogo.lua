Jogo = Classe:extend()

function Jogo:new()
end

function Jogo:update(dt)  
end

function Jogo:draw()   
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