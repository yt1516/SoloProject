import pygame
import pygame.gfxdraw
import time
import sys
import os
import numpy as np
from scipy.stats import norm
'''
Setup
'''
worldx=960
worldy=720
fps=60
ani = 101

BLUE  = (0,0,254)
BLACK = (23,23,23 )
WHITE = (254,254,254)
RED = (254,0,0)

pygame.init()
world=pygame.display.set_mode([worldx,worldy])
clock=pygame.time.Clock()
worldc=[700,250]
'''
Objects
'''

class Hand(pygame.sprite.Sprite):
    '''
    Spawn the hand
    '''
    def __init__(self):
        pygame.sprite.Sprite.__init__(self)
        self.image=pygame.Surface((100,100),pygame.SRCALPHA)
        self.size=10
        self.color=(254,254,254)
        pygame.gfxdraw.filled_circle(self.image, 50, 50, self.size, self.color)
        self.rect=self.image.get_rect()
        self.rect.center=worldc
        self.speedx=0
        self.speedy=0

    def rgb(self,minimum, maximum, value):
        minimum, maximum = float(minimum), float(maximum)
        ratio = 2 * (value-minimum) / (maximum - minimum)
        b = int(max(0, 254*(1 - ratio)))
        r = int(max(0, 254*(ratio - 1)))
        g = 254 - b - r
        return r, g, b

    def hit(self,pose,force):
        self.size=30
        self.color=self.rgb(0,100,force)
        # pygame.gfxdraw.filled_circle(self.image, 50, 50, 50, self.rgb(0,100,0)) # outer circle
        # c_nums=int(value)
        # rad_list=np.linspace(11,50,c_nums,dtype=int,endpoint=False)
        # val_list=np.linspace(0,value,c_nums,endpoint=False)
        # rad_list=list(rad_list)
        # rad_list=rad_list[::-1]
        # val_list=list(val_list)
        # val_inner=value
        # i=0
        # for i in range(len(val_list)):
        #     pygame.gfxdraw.filled_circle(self.image, 50, 50, rad_list[i], self.rgb(0,100,val_list[i]))
        #     i+=1
        #
        # pygame.gfxdraw.filled_circle(self.image, 50, 50, 10, self.rgb(0,100,value)) # innter circle
        # self.rect.center=pose

    def release(self):
        self.image=pygame.Surface((100, 100), pygame.SRCALPHA)
        self.size=10
        self.color=(254,254,254)

    def update(self):
        '''
        update position
        '''
        self.speedx = 0
        self.speedy = 0
        keystate = pygame.key.get_pressed()
        if keystate[pygame.K_LEFT]:
            self.speedx = -5
        if keystate[pygame.K_RIGHT]:
            self.speedx = 5
        if keystate[pygame.K_UP]:
            self.speedy = -5
        if keystate[pygame.K_DOWN]:
            self.speedy = 5

        self.rect.x += self.speedx
        self.rect.y += self.speedy
        if self.rect.right > worldx:
            self.rect.right = worldx
        if self.rect.left < 0:
            self.rect.left = 0
        if self.rect.bottom > worldy:
            self.rect.bottom = worldy
        if self.rect.top < 0:
            self.rect.top = 0

        pygame.gfxdraw.filled_circle(self.image, 50, 50, self.size, self.color)

    def press(self,color):
        '''
        pressing down
        '''
        self.image.fill(color)

    def getpose(self):
        return self.rect.center

class Face(pygame.sprite.Sprite):

    def __init__(self):
        pygame.sprite.Sprite.__init__(self)
        self.frame=0 # current frame
        self.images=[] # store all images
        self.force=0 # applied force
        self.df=0

        for i in range(0,101):
            img=pygame.image.load(os.path.join('faces',str(i)+'.png')).convert()
            img.convert_alpha()
            self.images.append(img)
            self.image=self.images[0]
            self.rect=self.image.get_rect()

    def palpate(self,loc,force): # when pressed
        self.force=force
        self.df=int(self.force/20)


    def update(self):
        if self.frame<self.force-self.df:
            self.frame+=self.df
            self.image = self.images[self.frame]
        elif self.frame>self.force+1:
            self.frame-=self.df
            self.image = self.images[self.frame]

    def reset(self):
        self.force=0

class Abdomen(pygame.sprite.Sprite):

    def __init__(self):
        pygame.sprite.Sprite.__init__(self)
        self.image=pygame.Surface((400,300),pygame.SRCALPHA)
        mu=200
        sigma=50
        x=np.linspace(0,400,400)
        y=norm.pdf(x,mu,sigma)
        y=1/max(y)*y
        y=list(y)
        mat=[]
        for i in range(0,300):
            mat.append(y)
        self.mat=mat
        for i in range(len(y)):
            pygame.gfxdraw.vline(self.image,i,0,300,self.rgb(0,100,100*y[i]))

        # self.image=pygame.Surface((400,300))
        # self.image.fill(BLUE)
        self.rect=self.image.get_rect()
        self.rect.center=worldc


    def get_sensitivity(self,pose):
        x=pose[0]
        y=pose[1]
        return self.mat[y][x]

    def rgb(self,minimum, maximum, value):
        minimum, maximum = float(minimum), float(maximum)
        ratio = 2 * (value-minimum) / (maximum - minimum)
        b = int(max(0, 254*(1 - ratio)))
        r = int(max(0, 254*(ratio - 1)))
        g = 254 - b - r
        return r, g, b



hand=Hand()
abdomen=Abdomen()
# impact=Impact()
face=Face()
face.rect.x=0
face.rect.y=0
hand_list=pygame.sprite.Group()
hand_list.add(face)
hand_list.add(abdomen)
# hand_list.add(impact)
hand_list.add(hand)

main = True
'''
Main Loop
'''
light=10
med=20
hard=30

while main:
    clock.tick(fps)
    for event in pygame.event.get():

        if event.type == pygame.QUIT:
            pygame.quit(); sys.exit()
            main = False
        elif event.type == pygame.KEYDOWN:
            if event.key==pygame.K_KP0:
                pose=hand.getpose()
                pose_abdomen=[pose[0]-500,pose[1]-100]
                sense=abdomen.get_sensitivity(pose_abdomen)
                force=int(light*(1+sense)*1.5)
                hand.hit(pose,force)
                face.palpate(pose,force)
            if event.key==pygame.K_KP1:
                pose=hand.getpose()
                pose_abdomen=[pose[0]-500,pose[1]-100]
                sense=abdomen.get_sensitivity(pose_abdomen)
                force=int(med*(1+sense)*1.5)
                hand.hit(pose,force)
                face.palpate(pose,force)
            if event.key==pygame.K_KP2:
                pose=hand.getpose()
                pose_abdomen=[pose[0]-500,pose[1]-100]
                sense=abdomen.get_sensitivity(pose_abdomen)
                force=int(hard*(1+sense)*1.5)
                hand.hit(pose,force)
                face.palpate(pose,force)

        elif event.type == pygame.KEYUP:
            if pygame.K_KP0 <= event.key <= pygame.K_KP9:
                # hand.press(BLACK)
                face.reset()
                hand.release()
                # impact.release()

    hand_list.update()

    world.fill(BLACK)
    hand_list.draw(world)
    pygame.display.flip()
