globals [
  ;; prestatges
  queue-prestatges-pxcor
  queue-prestatges-pycor

  ;; peix
  queue-peix
  queue-peix-pxcor
  queue-peix-pycor

  ;; forn
  queue-forn
  queue-forn-pxcor
  queue-forn-pycor

  ;; carn
  queue-carn
  queue-carn-pxcor
  queue-carn-pycor

  ;; fruita
  queue-fruita
  queue-fruita-pxcor
  queue-fruita-pycor

  ;; caixes
  queue-caixes
  queue-caixes-pxcor
  queue-caixes-pycor

  ;; Other
  starting-point
  margin-between-zones
  client-cd
  cur-turt
  size-queue
]

breed [treballadors treballador] ;;Treballadors. Són un actius
breed [clients client]           ;;Clients, passius

treballadors-own [
  serving-time
  serving-time-margin
  serving-cd
  serving-client
]

clients-own [
  visited-carn
  visited-peix
  visited-forn
  visited-fruita
  visited-prestatges
  visited-caixes
  prestatges-cd
]

;; Setup
to setup
  clear-all
  set margin-between-zones 5
  set starting-point (min-pxcor + margin-between-zones - 1)
  set client-cd temps-entrada + random marge-temps-entrada
  set size-queue margin-between-zones
  setup-prestatges
  setup-fruita
  setup-forn
  setup-peix
  setup-carn
  setup-caixes

  reset-timer
  reset-ticks
end

to setup-prestatges
  set queue-prestatges-pxcor starting-point
  set queue-prestatges-pycor 0
  setup-zona "prestages" 0 (yellow - 2) 0 temps-prestatges marge-temps-prestatges
end

to setup-fruita
  set queue-fruita []
  set queue-fruita-pxcor starting-point
  set queue-fruita-pycor 10
  setup-zona "fruita" num-treb-fruita (blue - 2) 10 temps-fruita marge-temps-fruita
end

to setup-forn
  set queue-forn []
  set queue-forn-pxcor starting-point
  set queue-forn-pycor 5
  setup-zona "forn" num-treb-forn green - 2 5 temps-forn marge-temps-forn
end

to setup-peix
  set queue-peix []
  set queue-peix-pxcor starting-point
  set queue-peix-pycor 0
  setup-zona "peix" num-treb-peix red - 2 0 temps-peix marge-temps-peix
end

to setup-carn
  set queue-carn []
  set queue-carn-pxcor starting-point
  set queue-carn-pycor -5
  setup-zona "carn" num-treb-carn white - 2 -5 temps-carn marge-temps-carn
end

to setup-caixes
  set queue-caixes []
  set queue-caixes-pxcor starting-point
  set queue-caixes-pycor -15
  setup-zona "caixes" num-treb-caixes red - 2 -15 temps-caixes marge-temps-caixes
end

to setup-zona [name n col ycoord t t-margin]
  let zona-pxcor starting-point
  set starting-point starting-point + margin-between-zones

  ask patches with [zona-pxcor = pxcor] [set pcolor col]
  ask patches with [pycor = ycoord and pxcor < zona-pxcor and pxcor > (zona-pxcor - size-queue)] [set pcolor turquoise]

  ask n-of n patches with [zona-pxcor = pxcor]
  [
    sprout-treballadors 1 [
      set label name
      set color white
      set shape "person"
      set size 2
      setxy zona-pxcor pycor
      set serving-time t
      set serving-time-margin t-margin
      set serving-cd t + random t-margin
      set serving-client -1
    ]
  ]
end

