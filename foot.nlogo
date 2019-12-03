breed [g1 g1-p]
breed [t1 t1-p]
breed [g2 g2-p]
breed [t2 t2-p]
breed [ball ballon]



globals [
score-blue
score-red
ballont1
ballont2
objt1
objt2
]

to setup
  clear-all
  dessiner-terrain
  set-default-shape turtles "person"
  create-g1 1 [ init-gardien red ]
  create-g2 1 [init-gardien blue]

  ifelse (tactique_rouge = "4-4-2") [

  create-t1 1 [ init-joueur red -50 30]
  create-t1 1 [ init-joueur red -55 10]
  create-t1 1 [ init-joueur red -55 -10]
  create-t1 1 [ init-joueur red -50 -30]
  create-t1 1 [ init-joueur red -11 45]
  create-t1 1 [ init-joueur red -30 15]
  create-t1 1 [ init-joueur red -30 -15]
  create-t1 1 [ init-joueur red -11 -45]
  create-t1 1 [ init-joueur red 0 5]
  create-t1 1 [ init-joueur red 0 0]
  ]
  [
  create-t1 1 [ init-joueur red -50 30]
  create-t1 1 [ init-joueur red -55 10]
  create-t1 1 [ init-joueur red -55 -10]
  create-t1 1 [ init-joueur red -50 -30]
  create-t1 1 [ init-joueur red -30 20]
  create-t1 1 [ init-joueur red -30 0]
  create-t1 1 [ init-joueur red -30 -20]
  create-t1 1 [ init-joueur red -15 35]
  create-t1 1 [ init-joueur red  0   0]
  create-t1 1 [ init-joueur red -15 -35]
  ]

 ifelse (tactique_bleu = "4-4-2") [
  create-t2 1 [ init-joueur blue 50 30]
  create-t2 1 [ init-joueur blue 55 10]
  create-t2 1 [ init-joueur blue 55 -10]
  create-t2 1 [ init-joueur blue 50 -30]
  create-t2 1 [ init-joueur blue 11 45]
  create-t2 1 [ init-joueur blue 30 15]
  create-t2 1 [ init-joueur blue 30 -15]
  create-t2 1 [ init-joueur blue 11 -45]
  create-t2 1 [ init-joueur blue 9 -8]
  create-t2 1 [ init-joueur blue 9 8]
  ]
  [

  create-t2 1 [ init-joueur blue 50 30]
  create-t2 1 [ init-joueur blue 55 10]
  create-t2 1 [ init-joueur blue 55 -10]
  create-t2 1 [ init-joueur blue 50 -30]
  create-t2 1 [ init-joueur blue 30 20]
  create-t2 1 [ init-joueur blue 30 0]
  create-t2 1 [ init-joueur blue 30 -20]
  create-t2 1 [ init-joueur blue 15 35]
  create-t2 1 [ init-joueur blue 12 0]
  create-t2 1 [ init-joueur blue 15 -35]


  ]
  create-ball 1 [init-ball]

  set ballont1 true
  set ballont2 false

  reset-ticks
end

to dessiner-terrain
  ask patches [set pcolor green]
  ask patches with [pxcor = max-pxcor or pxcor = min-pxcor
    or pxcor = 0 or pycor = max-pycor or pycor = min-pycor]
    [ set pcolor white ]
  ask patches with [distance patch 0 0 > 12 and distance patch 0 0 <= 13 ]
    [ set pcolor white ]
  ask patches with [distance patch max-pxcor max-pycor > 4 and distance patch max-pxcor max-pycor <= 5 ]
    [ set pcolor white ]
    ask patches with [ distance patch 0 0 <= 1]
    [ set pcolor white ]
  ask patches with [pxcor < min-pxcor + 32 and pycor = 30] [ set pcolor white]
  ask patches with [pxcor < min-pxcor + 32 and pycor = -30] [ set pcolor white]
  ask patches with [pxcor = min-pxcor + 32 and pycor >= -30 and pycor <= 30] [ set pcolor white]
  ask patches with [distance patch (min-pxcor + 32) 0 > 6 and distance patch (min-pxcor + 32) 0 <= 7 and pxcor > min-pxcor + 32] [ set pcolor white]

   ask patches with [pxcor > max-pxcor - 32 and pycor = 30] [ set pcolor white]
  ask patches with [pxcor > max-pxcor - 32 and pycor = -30] [ set pcolor white]
  ask patches with [pxcor = max-pxcor - 32 and pycor >= -30 and pycor <= 30] [ set pcolor white]
  ask patches with [distance patch (max-pxcor - 32) 0 > 6 and distance patch (max-pxcor - 32) 0 <= 7 and pxcor < max-pxcor - 32] [ set pcolor white]
  ask patches with [pxcor = min-pxcor and distance patch min-pxcor 0 < 9 and distance patch min-pxcor 0 > -9] [ set pcolor blue]
  ask patches with [pxcor = max-pxcor and distance patch max-pxcor 0 < 9 and distance patch max-pxcor 0 > -9] [ set pcolor red]


end



to init-joueur [coul coord-x coord-y]
  set color coul
  set size 3
  ;;set placement place
  setxy coord-x coord-y

end

to init-gardien [coul]
  set color coul
  set size 3
  ifelse (coul = red)
  [setxy min-pxcor 0]
  [setxy max-pxcor 0]
end

to init-ball
  set color black
  set shape "circle"
  set size 1
  setxy 0 0
end

to bougesansballon
  let proba random-float 1
  if (proba > 0.9)
  [rt random 10
  lt random 10
  fd 1]
end

