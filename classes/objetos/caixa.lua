Caixa = Classe:extend()

function Caixa:new(posicao)
    self.nome = 'caixa'
    self.img = love.graphics.newImage("materials/misc/caixa.png")
    self.larg = self.img:getWidth()
    self.alt = self.img:getHeight()

    self.larg_frame = self.larg/4
    self.alt_frame = self.alt/3

    self.posicao = posicao

    local grid = anim.newGrid(self.larg_frame, self.alt_frame, self.larg, self.alt)
    self.animation = anim.newAnimation(grid('1-4', 1, '1-4', 2, '1-4', 3), 0.1)

    self.collider = world:newBSGRectangleCollider(self.posicao.x+10, self.posicao.y+60, self.larg_frame-20, self.alt_frame-70, 0)
    self.collider:setType('static')
end

function Caixa:update(dt)
    self.animation:update(dt)
end

function Caixa:draw()
    self.animation:draw(self.img, self.posicao.x, self.posicao.y)
    love.graphics.circle("line", self.posicao.x+50, self.posicao.y+50, 5)
end
