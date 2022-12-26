Caixa = Classe:extend()

function Caixa:new()
    self.img = love.graphics.newImage("materials/misc/caixa.png")
    self.larg = self.img:getWidth()
    self.alt = self.img:getHeight()

    self.larg_frame = self.larg/2
    self.alt_frame = self.alt/2

    self.x = 0
    self.y = (ALTURA_TELA-self.alt)/2

    local grid = anim.newGrid(self.larg_frame, self.alt_frame, self.larg, self.alt)
    self.animation = anim.newAnimation(grid('1-2', 1, '1-2', 2), 0.1)

end

function Caixa:update(dt)
    self.animation:update(dt)
end

function Caixa:draw()
    self.animation:draw(self.img, (LARGURA_TELA/2)-self.larg_frame/2, (ALTURA_TELA/2)-self.alt_frame/2)
end