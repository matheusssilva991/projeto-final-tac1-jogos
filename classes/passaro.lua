Passaro = Classe:extend()

function Passaro:new()
    self.img = imagem_passaro
    self.x, self.y = 50, altura_tela/2 - 60
    
    self.largura, self.altura = self.img:getDimensions()
    
    self.gravidade = 10
    self.velocidade = 0
    
    self.rotacao = 0
    
    self.imgBarraEnergia = imagem_barra_energia
    self.energia = 100 --percentual de energia inicial (100%)
end

function Passaro:update(dt)
    self:ficaNaTela()
    
    self.velocidade = self.velocidade + self.gravidade*1.5*dt
    
    if love.keyboard.isDown("space") then
        self:voar(dt)
        self.botaoPressionado = true
    else
        self.botaoPressionado = false
    end

    self.y = self.y + self.velocidade

    --faz o pássaro rotacionar
    self.rotacao = math.min(self.velocidade/4, 0.1)
    self.rotacao = math.max(self.rotacao, -0.1)
end

function Passaro:draw()
    love.graphics.draw(self.imgBarraEnergia, self.x-5, self.y-12)
    love.graphics.setColor(.2, 1, .2)
    love.graphics.rectangle("fill", self.x-3, self.y-10, 41*self.energia/100, 4)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.img, self.x, self.y, self.rotacao) -- imagem do pássaro
end

function Passaro:voar(dt)
    if self.energia > 0 and self.botaoPressionado == false then
        print(self.cont)
        som_asa:play()
        self:mudaEnergia(-.75)
        self.velocidade = -300*dt
    end
end

function Passaro:ficaNaTela()
    if self.y < 0 then
        self.y = 0
        self.velocidade = 0
    elseif self.y + self.altura > 400 then
        self.y = 400 - self.altura
        self.velocidade = 0
    end
end

function Passaro:mudaEnergia(valor)
    self.energia = math.max(self.energia+valor, 0) --não permite que a energia seja menor que zero
    self.energia = math.min(self.energia, 100) --não permite que a energia seja maior que 100
end

function Passaro:verificaColisao(e)
    if self.x < e.x + e.largura and
    self.x + self.largura > e.x and
    self.y < e.y + e.altura and
    self.y + self.altura > e.y then
        return true
    end
end