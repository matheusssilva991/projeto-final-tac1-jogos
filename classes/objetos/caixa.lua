Caixa = Classe:extend()

function Caixa:new(posicao)
    self.nome = 'caixa'
    self.img = love.graphics.newImage("materials/misc/caixa.png")
    self.larg = self.img:getWidth()
    self.alt = self.img:getHeight()

    self.larg_frame = self.larg/4
    self.alt_frame = self.alt/3

    self.posicao = posicao + Vector(50, 50)
    self.pos_real = posicao
    self.vida = 100
    self.raio = 38
    self.numero_tiros = 0
    self.acertou = true
    self.tempo_caixa = 0

    local grid = anim.newGrid(self.larg_frame, self.alt_frame, self.larg, self.alt)
    self.anim_zero_tiro = anim.newAnimation(grid('1-1', 1), 0.5)
    self.anim_um_tiro = anim.newAnimation(grid('1-4', 1), 0.5)
    self.anim_um_tiro_final = anim.newAnimation(grid('4-4', 1), 0.5)
    self.anim_dois_tiro = anim.newAnimation(grid('1-4', 2), 0.5)
    self.anim_dois_tiro_final = anim.newAnimation(grid('4-4', 2), 0.5)
    self.anim_tres_tiro = anim.newAnimation(grid('1-4', 3), 0.5)

    self.collider = world:newBSGRectangleCollider(self.pos_real.x+10, self.pos_real.y+60, self.larg_frame-20, self.alt_frame-70, 0)
    self.collider:setType('static')
end

function Caixa:update(dt)
    if self.numero_tiros == 0 then
        self.anim_zero_tiro:update(dt)
    elseif self.numero_tiros == 1 and self.acertou == true then
        self.tempo_caixa = self.tempo_caixa + dt
        self.anim_um_tiro:update(dt)

        if self.tempo_caixa > 0.15 then
            self.acertou = false
            self.tempo_caixa = 0
        end
    elseif self.numero_tiros == 1 and not self.acertou then
        self.anim_um_tiro_final:update(dt)
    elseif self.numero_tiros == 2 and self.acertou == true then
        self.tempo_caixa = self.tempo_caixa + dt
        self.anim_dois_tiro:update(dt)

        if self.tempo_caixa > 0.15 then
            self.acertou = false
            self.tempo_caixa = 0
        end
    elseif self.numero_tiros == 2 and not self.acertou then
        self.anim_dois_tiro_final:update(dt)
    elseif self.numero_tiros == 3 and self.acertou == true then
        self.anim_tres_tiro:update(dt)
    end
end

function Caixa:draw()
    if self.numero_tiros == 0 then
        self.anim_zero_tiro:draw(self.img, self.pos_real.x, self.pos_real.y)
    elseif self.numero_tiros == 1 and self.acertou == true then
        self.anim_um_tiro:draw(self.img, self.pos_real.x, self.pos_real.y)
    elseif self.numero_tiros == 1 and not self.acertou then
        self.anim_um_tiro_final:draw(self.img, self.pos_real.x, self.pos_real.y)
    elseif self.numero_tiros == 2 and self.acertou == true then
        self.anim_dois_tiro:draw(self.img, self.pos_real.x, self.pos_real.y)
    elseif self.numero_tiros == 2 and not self.acertou then
        self.anim_dois_tiro_final:draw(self.img, self.pos_real.x, self.pos_real.y)
    elseif self.numero_tiros == 3 and self.acertou == true then
        self.anim_tres_tiro:draw(self.img, self.pos_real.x, self.pos_real.y)
    elseif self.numero_tiros == 3 and not self.acertou then
        self.anim_tres_tiro_final:draw(self.img, self.pos_real.x, self.pos_real.y)
    end
    --love.graphics.circle("line", self.posicao.x, self.posicao.y, self.raio)
end
