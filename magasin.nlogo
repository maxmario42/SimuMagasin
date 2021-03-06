extensions [ table ]

;;Simulation d'un magasin

;;variables globales
;; numéro du produit
;; nombre d'achat fait
;; nombre de clients passés
globals [
  numeroProduit
  nbAchats
  nbClientsTot
]

;;variables de cellules :
;; la case correspond a un rayon, une sortie, une caisse, un produit sinon un espace vide
;; rayon?, sortie? et caisse? sont des booleans, un seul des trois peut être TRUE au maximum
;; produit est un entier strictement positif si il y a un produit, sinon -1
patches-own [
  rayon?
  sortie?
  caisse?
  produit
]

;; les clients
breed[clients client]

;; Les agents ont une liste de produit à voir
;; Ils peuvent acheter au moins un produit. Si ils ont un produit, achat? passe a TRUE avec la proba correspondante dans probaAchat.
;; Ils ont une destination en fonction des produits restants à voir et s'ils ont un achat à régler
;; Ils ont un chemin à suivre pour attendre leur destination
clients-own[
  listeVoir
  probaAchat
  achat?
  destination
  path
  step
  successive_recompute
  tmp_dst
]

;;initialiser
to setup
  clear-all
  set numeroProduit 1
  set nbAchats 0
  set nbClientsTot 0
  initialiserRayons
  initialiserSorties
  initialiserCaisses
end

;; dessins des rayons et des produits
to initialiserRayons
  ask patches
    [
      set rayon? false
      set sortie? false
      ifelse pycor >= -46 and  pycor <= 40
        and pxcor >= -17 and  pxcor <= 17
        and (pxcor <= -4 or  pxcor >= 4)
        and (pycor mod 3 = 0)
      [ rayonCell ]
      [ ifelse (pxcor >= -17 and  pxcor <= 17)
        and (pxcor <= -4 or  pxcor >= 4)
        and pycor >= -46 and pycor <= 40
        and (pycor mod 3 = 1 or pycor mod 3 = 2)
        [ produitCell ]
        [ libreCell ]
  ]
  ]
end

;; dessins des sorties
to initialiserSorties
  ask patches
    [ if (pycor = 50
        and (pxcor >= -5 and pxcor <= 5))
          [ sortieCell ]]
end

;; dessins des caisses
to initialiserCaisses
  ask patches
    [ if (pycor = 50
        and (pxcor >= 17 and pxcor <= 25))
          [ caisseCell ]]
end

;;initialisation des agents
to creerClient
  create-clients nbAgents
  [
    set achat? false ;;Ils n'ont pas encore fait d'achat
    set listeVoir []
    set probaAchat []
    repeat nbProduits [
      set listeVoir lput ((random numeroProduit) + 1) listeVoir
      set probaAchat lput (random-float 1) probaAchat
    ] ;; Leur liste comporte autant de produit que désiré
    set color yellow - 2 + random 7
    move-to one-of patches with [sortie? = true] ;; Ils entrent par l'entrée
    chercherDest
    set nbClientsTot nbClientsTot + 1
  ]
end

;; rayon  -> couleur de cellule
to rayonCell
  set rayon? true
  set sortie? false
  set caisse? false
  set produit -1
  set pcolor white
end

;; sortie -> couleur de sortie
to sortieCell
  set rayon? false
  set sortie? true
  set caisse? false
  set produit -1
  set pcolor red
end

;; caisse -> couleur de caisse
to caisseCell
  set rayon? false
  set sortie? false
  set caisse? true
  set produit -1
  set pcolor blue
end

;; produit  -> couleur du produit
to produitCell
  set rayon? false
  set sortie? false
  set caisse? false
  set produit numeroProduit
  set numeroProduit numeroProduit + 1
  set pcolor green
end

;; libre  -> couleur du fond
to libreCell
  set rayon? false
  set sortie? false
  set caisse? false
  set produit -1
  set pcolor black
end

;; Calcul de la destination
to chercherDest
  ifelse empty? listeVoir ;; Si le client n'a plus rien a voir
  [
    ifelse achat? = true ;; Si le client a réalisé un achat, il va aux caisses, sinon vers la sortie
    [
      set destination one-of (patches with [caisse? = true])
    ]
    [
      set destination one-of (patches with [sortie? = true])
    ]
  ]
  [
    let n first listeVoir ;; Il va vers le premier produit de sa liste
    set destination one-of (patches with [produit = n])
  ]
  set successive_recompute 0
  set tmp_dst nobody
  compute_new_path destination
end

to go
  ask clients [ client_step ]
  let bad patches with [count clients-here > 1]
  if any? bad [
    show bad
  ]
end

to client_step
  let c color
  let success true
  let current_patch patch-here
  let dest destination

  (ifelse step < length path [
    let next_patch item step path

    ; Si le prochain patch contient un client, nous devons calculer un nouveau chemin
    ifelse [not any? clients-here] of next_patch or next_patch = current_patch [
      face next_patch
      move-to next_patch

      (ifelse next_patch = destination [
        show "reached destination"
      ] next_patch = tmp_dst [
        set tmp_dst nobody
        compute_new_path destination
      ])

      set step step + 1
    ] [
      set success false
    ]
  ] length path = 0 [
    set success false
  ])

  ifelse not success [
    set successive_recompute successive_recompute + 1
    ifelse successive_recompute < 50 [
      may_compute_new_path 0.9 destination
    ] [
      show "HORS DE MA ROUTE"
      set tmp_dst one-of patches with [not rayon? and not any? clients-here and current_patch != dest]
      may_compute_new_path 0.9 tmp_dst
    ]
  ] [
    set successive_recompute 0
  ]
  ;; arrive au produit désiré, achat éventuel
    if not empty? listeVoir and [produit] of patch-here = first listeVoir
    [
      set listeVoir but-first listeVoir ;; On retire le produit de la liste
      if ((random-float 1) + fievreAcheteuse) > first probaAchat[
      set achat? true
      set nbAchats nbAchats + 1
    ]
      set probaAchat but-first probaAchat
      chercherDest
    ]

    ;; arrive à la caisse : direction la sortie
    if [caisse?] of patch-here
    [
      set achat? false
      chercherDest
    ]
    ;; arrive à la sortie : mourir
    if [sortie?] of patch-here and empty? listeVoir
    [
    die
  ]

