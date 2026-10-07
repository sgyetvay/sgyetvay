*****************************************************************************
*************              Initiation à Stata                    ************
*************     Installation de stata et commandes de base     ************
*****************************************************************************

** On nettoie l'environnement avant de commencer

clear all
set more off

** On utilise un jeu de données déjà intégré à Stata (on peut aussi utiliser un fichier externe)
** "auto.dta" contient des informations sur 74 modèles de voitures

sysuse auto.dta

****  EXPLORER LES DONNÉES   ****

** describe : donne la liste des variables, leur type, et leur étiquette

describe

** Afficher les 10 premières observations

list in 1/10

** Afficher seulement certaines variables pour les 10 premières observations

list make price mpg weight in 1/10

** browse ouvre les données dans une fenêtre tableur

browse

****     STATISTIQUES DESCRIPTIVES   ****

** summarize donne moyenne, écart-type, min, max

summarize

** summarize sur une seule variable, avec plus de détails

summarize price, detail

** tabulate : tableau de fréquences pour une variable catégorielle

tabulate foreign

** tableau croisé entre deux variables

tabulate foreign rep78


****  Créer et modifier des variables

** generate crée une nouvelle variable

generate price_milliers = price / 1000

** replace modifie une variable existante

replace mpg = 14 if mpg >= 41

** On crée une variable simple

generate note = 10

** On la remplace pour tout le monde

replace note = 15

** label variable : donne une étiquette descriptive à une variable

label variable price_milliers "Prix (en milliers de dollars)"



**************************************************************************************
************     Séances 2 : Commandes de base (suite) et graphs        **************
**************************************************************************************

** On nettoie l'environnement avant de commencer

clear all
set more off

** Importer la base incorporee a Stata

sysuse auto.dta

** Créer une variable catégorielle à partir d'une condition

generate cher = (price > 6000)
label variable cher "1 si le prix dépasse 6000$"

** rename : renommer une variable

rename mpg consommation

** drop : supprimer une variable (ou des observations avec une condition)

drop cher

** keep : garder seulement certaines variables ou observations

keep make price weight


** selectionner des observations (condition "if")

** Statistiques uniquement pour les voitures étrangères

summarize price if foreign == 1

** Statistiques uniquement pour les voitures domestiques

summarize price if foreign == 0

** Lister les voitures qui consomment beaucoup et qui sont chères

list make price consommation if consommation < 18 & price > 6000


****  graphiques de base

** Histogramme d'une variable continue

histogram price, normal

** Nuage de points entre deux variables

scatter price weight
scatter price weight || lfit price weight

** Diagramme en barres des moyennes par groupe

graph bar (mean) price, over(foreign)

** Boîte à moustaches (boxplot)

graph box price, over(foreign)

** Pour obtenir de l'aide sur n'importe quelle commande : help nomcommande
    Exemple : help regress


** Mean

summarize price
display r(mean)

** Median

summarize price, detail

** Or directly, using centile:

centile price, centile(50)
centile price, centile(10 25 50 75 90)

** Mode

egen mode_price = mode(price)

** Variance

summarize price, detail
display r(Var)

** Standard deviation (écart-type)

summarize price
display r(sd)

**  Skewness

summarize price, detail

egen skew_price = skew(price)

** Covariance

correlate price weight, covariance

** Corrélation

correlate price weight

** pwcorr rapporte aussi la significativité statistique:

pwcorr price weight mpg, sig

** Ecart interquartile (IQR)

egen iqr_price = iqr(price)

** On peut aussi le faire manuellement,

summarize price, detail

** IQR = r(p75) - r(p25)
display r(p75) - r(p25)


** l'utilisation de Preserve et restore

preserve

drop if foreign == 1

restore


*******************************************************************************
    SÉANCE 3 : Introduction à la simulation des données avec Stata
*******************************************************************************

clear all
set more off

****    Nombre aléatoire et graine (SEED)

set seed 1234

** On crée un jeu de données vide de 20 observations

set obs 20

** runiform() tire un nombre au hasard entre 0 et 1 (loi uniforme continue)

gen x_uniforme = runiform()
gen x_normal = rnormal()

** pour une loi uniforme on peut definir les valeurs extrèmes

gen x_uniforme = runiform(-5, 10)
gen x_uniforme = runiform(0, 10)

** Pour une loi normale on peut définir la moyenne et l'écart type au préalable

gen x_normal = rnormal(-5, 10)
gen x_normal = rnormal(0, 10)

list x_uniforme in 1/10

** Démonstration: relancer sans changer la graine -> mêmes valeurs

clear
set seed 12345
set obs 20
gen x_uniforme = runiform()
list x_uniforme in 1/10   // -> identique à la première fois

** Démonstration: changer la graine -> valeurs différentes

clear
set seed 999
set obs 20
gen x_uniforme = runiform()
list x_uniforme in 1/10   // -> différent


*** Exemple de construction d'un panel

clear all
set more off
set seed 1234

set obs 3
gen id = _n

** chaque individu est dupliqué 5 fois

expand 5
bys id: gen t = _n

** on invente une valeur de Y pour chaque individu à chaque période

gen Y = t + id + rnormal(0, 0.3)

**  Tracer la trajectoire d'UN SEUL individu

twoway line Y t if id == 1

**  ajouter une deuxième trajectoire

twoway (line Y t if id == 1) (line Y t if id == 2)

**     Ajouter des couleurs et une troisième trajectoire

twoway (line Y t if id == 1, lcolor(blue))  ///
       (line Y t if id == 2, lcolor(red))   ///
       (line Y t if id == 3, lcolor(black))


**    Ajouter une légende, des titres, et exporter le graphique

twoway (line Y t if id == 1, lcolor(blue))  ///
       (line Y t if id == 2, lcolor(red))   ///
       (line Y t if id == 3, lcolor(black)), ///
       legend(order(1 "id=1" 2 "id=2"  3 "id=3")) ///
       title("Trajectoires individuelles") ///
       ytitle("Y") xtitle("Période (t)")


graph export "exemple_trajectoires.png", replace