to arretgardient2
   ask one-of g2 [
  let proba  random-float 1
  ifelse ( proba < 0.5 ) [
    facexy max-pxcor max-pycor
   fd 8]
   [
     facexy max-pxcor min-pycor
  fd 8]

   ]
end

to arretgardient1
   ask one-of g1 [
  let proba  random-float 1
  ifelse ( proba < 0.5 ) [
    facexy min-pxcor max-pycor
   fd 8]
   [
     facexy min-pxcor min-pycor
  fd 8]

   ]
end

to tirt2

  ask one-of ball
  [let proba random-float 1
  ifelse ( proba < 0.5 ) [ask one-of g1 [arretgardient1]
  facexy min-pxcor 8
   while [distancexy min-pxcor 8 > 1] [fd 1]]
  [
   ask one-of g1 [arretgardient1]
  facexy min-pxcor -8
   while [distancexy min-pxcor -8 > 1 ] [fd 1]]
    ask one-of g1 [
    ifelse (distance one-of ball <= 2) [
      passet1
      set ycor 0]
    [set score-blue score-blue + 1
      set ycor 0
      ifelse (tactique_rouge = "4-4-2") [
       ask t1-p 2 [
      set xcor -50
      set ycor 30
      ]
      ask t1-p 3 [
      set xcor -55
      set ycor 10
      ]
      ask t1-p 4 [
      set xcor -55
      set ycor -10
      ]
      ask t1-p 5 [
      set xcor -50
      set ycor -30
      ]
      ask t1-p 6 [
      set xcor -11
      set ycor 45
      ]
      ask t1-p 7 [
      set xcor -30
      set ycor 15
      ]
      ask t1-p 8 [
      set xcor -30
      set ycor -15
      ]
      ask t1-p 9 [
      set xcor -11
      set ycor -45
      ]
      ask t1-p 10 [
      set xcor 0
      set ycor 5
      ]
      ask t1-p 11 [
      set xcor 0
      set ycor 0
      ]
      ]
      [
        ask t1-p 2 [
      set xcor -50
      set ycor 30
      ]
      ask t1-p 3 [
      set xcor -55
      set ycor 10
      ]
      ask t1-p 4 [
      set xcor -55
      set ycor -10
      ]
      ask t1-p 5 [
      set xcor -50
      set ycor -30
      ]
      ask t1-p 6 [
      set xcor -30
      set ycor 20
      ]
      ask t1-p 7 [
      set xcor -30
      set ycor 0
      ]
      ask t1-p 8 [
      set xcor -30
      set ycor -20
      ]
      ask t1-p 9 [
      set xcor -15
      set ycor 35
      ]
      ask t1-p 10 [
      set xcor 0
      set ycor 0
      ]
      ask t1-p 11 [
      set xcor -15
      set ycor -35
      ]
      ]
      ifelse (tactique_bleu = "4-4-2") [
      ask t2-p 12 [
      set xcor 50
      set ycor 30
      ]
      ask t2-p 13 [
      set xcor 55
      set ycor 10
      ]
      ask t2-p 14 [
      set xcor 55
      set ycor -10
      ]
      ask t2-p 15 [
      set xcor 50
      set ycor -30
      ]
      ask t2-p 16 [
      set xcor 11
      set ycor 45
      ]
      ask t2-p 17 [
      set xcor 30
      set ycor 15
      ]
      ask t2-p 18 [
      set xcor 30
      set ycor -15
      ]
      ask t2-p 19 [
      set xcor 11
      set ycor -45
      ]
      ask t2-p 20 [
      set xcor 9
      set ycor 8
      ]
      ask t2-p 21 [
      set xcor -9
      set ycor -8
      ]
      ]
      [
        ask t2-p 12 [
      set xcor 50
      set ycor 30
      ]
      ask t2-p 13 [
      set xcor 55
      set ycor 10
      ]
      ask t2-p 14 [
      set xcor 55
      set ycor -10
      ]
      ask t2-p 15 [
      set xcor 50
      set ycor -30
      ]
      ask t2-p 16 [
      set xcor 30
      set ycor 20
      ]
      ask t2-p 17 [
      set xcor 30
      set ycor 0
      ]
      ask t2-p 18 [
      set xcor 30
      set ycor -20
      ]
      ask t2-p 19 [
      set xcor 15
      set ycor 35
      ]
      ask t2-p 20 [
      set xcor 10
      set ycor 0
      ]
      ask t2-p 21 [
      set xcor 15
      set ycor -35
      ]
      ]
      ask one-of ball [
      set xcor 0
      set ycor 0
      ]
      set ballont2 false
      set ballont1 true

    ]
  ]
  ]
end

