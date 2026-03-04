* People's Voice Survey data cleaning for Romania - Wave 2
* Date of last update: February 2026
* Last updated by: S Islam

/*

This file cleans Ipsos data for Romania Wave 2. 

Cleaning includes:
	- Recoding outliers to missing 
	- Recoding skip patterns, refused, and don't know 
	- Creating new variables (e.g., time variables), renaming variables, labeling variables 
	- Correcting any values and value labels and their direction 
	
Missingness codes: .a = NA (skipped), .r = refused, .d = don't know, . = true missing 

*/

clear all
set more off 

*********************** ROMANIA (WAVE 2) ***********************

* Import raw data 
use "$data/Romania wave 2/data_RO_wave2_EN_18+.dta"

*Label as wave 2 data:
gen wave = 2

*Deleting unneccessary vars:
drop q8 q9 q14 q15 q19_1 q19_2 q19_3 q19_4 q19_5 q19_6 q19_7 q19_8 ///
	q29 q30 q30_other q41_1 q41_2 q41_3 q41_4 q41_5 q41_6 q41_7 q41_8 q41_998 q41_999 ///
	q46_mental_1 q47 q48 q49_1 q49_2 q49_3 q49_4 q49_5 q49_6 q49_999 ///
	q50_1 q50_2 q50_3 q50_4 q50_5 q50_6 q50_7 q50_999 q51 q52 q53 q54 q55 q56 ///
	q57_1 q57_2 q57_3 q57_4 q57_5 q57_6 q57_7 q57_8 q57_9 q57_10 q57_11 q57_12 q57_13 q57_14 q57_15 q57_16 ///
	q62 q62_other q64 q65 q65_other q90 q98 q99 q99_more q100_1 q100_2 q100_3 q100_4 q100_5 q100_6 q101 q102 ///
	hash sex varstac educ mediu weight_mkor q73_5_other q73_6_other q98_c
	  
*------------------------------------------------------------------------------*
* Rename some variables, and some recoding if variable will be dropped 

gen country = 19
lab def country 19 "Romania"
lab values country country

gen language = 19002 
lab def Language 19002 "RO: Romanian" 
lab values language Language

gen mode = 3
lab def mode 3 "CAWI"
lab val mode mode

rename wins weight
rename id respondent_serial	

gen q11_a = .
replace q11_a = 1 if q23 == 1 | q24 == 1
replace q11_a = 0 if q23 == 0 & q24 == 0
replace q11_a = .r if q23 == .r | q24 == .r
drop q23 q24

rename q2 q1
rename (q10 q11 q12) (q8 q9 q10)
rename q20 q11
rename (q21 q22) (q12_a q12_b)
* mental health qs
rename (q13_1 q13_2 q13_3 q13_4 q17 q18 q18_other) (m1_a m1_b m1_c_ch_ro m1_d_ch_ro m2_ch_ro m3_ch_ro m3_ch_ro_other) // remember to change name in CH
rename (q16 q28 q31) (q17_d q17_c q17_b) // q17_b needs to be changed in DE
rename (q25 q26 q89) (q41e_ch_ro q41f_ch_ro q41d_ch_de_ro) // remember to change name in CH and DE
rename (q27 q46 q46_mental) (q27k_ch_de_ro q27i_ch_de_ro q17g_ch_ro) // remember to change names in CH and DE
rename (q32 q33 q33_other q34 q34_other q35  q35_other q36 q37) (q13 q14_multi q14_other q15 q15_other q16 q16_other q17 q18)
rename (q38 q39 q40 q42 q44) (q20 q21 q22 q23 q25)
rename (q45_1 q45_2 q45_3 q45_4 q45_5 q45_6 q45_7 q45_8) (q27_a q27_b q27_c q27_d q27_e q27_f q27_g q27_h)
rename (q58 q59 q59_other q66 q67) (q29 q30 q30_other q31a q31b)
rename (q60 q61 q63) (q29a_ch_ro q29a_ch_ro_other q29b_ch_ro) // remember to change name in CH
rename (q68 q68_other q69 q69_other q70 q71 q72) (q33 q33_other q34 q34_other q35 q36 q37)
rename (q73_1 q73_2 q73_3 q73_4 q73_5) (q38_a q38_b q38_c q38_d q38_e)
rename (q73_6 q73_7 q73_8 q73_9 q73_10 q73_11) (q38_f q38_g q38_h q38_i q38_j q38_k)
rename (q73_12 q74) (q38_l_ch_ro q38_m_ro) // remember to change name in CH
rename (q76 q80 q81) (q39 q48 q49)
rename (q77 q78) (q28_a q28_b)
rename (q82 q83 q84 q85) (q40_a q40_b q40_c q40_d)
rename (q86 q87 q88) (q41_a q41_b q41_c)
rename (q91 q92 q93 q94 q95 q97) (q42 q43 q44_multi q45 q46 q51)

