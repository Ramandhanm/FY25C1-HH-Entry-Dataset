********************FY25C1 HH Entry Survey DQR OCT/Nov 2024 ******************************************
/*
	purpose of DQR: 
	-Check correct visit detail was selected and reasons for surveys not being completed
	-Investigate any duplicate surveys 
	-Create a time difference variable based on timestamps 
	-Check the number of household members stated versus the actual number of members listed
	-Separate data into functional datasets 
	-Check key variables for any data quality issues or missing data 
	-Confirm all households in sample have been surveyed 
*/

import delimited "C:\Users\RamandhanMasudi\Desktop\FY25C1 Entry Dataset\FY25C1 Household Entry Survey Part 1 (v1)_1_2204.csv", varnames(2)
des,short
ta office,mi
keep if office=="Yumbe"
ta survey_type,mi
ta no_interview,mi
duplicates report hh_id
duplicates tag hh_id, gen(dups)
ta dups
li mobileuser timestamp_started bm_cycle hh_id hh_name date if dups>=1
/*
     +-------------------------------------------------------------------------------------------------------+
     |    mobileuser            timestamp_started               bm_cycle    hh_id       hh_name         date |
     |-------------------------------------------------------------------------------------------------------|
160. | Nadia Manzubo   2024-09-23 12:02:00.000+03   FY25C1 Annet Eyotaru   536803   Dawa Ramula   2024-09-23 |
162. | Nadia Manzubo   2024-09-23 12:59:00.000+03   FY25C1 Annet Eyotaru   536803   Dawa Ramula   2024-09-23 |
     +-------------------------------------------------------------------------------------------------------+
*/
drop if timestamp_started=="2024-09-23 12:59:00.000+03" & hh_id==536803  //first data collected is the correct
	
save "C:\Users\RamandhanMasudi\Desktop\FY25C1 Entry Dataset\FY25C1 Household Entry Survey Part 1",replace
clear
import delimited "C:\Users\RamandhanMasudi\Desktop\FY25C1 Entry Dataset\FY25C1 Household Entry Survey Part 1 (v2)_1_1236.csv", varnames(2)
merge 1:1 hh_id using "C:\Users\RamandhanMasudi\Desktop\FY25C1 Entry Dataset\FY25C1 Household Entry Survey Part 1.dta",force 
ta office,mi
keep if office=="Yumbe"
*checking the time stamps

    gen str time_start = substr(startdate, 1,16)	
	gen double dt_start = clock(time_start, "YMD hm")
	format dt_start %tc
	
	gen str time_end = substr(enddate, 1,16)
	gen double dt_end = clock(time_end, "YMD hm")
	format dt_end %tc
	
	gen time_diff = minutes(dt_end - dt_start)
	ta time_diff // Check for surveys done in less than 10 min - and drop those survies		
	sum time_diff //ave 50 mins 
	bysort mobileuser : sum time_diff

*Time taken to water point
 ta minutes_walk,mi // looks fine
 
*Household savings
 ta save_currently,mi
 ta savings_amount,mi // looks fine
 
*Household Assets
 
ta mattresses,mi
ta amount_mattresses
li mobileuser bm_cycle hh_id hh_name hh_members mattresses if mattresses>4 // looks fine 
replace mattresses=0 if amount_mattresses==99
replace mattresses=0 if amount_mattresses==98
replace amount_mattresses=. if amount_mattresses==99
replace amount_mattresses=. if amount_mattresses==98

ta beds,mi
ta amount_beds
replace beds=0 if amount_beds==98
replace beds=0 if amount_beds==99
replace amount_beds=. if amount_beds==98
replace amount_beds=. if amount_beds==99

ta tables,mi
ta amount_tables,mi
replace tables=0 if amount_tables==0
replace amount_tables=. if amount_tables==0
replace tables=0 if amount_tables==98
replace tables=0 if amount_tables==99
replace amount_tables=. if amount_tables==98
replace amount_tables=. if amount_tables==98

ta chairs,mi 
ta amount_chairs,mi
replace chairs=0 if amount_chairs==99
replace amount_chairs=. if amount_chairs==99
	
ta televisionsets
ta amount_televisonsets,mi
replace televisionsets=0 if amount_televisonsets==99
replace amount_televisonsets=. if amount_televisonsets==99
	