to tirt1

  ask one-of ball
  [let proba random-float 1
  ifelse ( proba < 0.5 ) [ask one-of g2 [arretgardient2]
  facexy max-pxcor 8
   while [distancexy max-pxcor 8 > 1] [fd 1]]
  [
   ask one-of g2 [arretgardient2]
  facexy max-pxcor -8
   while [distancexy max-pxcor -8 > 1 ] [fd 1]]
  ]
  ask one-of g2 [
    ifelse (distance one-of ball <= 2) [
      passet2
      set ycor 0]
    [set score-red score-red + 1
      set ycor 0
            ifelse (tactique_rouge = "4-4-2") [
       ask t1-p 2 [
      set xcor -50
      set ycor 30
      ]
      ask t1-p 3 [
      set xcor -55
      set ycor 10
      ]
      ask t1-p 4 [
      set xcor -55
      set ycor -10
      ]
      ask t1-p 5 [
      set xcor -50
      set ycor -30
      ]
      ask t1-p 6 [
      set xcor -11
      set ycor 45
      ]
      ask t1-p 7 [
      set xcor -30
      set ycor 15
      ]
      ask t1-p 8 [
      set xcor -30
      set ycor -15
      ]
      ask t1-p 9 [
      set xcor -11
      set ycor -45
      ]
      ask t1-p 10 [
      set xcor -9
      set ycor 8
      ]
      ask t1-p 11 [
      set xcor -9
      set ycor -8
      ]
      ]
      [
        ask t1-p 2 [
      set xcor -50
      set ycor 30
      ]
      ask t1-p 3 [
      set xcor -55
      set ycor 10
      ]
      ask t1-p 4 [
      set xcor -55
      set ycor -10
      ]
      ask t1-p 5 [
      set xcor -50
      set ycor -30
      ]
      ask t1-p 6 [
      set xcor -30
      set ycor 20
      ]
      ask t1-p 7 [
      set xcor -30
      set ycor 0
      ]
      ask t1-p 8 [
      set xcor -30
      set ycor -20
      ]
      ask t1-p 9 [
      set xcor -15
      set ycor 35
      ]
      ask t1-p 10 [
      set xcor -12
      set ycor 0
      ]
      ask t1-p 11 [
      set xcor -15
      set ycor -35
      ]
      ]
      ifelse (tactique_bleu = "4-4-2") [
      ask t2-p 12 [
      set xcor 50
      set ycor 30
      ]
      ask t2-p 13 [
      set xcor 55
      set ycor 10
      ]
      ask t2-p 14 [
      set xcor 55
      set ycor -10
      ]
      ask t2-p 15 [
      set xcor 50
      set ycor -30
      ]
      ask t2-p 16 [
      set xcor 11
      set ycor 45
      ]
      ask t2-p 17 [
      set xcor 30
      set ycor 15
      ]
      ask t2-p 18 [
      set xcor 30
      set ycor -15
      ]
      ask t2-p 19 [
      set xcor 11
      set ycor -45
      ]
      ask t2-p 20 [
      set xcor 0
      set ycor 5
      ]
      ask t2-p 21 [
      set xcor 0
      set ycor 0
      ]
      ]
      [
        ask t2-p 12 [
      set xcor 50
      set ycor 30
      ]
      ask t2-p 13 [
      set xcor 55
      set ycor 10
      ]
      ask t2-p 14 [
      set xcor 55
      set ycor -10
      ]
      ask t2-p 15 [
      set xcor 50
      set ycor -30
      ]
      ask t2-p 16 [
      set xcor 30
      set ycor 20
      ]
      ask t2-p 17 [
      set xcor 30
      set ycor 0
      ]
      ask t2-p 18 [
      set xcor 30
      set ycor -20
      ]
      ask t2-p 19 [
      set xcor 15
      set ycor 35
      ]
      ask t2-p 20 [
      set xcor 0
      set ycor 0
      ]
      ask t2-p 21 [
      set xcor 15
      set ycor -35
      ]
      ]
      ask one-of ball [
      set xcor 0
      set ycor 0
      ]
      set ballont2 true
      set ballont1 false
      ]
  ]
end


to defendt2
  ask t2 [face one-of ball
  fd 2]
end

to defendt1
  ask t1 [face one-of ball
  fd 2]
end




to tac1bougesansballont11
  ifelse (ballont1) [
  facexy min-pxcor + 130 45
    fd 3
    bougesansballon

  ]
  [
  ifelse (distance (one-of ball) < 10 and xcor < 50 and ycor < 50 and 10 < ycor) [
  defendt1
  ]

  [facexy min-pxcor + 35 32
    fd 3
  ]
  ]
end

to tac1bougesansballont12
  ifelse (ballont1) [
    facexy min-pxcor + 105 10
    fd 3
    bougesansballon
  ]
  [ifelse (distance (one-of ball) < 10 and xcor < 25 and ycor < 25 and 0 < ycor) [
    defendt1
  ]
  [
    facexy min-pxcor + 30 10
    fd 2
  ]
  ]
end

to tac1bougesansballont13
  ifelse (ballont1) [
    facexy min-pxcor + 105 -10
    fd 3
    bougesansballon
  ]
  [
  ifelse ( distance (one-of ball) < 10 and xcor < 25 and ycor < 0 and -25 < ycor) [
    defendt1
  ]
  [facexy (min-pxcor + 30) -10
    fd 2
    bougesansballon
  ]
  ]
end

to tac1bougesansballont14
  ifelse (ballont1) [
  facexy min-pxcor + 130 -45
    fd 3
    bougesansballon

  ]
  [
  ifelse ( distance (one-of ball) < 10 and xcor < 50 and ycor < -10 and -50 < ycor) [
    defendt1
  ]
  [facexy min-pxcor + 35 -32
    fd 2

  ]
  ]
end

to tac1bougesansballont15
  ifelse (ballont1) [
    facexy min-pxcor + 180 35
    fd 3
  ]
  [ifelse ( distance (one-of ball) < 15 and xcor < 105 and ycor < 50 and 20 < ycor) [
    defendt1
  ]
  [
    facexy min-pxcor + 75 35
    fd 2

  ]
  ]
end

to tac1bougesansballont16
  ifelse (ballont1) [
    facexy min-pxcor + 150 10
    fd 3
  ]
  [ifelse ( distance (one-of ball) < 20 and xcor < 75 and ycor < 25 and 0 < ycor) [
  defendt1
  ]
  [facexy min-pxcor + 50 10
    fd 2

  ]
  ]
end