*------------------------------------------------------------------------------*
* Generate vairables
* Fix interview length variable and other time variables 

gen respondent_id = "RO" + string(respondent_serial) 

gen double date = daily(start_date, "DMY")
format date %tdD_M_CY
drop start_date end_date

gen double int_length = duration / 60
drop duration

gen q2 = . 
replace q2 = 1 if q1 >=18 & q1<=39
replace q2 = 2 if q1 >=30 & q1<=39
replace q2 = 3 if q1 >=40 & q1<=49
replace q2 = 4 if q1 >=50 & q1<=59
replace q2 = 5 if q1 >=60 & q1<=69
replace q2 = 6 if q1 >=70 & q1<=79
replace q2 = 7 if q1 >=80 
replace q2 = .a if q1 == .a | q1 == .d | q1 == .r

lab def q2_label 0 "under 18" 1 "18-29" 2 "30-39" 3 "40-49" 4 "50-59" 5 "60-69" ///
				6 "70-79" 7 "80 +" .r "Refused" .a "NA" .d "Don't Know" .r "Refused"
lab val q2 q2_label

encode q4, gen(recq4)
drop q4
recode recq4 (1 = 239) (2 = 240) (3 = 241) (4 = 242) (5 = 243) (6 = 244) (7 = 245) (8 = 247) (9 = 246) (10 = 248) (11 = 249) (12 = 251) (13 = 252) (14 = 253) (15 = 254) (16 = 250) (17 = 256) (18 = 255) (19 = 257) (20 = 258) (21 = 259) (22 = 260) (23 = 261) (24 = 262) (25 = 263) (26 = 264) (27 = 265) (28 = 266) (29 = 267) (30 = 268) (31 = 269) (32 = 270) (33 = 272) (34 = 273) (35 = 274) (36 = 271) (37 = 275) (38 = 276) (39 = 277) (40 = 279) (41 = 280) (42 = 278)
lab def q4_label 239 "Alba" 240 "Arad" 241 "Arges" 242 "Bacau" 243 "Bihor"244 "Bistrita-Nasaud" 245 "Botosani" 246 "Braila" 247 "Brasov" 248 "Bucuresti" 249 "Buzau" 250 "Calarasi" 251 "Caras-Severin" 252 "Cluj" 253 "Constanta" 254 "Covasna" 255 "Dambovita" 256 "Dolj" 257 "Galati" 258 "Giurgiu" 259 "Gorj" 260 "Harghita" 261 "Hunedoara" 262 "Ialomita" 263 "Iasi" 264 "Ilfov" 265 "Maramures" 266 "Mehedinti" 267 "Mures" 268 "Neamt" 269 "Olt" 270 "Prahova" 271 "Salaj" 272 "Satu Mare" 273 "Sibiu" 274 "Suceava" 275 "Teleorman" 276 "Timis" 277 "Tulcea" 278 "Valcea" 279 "Vaslui" 280 "Vrancea"
lab val recq4 q4_label

rename recq4 q4

gen q7 = .
replace q7 = 19031 if q7_1 == 1 & q7_2 != 1 & q7_3 != 1
replace q7 = 19032 if q7_2 == 1
replace q7 = 19033 if q7_3 == 1
replace q7 = 19034 if q7_2 == 1 & q7_1 != 1 & q7_3 != 1
replace q7 = 19995 if q7_4 == 1
replace q7 = .d if q7_998 == 1
replace q7 = .r if q6 == 1 & q7_1 == 0 & q7_2 == 0 & q7_3 == 0 & q7_4 == 0 & q7_998 == 0

