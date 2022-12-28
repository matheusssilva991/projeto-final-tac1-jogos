Caixa = Classe:extend()

function Caixa:new()
    self.img = love.graphics.newImage("materials/misc/caixa.png")
    self.larg = self.img:getWidth()
    self.alt = self.img:getHeight()

    self.larg_frame = self.larg/4
    self.alt_frame = self.alt/3

    self.x = (LARGURA_TELA/2)-self.larg_frame/2
    self.y = (ALTURA_TELA/2)-self.alt_frame/2

    local grid = anim.newGrid(self.larg_frame, self.alt_frame, self.larg, self.alt)
    self.animation = anim.newAnimation(grid('1-4', 1, '1-4', 2, '1-4', 3), 0.1)

    self.collider = world:newBSGRectangleCollider(self.x+10, self.y+60, self.larg_frame-20, self.alt_frame-70, 0)
    self.collider:setType('static')
end

function Caixa:update(dt)
    self.animation:update(dt)
end

function Caixa:draw()
    self.animation:draw(self.img, self.x, self.y)
    --love.graphics.circle("line", self.x+50, self.y+50, 10)
end