to tac1bougesansballont17
  ifelse (ballont1) [
    facexy min-pxcor + 150 -10
    fd 3
  ]
  [ifelse ( distance (one-of ball) < 20 and xcor < 75 and ycor < 0 and -25 < ycor) [
  defendt1
  ]
  [
    facexy min-pxcor + 50 -10
    fd 2

  ]
  ]
end

to tac1bougesansballont18
  ifelse (ballont1) [
    facexy min-pxcor + 180 -35
    fd 3
  ]
  [ifelse ( distance (one-of ball) < 15 and xcor < 105 and ycor < -20 and -50 < ycor) [
  defendt1
  ]
  [facexy min-pxcor + 75 -35
    fd 2

  ]
  ]
end

to tac1bougesansballont19
  ifelse (ballont1) [
    facexy min-pxcor + 190 10
    fd 3
  ]
  [ifelse ( distance (one-of ball) < 10 and xcor < 105 and ycor < 25 and 0 < ycor) [
  defendt1
  ]
  [facexy min-pxcor + 90 10
    fd 2
    bougesansballon
  ]
  ]
end

  to tac1bougesansballont110
    ifelse (ballont1) [
    facexy min-pxcor + 190 -10
    fd 3
  ]
  [ifelse ( distance (one-of ball) < 10 and xcor < 105 and ycor < 0 and -25 < ycor) [
  defendt1
  ]
  [facexy min-pxcor + 90 -10
    fd 2
    bougesansballon
  ]
  ]
end


to tac1bougesansballont21
   ifelse (ballont2) [
  facexy max-pxcor - 130 45
    fd 3
    bougesansballon

  ]
  [ifelse ( distance (one-of ball) < 10 and xcor > -50 and ycor < 50 and 10 < ycor) [
  defendt2
  ]

  [facexy max-pxcor - 35 32
    fd 2

  ]
  ]
end

to tac1bougesansballont22
  ifelse (ballont2) [
    facexy max-pxcor - 105 10
    fd 3
    bougesansballon
  ]
  [
  ifelse (distance (one-of ball) < 10 and xcor > -25 and (ycor < 25 and 0 < ycor)) [
    defendt2
  ]
  [
    facexy max-pxcor - 30 10
    fd 2

  ]
  ]
end

to tac1bougesansballont23
  ifelse (ballont2) [
    facexy max-pxcor - 105 -10
    fd 3
    bougesansballon
  ]
  [ifelse ( distance (one-of ball) < 10 and xcor > -25 and (ycor < 0 and -25 < ycor)) [
    defendt2
  ]
  [
    facexy max-pxcor - 30 -10
    fd 2

  ]
  ]
end

to tac1bougesansballont24
  ifelse (ballont2) [
  facexy max-pxcor - 130 -45
    fd 3
    bougesansballon

  ]
  [ifelse ( distance (one-of ball) < 10 and xcor > -50 and (ycor < -10 and -50 < ycor)) [
  defendt2
  ]

  [facexy max-pxcor - 35 -32
    fd 2

  ]
]
end

to tac1bougesansballont25
  ifelse (ballont2) [
    facexy max-pxcor - 180 35
    fd 3
  ]
  [ifelse ( distance (one-of ball) < 15 and xcor > -105 and ycor < 50 and 20 < ycor) [
    defendt2
  ]
  [
    facexy max-pxcor - 75 35
    fd 2

  ]
  ]
end

to tac1bougesansballont26
  ifelse (ballont2) [
    facexy max-pxcor - 150 10
    fd 3
  ]
  [ifelse ( distance (one-of ball) < 20 and xcor > -75 and (ycor < 25 and 0 < ycor)) [
  defendt2
  ]
  [facexy max-pxcor - 50 10
    fd 2

  ]
  ]
end


to tac1bougesansballont27
  ifelse (ballont2) [
    facexy max-pxcor - 150 -10
    fd 3
  ]
  [ifelse ( distance (one-of ball) < 20 and xcor > -75 and (ycor < 0 and -25 < ycor)) [
  defendt2
  ]
  [facexy max-pxcor - 50 -10
    fd 2

  ]
  ]
end

to tac1bougesansballont28
  ifelse (ballont2) [
    facexy max-pxcor - 180 -35
    fd 3
  ]
  [
  ifelse ( distance (one-of ball) < 15 and xcor > -105 and (ycor < -20 and -50 < ycor)) [
    defendt2
  ]
  [
    facexy max-pxcor - 75 -35
    fd 2

  ]
  ]
end

 to tac1bougesansballont29
   ifelse (ballont2) [
    facexy max-pxcor - 190 10
    fd 3
  ]
  [ifelse ( distance (one-of ball) < 10 and xcor > -105 and (ycor < 25 and 0 < ycor)) [
  defendt2
  ]
  [facexy max-pxcor - 90 10
    fd 2

  ]
  ]
end

  to tac1bougesansballont210
    ifelse (ballont2) [
    facexy max-pxcor - 190 -10
    fd 3
  ]
  [ifelse ( distance (one-of ball) < 10 and xcor > -105 and ycor < 0 and -25 < ycor) [
  defendt2
  ]
  [facexy max-pxcor - 90 -10
    fd 2

  ]
  ]
  end

to tac2bougesansballont11
  ifelse (ballont1) [
  facexy min-pxcor + 130 45
    fd 3
    bougesansballon

  ]
  [
  ifelse (distance (one-of ball) < 10 and xcor < 50 and ycor < 50 and 10 < ycor) [
  defendt1
  ]

  [facexy min-pxcor + 35 32
    fd 3
  ]
  ]
end