drop q7_1 q7_2 q7_3 q7_4 q7_998 q7_cost q7_cost_other

* SI: Check to make sure this is correct
gen q24 = .
replace q24 = 1 if q43_1 == 1
replace q24 = 2 if q43_2 == 1
replace q24 = 3 if q43_3 == 1
replace q24 = 4 if q43_4 == 1
replace q24 = .d if q43_998 == 1
replace q24 = .r if q43_999 == 1

drop q43_1 q43_2 q43_3 q43_4 q43_998 q43_999

encode q30, gen(recq30)
drop q30
rename recq30 q30

gen q50 = .
replace q50 = 19091 if q96_1 == 1 & q50 == .
replace q50 = 19092 if q96_2 == 1 & q50 == .
replace q50 = 19093 if q96_3 == 1 & q50 == .
replace q50 = 19995 if q96_4 == 1 & q50 == .
replace q50 = .r if q96_999 == 1
replace q50 = .r if q96_1 == 0 & q96_2 == 0 & q96_3 == 0 & q96_4 == 0
replace q50 = .d if q96_998 == 1

drop q96_1 q96_2 q96_3 q96_4 q96_998 q96_999

* gen rec variable for variables that have overlap values to be country code * 1000 + variable  

gen recq4 = country*1000 + q4
*replace recq4 = .r if q4 == 999

gen recq5 = country*1000 + q5  
*replace recq5 = .r if q5 == 999

gen recq8 = country*1000 + q8
*replace recq8 = .r if q8== 999

gen recq15 = country*1000 + q15
*replace recq15 = .r if q15== 999
*replace recq15 = .d if q15== 998

gen recq33 = country*1000 + q33
*replace recq33 = .r if q33== 999 
*replace recq33 = .d if q33== 998

* Relabel some variables now so we can use the orignal label values
label define country_short 2 "CO" 3 "ET" 4 "IN" 5 "KE" 7 "PE" 9 "ZA" 10 "UY" ///
						   11 "LA" 12 "US" 13 "MX" 14 "IT" 15 "KR" 16 "AR" ///
						   17 "GB" 18 "GT" 19 "RO" 20 "NG" 21 "CN" 22 "SO" ///
						   23 "NP"
qui elabel list country_short
local countryn = r(k)
local countryval = r(values)
local countrylab = r(labels)

local q4l q4_label
local q5l q5
local q8l q10
local q15l q34
local q33l q34

foreach q in q4 q5 q8 q15 q33 {
	qui elabel list ``q'l'
	local `q'n = r(k)
	local `q'val = r(values)
	local `q'lab = r(labels)
	local g 0
	foreach i in ``q'lab'{
		local ++g
		local gr`g' `i'
	}

	qui levelsof rec`q', local(`q'level)

	forvalues o = 1/`countryn' {
		forvalues i = 1/``q'n' {
			local recvalue`q' = `: word `o' of `countryval''*1000+`: word `i' of ``q'val''
			foreach lev in ``q'level'{
				if strmatch("`lev'", "`recvalue`q''") == 1{
					elabel define `q'_label (= `: word `o' of `countryval''*1000+`: word `i' of ``q'val'') ///
									        (`"`: word `o' of `countrylab'': `gr`i''"'), modify			
				}	
			}                 
		}
	}
	
	label val rec`q' `q'_label
}


*****************************

drop q4 q5 q8 q15 q33
ren rec* *
*------------------------------------------------------------------------------*
* Recode all Refused and Don't know responses - Already recoded in dataset

* Fix visit number vars in dataset (q18, q20, etc)

replace q37_more = trim(q37_more)
destring q37_more, replace

gen recq18 = .
replace recq18 = q18 if inrange(q18, 1, 20)
replace recq18 = q37_more if q18 == 21
replace recq18 = 0 if q18 == 22
replace recq18 = .d if q18 == .d
replace recq18 = .r if q18 == .r
label values recq18