end

to may_compute_new_path [ sigma dest ]
  if random-float 1 <= sigma [
    compute_new_path dest
  ]
end

; Calculer un nouveau chemin vers la destination à l'aide de l'algorithme A* et réinitialiser l'étape
; Renvoie une liste commençant par patch-here lorsqu'un chemin a été trouvé
; Renvoie une liste vide lorsque la destination est inaccessible
to compute_new_path [ dest ]

  set path (list)
  set step 1

  let origin patch-here
  let to_explore table:make
  table:put to_explore (word origin) origin

  let explored table:make

  let came_from table:make
  let score_origin table:make
  let score_total table:make

  table:put score_origin (word origin) 0
  table:put score_total (word origin) distance dest

  while [ table:length to_explore > 0 ] [
    let current pick_patch_with_lowest_score to_explore score_total
    table:put explored (word current) true

    ifelse current != dest [
      let neighs [neighbors] of current

      foreach sort neighs [ neigh ->
        if is_patch_walkable neigh = true [
          let tentative_score [distance current] of neigh + table:get score_origin (word current)
          if table:has-key? score_origin (word neigh) = false or table:get score_origin (word neigh) > tentative_score [
            table:put came_from (word neigh) current
            table:put score_origin (word neigh) tentative_score
            table:put score_total (word neigh) [distance dest] of neigh + tentative_score

            if table:has-key? explored (word neigh) = false [
              table:put to_explore (word neigh) neigh
            ]
          ]
        ]
      ]

      table:remove to_explore (word current)
    ] [
      set path (list current)
      while [ table:has-key? came_from (word current) ] [
        set current table:get came_from (word current)
        set path sentence current path
      ]

      table:clear to_explore
    ]
  ]
end

to-report pick_patch_with_lowest_score [ to_explore score_total ]
  let minimum world-width * world-height + 1 ; max value possible for a path
  let result_patch nobody

  foreach (table:keys to_explore) [ pat ->
    if table:has-key? score_total pat [
      let tentative_min table:get score_total pat
      if tentative_min < minimum [
        set minimum tentative_min
        set result_patch table:get to_explore pat
      ]
    ]
  ]

  report result_patch
end

to-report compare_patch_score [ score pat_a pat_b ]
  let pat_a_score table:get score (word pat_a)
  let pat_b_score table:get score (word pat_b)
  report pat_a_score < pat_b_score
end

to-report is_patch_walkable [ p ]
  ifelse p != patch-here [
    report [not rayon?] of p and [not any? clients-here] of p
  ] [
    report [not rayon?] of p
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
157
10
828
1332
-1
-1
13.0
1
10
1
1
1
0
0
0
1
-25
25
-50
50
0
0
1
ticks
30.0

BUTTON
851
164
914
197
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

BUTTON
853
86
916
119
NIL
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

MONITOR
1028
270
1130
315
Clients presents
count clients
17
1
11

BUTTON
917
164
996
197
go 1 fois
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

SLIDER
848
258
1020
291
nbAgents
nbAgents
1
100
100.0
1
1
NIL
HORIZONTAL

BUTTON
848
369
974
402
Créer des Clients
creerClient
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
848
295
1020
328
nbProduits
nbProduits
1
100
1.0
1
1
NIL
HORIZONTAL

TEXTBOX
855
62
921
80
Installation
11
0.0
1

TEXTBOX
853
149
1003
167
Lancement
11
0.0
1

TEXTBOX
851
241
905
259
Clients
11
0.0
1

SLIDER
847
330
1019
363
fievreAcheteuse
fievreAcheteuse
-1
1
0.01
0.01
1
NIL
HORIZONTAL

MONITOR
1028
368
1183
413
Achats depuis Installation
nbAchats
17
1
11

MONITOR
1028
320
1179
365
Clients depuis installation
nbClientsTot
17
1
11

@#$#@#$#@
# Présentation
Ceci est un modèle de supermarché. Il montre le comportement des clients en fonction de ceux dont ils ont besoin et de leur profil.

# Utilisation

## Installation

Il suffit de cliquer sur SETUP. Cela créera le magasin et effacera le précédent (s'il existe). Le magasin comporte différents types de cases :

* Noir : Vide
* Blanc : Rayon
* Vert : Produit
* Bleu : Caisse
* Rouge : Entrée/Sortie
	

## Lancement

Vous pouvez cliquer sur GO pour que la simulation tourne en permanence ou sur GO 1 FOIS pour une exécution pas à pas.

## Clients

Avec le slider nbAgents, vous pouvez choisir le nombre de clients qui vont entrer puis avec le slider nbProduits, le nombre de produits qu'ils vont voir. 
Enfin, avec le slider fievreAcheteuse, vous pouvez régler le profil de client, la valeur de -1 fera en sorte qu'ils n'achètent rien et 1 tout ce qu'il y a sur leur liste.
Il vous suffit ensuite de cliquer sur CREER DES CLIENTS pour qu'ils apparaissent à l'entrée.


# Fonctionnement
Le calcul de chemin est basé sur l'algorithme A*. Voir les commentaires du code.

# Auteurs

Réalisé par Maxence Godefert et Valentin Maerten
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
