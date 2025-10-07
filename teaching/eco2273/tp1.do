****Question 4*****

*Ouvrir la base de données csv, juste à changer le chemin avant "\nlsw88.csv"
import delimited "C:\Users\oumar\Downloads\nlsw88.csv", clear

**A**
*Faire un graphique nuage de points
twoway scatter Y X //remplacer Y par le nom de la variable en ordonnée et X par le nom de la variable en abscisse

*Générer une nouvelle variable grâce à une variable déjà existante
gen tenure_bin = .
replace tenure_bin = 2 if anciennete <= 8
replace tenure_bin = 6 if anciennete > 8 & anciennete <= 14 //remplacer anciennete par le vrai nom de la variable

*Calculer une moyenne dans un intervalle
egen moyenne_salaire /*après gen ou egen, mettre le nom que vous allez donner à la variable*/ = mean(salaire), by(tenure_bin) //remplacer salaire par le vrai nom de la variable
twoway scatter Y X

*si vous voulez savoir les différentes valeurs de moyenne_salaire, ainsi que le nombre de personnes dans chacune des moyenne_salaire
tab moyenne_salaire

**B**

*Installer binscatter
ssc install binscatter, replace

*Faire le binscatter
binscatter Y X //remplacer Y par le nom de la variable en ordonnée et X par le nom de la variable en abscisse
graph export "C:\Users\oumar\Downloads\binscatter.png", replace

**C**

*Générer le log du salaire
gen logsalaire = log(salaire) //remplacer salaire par le vrai nom de la variable du salaire

*Calculer la corrélation
correlate Y X // remplacer Y et X par le nom des variables qui nous intéressent 

*Calculer la corrélation par groupe
correlate Y X if union == "Union" // à la place de "union", mettre la variable qui nous intéresse
correlate Y X if union == "Nonunion" // à la place de "union", mettre la variable qui nous intéresse
*A faire pour chaque groupe demandé

correlate Y X if union == "Union" // à la place de "union", mettre la variable qui nous intéresse
correlate Y X if union == "Nonunion" // à la place de "union", mettre la variable qui nous intéresse

correlate Y X if union == "Union" // à la place de "union", mettre la variable qui nous intéresse
correlate Y X if union == "Nonunion" // à la place de "union", mettre la variable qui nous intéresse

**D**

*Faire un histogramme
summarize salaire, d

hist salaire, caption("moyenne = 1563, ecart-type = 2635, asymétrie = 1652, étendue interquartile = 41525") // les valeurs sont aléatoires, mettre les bonnes valeurs de la moyenne et des autres caractéristiques demandées

hist salaire, by(union) // remplacer salaire par son vrai nom


****Question 5 ****

import delimited "C:\Users\oumar\Downloads\canada.csv", clear


**A**

*Transforme les chaines de caractère (string, en rouge) en nombre (int ou float, en noir)
destring revenu, force replace //tous vos NA se transformeront en . (missing), mettre le nom de la variable du revenu
*faire ça pour les deux autres variables rouges
*Trouver des NA et voir avec le prof ce qu'il veut

**B**

preserve

*Calcule une moyenne pondérée
collapse (mean) moyenne_income = revenu [aw = pop], by(year)
*Fait le graph
twoway line moyenne_income annee
graph export "C:\Users\oumar\Downloads\graph1.png", replace
*graph export "" permet d'enregistrer le graphique dans mes dossiers au format que je veux

restore
*Quand on fait collapse, stata ne garde que les variables qu'on lui a indiqué, et également supprime tous les doublons, c'est pourquoi on fait "preserve/restore", afin de ne pas rouvrir la base de données à chaque fois

*A faire pour chacune des variables

**C**

keep if province == "Quebec" | province == "Ontario" // remplacer le nom de prov par la vraie variable

twoway (line revenu annee if province == "Quebec", lcolor(blue)) (line revenu annee if province == "Ontario", lcolor(red)), legend(order(1 "Québec" 2 "Ontario")) // remplacer le nom des variables par les vrais noms
**D**

*tsset pour faire comprendre à stata que c'est une série chronologique

preserve

keep if province == "Quebec" // remplacer le nom des variables par les vrais noms

tsset annee // remplacer le nom des variables par les vrais noms, pour dire à stata que year est une variable chronologique

*Générer la variable taux de croissance
gen taux_croissance = (D.revenu / L.revenu)*100 // remplacer le nom des variables par les vrais noms
save "C:\Users\oumar\Downloads\croissance_qc.dta", replace // sauvegarder une base de données

restore

keep if province == "Ontario" // remplacer le nom des variables par les vrais noms

tsset annee // remplacer le nom des variables par les vrais noms

*Générer la variable taux de croissance
gen taux_croissance = (D.revenu / L.revenu)*100 // remplacer le nom des variables par les vrais noms

append using "C:\Users\oumar\Downloads\croissance_qc.dta" // cela permet de fusionner la base du québec enregistré précédemment à celle de l'ontario
twoway (line taux_croissance annee if province == "Quebec", lcolor(blue)) (line taux_croissance annee if province == "Ontario", lcolor(red)), legend(order(1 "Québec" 2 "Ontario")) // remplacer le nom des variables par les vrais noms






