gen q19 = .
replace q19 = 0 if q18 == 0
replace q19 = 1 if q18 > 0 & q18 <= 4
replace q19 = 2 if q18 >= 5 & q18 <= 9
replace q19 = 3 if q18 >= 10 & q18 < .
replace q19 = .d if q18 == .d
replace q19 = .r if q18 == .r

* q18/q19 mid-point var 
gen q18_q19 = q18 
recode q18_q19 (998 999 = 0) if q19 == 0
recode q18_q19 (998 999 = 2.5) if q19 == 1
recode q18_q19 (998 999 = 7) if q19 == 2
recode q18_q19 (998 999 = 10) if q19 == 3

gen recq21 = .
replace recq21 = 2 if q21 == 1
replace recq21 = 3 if q21 == 2
replace recq21 = 4 if q21 == 3
replace recq21 = 5 if q21 == 4
replace recq21 = 6 if q21 == 5
replace recq21 = 7 if q21 == 6
replace recq21 = 8 if q21 == 7
replace recq21 = 9 if q21 == 8
replace recq21 = 10 if q21 == 9
replace recq21 = .d if q21 == .d
replace recq21 = .r if q21 == .r
label values recq21

replace q40_more = trim(q40_more)
destring q40_more, replace

gen recq22 = .
replace recq22 = q22 if inrange(q22, 1, 20)
replace recq22 = q40_more if q22 == 21
replace recq22 = 0 if q22 == 22
replace recq22 = .d if q22 == .d
replace recq22 = .r if q22 == .r
label values recq22

replace q42_more = trim(q42_more)
destring q42_more, replace

gen recq23 = .
replace recq23 = q23 if inrange(q23, 1, 20)
replace recq23 = q42_more if q23 == 21
replace recq23 = 0 if q23 == 22
replace recq23 = .d if q23 == .d
replace recq23 = .r if q23 == .r
label values recq22

drop q18 q21 q22 q23 q37_more q39_more q40_more q42_more
ren rec* *
*------------------------------------------------------------------------------*
* Check for implausible values 

* Q17. Overall respondent's rating of the quality received in this facility
* Q18/Q19. Total number of visits made in past 12 months (q23, q24 mid-point)
* Q20. Were all of the visits you made to the same healthcare facility? 
* Q21. How many different healthcare facilities did you go to? 
* Q22. How many visits did you have with a healthcare provider at your home?
* Q23. How many virtual or telemedicine visits did you have?

* Q20, Q21
list q18_q19 q21 if q21 > q18_q19 & q21 < . 
*None

list q20 q21 if q21 == 0 | q21 == 1
* None

* List if yes to q20: "all visits in the same facility" but q21: "how many different healthcare facilities did you go to" is more than 0
list q20 q21 if q20 ==1 & q21 > 0 & q21 < . 
* None

* Q28a, Q28b 
* list if they say "I did not get healthcare in past 12 months" but they have visit values in past 12 months - Note: q28_a and q28_b in this dataset does not have this option
egen visits_total = rowtotal(q18_q19 q22 q23) 
list visits_total q17 if q17 == 5 & visits_total > 0 & visits_total < . | q17 == 5 & visits_total > 0 & visits_total < .

recode q17 (5 = .r) if visits_total > 0 & visits_total < . // N=19 changes

drop visits_total

*------------------------------------------------------------------------------*
* Recode missing values to NA for intentionally skipped questions (q14, q32 missing in this dataset)

* q1
recode q1 (. = 80) if q2 == 7

* q7 
recode q7 (. = .a) if q6 !=1
recode q7 (nonmissing = .a) if q6 == 0

* pregnancy/contraception qs
recode q11_a q41e_ch_ro q41f_ch_ro q27k_ch_de_ro q29b_ch_ro (. = .a) if q3 != 1 | q1 > 49

*q14-17
recode q14_multi q15 q16 q17 (. = .a) if q13 !=1
recode q15 (. = .r) if q13 == 1
recode q17_b q17_c q17_d m2_ch_ro (. = .a) if q1 >= 20 
recode m3_ch_ro (. = .a) if m2_ch_ro != 1