to tac2bougesansballont12
  ifelse (ballont1) [
    facexy min-pxcor + 105 10
    fd 3
    bougesansballon
  ]
  [ifelse (distance (one-of ball) < 10 and xcor < 25 and ycor < 25 and 0 < ycor) [
    defendt1
  ]
  [
    facexy min-pxcor + 30 10
    fd 2
  ]
  ]
end

to tac2bougesansballont13
  ifelse (ballont1) [
    facexy min-pxcor + 105 -10
    fd 3
    bougesansballon
  ]
  [
  ifelse ( distance (one-of ball) < 10 and xcor < 25 and ycor < 0 and -25 < ycor) [
    defendt1
  ]
  [facexy (min-pxcor + 30) -10
    fd 2
    bougesansballon
  ]
  ]
end

to tac2bougesansballont14
  ifelse (ballont1) [
  facexy min-pxcor + 130 -45
    fd 3
    bougesansballon

  ]
  [
  ifelse ( distance (one-of ball) < 10 and xcor < 50 and ycor < -10 and -50 < ycor) [
    defendt1
  ]
  [facexy min-pxcor + 35 -32
    fd 2

  ]
  ]
end

to tac2bougesansballont15
  ifelse (ballont1) [
    facexy min-pxcor + 150 20
    fd 3
  ]
  [ifelse ( distance (one-of ball) < 15 and xcor < 105 and ycor < 30 and 10 < ycor) [
    defendt1
  ]
  [
    facexy min-pxcor + 60 20
    fd 2

  ]
  ]
end

to tac2bougesansballont16
  ifelse (ballont1) [
    facexy min-pxcor + 140 0
    fd 3
  ]
  [ifelse ( distance (one-of ball) < 20 and xcor < 75 and ycor < 20 and -20 < ycor) [
  defendt1
  ]
  [facexy min-pxcor + 50 10
    fd 2

  ]
  ]
end

to tac2bougesansballont17
  ifelse (ballont1) [
    facexy min-pxcor + 150 -20
    fd 3
  ]
  [ifelse ( distance (one-of ball) < 15 and xcor < 75 and ycor < -10 and -30 < ycor) [
  defendt1
  ]
  [
    facexy min-pxcor + 50 -20
    fd 2

  ]
  ]
end

to tac2bougesansballont18
  ifelse (ballont1) [
    facexy min-pxcor + 180 -35
    fd 3
  ]
  [ifelse ( distance (one-of ball) < 15 and xcor < 105 and ycor < 50 and 10 < ycor) [
  defendt1
  ]
  [facexy min-pxcor + 75 35
    fd 2

  ]
  ]
end

to tac2bougesansballont19
  ifelse (ballont1) [
    facexy min-pxcor + 190 0
    fd 3
  ]
  [ifelse ( distance (one-of ball) < 10 and xcor < 105 and ycor < 15 and -15 < ycor) [
  defendt1
  ]
  [facexy min-pxcor + 90 0
    fd 2
    bougesansballon
  ]
  ]
end

  to tac2bougesansballont110
    ifelse (ballont1) [
    facexy min-pxcor + 180 -35
    fd 3
  ]
  [ifelse ( distance (one-of ball) < 10 and xcor < 105 and ycor < -10 and -50 < ycor) [
  defendt1
  ]
  [facexy min-pxcor + 75 -35
    fd 2
    bougesansballon
  ]
  ]
end


to tac2bougesansballont21
   ifelse (ballont2) [
  facexy max-pxcor - 130 45
    fd 3
    bougesansballon

  ]
  [ifelse ( distance (one-of ball) < 10 and xcor > -50 and ycor < 50 and 10 < ycor) [
  defendt2
  ]

  [facexy max-pxcor - 35 32
    fd 2

  ]
  ]
end

to tac2bougesansballont22
  ifelse (ballont2) [
    facexy max-pxcor - 105 10
    fd 3
    bougesansballon
  ]
  [
  ifelse (distance (one-of ball) < 10 and xcor > -25 and (ycor < 25 and 0 < ycor)) [
    defendt2
  ]
  [
    facexy max-pxcor - 30 10
    fd 2

  ]
  ]
end

to tac2bougesansballont23
  ifelse (ballont2) [
    facexy max-pxcor - 105 -10
    fd 3
    bougesansballon
  ]
  [ifelse ( distance (one-of ball) < 10 and xcor > -25 and (ycor < 0 and -25 < ycor)) [
    defendt2
  ]
  [
    facexy max-pxcor - 30 -10
    fd 2

  ]
  ]
end

to tac2bougesansballont24
  ifelse (ballont2) [
  facexy max-pxcor - 130 -45
    fd 3
    bougesansballon

  ]
  [ifelse ( distance (one-of ball) < 10 and xcor > -50 and (ycor < -10 and -50 < ycor)) [
  defendt2
  ]

  [facexy max-pxcor - 35 -32
    fd 2

  ]
]
end

to tac2bougesansballont25
  ifelse (ballont2) [
    facexy max-pxcor - 150 20
    fd 3
  ]
  [ifelse ( distance (one-of ball) < 15 and xcor > -105 and ycor < 30 and 10 < ycor) [
    defendt2
  ]
  [
    facexy max-pxcor - 75 35
    fd 2

  ]
  ]
end

to tac2bougesansballont26
  ifelse (ballont2) [
    facexy max-pxcor - 140 0
    fd 3
  ]
  [ifelse ( distance (one-of ball) < 20 and xcor > -75 and (ycor < 15 and -15 < ycor)) [
  defendt2
  ]
  [facexy max-pxcor - 50 10
    fd 2

  ]
  ]