br radios amount_radios mobilephones amount_mobilephones  
ta radios
ta amount_radios,mi
replace radios=0 if amount_radios==99
replace amount_radios=. if amount_radios==99
ta mobilephones,mi 
ta amount_mobilephones,mi
li mobileuser bm_cycle hh_id hh_name mobilephones amount_mobilephones if amount_mobilephones>500000 // HHs all have 3 phones 
replace mobilephones=0 if amount_mobilephones==98
replace mobilephones=0 if amount_mobilephones==99
replace amount_mobilephones=. if amount_mobilephones==98
replace amount_mobilephones=. if amount_mobilephones==99  	 	 	 	
	
ta bicycles,mi 
ta amount_bicycles,mi 
replace bicycles=0 if amount_bicycles==99
replace amount_bicycles=. if amount_bicycles==99

ta ironbox,mi 
ta amount_ironboxes,mi
replace ironbox=0 if ironbox==. 
replace ironbox=0 if amount_ironboxes==0
replace amount_ironboxes=. if amount_ironboxes==0
replace ironbox=0 if amount_ironboxes==99
replace amount_ironboxes=. if amount_ironboxes==99	

ta cookstoves,mi 
ta amount_cookstoves,mi
replace cookstoves=0 if cookstoves==.
replace cookstoves=0 if amount_cookstoves==99
replace amount_cookstoves=. if amount_cookstoves==99	
	
ta solarpanels,mi
ta amount_solarpanels,mi
replace solarpanels=0 if amount_solarpanels==0
replace amount_solarpanels=. if amount_solarpanels==0
replace solarpanels=0 if amount_solarpanels==99
replace amount_solarpanels=. if amount_solarpanels==99	

ta lamps,mi 
ta amount_lamps,mi
li mobileuser bm_cycle hh_id hh_name hh_members lamps amount_lamps if amount_lamps>=50000
replace lamps=0 if amount_lamps==99
replace amount_lamps=. if amount_lamps==99
replace amount_lamps=10000 if amount_lamps==100000 // Enumerator typing error
	
ta motorcycles,mi 
ta amount_motorcycles, mi
replace motorcycles=0 if amount_motorcycles==99
replace amount_motorcycles=. if amount_motorcycles==99	
    
ta jewellery
ta amount_jewellery,mi 
replace jewellery=0 if amount_jewellery==99
replace amount_jewellery=. if amount_jewellery==99
	
ta cookingpots,mi
ta amount_cookingpots,mi
replace cookingpots=0 if amount_cookingpots==0
replace cookingpots=0 if amount_cookingpots==98
replace cookingpots=0 if amount_cookingpots==99
replace amount_cookingpots=. if amount_cookingpots==0
replace amount_cookingpots=. if amount_cookingpots==98
replace amount_cookingpots=. if amount_cookingpots==99
	
ta jerrycans,mi
ta amount_jerrycans,mi
br mobileuser bm_cycle hh_id hh_name jerrycans amount_jerrycans if amount_jerrycans>=40000
replace amount_jerrycans=6000 if hh_id==522108 // typing error
replace jerrycans=0 if amount_jerrycans==99
replace amount_jerrycans=. if amount_jerrycans==99
		
ta hoes,mi 
ta amount_hoes,mi
li bm_cycle hh_id hh_name hoes amount_hoes if amount_hoes>=50000 // figures make sense
replace hoes=0 if amount_hoes==99
replace amount_hoes=. if amount_hoes==99
replace amount_hoes=2000 if amount_hoes==2  // typing error
replace amount_hoes=6900 if amount_hoes==69 // typing error

ta pangas,mi 
ta amount_pangas,mi
li bm_cycle hh_id hh_name pangas amount_pangas if amount_pangas>=10000
replace amount_pangas=2000 if amount_pangas==2
replace pangas=0 if amount_pangas==0
replace amount_pangas=. if amount_pangas==0
replace pangas=0 if amount_pangas==99
replace amount_pangas=. if amount_pangas==99
	
ta cattle,mi 
ta amount_cattle,mi 
br bm_cycle hh_id hh_name cattle amount_cattle 
replace cattle=0 if cattle==16000  // typing error
replace amount_cattle=. if amount_cattle==0
	