* NA's for q19-21 
recode q20 (. = .a) if q18 <1 | q18 == 1 |q18 == .d | q18 == .r
recode q21 (. = .a) if q20 !=0 

*q24-q25 
recode q24 q25 (. = .a) if q23 == 0  | q23 == .d | q23 == .r
recode q24 (. = .r) if q23 != 0 

* q27_b q27_c q27i_ch_de_ro
recode q27_b q27_c (. = .a) if q3 !=1 
recode q27_b q27_c (. = .r) if q3 == 1
recode q27i_ch_de_ro (. = .a) if q1 <= 49

*q28
recode q28_a q28_b (. = .a) if q18 == 0 | q18 == .d | q18 == .r | q19 == 0 | q19 == .d | ///
							   q19 == .r | q22 == 0 | q22 == .d | q22 == .r | ///
							   q23 == 0 | q23 == .d | q23 == .r

* q30
recode q30 (. = .a) if q29 !=1

* q33-38
recode q33 q34 q35 q36 q37 q38_a q38_b q38_c q38_d q38_e q38_f /// 
	   q38_g q38_h q38_i q38_j q38_k q38_l_ch_ro q38_m_ro q39 (. = .a) if q18 == 0 | q18 == .d | q18 == .r | ///
													 q19 == 0 | q19 == .d | q19 == .r
					
recode q33 (. = .r) if q18 != 0 | q18 != .d | q18 != .r | q19 != 0 | q19 != .d | q19 != .r
replace q38_e = .a if q38_e == 5  // I have not had prior visits or tests or The clinic had no other staff
replace q38_j = .a if q38_j == 6  // I have not had prior visits or tests or The clinic had no other staff													 

recode q36 q38_i q38_k (. = .a) if q35 !=1

*------------------------------------------------------------------------------*

* Other specify recode 
* This command recodes all "other specify" variables as listed in /specifyrecode_inputs spreadsheet
* This command requires an input file that lists all the variables to be recoded and their new values
* The command in data quality checks below extracts other, specify values 


foreach i in 19 {

ipacheckspecifyrecode using "$in_out/Input/specifyrecode_inputs/specifyrecode_inputs_`i'.xlsx",	///
	sheet(other_specify_recode)							///	
	id(respondent_id)	
 
}	

*------------------------------------------------------------------------------*/

* Recode values and value labels:
* Recode values and value labels so that their values and direction make sense:

recode q5 (19001 = 19020 "RO: Village/locality") ///
		  (19002 = 19021 "RO: City") ///
		  (.a = .a "NA") (.d = .d "Don't know") (.r = .r "Refused"), pre(rec) label(q5_label)
drop q5
		  
lab def q7_label 19031 "RO: Mandatory social health insurance only (CAS)" 19032 "RO: Both mandatory social health insurance and private health insurance" 19033 "RO: Both mandatory social health insurance and private medical subscription" ///
19034 "RO: Private insurance" 19995 "RO: Other" ///
.a "NA" .r "Refused" .d "Don't know"
lab val q7 q7_label

recode q8 (19002 = 19053 "RO: Primary (I-IV)") ///
		  (19003 = 19054 "RO: Secondary (V-VIII)") ///
		  (19004 = 19055 "RO: High school/Vocational school") ///
		  (19005 = 19055 "RO: High school/Vocational school") ///
		  (19006 = 19056 "RO: Post-secondary school") ///
		  (19007 = 19057 "RO: University degree") ///
		  (19008 = 19058 "RO: Postgraduate degree") ///
		  (.a = .a "NA") (.d = .d "Don't know") (.r = .r "Refused"), pre(rec) label(q8_label)
drop q8
		  
lab val q11_a q13 q17_b q17_c q17_d q17g_ch_ro q28_a q28_b q31a q31b yesno

recode q14_multi (1 = 1 "Public") ///
		  (2 = 2 "Private (for-profit)") ///
		  (3 = 4 "Other(specify)") ///
		  (4 = 3 "NGO/Faith-based ") ///
		  (5 = 4 "Other(specify)") ///
		  (.a = .a "NA") (.d = .d "Don't know") (.r = .r "Refused"), pre(rec) label(q14_label)
drop q14_multi
			