;; GO
to go
  set client-cd (client-cd - 1)
  if client-cd = 0
  [
    client-new
    set client-cd temps-entrada + random marge-temps-entrada
  ]

  ask clients with [prestatges-cd > 0]
  [
    set prestatges-cd (prestatges-cd - 1)
    if prestatges-cd = 0
    [
      move-client who
    ]
  ]

  ask treballadors
  [
    set serving-cd (serving-cd - 1)
    if serving-cd = 0
    [
      set serving-cd serving-time + random serving-time-margin
      if client serving-client != nobody
      [
        move-client serving-client
      ]

      ifelse label = "fruita"
      [
        if length queue-fruita > 0
        [
          set serving-client first queue-fruita
          set queue-fruita bf queue-fruita
          move-queue queue-fruita-pxcor queue-fruita-pycor
        ]
      ]
      [
        ifelse label = "forn"
        [
          if length queue-forn > 0
          [
            set serving-client first queue-forn
            set queue-forn bf queue-forn
            move-queue queue-forn-pxcor queue-forn-pycor
          ]
        ]
        [
          ifelse label = "peix"
          [
            if length queue-peix > 0
            [
              set serving-client first queue-peix
              set queue-peix bf queue-peix
              move-queue queue-peix-pxcor queue-peix-pycor
            ]
          ]
          [
            ifelse label = "carn"
            [
              if length queue-carn > 0
              [
                set serving-client first queue-carn
                set queue-carn bf queue-carn
                move-queue queue-carn-pxcor queue-carn-pycor
              ]
            ]
            [
              if label = "caixes"
              [
                if length queue-caixes > 0
                [
                  set serving-client first queue-caixes
                  set queue-caixes bf queue-caixes
                  move-queue queue-caixes-pxcor queue-caixes-pycor
                ]
              ]
            ]
          ]
        ]
      ]
    ]
  ]
  tick
end

to client-new
  print "New client arrived"
  create-clients 1 [
      set color black
      set shape "person"
      set size 1
      set visited-carn false
      set visited-peix false
      set visited-forn false
      set visited-fruita false
      set visited-prestatges false
      set visited-caixes false
      set prestatges-cd 0
      rt 90
      move-client who
  ]
end

to move-client [clt]
  print "Moving client"
  ask client clt
  [
    ifelse not visited-prestatges
    [
      set prestatges-cd temps-prestatges + random marge-temps-prestatges
      set visited-prestatges true
      add-to-queue clt queue-prestatges-pxcor queue-prestatges-pycor
    ]
    [
      ifelse not visited-fruita
      [
        set queue-fruita lput clt queue-fruita
        set visited-fruita true
        add-to-queue clt queue-fruita-pxcor queue-fruita-pycor
      ]
      [
        ifelse not visited-forn
        [
          set queue-forn lput clt queue-forn
          set visited-forn true
          add-to-queue clt queue-forn-pxcor queue-forn-pycor
        ]
        [
          ifelse not visited-carn
          [
            set queue-carn lput clt queue-carn
            set visited-carn true
            add-to-queue clt queue-carn-pxcor queue-carn-pycor
          ]
          [
            ifelse not visited-peix
            [
              set queue-peix lput clt queue-peix
              set visited-peix true
              add-to-queue clt queue-peix-pxcor queue-peix-pycor
            ]
            [
              ifelse not visited-caixes
              [
                set queue-caixes lput clt queue-caixes
                set visited-caixes true
                add-to-queue clt queue-caixes-pxcor queue-caixes-pycor
              ]
              [
                die
              ]
            ]
          ]
        ]
      ]
    ]
  ]
end

to add-to-queue [clt pxfirst pyfirst]
  let patch-list sort patches with [pycor = pyfirst and pxcor < pxfirst and pxcor > pxfirst - size-queue]
  foreach patch-list [
    ask ?
    [
      let pxnew pxcor
      if not any? (clients-on self)
      [
        ask client clt [
          setxy pxnew pyfirst
        ]
        stop
      ]
    ]
  ]
end

