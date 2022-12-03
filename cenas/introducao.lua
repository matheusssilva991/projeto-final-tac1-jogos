Introducao = Classe:extend()

function Introducao:new()
    self.imgPlanoFundo = imagem_introducao -- plano de fundo
    
    --dados da barra de carregamento
    self.x = 22 
    self.y = 432
    self.larguraMax=243
    self.altura = 2
    self.carregado = 0 -- percentual 0 a 100
    self.tempoCarregamento = 5 -- segundos
    self.tempoIniciarCarregamento = 1.5

    --sprite do pássaro voando
    self.imgAnimacao = imagem_animacao
    self.quadros = {}
    self.quadroAtual = 1
    --divide o sprite em três quadros
    for i=0, 2 do
        self.quadros[i+1] = love.graphics.newQuad((i)*34, 0, 34, 24, self.imgAnimacao:getDimensions())
    end
    self.quadros[#self.quadros+1] = love.graphics.newQuad(34, 0, 34, 24, self.imgAnimacao:getDimensions())--insere o sprite 2 no quadro 4
    
    som_entrada:play()
end

function Introducao:update(dt)
    self.tempoIniciarCarregamento = self.tempoIniciarCarregamento - dt
    
    fator = love.math.random(1, 30)
    if self.tempoIniciarCarregamento <= 0 then
        
        self.carregado = self.carregado + fator*1
        self.tempoIniciarCarregamento = .5
    end

    --se o carregamenta chegou a 100%
    if self.carregado > 100 then
        cenaAtual = "telaInicial"
    end

    self.quadroAtual = self.quadroAtual + 12*dt --animação em 6fps
    if self.quadroAtual >= #self.quadros+1 then
        self.quadroAtual = 1
    end
end

function Introducao:draw()
    love.graphics.draw(self.imgPlanoFundo)

    love.graphics.draw(self.imgAnimacao, self.quadros[math.floor(self.quadroAtual)], largura_tela/2-34/2, altura_tela/2-38)

    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", self.x, self.y, self.carregado*self.larguraMax/100, self.altura)
    love.graphics.setColor(1, 1, 1)
end