recode q16 (.d = 22)

recode q17 (5 = .a)
label copy q36 rating
lab val q17 q25 q38_a q38_b q38_c q38_d q38_f q38_g q38_h q38_i q38_k q38_l_ch_ro q38_m_ro q42 q43 q44_multi q48 q49 rating

label copy health5 q40_label
lab val q40_a q40_b q40_c q40_d q40_label

lab def q19_label 0 "0" 1 "1-4" 2 "5-9" 3 "10 or more" ///
.a "NA" .r "Refused" .d "Don't know"
lab val q19 q19_label

label define q24lbl ///
            1 "Care for an urgent or new health problem such as an accident or injury or a new symptom like fever, pain, diarrhea, or depression." ///
            2 "Follow-up care for a longstanding illness or chronic disease such as hypertension or diabetes. This may include mental health conditions." ///
            3 "Preventive care or a visit to check on your health, such as an annual check-up, antenatal care, or vaccination." ///
            4 "Other (specify)" ///
			.a "NA" .r "Refused" .d "Don't know", add
lab values q24 q34 q24lbl

recode q30 (4 = 1 "High cost (e.g., high out of pocket payment, not covered by insurance)") ///
		   (2 = 2 "Far distance (e.g., too far to walk or drive, transport not readily available)") ///
		   (8 = 3 "Long waiting time (e.g., long line to access facility, long wait for the provider)") ///
		   (11 = 4 "Poor healthcare provider skills (e.g., spent too little time with patient, did not conduct a thorough exam)") ///
		   (5 = .r "Refused") ///
		   (12 = 5 "Staff don't show respect (e.g., staff is rude, impolite, dismissive)") ///
		   (9 = 6 "Medicines and equipment are not available (e.g., medicines regularly out of stock, equipment like X-ray machines broken or unavailable)") ///
		   (6 = 7 "Illness not serious enough") (10 = 10 "Other") ///
		   (3 = 13 "RO: Fear of examination/medical procedure") ///
		   (7 = 14 "RO: Lack of trust in doctors/procedures") ///
		   (1 = 15 "RO: Concern about informal payments/gifts") ///
		   (.a = .a "NA") (.d = .d "Don't know") (.r = .r "Refused"), pre(rec) label(q30_label)
drop q30

recode q45 (3 = 0) ///
           (2 = 1) ///
           (1 = 2)

label define q45_label 0 "Getting worse" ///
                      1 "Staying the same" ///
                      2 "Getting better"
lab val q45 q45_label

label copy q70 q35_label
label copy q71 q36_label
label copy q72 q37_label
lab val q35 q35_label
lab val q36 q36_label
lab val q37 q37_label


recode q45 (3 = 0) (2 = 1) (1 = 2)
lab def q45_label 0 "Getting worse" 1 "Staying the same" 2 "Getting better" 
lab val q45 q45_label


lab define q46_label 1 "Our healthcare system has so much wrong with it that we need to completely rebuild it." ///
	2 "There are some good things in our healthcare system, but major changes are needed to make it work better." ///
	3 "On the whole, the system works pretty well and only minor changes are necessary to make it work better." ///
	.a "NA" .r "Refused" .d "Don't know", add

lab val q46 q46_label

lab def q50_label 19091 "RO: Romanian" 19092 "RO: Hungarian" 19093 "RO: German" 19995 "RO: Other" .a "NA" .r "Refused" .d "Don't know"
lab val q50 q50_label

recode q51 (1 = 19068 "RO: < 1.500 lei") ///
		   (2 = 19169 "RO: 1501 - 3000 lei") ///
		   (3 = 19169 "RO: 1501 - 3000 lei") ///
		   (4 = 19170 "RO: 3001 - 6000 lei") ///
		   (5 = 19170 "RO: 3001 - 6000 lei") ///
		   (6 = 19170 "RO: 3001 - 6000 lei") ///
		   (7 = 19171 "RO: 6001 - 10000 lei") ///
		   (8 = 19171 "RO: 6001 - 10000 lei") ///
		   (9 = 19171 "RO: 6001 - 10000 lei") ///
		   (10 = 19171 "RO: 6001 - 10000 lei") ///
		   (11 = 19172 "RO: 10001 - 15000 lei") ///
		   (12 = 19172 "RO: 10001 - 15000 lei") ///
		   (13 = 19172 "RO: 10001 - 15000 lei") ///
		   (14 = 19172 "RO: 10001 - 15000 lei") ///
		   (15 = 19172 "RO: 10001 - 15000 lei") ///
		   (16 = 19174 "RO: Over 15000 lei") ///
		   (.a = .a "NA") (.d = .d "Don't know") (.r = .r "Refused"), pre(rec) label(q51_label)