to move-queue [pxfirst pyfirst]
  let patch-list sort patches with [pycor = pyfirst and pxcor < pxfirst and pxcor > pxfirst - size-queue]
  foreach patch-list [
    ask ?
    [
      let pxnew pxcor + 1
      ask clients-on self [
        if not any? clients-on patch-ahead 1 [setxy pxnew pyfirst]
      ]
    ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
99
10
564
470
17
16
13.0
1
10
1
1
1
0
1
1
1
-17
17
-16
16
0
0
1
ticks
30.0

BUTTON
9
10
83
43
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
1097
91
1329
124
num-treb-carn
num-treb-carn
1
10
1
1
1
persones
HORIZONTAL

SLIDER
1101
256
1333
289
num-treb-fruita
num-treb-fruita
1
10
1
1
1
persones
HORIZONTAL

SLIDER
1350
91
1584
124
num-treb-peix
num-treb-peix
1
10
4
1
1
persones
HORIZONTAL

SLIDER
1349
255
1581
288
num-treb-forn
num-treb-forn
1
10
4
1
1
persones
HORIZONTAL

SLIDER
1097
424
1332
457
num-treb-caixes
num-treb-caixes
1
10
4
1
1
persones
HORIZONTAL

BUTTON
11
100
82
133
Go
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

BUTTON
10
55
82
88
Step
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
1103
63
1253
81
Carnisseria
12
0.0
1

SLIDER
1099
134
1328
167
temps-carn
temps-carn
0
500
250
10
1
sec
HORIZONTAL

SLIDER
1099
178
1327
211
marge-temps-carn
marge-temps-carn
0
100
51
1
1
sec
HORIZONTAL

TEXTBOX
1374
69
1524
87
Peixateria
12
0.0
1

SLIDER
1350
134
1584
167
temps-peix
temps-peix
0
500
240
10
1
sec
HORIZONTAL

SLIDER
1352
181
1582
214
marge-temps-peix
marge-temps-peix
0
100
49
1
1
NIL
HORIZONTAL

TEXTBOX
1105
229
1255
247
Fruiteria
12
0.0
1

SLIDER
1099
302
1330
335
temps-fruita
temps-fruita
0
500
240
10
1
sec
HORIZONTAL

SLIDER
1097
349
1333
382
marge-temps-fruita
marge-temps-fruita
0
100
51
1
1
NIL
HORIZONTAL

TEXTBOX
1359
226
1509
244
Forn
12
0.0
1

SLIDER
1346
301
1581
334
temps-forn
temps-forn
0
500
240
10
1
sec
HORIZONTAL

SLIDER
1350
349
1582
382
marge-temps-forn
marge-temps-forn
0
100
25
1
1
sec
HORIZONTAL

TEXTBOX
1100
397
1250
415
Caixes
12
0.0
1

SLIDER
1096
467
1332
500
temps-caixes
temps-caixes
0
500
240
10
1
sec
HORIZONTAL

SLIDER
1098
514
1336
547
marge-temps-caixes
marge-temps-caixes
0
100
50
1
1
sec
HORIZONTAL

TEXTBOX
1361
397
1511
415
Prestatgeries
12
0.0
1

SLIDER
1350
426
1566
459
temps-prestatges
temps-prestatges
0
500
500
10
1
sec
HORIZONTAL

SLIDER
1352
470
1570
503
marge-temps-prestatges
marge-temps-prestatges
0
100
100
1
1
sec
HORIZONTAL

PLOT
590
22
1081
292
Cues
Temps
Gent
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Carnisseria" 1.0 0 -16777216 true "" "plot length queue-carn"
"Peixateria" 1.0 0 -2674135 true "" "plot length queue-peix"
"Fruiteria" 1.0 0 -955883 true "" "plot length queue-fruita"
"Forn" 1.0 0 -10899396 true "" "plot length queue-forn"
"Caixa" 1.0 0 -13345367 true "" "plot length queue-caixes"

SLIDER
1099
10
1324
43
temps-entrada
temps-entrada
0
1000
110
10
1
sec
HORIZONTAL

SLIDER
1346
10
1590
43
marge-temps-entrada
marge-temps-entrada
0
100
100
1
1
sec
HORIZONTAL

@#$#@#$#@
## QUÈ ÉS?

Aquest model tracta de simular el comportament intern d'un supermercat.

És a dir, com són atesos els clients a cada zona del super en funció del nombre de dependents a cada una d'elles. El nostre supermercat consta de 6 zones: carnisseria, peixateria, fruiteria, forn, prestatges i caixes.  En totes elles hi ha dependents menys a la zona de prestatges que els clients s’autoserveixen.


## UTILITZACIÓ
Primer s'ha de fer click a SETUP per tal d’inicialitzar el model.
Després a GO per a fer-lo funcionar.
Amb el botó STEP es pot fer córrer el model un tick i veure l’execució pas a pas. Això permet analitzar millor el comportament del model.

Per a cada zona, hi ha un slider que determina el número de treballadors que poden atendre clients. A totes elles hi ha d’haver almenys un treballador (menys a prestatgeries, on cada client es serveix a si mateix i no depèn de ser atès), i un màxim de 10. Tot i això, el màxim és arbitrari i es pot augmentar sense cap problema.

## IMPLEMENTACIÓ
A grans trets, cada zona disposa d’una cua interna on es guarda el número de clients que estan fent cua per a ser atesos.
Un cop es pot moure de zona, els clients comproven quines zones els falten per a visitar i, quan troben una que els falta, hi van. Un cop han acabat passen per caixes.

S’ha decidit separar la representació gràfica del model amb la representació funcional d’aquest per a tal de facilitar la implementació. Pel que fa a la represntació gràfica, les cues estan represntades per a un espai entre dues zones de tal manera que la cua és de la zona de la dreta. En aquesta zona s’hi pintarà gent quan l’algorisme decideixi enviar-hi clients i s’esborraran quan aquests siguin atesos.


## REPRESENTACIÓ
S’ha especificat cada zona com una gran columna, pretenent imitar un mostrador. En inicialitzar el model, a cada mostrador de cada zona es posicionen tants treballadors com s’hagin especificat als sliders.

Finalment, les cues es representen a l’esquerra del mostrador com a una fila horitzontal de color turquesa.





##EXPERIMENTACIÓ

Els gràfics es poden veure en el pdf adjunt.

Tots els experiments s’han fet tenint en compte que només hi ha 20 empleats al supermercat i que els temps de servei per a totes les zones són el mateix.
En el primer experiment el que hem fet és repartir els 20 empleats entre totes les botigues de dins el supermercat. Al ser 5, toquen 4 empleats per a cada una. Aquesta simulació l’hem fet amb un temps de servei normal però amb molt poc temps entre arribades.

Com podem veure en el gràfic resultant, hi ha una mitjana de 2 persones a les cues, però com es pot observar, no hi ha cap zona que relantitziespecialment les vendes.



El segon experiment que hem dut a terme és pràcticament igual que el primer malgrat el temps entre arribades, que l’hem augmentat considerablement. En el gràfic resultant podem veure com la mitjana de clients a les cues és pràcticament 0 i hi ha algun cop que arriba a haver-hi una persona. De la mateixa manera que en el primer experiment podem veure com els colors de la gràfica estàn completament distribuits.



En el tercer experiment, hem volgut comprovar que passava si reduíem el nombre de dependents d’una zona. D’aquesta manera, s’ha tornat a augmentar el temps entre arribades general i s’ha reduït el número de dependents de la carnisseria a 1.

Tal i com es pot veure en la gràfica dels resultats, les persones de la cua de la carnisseria es disparen ja que aquesta no és capaç d’absorbir tota la càrrega de clients amb un dependent i prou.



En l’últim experiment, hem volgut comprovar quin és el comportament de la simulació en el cas de que hi hagi dos zones amb pocs dependents. D’aquesta manera hem decidit deixar tant la carnisseria com la fruiteria amb només una persona.

Els resultats obtinguts es poden veure en la següent gràfica i el que podem observar és que la cua de la fruiteria es dispara mentre que la cua de la carnisseria no. Tot i que aquesta última no es dispari aquesta sempre té una persona, i a vegades dues a la cua.

Aquest comportament és degut a que la fruiteria està al principi del supermercat i per tant la gent primer passa per aquesta zona. Per tant aquesta zona fa de filtre i la gent no s’acumula a les altres. És per aquesta raó que encara que tant la fruiteria com la carnisseria tinguin el mateix nombre de dependents, a la fruiteria s’hi acumula molta més gent.



De l’anàlisi dels resultats d’aquests experiments, podem concloure que el millor rendiment s’obté quan el nombre de dependents és similar en totes les zones.

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
NetLogo 5.3.1
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
