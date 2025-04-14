clear all
cls


* Cargar datos
use ${data_raw_dir}/female_politics.dta, clear

* ============================================= *
* VARIABLE DE FOCALIZACIÓN
* ============================================= *
twoway (scatter GenWin PrimMargin, jitter(10)) || /// 
	(qfitci GenWin PrimMargin if primary_winner == 1) || ///
	(qfitci GenWin PrimMargin if primary_winner == 0), aspectratio(1)  
graph export "${output_dir}/rdplot_qfit.png", replace
* mostrar pa entender por q cambia de signo cuando usamos p(x)_1
twoway (scatter GenWin PrimMargin, jitter(10)) || /// 
	(lfitci GenWin PrimMargin if primary_winner == 1) || ///
	(lfitci GenWin PrimMargin if primary_winner == 0) , aspectratio(1)  
graph export "${output_dir}/rdplot_lfit.png", replace


foreach hval in 0.15 0.1 0.05 {
    // calculate half of the current hval
    local c = `hval'/2

    // display current bandwidth and c for tracking
    di _newline(4) "Running rdrobust with h = `hval' and c = `c'"

    // run the regression
    rdrobust GenWin PrimMargin primary_winner c.primary_winner#c.PrimMargin, c(0) p(2) all h(`c' `c')
}
	

* ============================================= *
* SIN CONTROLES
* ============================================= *

* Polinimio Global 
gen  PrimMargin2 =  PrimMargin^2
reg GenWin primary_winner##c.(PrimMargin PrimMargin2), r

* Kernel
foreach hval in 0.15 0.1 0.05 {
	 // calculate half of the current hval
    local c = `hval'/2
	local cneg = -`c'
	
	reg  GenWin primary_winner##c.PrimMargin if inrange(PrimMargin, `cneg', `c'), r
	di "UNIFORM KERNEL  ****************"
	rdrobust GenWin PrimMargin, p(1) c(0) kernel(uniform) h(`hval')
	di _newline(3) "EPANECHIKOV KERNEL ****************"
	rdrobust GenWin PrimMargin, p(1) c(0) kernel(epa) h(`hval')
}




* Kernel con cuadrática
foreach hval in 0.15 0.1 0.05 {
	 // calculate half of the current hval
    local c = `hval'/2
	local cneg = -`c'
	
	reg  GenWin primary_winner##c.(PrimMargin PrimMargin2) if inrange(PrimMargin, `cneg', `c'), r
	di "UNIFORM KERNEL  ****************"
	rdrobust GenWin PrimMargin, p(2) c(0) kernel(uniform) h(`hval')
	di _newline(3) "EPANECHIKOV KERNEL ****************"
	rdrobust GenWin PrimMargin, p(2) c(0) kernel(epa) h(`hval')
}




* ============================================= *
* SIN CONTROLES
* ============================================= *
reg GenWin primary_winner##c.(PrimMargin), r
reg GenWin primary_winner##c.(PrimMargin PrimMargin2), r

	
foreach hval in 0.15 0.1 0.05 {
	 // calculate half of the current hval
    local r = `hval'/2
	
	di "UNIFORM KERNEL  ****************"
	rdrobust GenWin PrimMargin, p(1) c(0) kernel(uniform) h(`r')
	di _newline(3) " Triangle KERNEL ****************"
	rdrobust GenWin PrimMargin, p(1) c(0) h(`r')
}
	

* ============================================= *
* CON CONTROLES
* ============================================= *
global controles "prez PrezYear inc Y82to90 Y92to00 Y02to10"

reg GenWin primary_winner##c.(PrimMargin) $controles, r
reg GenWin primary_winner##c.(PrimMargin PrimMargin2) $controles, r

	
foreach hval in 0.15 0.1 0.05 {
	 // calculate half of the current hval
    local r = `hval'/2
	
	di "UNIFORM KERNEL  ****************"
	rdrobust GenWin PrimMargin, covs($controles) p(1) c(0) kernel(uniform) h(`r')
	di _newline(3) " Triangle KERNEL ****************"
	rdrobust GenWin PrimMargin, covs($controles) p(1) c(0) h(`r')
}



* ============================================= *
* POLINOMIO GLOBAL
* ============================================= *
reg GenWin PrimMargin##c.()
	
rdrobust GenWin PrimMargin primary_winner c.primary_winner#c.PrimMargin, c(0)  p(1) all  h(`c' `c') // da -.33407  quiero que de -0.42 :(
rdrobust GenWin PrimMargin, c(0)  p(1) kernel(uniform) h(0.05 0.05)  // da -.28489 
reg GenWin primary_winner PrimMargin  c.primary_winner#c.PrimMargin if inrange(PrimMargin, -0.025, 0.025) // da -.2848901  pero quiero que de -0.42 :(r
reg GenWin primary_winner PrimMargin  i.primary_winner#c.PrimMargin if inrange(PrimMargin, -0.1, 0.1) // da -.2848901  pero quiero que de -0.42 :(r