drop q51

lab def m1_label 0 "Not at all" 1 "Several days" 2 "More than half the days" 3 "Nearly every day" .a "NA" .r "Refused" .d "Don't know"
lab val m1_a m1_b m1_c_ch_ro m1_d_ch_ro m1_label

recode m3_ch_ro (1 = 1 "School nurse or doctor") ///
				(2 = 2 "Family doctor, general practitioner, or pediatrician's office") ///
				(3 = 2 "Family doctor, general practitioner, or pediatrician's office") ///
				(4 = 3 "Psychologist or psychiatrist's office") ///
				(7 = 7 "Other (Specify)") ///
		   (.a = .a "NA") (.d = .d "Don't know") (.r = .r "Refused"), pre(rec) label(m3_ch_ro_label)
drop m3_ch_ro

rename rec* *
 
* Add value labels 
label define q2_label 1 "18 to 29" 2 "30-39" 3 "40-49" 4 "50-59" 5 "60-69" 6 "70-79" 7 "80 or older" .a "NA" .d "Don't know" .r "Refused",modify
label define q3 0 "Male" 1 "Female" 2 "Another gender" .a "NA" .d "Don't know" .r "Refused", modify
label define q8_label 19052 "RO: None", modify
label define yesno .a "NA" .d "Don't know" .r "Refused",modify
label define confident4 .a "NA" .d "Don't know" .r "Refused",modify
label define q33 .a "NA" .d "Don't know" .r "Refused",modify
label define q15_label .a "NA" .d "Don't know" .r "Refused",modify
label define q35 22 "Confidentiality of care" .a "NA" .d "Don't know" .r "Refused",modify
label define rating .a "NA" .d "Don't know" .r "Refused",modify
label define q33_label .a "NA" .d "Don't know" .r "Refused",modify
label define q35_label .a "NA" .d "Don't know" .r "Refused",modify
label define q36_label 1 "Same or next day" .a "NA" .d "Don't know" .r "Refused",modify
label define q37_label .a "NA" .d "Don't know" .r "Refused",modify
label define q73 .a "NA or I have not had prior visits or tests or the clinic had no other staff" .d "Don't know" .r "Refused",modify
label define q40_label .a "NA" .d "I am unable to judge" .r "Refused",modify
label define q45_label .a "NA" .d "Don't know" .r "Refused",modify
label define m3_ch_ro_label 4 "Phone-based service" 5 "Online-based service",modify

label drop q13 health5 q18 q97 q95 q94 q72 q71 q70 q69 health5dk yesno_r recq30 

*------------------------------------------------------------------------------*
* Renaming variables 
*for appending process:
label copy q3 gender2
label copy q4_label q4_label2
label copy q5_label q5_label2
label copy q15_label q15_label2
label copy q33_label q33_label2
label copy q50_label q50_label2
label copy q51_label q51_label2

label val q4 q4_label2
label val q5 q5_label2
label val q15 q15_label2
label val q33 q33_label2
label val q50 q50_label2
label val q51 q51_label2

label drop q4_label q5_label q15_label q33_label q50_label q51_label

*------------------------------------------------------------------------------*

* Reorder variables
	order m1_a m1_b m1_c_ch_ro m1_d_ch_ro m2_ch_ro m3_ch_ro m3_ch_ro_other
	order q*, sequential
	order respondent_serial respondent_id date int_length mode country wave language weight

*------------------------------------------------------------------------------*

* Save data
save "$data_mc/02 recoded data/input data files/pvs_ro_wave2.dta", replace

*------------------------------------------------------------------------------*