ta goats,mi 
ta amount_goats,mi
br bm_cycle hh_id hh_name goats amount_goats if amount_goats>=100000 // figures match with the no. of goats
replace goats=0 if amount_goats==99
replace amount_goats=. if amount_goats==99
 
	
ta sheep,mi 
ta amount_sheep,mi
li bm_cycle hh_id hh_name sheep amount_sheep if amount_sheep>=100000 // looks fine
replace sheep=0 if amount_sheep==99
replace amount_sheep=. if amount_sheep==99
	
ta pigs,mi 
ta amount_pigs,mi
br hh_id hh_name pigs amount_pigs // looks fine
replace pigs=0 if amount_pigs==0
replace amount_pigs=. if amount_pigs==0	
	
ta chicken,mi
ta amount_chicken,mi 
br hh_id hh_name chicken amount_chicken //looks fine
replace chicken=10 if chicken==10000
replace chicken=0 if amount_chicken==98
replace chicken=0 if amount_chicken==99
replace amount_chicken=. if amount_chicken==98
replace amount_chicken=. if amount_chicken==99
	
ta otheranimals,mi 
ta amount_otheranimals,mi
replace otheranimals=0 if amount_otheranimals==99
replace amount_otheranimals=. if amount_otheranimals==99

		
*Household Loans & Business Loans**************

ta total_value_loans_friend,mi
li mobileuser bm_cycle hh_id hh_name total_value_loans_friend if total_value_loans_friend==8
/*
     +--------------------------------------------------------------------------+
     |    mobileuser              bm_cycle    hh_id          hh_name   total_~d |
     |--------------------------------------------------------------------------|
 23. | Amina Drateru   FY25C1 Fauzu Ajidra   519972   Jennifer Nyoka          8 |
     +--------------------------------------------------------------------------+
*/
replace total_value_loans_friend=8000 if total_value_loans_friend==8

ta total_value_loans_traders,mi
li mobileuser bm_cycle hh_id hh_name total_value_loans_traders if total_value_loans_traders==3
/*
     +---------------------------------------------------------------------------------+
     |            mobileuser                  bm_cycle    hh_id     hh_name   total~rs |
     |---------------------------------------------------------------------------------|
 37. | Caroline Dawa Godfrey   FY25C1 Glorious Ayikoru   536428   Lona Kadi          3 |
     +---------------------------------------------------------------------------------+
*/
replace total_value_loans_traders=3000 if total_value_loans_traders==3

ta total_value_loans_workplace,mi // looks fine
ta total_value_loans_cooperative,mi 
ta total_value_loans_lender,mi
ta total_value_loans_brac,mi
ta total_value_loans_otherngos,mi
ta total_value_loans_mfi,mi
ta total_value_loans_privatebank,mi
ta total_value_loans_govtbank,mi
li mobileuser bm_cycle hh_id hh_name total_value_loans_govtbank if total_value_loans_govtbank==8
/*
     +-----------------------------------------------------------------------------------+
     |     mobileuser                bm_cycle    hh_id                hh_name   to~tbank |
     |-----------------------------------------------------------------------------------|
247. | Phillimon Waka   FY25C1 Modnes Akandru   535325   Christine Sunday Awa          8 |
     +-----------------------------------------------------------------------------------+
*/
replace total_value_loans_govtbank=0 if total_value_loans_govtbank==8
ta total_value_loans_othersources,mi

** Family Dynamics
ta has_any_member_of_the_household_,mi
ta how_many_hh_members_away,mi         // looks fine

**Household Consumption & Expenditure

*reshaping data from wide to long
br
drop consumption_pasta ucode_pasta quantity_pasta ucost_pasta

reshape long consumption_ quantity_ ucode_ ucost_, i(hh_id) j(product) string 
ta product, m
order product, after(bm_cycle)

ta consumption_rice if 
ta quantity_rice,mi
ta ucode_rice,mi 
ta ucost_rice,mi
br mobileuser hh_id hh_name consumption_rice quantity_rice ucode_rice ucost_rice
replace ucost_rice=1500 if hh_id==520679
replace ucost_rice=2000 if hh_id==519299

