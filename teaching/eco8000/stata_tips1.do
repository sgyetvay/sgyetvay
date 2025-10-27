*seance STATA eco8000 2025-10-14 et 2025-10-16

*exploring a dataset that comes installed in stata
sysuse auto.dta, clear

*show first observation
list in 1

*how many observations
display _N

*list all variables
ds, alpha

*summarise all variable
codebook

*list some variables 
list make price if foreign == 1
list make mpg if mpg >= 30 & mpg < 49
list make mpg if mpg >= 30 | mpg < 18

*summarise a variable (continuous)
summarize length
summarize length, detail
summarize price, detail

*tabulate a variable (discrete/categorical)
tabulate rep78, missing
tabulate foreign 
tabulate foreign, missing

*count missing observations
count if rep78 == .
count if missing(rep78)
list make if missing(rep78)
summarize price if missing(rep78)

*exploring a dataset that we upload to stata

*print working directory
pwd

*change directory 
cd "/Users/samuelgyetvay/Dropbox/teaching/eco8000/homework/ps1"

*set global for data folder
global data "/Users/samuelgyetvay/Dropbox/teaching/eco8000/homework/ps1/data"

*call globals using $
display "$data"

*open a data set 
*use , clear so that stata doesn't throw an error if you already have data in memory
use "$data/cps.dta", clear

*summarize all variables in the data
*codebook //long--uncomment to run

*list all variable names in alphabetic order
ds, alpha 

*more detail
ds, alpha detail

*summarize a variable 
summarize age
//summarize age, detail // long, uncomment to run
return list // view locals saved after summarize
*display + calculate using locals
display `r(mean)'
display `r(mean)'/`r(sd)'
* display `r(p75)'-`r(p25)' // requires detail

*summarize with a condition 
summarize __incwag if wrkyr == 1975
summarize __incwag if wrkyr == 1975 & married == 1
summarize __incwag if married == 1 | never_married == 1
summarize __incwag if wrkyr >= 1975 & wrkyr <= 1979
summarize __incwag if inlist(wrkyr, 1975, 1976, 1977, 1978, 1979)

*tabulate 
tabulate race
tabulate school
tabulate race school
tabulate education 

*missing values (use missing(), not .--other ways of coding missings)
count if missing(__incwag)
count if __incwag == .

*help function to display each function's documentation
help summarize
help tabulate 
help count 

*create a variable based on 'education' that combines HSD9-10-11 into one category
tabulate education 
tabulate education, m nolabel
generate educ = 1 if education == 1
replace educ = 2 if inlist(education, 2, 3, 4)
replace educ = 3 if education == 5
replace educ = 4 if education == 6 
replace educ = 5 if education == 7
replace educ = 6 if education == 8

*create a value label for our new education variable
label define educ_labels ///
	1 "HSD8 (1)" ///
	2 "HSD9-10-11 (2)" ///
	3 "HSG (3)" ///
	4 "Some College (4)" ///
	5 "College Graduate (5)" ///
	6 "Advanced Degree (6)"
label values educ educ_labels

*take a weighted mean (moyenne ponderee)
summarize __incwag [aweight = wgt] if wrkyr == 1975
summarize __incwag if wrkyr == 1975 // compare unweighted 

*regression 
gen log_wage = log(wage_cpi)
gen exp2 = exp^2 
help regress
regress log_wage exp exp2 age white black married if wrkyr == 1975
regress log_wage exp exp2 age white black married if wrkyr == 1975 [aweight = wgt]

*regression with globals 
global X exp exp2 age white black married
display "$X"
regress log_wage $X if wrkyr == 1975 [aweight = wgt]
regress log_wage selfemp $X if wrkyr == 1975 [aweight = wgt]

*Q2 TP1 

*Q2(a)
*"Restreignez l'échantillon aux travailleurs blancs, non hispaniques, âgés de 26 à 55 ans."
keep if white == 1
keep if age >= 26 & age <= 55
*equivalently,
drop if white == 0 
drop if age <= 25 
drop if age >= 56

*"Supprimez les travailleurs vivant en quartiers collectifs, et supprimez les travailleurs ayant une valeur manquante pour la variable married. "
tab group_quarters 
tab group_quarters, nolabel 
drop if group_quarters == 1
drop if missing(married)

*Q2(b) 
*Commencez par créer une variable indicatrice qui identifie les travailleurs "à temps plein toute l'année" : travailleurs ayant travaillé au moins 50 semaines et 35 heures par semaine. (Indice: utilisez les variables wksly et hrslyr). Créez une mesure du salaire horaire réel en divisant la variable wage_cpi par la variable wrkhrlyr, puis créez une variable égale au logarithme du salaire horaire réel."
generate ftfy = (hrslyr >= 35 & wksly >= 50)
gen real_hourly_wage = wage_cpi/wrkhrlyr
cap drop log_wage 
gen log_wage = log(real_hourly_wage)

*Q2(c)
* Commencez par créer une variable égale à 1 si le travailleur n'a jamais été marié, 0 sinon. Générez une variable indicatrice pour chacun des groupes d'éducation suivants : non diplômés du secondaire (8 ans de scolarité ou moins), non diplômés avec 9-11 ans de scolarité, diplômés du secondaire, travailleurs ayant un peu d'université, diplômés universitaires, diplômes avancés." 
generate never_married = 1 - ever_married
*alternatively,
drop never_married 
generate never_married = (ever_married == 0)
*generate education dummies 
generate educ1 = (educ == 1)
generate educ2 = (educ == 2)
generate educ3 = (educ == 3)
generate educ4 = (educ == 4)
generate educ5 = (educ == 5)
generate educ6 = (educ == 6)
*"Générez les composantes d'un polynôme d'ordre quatre en expérience (mesurée dans la variable exp)"
generate exp1 = exp/10
generate exp2 = (exp/10)^2
generate exp3 = (exp/10)^3
generate exp4 = (exp/10)^4
*"Ensuite, créez un ensemble de variables nommées par exemple exp1_hsd08, exp2_hsd08 pour chacune des interactions éducation-expérience"

*intro to loops 
forvalues i = 1/4 { 
	forvalues j = 1/5 {
		display `i' `j'
	}
}

*use the loops to create interactions 
forvalues i = 1/4 { 
	forvalues j = 1/6 { 
		generate exp`i'_educ`j' = exp`1'*educ`j'
	}
}


*Question 5 hints 

*download data from Acemoglu website 
*open data in STATA
*impose sample restrictions (look in paper or look in Acemoglu's do files)
*use the command collapse to calculate averages within each state
*use twoway scatter to create scatterplot 
*(to find state names/labels, look online https://usa.ipums.org/usa-action/variables/stateicp#codes_section) and generate either a new variable or labels e.g. generate state = "CT" if stateicp == 1, etc.


*example of collapse 
di _N
collapse (mean) incwage hrswork1, by(stateicp)
di _N
twoway scatter incwage hrswork1 
twoway scatter incwage hrswork1 || lfit incwage hrswork1