end


to tac2bougesansballont27
  ifelse (ballont2) [
    facexy max-pxcor - 150 -20
    fd 3
  ]
  [ifelse ( distance (one-of ball) < 20 and xcor > -75 and (ycor < -10 and -30 < ycor)) [
  defendt2
  ]
  [facexy max-pxcor - 50 -10
    fd 2

  ]
  ]
end

to tac2bougesansballont28
  ifelse (ballont2) [
    facexy max-pxcor - 180 35
    fd 3
  ]
  [
  ifelse ( distance (one-of ball) < 15 and xcor > -105 and (ycor < 50 and 10 < ycor)) [
    defendt2
  ]
  [
    facexy max-pxcor - 75 35
    fd 2

  ]
  ]
end

 to tac2bougesansballont29
   ifelse (ballont2) [
    facexy max-pxcor - 190 0
    fd 3
  ]
  [ifelse ( distance (one-of ball) < 10 and xcor > -105 and (ycor < 15 and -15 < ycor)) [
  defendt2
  ]
  [facexy max-pxcor - 90 0
    fd 2

  ]
  ]
end

  to tac2bougesansballont210
    ifelse (ballont2) [
    facexy max-pxcor - 190 -35
    fd 3
  ]
  [ifelse ( distance (one-of ball) < 10 and xcor > -105 and ycor < -10 and -50 < ycor) [
  defendt2
  ]
  [facexy max-pxcor - 75 -35
    fd 2

  ]
  ]
  end






to dribblet1

  ifelse (xcor >= max-pxcor - 32 and (ycor < 30 and ycor > -30 ))[tirt1][
  ifelse (passe_rouge = "passe courte") [
    ifelse (distance(min-one-of t2 [distance myself] )> 3)
    [
    facexy max-pxcor 0
    fd 2
    ask one-of ball[facexy max-pxcor 0 fd 2]
  ]
    [
    set objt1 one-of t1
    ifelse (distance objt1 < 15)[
    passet1
    ]
[   ifelse (random-float 1 < .5)
    [rt 45
    fd 2
    ask ball[rt 45 fd 2] ]
  [
    lt 45
    fd 2
    ask ball[lt 45 fd 2]
  ] ]
  ]
    ]
    [
      ifelse (passe_rouge = "passe longue") [
        ifelse (distance(min-one-of t2 [distance myself] )> 3)
    [
    facexy max-pxcor 0
    fd 2
    ask one-of ball[facexy max-pxcor 0 fd 2]
  ]
    [
    set objt1 one-of t1
    ifelse (distance objt1 > 30)[
    passet1
    ]
[   ifelse (random-float 1 < .5)
    [rt 45
    fd 2
    ask ball[rt 45 fd 2] ]
  [
    lt 45
    fd 2
    ask ball[lt 45 fd 2]
  ] ]
  ]
    ]
   [
  let proba random-float 1
   ifelse (distance(min-one-of t2 [distance myself] )> 3)
  [
    facexy max-pxcor 0
    fd 2
    ask one-of ball[facexy max-pxcor 0 fd 2]
  ]
[
    ifelse (proba < 0.5) [
    ifelse (random-float 1 < .5)
    [rt 45
    fd 2
    ask ball[rt 45 fd 2] ]


  [
    lt 45
    fd 2
    ask ball[lt 45 fd 2]
  ] ]
  [
  set objt1 one-of t1
  passet1
  ]
]
  ]
  ]
  ]
end

to passet1


   ask one-of ball [
  face objt1
  while [distance (min-one-of t1 [distance myself]) > 1] [fd 1]]




end


to dribblet2
  ifelse (xcor <= min-pxcor + 32 and (ycor < 30 and ycor > -30 ))[tirt2][
  ifelse (passe_bleu = "passe courte") [
    ifelse (distance(min-one-of t1 [distance myself] )> 3)
    [
    facexy min-pxcor 0
    fd 2
    ask one-of ball[facexy min-pxcor 0 fd 2]
  ]
    [
    set objt2 one-of t2
    ifelse (distance objt2 < 15)[
    passet2
    ]
[   ifelse (random-float 1 < .5)
    [rt 45
    fd 2
    ask ball[rt 45 fd 2] ]
  [
    lt 45
    fd 2
    ask ball[lt 45 fd 2]
  ] ]
  ]
    ]
    [
      ifelse (passe_bleu = "passe longue") [
        ifelse (distance(min-one-of t1 [distance myself] )> 3)
    [
    facexy min-pxcor 0
    fd 2
    ask one-of ball[facexy min-pxcor 0 fd 2]
  ]
    [
    set objt2 one-of t2
    ifelse (distance objt2 > 30)[
    passet2
    ]
[   ifelse (random-float 1 < .5)
    [rt 45
    fd 2
    ask ball[rt 45 fd 2] ]
  [
    lt 45
    fd 2
    ask ball[lt 45 fd 2]
  ] ]
  ]
    ]
   [
  let proba random-float 1
   ifelse (distance(min-one-of t1 [distance myself] )> 3)
  [
    facexy min-pxcor 0
    fd 2
    ask one-of ball[facexy min-pxcor 0 fd 2]
  ]
[
    ifelse (proba < 0.5) [
    ifelse (random-float 1 < .5)
    [rt 45
    fd 2
    ask ball[rt 45 fd 2] ]


  [
    lt 45
    fd 2
    ask ball[lt 45 fd 2]
  ] ]
  [
    set objt2 one-of t2
  passet2
  ]
]
  ]
  ]
  ]
end