ta consumption_maizeflour,mi 
ta quantity_maizeflour,mi 
ta ucode_maizeflour,mi 
ta ucost_maizeflour,mi
br mobileuser hh_id hh_name consumption_maizeflour quantity_maizeflour ucode_maizeflour ucost_maizeflour
replace consumption_maizeflour="No" if ucost_maizeflour==99
replace quantity_maizeflour=. if ucost_maizeflour==99
replace quantity_maizeflour=1 if quantity_maizeflour==99 
replace consumption_maizeflour="No" if ucost_maizeflour==98
replace quantity_maizeflour=. if ucost_maizeflour==98
replace ucode_maizeflour=" " if  ucost_maizeflour==98
replace ucode_maizeflour=" " if  ucost_maizeflour==99
replace ucost_maizeflour=. if ucost_maizeflour==99
replace ucost_maizeflour=. if ucost_maizeflour==98

ta consumption_maizecobs,mi
ta quantity_maizecobs,mi
ta ucode_maizecobs,mi
ta ucost_maizecobs,mi
br mobileuser hh_id hh_name consumption_maizecobs quantity_maizecobs ucode_maizecobs ucost_maizecobs
replace ucode_maizecobs="Whole" if hh_id==522235
replace ucode_maizecobs="Whole" if hh_id==520679
replace ucost_maizecobs=1000 if hh_id==520934
replace quantity_maizecobs=1 if hh_id==503295

ta consumption_millet,mi
ta quantity_millet,mi
ta ucode_millet,mi
ta ucost_millet,mi
br mobileuser hh_id hh_name consumption_millet quantity_millet ucode_millet ucost_millet // looks fine

ta consumption_sorghum,mi
ta quantity_sorghum,mi
ta ucode_sorghum,mi
ta ucost_sorghum,mi
br mobileuser hh_id hh_name consumption_sorghum quantity_sorghum ucode_sorghum ucost_sorghum
replace consumption_sorghum="No" if ucost_sorghum==99
replace consumption_sorghum="No" if ucost_sorghum==98
replace quantity_sorghum=. if ucost_sorghum==99
replace ucode_sorghum=" " if ucost_sorghum==99
replace ucost_sorghum=. if ucost_sorghum==99
replace quantity_sorghum=1 if hh_id==519940
replace ucode_sorghum="Other" if hh_id==519940

ta consumption_matooke,mi
ta quantity_matooke,mi
ta ucode_matooke,mi
ta ucost_matooke,mi
br mobileuser hh_id hh_name consumption_matooke quantity_matooke ucode_matooke ucost_matooke
replace consumption_matooke="No" if hh_id==501885
replace quantity_matooke=. if hh_id==501885
replace ucode_matooke=" " if hh_id==501885
replace ucost_matooke=. if hh_id==501885

ta consumption_irishpotatoes,mi
ta quantity_irishpotatoes,mi
ta ucode_irishpotatoes,mi    // looks fine
ta ucost_irishpotatoes,mi

ta consumption_sweetpotatoes,mi
ta quantity_sweetpotatoes,mi
ta ucode_sweetpotatoes,mi
ta ucost_sweetpotatoes,mi
br mobileuser hh_id hh_name consumption_sweetpotatoes quantity_sweetpotatoes ucode_sweetpotatoes ucost_sweetpotatoes
replace consumption_sweetpotatoes="No" if hh_id==501878
replace quantity_sweetpotatoes=. if hh_id==501878
replace ucode_sweetpotatoes=" " if hh_id==501878
replace ucost_sweetpotatoes=. if hh_id==501878

ta consumption_cassava,mi
ta quantity_cassava,mi
ta ucode_cassava,mi
ta ucost_cassava,mi
br mobileuser hh_id hh_name consumption_cassava quantity_cassava ucode_cassava ucost_cassava
replace consumption_cassava="No" if ucost_cassava==99
replace consumption_cassava="No" if ucost_cassava==98
replace quantity_cassava=. if ucost_cassava==99
replace quantity_cassava=. if ucost_cassava==98
replace ucode_cassava=" " if ucost_cassava==99
replace ucode_cassava=" " if ucost_cassava==98
replace ucost_cassava=. if ucost_cassava==99
replace ucost_cassava=. if ucost_cassava==98
replace ucode_cassava="Other" if ucode_cassava=="Don't know"
replace ucode_cassava="Other" if ucode_cassava=="Goro Goro"
replace quantity_cassava=1 if quantity_cassava==99
replace quantity_cassava=5 if hh_id==522587

