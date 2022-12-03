TelaInicial = Classe:extend()

function TelaInicial:new()
    passaro = Passaro()

    self.img = imagem_logo
    self.largura, self.altura = self.img:getDimensions()
    self.angulo = 0

    self.tempoComecar = .5
end

function TelaInicial:update(dt)
    self.angulo = self.angulo + 500*dt

    --faz o pássaro ficar flutuando
    passaro.y = math.sin(math.rad(self.angulo))
    passaro.y = passaro.y + 1
    passaro.y = passaro.y * 10

    passaro.y = passaro.y + 200

    self.tempoComecar = self.tempoComecar - dt
    if love.keyboard.isDown("space") and self.tempoComecar <=0 then
        self.tempoComecar = .5
        jogo:new()
        cenaAtual = "jogo"
    end
end

function TelaInicial:draw()
    base:draw() 
    
    passaro:draw()
    love.graphics.draw(self.img, largura_tela/2 - self.largura/2, 50)
end