to passet2
ask one-of ball [

  face objt2
  while [distance (min-one-of t2 [distance myself]) > 1] [fd 1]]

end




  to go

    ask one-of ball [ifelse (distance (min-one-of t1 [distance myself]) > 3 and ballont1) [
        let joueur_prochet1 min-one-of t1 [distance myself]
          ask joueur_prochet1 [face one-of ball
            fd 2]]  [
            ifelse (distance (min-one-of t2 [distance myself]) > 3 and ballont2) [
              let joueur_prochet2 min-one-of t2 [distance myself]
          ask joueur_prochet2 [face one-of ball
            fd 2]
          ]
           [







    ifelse (tactique_rouge = "4-4-2") [

        ask t1-p 2 [ifelse (distance one-of ball <= 2) [
          dribblet1
          set ballont1  true
          set ballont2  false]
          [tac1bougesansballont11]]

        ask t1-p 3 [ifelse (distance one-of ball <= 2) [dribblet1
          set ballont1 true
          set ballont2 false]
          [tac1bougesansballont12]]
        ask t1-p 4 [ifelse (distance one-of ball <= 2) [dribblet1
          set ballont1 true
          set ballont2 false]
          [tac1bougesansballont13]]
        ask t1-p 5 [ifelse (distance one-of ball <= 2) [dribblet1
          set ballont1 true
          set ballont2 false]
          [tac1bougesansballont14]
          ]
        ask t1-p 6 [ifelse (distance one-of ball <= 2) [dribblet1
          set  ballont1 true
          set  ballont2 false]
          [tac1bougesansballont15]
          ]
        ask t1-p 7 [ifelse (distance one-of ball <= 2) [dribblet1
          set ballont1 true
          set ballont2 false]
          [tac1bougesansballont16]
          ]
        ask t1-p 8 [ifelse (distance one-of ball <= 2) [dribblet1
          set ballont1 true
          set ballont2 false]
          [tac1bougesansballont17]
          ]
        ask t1-p 9 [ifelse (distance one-of ball <= 2) [dribblet1
          set ballont1 true
          set ballont2 false]
          [tac1bougesansballont18]
          ]
        ask t1-p 10 [ifelse (distance one-of ball <= 2) [dribblet1
          set  ballont1 true
          set ballont2 false]
          [tac1bougesansballont19]
          ]
        ask t1-p 11 [ifelse (distance one-of ball <= 2) [dribblet1
         set ballont1 true
         set ballont2 false]
          [tac1bougesansballont110]
          ]
    ]

     [ask t1-p 2 [ifelse (distance one-of ball <= 2) [
          dribblet1
          set ballont1  true
          set ballont2  false]
          [tac2bougesansballont11]]
       ask t1-p 3 [ifelse (distance one-of ball <= 2) [dribblet1
          set ballont1 true
          set ballont2 false]
          [tac2bougesansballont12]]
        ask t1-p 4 [ifelse (distance one-of ball <= 2) [dribblet1
          set ballont1 true
          set ballont2 false]
          [tac2bougesansballont13]]
        ask t1-p 5 [ifelse (distance one-of ball <= 2) [dribblet1
          set ballont1 true
          set ballont2 false]
          [tac2bougesansballont14]
          ]
        ask t1-p 6 [ifelse (distance one-of ball <= 2) [dribblet1
          set  ballont1 true
          set  ballont2 false]
          [tac2bougesansballont15]
          ]
        ask t1-p 7 [ifelse (distance one-of ball <= 2) [dribblet1
          set ballont1 true
          set ballont2 false]
          [tac2bougesansballont16]
          ]
        ask t1-p 8 [ifelse (distance one-of ball <= 2) [dribblet1
          set ballont1 true
          set ballont2 false]
          [tac2bougesansballont17]
          ]
        ask t1-p 9 [ifelse (distance one-of ball <= 2) [dribblet1
          set ballont1 true
          set ballont2 false]
          [tac2bougesansballont18]
          ]
        ask t1-p 10 [ifelse (distance one-of ball <= 2) [dribblet1
          set  ballont1 true
          set ballont2 false]
          [tac2bougesansballont19]
          ]
        ask t1-p 11 [ifelse (distance one-of ball <= 2) [dribblet1
         set ballont1 true
         set ballont2 false]
          [tac2bougesansballont110]
          ]
     ]

    ifelse (tactique_bleu = "4-4-2") [


      ask t2-p 12 [ifelse (distance one-of ball <= 2) [dribblet2
         set ballont1 false
         set ballont2 true]
        [tac1bougesansballont21]
        ]
      ask t2-p 13 [ifelse (distance one-of ball <= 2) [dribblet2
          set ballont1 false
         set ballont2 true]
        [tac1bougesansballont22]
        ]
      ask t2-p 14 [ifelse (distance one-of ball <= 2) [dribblet2
          set ballont1 false
         set ballont2 true]
        [tac1bougesansballont23]
        ]
      ask t2-p 15 [ifelse (distance one-of ball <= 2) [dribblet2
          set ballont1 false
         set ballont2 true]
        [tac1bougesansballont24]
        ]
      ask t2-p 16 [ifelse (distance one-of ball <= 2) [dribblet2
          set ballont1 false
         set ballont2 true]
        [tac1bougesansballont25]
        ]
      ask t2-p 17 [ifelse (distance one-of ball <= 2) [dribblet2
          set ballont1 false
         set ballont2 true]
        [tac1bougesansballont26]
        ]
      ask t2-p 18 [ifelse (distance one-of ball <= 2) [dribblet2
          set ballont1 false
         set ballont2 true]
        [tac1bougesansballont27]
        ]
      ask t2-p 19 [ifelse (distance one-of ball <= 2) [dribblet2
          set ballont1 false
         set ballont2 true]
        [tac1bougesansballont28]
        ]
      ask t2-p 20 [ifelse (distance one-of ball <= 2) [dribblet2
          set ballont1 false
         set ballont2 true]
        [tac1bougesansballont29]
        ]
      ask t2-p 21 [ifelse (distance one-of ball <= 2) [dribblet2
          set ballont1 false
         set ballont2 true]
        [tac1bougesansballont210]
        ]
    ]

    [
      ask t2-p 12 [ifelse (distance one-of ball <= 2) [dribblet2
         set ballont1 false
         set ballont2 true]
        [tac2bougesansballont21]
        ]
      ask t2-p 13 [ifelse (distance one-of ball <= 2) [dribblet2
          set ballont1 false
         set ballont2 true]
        [tac2bougesansballont22]
        ]
      ask t2-p 14 [ifelse (distance one-of ball <= 2) [dribblet2
          set ballont1 false
         set ballont2 true]
        [tac2bougesansballont23]
        ]
      ask t2-p 15 [ifelse (distance one-of ball <= 2) [dribblet2
          set ballont1 false
         set ballont2 true]
        [tac2bougesansballont24]
        ]
      ask t2-p 16 [ifelse (distance one-of ball <= 2) [dribblet2
          set ballont1 false
         set ballont2 true]
        [tac2bougesansballont25]
        ]
      ask t2-p 17 [ifelse (distance one-of ball <= 2) [dribblet2
          set ballont1 false
         set ballont2 true]
        [tac2bougesansballont26]
        ]
      ask t2-p 18 [ifelse (distance one-of ball <= 2) [dribblet2
          set ballont1 false
         set ballont2 true]
        [tac2bougesansballont27]
        ]
      ask t2-p 19 [ifelse (distance one-of ball <= 2) [dribblet2
          set ballont1 false
         set ballont2 true]
        [tac2bougesansballont28]
        ]
      ask t2-p 20 [ifelse (distance one-of ball <= 2) [dribblet2
          set ballont1 false
         set ballont2 true]
        [tac2bougesansballont29]
        ]
      ask t2-p 21 [ifelse (distance one-of ball <= 2) [dribblet2
          set ballont1 false
         set ballont2 true]
        [tac2bougesansballont210]
        ]

      ]
            ]
    ]
    ]