ta consumption_yams,mi
ta quantity_yams,mi
ta ucode_yams,mi
ta ucost_yams,mi
replace consumption_yams="No" if ucost_yams==0
replace quantity_yams=. if ucost_yams==0
replace ucode_yams=" " if ucost_yams==0
replace ucost_yams=. if ucost_yams==0

ta consumption_pumpkin,mi
ta quantity_pumpkin,mi
ta ucode_pumpkin,mi
ta ucost_pumpkin,mi
br mobileuser hh_id hh_name consumption_pumpkin quantity_pumpkin ucode_pumpkin ucost_pumpkin
replace consumption_pumpkin="No" if ucost_pumpkin==99
replace quantity_pumpkin=. if ucost_pumpkin==99
replace ucode_pumpkin=" " if ucost_pumpkin==99
replace ucost_pumpkin=. if ucost_pumpkin==99

ta consumption_carrots,mi
ta quantity_carrots,mi
ta ucode_carrots,mi        // looks fine
ta ucost_carrots,mi

ta consumption_cabbage,mi
ta quantity_cabbage,mi
ta ucode_cabbage,mi
ta ucost_cabbage,mi
br mobileuser hh_id hh_name consumption_cabbage quantity_cabbage ucode_cabbage ucost_cabbage
replace consumption_cabbage="No" if hh_id==503295
replace quantity_cabbage=. if hh_id==503295
replace ucode_cabbage=" " if hh_id==503295
replace ucost_cabbage=. if hh_id==503295
replace quantity_cabbage=1 if hh_id==520782
replace ucost_cabbage=1000 if hh_id==536898

ta consumption_localgreens,mi
ta quantity_localgreens,mi
ta ucode_localgreens,mi
ta ucost_localgreens,mi
br mobileuser hh_id hh_name consumption_localgreens quantity_localgreens ucode_localgreens ucost_localgreens
replace consumption_localgreens="No" if ucost_localgreens==99
replace consumption_localgreens="No" if ucost_localgreens==98
replace quantity_localgreens=. if ucost_localgreens==99
replace quantity_localgreens=. if ucost_localgreens==98
replace ucode_localgreens=" " if ucost_localgreens==99
replace ucode_localgreens=" " if ucost_localgreens==98
replace ucost_localgreens=. if ucost_localgreens==99
replace ucost_localgreens=. if ucost_localgreens==98
replace ucode_localgreens="Other" if ucode_localgreens=="Don't know"
replace quantity_localgreens=1 if quantity_localgreens==99
replace quantity_localgreens=1 if quantity_localgreens==98
replace quantity_localgreens=5 if quantity_localgreens==500
replace ucost_localgreens=200 if ucost_localgreens==2002

ta consumption_tomatoes,mi
ta quantity_tomatoes,mi
ta ucode_tomatoes,mi
ta ucost_tomatoes,mi
br mobileuser hh_id hh_name consumption_tomatoes quantity_tomatoes ucode_tomatoes ucost_tomatoes
replace consumption_tomatoes="No" if ucost_tomatoes==99
replace quantity_tomatoes=. if ucost_tomatoes==99
replace quantity_tomatoes=1 if quantity_tomatoes==99
replace ucode_tomatoes=" " if ucost_tomatoes==99
replace ucode_tomatoes="Other" if ucode_tomatoes=="Don't know"
replace ucost_tomatoes=. if ucost_tomatoes==99

ta consumption_onions,mi
ta quantity_onions,mi
ta ucode_onions,mi
ta ucost_onions,mi
br mobileuser hh_id hh_name consumption_onions quantity_onions ucode_onions ucost_onions
replace consumption_onions="No" if ucost_onions==99
replace quantity_onions=. if ucost_onions==99
replace ucode_onions=" " if ucost_onions==99
replace ucost_onions=. if ucost_onions==99
replace quantity_onions=1 if quantity_onions==99

ta consumption_frenchbeans,mi
ta quantity_frenchbeans,mi               // looks fine
ta ucode_frenchbeans,mi
ta ucost_frenchbeans,mi

