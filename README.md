# Demon Team


![Demon Team image](http://douglaslamb.com/public/demon-team-20151223.jpg)

Demon Team is a two-player coop game wherein you and a friend shoot demons. It was written in Lua using the Löve framework https://love2d.org .

## How to run the game

1. Install [Löve] (https://love2d.org/wiki/Getting_Started)
2. Clone Demon Team `git clone https://github.com/douglaslamb/demon-team`
3. If you are on Mac or Win drag and drop the directory you just cloned onto the Löve application bundle. E.g., on Mac drag and drop the demon-team directory onto love.app in ~/Applications . If you are on Linux simply cd to the demon-team directory you just cloned and `love .` https://love2d.org/wiki/Getting_Started 

Or download the exectuables:
[Win] (https://s3-us-west-2.amazonaws.com/lamb-douglas-my-games/demon-team/demon-team-win.zip)
[Mac] (https://s3-us-west-2.amazonaws.com/lamb-douglas-my-games/demon-team/demon-team-mac.zip)

## How to play the game

Both players use one keyboard. Kill all the demons. Your health falls by itself at a constant rate. The demons drop health when they die. If one player dies you both lose. You cannot shoot and move at the same time.

Black:

a - left 

d - right 

w - up 

s - down 

v + (a or d or w or s) - shoot in that direction 


White: 

left - left 

right - right 

up - up 

down - down 

rshift + (left or right or up or down) - shoot in that direction

## Attributions

This software uses Lua, Löve https://love2d.org , middleclass (a Lua OOP library) https://github.com/kikito/middleclass , and HC (Lua collision detection) https://github.com/vrld/HC .