end
@#$#@#$#@
GRAPHICS-WINDOW
211
11
1274
525
-1
-1
5.0
1
10
1
1
1
0
0
0
1
-105
105
-50
50
0
0
1
ticks
5.0

BUTTON
45
41
108
74
NIL
setup\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
131
132
194
165
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
39
242
177
287
tactique_bleu
tactique_bleu
"4-4-2" "4-3-3"
1

MONITOR
38
486
109
531
NIL
score-blue
17
1
11

MONITOR
127
484
193
529
NIL
score-red
17
1
11

CHOOSER
40
187
178
232
tactique_rouge
tactique_rouge
"4-4-2" "4-3-3"
0

CHOOSER
39
310
177
355
passe_rouge
passe_rouge
"passe courte" "passe longue" "aléatoire"
1

CHOOSER
40
383
178
428
passe_bleu
passe_bleu
"passe longue" "passe courte" "aléatoire"
1

@#$#@#$#@
## Explication

Mon programme est constitué de 2 fonctions principale. La fonction qui fait bouger le joueur sans le ballon et celle qui fait bouger le joueur avec les ballon.

La fonction qui fait bouger le joueur sans le ballon est individuelle à chaque joueur. Elle l'oblige à essayer de rester dans "sa zone" géographique du terrain et de défendre cette zone ou de l'attaquer.

La fonction dribble est commune à toutes les joueurs (voir ci-après) elle oblige le joueur à avancer vers le but quand il est libre et lorsqu'il est attaqué le joueur fait soit une passe soit un dribble.



## Idée d'améliorations

Afin d'améliorer le programme je pourrais écrire une fonction dribble individuelle à aux joueurs. Cela l'obligerait à attaquer et à rester dans sa zone du terrain. 
Elle permettrai d'éviter les regroupement de joueur au milieu du terrain.
Elle pourrait permettre également pourquoi pas de faire des centres lorsque le joueur qui est à l'aile arrive vers les "30 mètres". Mais je n'ai pas eu le temps ni le courage d'aller jusqu'à la car ça consiste juste à faire des copier coller de la fonction dribble et quelques conditions...

(Si vous souhaitez que j'aille plus loin je peux le faire!)

## Methode dribble

Surle principe la méthode dribble est appelé lorsqu'un joueur a la balle. Elle dit au joueur d'avancer s'il est libre vers le but, sinon de soit faire une passe soit dribbler. Si le mode est en "passe courte" le joueur va choisir aléatoirement un joueur de son équipe, il regarde s'il est proche. S'il l'est, il lui fait sinon il dribble. Le mode passe longue est basé sur le même principe sauf qu'il regarde si le joueur est loin pour lui faire la passe. Le mode aléatoire, le joueur fait une passe au hasard à un de ses co-équiper.

## Methode tacbougesansballon 

Elle permet de faire bouger les joueurs quand ils n'ont pas le ballon. Lorsque l'equipe du joueur a le ballon lui ne l'a pas. Le joueur va vers sa position "attaque". Lorsque l'equipe du joueur n'a pas le ballon et que le ballon est loin du joueur, le joueur va a sa position "défense". Lorsque le joueur a la balle proche de lui il va vers la balle pour défendre.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