ta consumption_eggplant,mi
ta quantity_eggplant,mi
ta ucode_eggplant,mi
ta ucost_eggplant,mi
br mobileuser hh_id hh_name consumption_eggplant quantity_eggplant ucode_eggplant ucost_eggplant
replace consumption_eggplant="No" if ucost_eggplant==99
replace quantity_eggplant=. if ucost_eggplant==99
replace ucode_eggplant=" " if ucost_eggplant==99
replace ucost_eggplant=. if ucost_eggplant==99
replace ucode_eggplant="other" if ucode_eggplant=="Don't Know"
replace quantity_eggplant=1 if quantity_eggplant==99

ta consumption_mangoes,mi
ta quantity_mangoes,mi
ta ucode_mangoes,mi            //looks fine
ta ucost_mangoes,mi

ta consumption_pawpaw,mi
ta quantity_pawpaw,mi
ta ucode_pawpaw,mi
ta ucost_pawpaw,mi
br mobileuser hh_id hh_name consumption_pawpaw quantity_pawpaw ucode_pawpaw ucost_pawpaw
replace consumption_pawpaw="No" if ucost_pawpaw==99
replace quantity_pawpaw=. if ucost_pawpaw==99
replace ucode_pawpaw=" " if ucost_pawpaw==99
replace ucost_pawpaw=. if ucost_pawpaw==99

ta consumption_avocados,mi
ta quantity_avocados,mi
ta ucode_avocados,mi                     // looks fine
ta ucost_avocados,mi
br mobileuser hh_id hh_name consumption_avocados quantity_avocados ucode_avocados ucost_avocados

ta consumption_oranges,mi
ta quantity_oranges,mi     //looks fine
ta ucode_oranges,mi
ta ucost_oranges,mi

ta consumption_passionfruit,mi
ta quantity_passionfruit,mi     // looks fine
ta ucode_passionfruit,mi
ta ucost_passionfruit,mi

ta consumption_melons, 
ta quantity_melons,mi      
ta ucode_melons,mi             //looks fine
ta ucost_melons,mi

ta consumption_grams,mi
ta quantity_grams,mi
ta ucode_grams,mi
ta ucost_grams,mi

ta consumption_ripebananas,mi
ta quantity_ripebananas,mi
ta ucode_ripebananas,mi
ta ucost_ripebananas,mi
br mobileuser hh_id hh_name consumption_ripebananas quantity_ripebananas ucode_ripebananas ucost_ripebananas
replace quantity_ripebananas=1 if quantity_ripebananas==99
replace ucode_ripebananas="Other" if ucode_ripebananas=="Don't know"

ta consumption_otherfruitveg,mi
ta specify_otherfruitveg_descri,mi
ta quantity_otherfruitveg,mi
ta ucode_otherfruitveg,mi
ta ucost_otherfruitveg,mi
br mobileuser hh_id hh_name consumption_otherfruitveg specify_otherfruitveg_descri quantity_otherfruitveg ucode_otherfruitveg ucost_otherfruitveg
replace specify_otherfruitveg_descri="Guava" if specify_otherfruitveg_descri=="6"
replace quantity_otherfruitveg=1 if quantity_otherfruitveg==99
replace ucode_otherfruitveg="Other" if ucode_otherfruitveg=="Don't know"

ta consumption_offalsmatumbo,mi
ta quantity_offalsmatumbo,mi
ta ucode_offalsmatumbo,mi                       // looks fine
ta ucost_offalsmatumbo,mi
br mobileuser hh_id hh_name consumption_offalsmatumbo quantity_offalsmatumbo ucode_offalsmatumbo ucost_offalsmatumbo

ta consumption_chicken,mi
ta quantity_chicken,mi
ta ucode_chicken,mi           //looks fine
ta ucost_chicken,mi

ta consumption_pork,mi
ta quantity_pork,mi
ta ucode_pork,mi               // looks fine
ta ucost_pork,mi

ta consumption_beefmuttongoat,m
ta quantity_beefmuttongoat,mi
ta ucode_beefmuttongoat,mi           //looks fine
ta ucost_beefmuttongoat,mi

ta consumption_fish,mi
ta quantity_fish,mi
ta ucode_fish,mi
ta ucost_fish,mi
ta consumption_silverfish,mi
ta quantity_silverfish,mi
ta ucode_silverfish,mi
ta ucost_silverfish,mi
br mobileuser hh_id hh_name consumption_fish quantity_fish ucode_fish ucost_fish consumption_silverfish quantity_silverfish ucode_silverfish ucost_silverfish
replace consumption_fish="No" if ucost_fish==99
replace quantity_fish=. if ucost_fish==99
replace ucode_fish=" " if ucost_fish==99
replace ucost_fish=. if ucost_fish==99
replace consumption_silverfish="No" if ucost_silverfish==99
replace quantity_silverfish=. if ucost_silverfish==99
replace ucode_silverfish=" " if ucost_silverfish==99
replace ucost_silverfish=. if ucost_silverfish==99
replace quantity_silverfish=1 if hh_id==520925

ta consumption_eggs,mi
ta quantity_eggs,mi
ta ucode_eggs,mi
ta ucost_eggs,mi
br mobileuser hh_id hh_name consumption_eggs quantity_eggs ucode_eggs ucost_eggs
replace ucost_eggs=500 if hh_id==531741
replace ucost_eggs=500 if ucost_eggs==2000

ta consumption_milk,mi
ta quantity_milk,mi
ta ucode_milk,mi
ta ucost_milk,mi                     //looks fine
ta consumption_yoghurtcream,mi
ta quantity_yoghurtcream,mi
ta ucode_yoghurtcream,mi
ta ucost_yoghurtcream,mi

ta consumption_nuts,mi
ta quantity_nuts,mi
ta ucode_nuts,mi
ta ucost_nuts,mi
br mobileuser hh_id hh_name consumption_nuts quantity_nuts ucode_nuts ucost_nuts
replace consumption_nuts="No" if ucost_nuts==99
replace quantity_nuts=1 if quantity_nuts==99
replace ucode_nuts="Other" if hh_id==520757
replace quantity_nuts=. if ucost_nuts==99
replace ucode_nuts=" " if ucost_nuts==99
replace ucost_nuts=. if ucost_nuts==99

ta consumption_beans,mi
ta quantity_beans,mi
ta ucode_beans,mi
ta ucost_beans,mi
ta consumption_soyabeans,mi
ta quantity_soyabeans,mi
ta ucode_soyabeans,mi
ta ucost_soyabeans,mi
ta consumption_peas,mi
ta quantity_peas,mi
ta ucode_peas,mi
ta ucost_peas,mi
ta consumption_cowpeas,mi
ta quantity_cowpeas,mi
ta ucode_cowpeas,mi
ta ucost_cowpeas,m
br mobileuser hh_id hh_name consumption_beans quantity_beans ucode_beans ucost_beans consumption_soyabeans quantity_soyabeans ucode_soyabeans ucost_soyabeans consumption_peas quantity_peas ucode_peas ucost_peas consumption_cowpeas quantity_cowpeas ucode_cowpeas ucost_cowpeas
replace consumption_beans="No" if ucost_beans==99
replace consumption_beans="No" if ucost_beans==98
replace quantity_beans=. if ucost_beans==99
replace quantity_beans=. if ucost_beans==98
replace ucode_beans=" " if inlist(ucost_beans,99, 98)
replace ucode_beans=" " if ucost_beans==98
replace ucost_beans=. if ucost_beans==99
replace ucost_beans=. if ucost_beans==98
replace quantity_beans=1 if quantity_beans==99
replace ucost_beans=2000 if hh_id==536797
replace quantity_soyabeans=. if ucost_soyabeans==99
replace ucode_soyabeans=" " if ucost_soyabeans==99
replace ucost_soyabeans=. if ucost_soyabeans==99
replace consumption_peas="No" if ucost_peas==99
replace quantity_peas=. if ucost_peas==99
replace ucode_peas=" " if ucost_peas==99
replace ucost_peas=. if ucost_peas==99
replace consumption_cowpeas="No" if ucost_cowpeas==99
replace quantity_cowpeas=. if ucost_cowpeas==99
replace ucode_cowpeas=" " if ucost_cowpeas==99
replace ucost_cowpeas=. if ucost_cowpeas==99

ta consumption_cookingoil,mi
ta quantity_cookingoil,mi
ta ucode_cookingoil,mi
ta ucost_cookingoil,mi
br mobileuser hh_id hh_name consumption_cookingoil quantity_cookingoil ucode_cookingoil ucost_cookingoil
