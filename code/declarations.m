! This module contains:
!   - Declaration and assignment of all exogenouns data
!   - Declaration of all variables used in the model

! ************* DEFINITION OF EXOGENOUS DATA *************
INTEGER 
	Active_Eol_lowtech[NRC,4](t)			= FILE("../data/exogenous/data/Active_EoL_lowtech.dat"),		! -		Active End of life options if GDPpc is below 10000 USD/cap
	Active_Eol_hitech[NRC,4](t)				= FILE("../data/exogenous/data/Active_EoL_hitech.dat");		    ! -		All EoL options are active (for GDPpc above 10000 USD/cap

REAL 	
	ConvCostPRIMNE_in[PLASTICFEED](t)		= FILE("../data/exogenous/data/ConvCostPRIMNE_in.dat"),		    ! $2005/GJ-feed 	Cap+OM cost for conversion of PRIM to FEED, annualized
	ConvCostFEEDNE_in[PLASTICFEED](t)	    = FILE("../data/exogenous/data/ConvCostFEEDNE_in.dat"),		    ! $/GJ-HVC 		Cap+OM cost for conversion of FEED to HVC, annualized
    ConvEnUsePRIMNE_in[NEC](t)		        = FILE("../data/exogenous/data/ConvEnUsePRIMNE_in.dat"),	    ! GJ-UE/GJ-feed 	Fossil energy requirement to produce feedstocks
	ConvEnUSEFEEDNE_in[PLASTICFEED](t)	    = FILE("../data/exogenous/data/ConvEnUseFEEDNE_in.dat"),	    ! GJ-UE/GJ-HVC 		Fossil energy requirement to produce HVC
	RegionSizeNet[NRC]                      = FILE("../data/exogenous/data/regionsizenet.dat"),             ! Ha      	Usable area
	Active_Eol_hist[NRC,4](t)				= FILE("../data/exogenous/data/Active_EoL_hist.dat"),		    ! Historic (up to 2017) active EoL; Pyrolysis only in Japan; WtE in EU, Japan, USA, Canada starting 1980; WtE in China starting 2000, WtE starting India & SOuth-east asia in 2010
	PlasticDemGlobHist[1,1](t)				= FILE("../data/exogenous/data/PlasticDemGlobHist.dat"),		! Historic global plastic demand in PJ (from regressions based on Geyer et al 2017)
	PlaSec[PS,2]							= FILE("../data/exogenous/data/PlaSec.dat"),					! PS=8 plastic sectors; column 1 = Share of plastic sector, 2= mean lifetime of plastic in a sector (all data from Geyer et al 2017)
	PlaSec_LTE[PS,2]						= FILE("../data/exogenous/data/PlaSec_LTE.dat"),				! same as above but with life time extension for scenario analysis
	PPLD[90,PS]								= FILE("../data/exogenous/data/PPLD.dat"),					    ! Plastic Product lifetime distribution by sector: Shares of plastics produced in year t-x becoming waste in year t
	PPLD_LTE[90,PS]							= FILE("../data/exogenous/data/PPLD_LTE.dat"),				    ! Plastic Product lifetime distribution by sector for the LTE scenario (life time extension): Shares of plastics produced in year t-x becoming waste in year t
	PPLD_short[90,PS]						= FILE("../data/exogenous/data/PPLD_short.dat"),				! Plastic Product lifetime distribution by sector: Shares of plastics produced in year t-x becoming waste in year t; Sensitivity, 30% shorter mean lifetime
	PPLD_long[90,PS]						= FILE("../data/exogenous/data/PPLD_long.dat"),				    ! Plastic Product lifetime distribution by sector: Shares of plastics produced in year t-x becoming waste in year t; Sensitivity, 30% longer mean lifetime
	PlaDemFac[26,PS](t)						= FILE("../data/exogenous/data/PlaDemFac.dat"),				    ! Factor to change plastic demand for each sector (used in low demand scenario)
	PlaWa_EoL[3,3]							= FILE("../data/exogenous/data/PlaWa_EoL.dat"), 				! Cost & energy use data for waste treatment technologies: 
																									        ![3,]: 1= Mechanical Recycling, 2= Waste to Energy, 3= Landfilling; 
																									        ![,3] 1= Costs in 2005 USD/GJ plastic waste, 2= Electricity use/benefit in GJ/GJ plastic waste, 3= Heat use/benefit in GJ/GJ plastic (excemption: Landfilling [3,3] which is diesel use in GJ/GJ plastic)
	EoL_Mshare_Hist[NRC,EOL](t)				= FILE("../data/exogenous/data/EoL_Mshare_Hist.dat"),		    ! Historic shares of plastic waste sent to mech. recycling, WtE, chem. rec. & landfilling; 
																									        ! Available only for USA, Japan and Europe (assumed same for Regions 11 & 12); Data gaps filled via linear interpolation; Where no data before 1980 is available, it is assumed that all plastic waste went to landfilling
																									        ! Sources: PlasticsEurope, American Chemistry Council, Plastic Waste Management Institute (Japan)
	CollRate(pp)							= FILE("../data/exogenous/data/CollRate.dat");				    ! Post Consumer Waste collection rate per Income group (GNI/cap in 2005 USD assumed to equal GDP/cap); World Bank (2018): What A waste 2.0

! ************* DEFINITION OF SCENARIO DATA *************
! Defaul (SSP2 baseline) data read in here. 
! In scenario runs these are replaced with appropriate values as determine in the coupled TIMER-PLAIA model
REAL 	
    AromaticsPropC4[NRC,FOSSIL+1](t)            = FILE("../data/exogenous/scenario/AromaticsPropC4.scn"),    	! GJsec demand for feedstock energy for aromatics & refinery sourced propylene and C4
    CarbonTax[NRC](t)                           = FILE("../data/exogenous/scenario/CarbonTax.scn"),		        ! $2005 /t carbon
    CCpPlaWa[NRC](t)                            = FILE("../data/exogenous/scenario/CCpPlaWa.scn"),		        ! ! kg/GJ	Carbon content in kg per GJ plastic waste
    EffFEEDNE[NRC,PLASTICFEED](t)	            = FILE("../data/exogenous/scenario/EffFEEDNE.scn"),             ! GJ-HVC/GJ-FEED 	Efficiency of conversion of FEEDNE to HVC (GJ-HVC/GJ-FEED)
	EffPRIMNE[NRC,NEC](t)				        = FILE("../data/exogenous/scenario/EffPRIMNE.scn"),				! GJ-FEED/GJ-PRIM 	Efficiency of conversion of PRIMNE to FEEDNE (GJ-FEED/GJ-PRIM)
    EnergyRequirement_En[NRC,PLASTICFEED,3](t)	= FILE("../data/exogenous/scenario/EnergyRequirement_En.scn"),  ! GJ/GJ-HVC 		Total, 1. Heat, 2. Electricity, 3. Biomass (according to Ren)
    GDPpc[NRCT](t)				                = FILE("../data/exogenous/scenario/GDPpc.scn"),                          ! $/cap, GDP in ppp values 
    MethGross[NRC,7](t)         		        = FILE("../data/exogenous/scenario/MethGross.scn"),             ! GJ fuels for methanol demand, reorganised
    MethNet[NRC,5](t)		                    = FILE("../data/exogenous/scenario/MethNet.scn"),               ! GJ Enery carriers bound in methanol products
	NonEnFuncTot_Base[NRC,NEUF](t)              = FILE("../data/exogenous/scenario/NonEnFuncTot_Base.scn"),		! GJ		Total demand of non energy per function for baseline scenario: Following historic production capacities and their relation to GDP/cap
    NonEnTot2[NRC,8](t) 				        = FILE("../data/exogenous/scenario/NonEnTot2.scn"),             ! GJ NonEnergy demand per fuel (BSF/BLF in secondary energy terms)
    NonEnTotal1[NRC,8](t)		                = FILE("../data/exogenous/scenario/NonEnTotal1.scn"),           ! GJ Demand of fuels for NonEnergy. Historic is same as IEA  (BSF/BLF in secondary energy terms)
    Price_pHVC[NRC](t)                          = FILE("../data/exogenous/scenario/Price_pHVC.scn"),			! Regional price in USD / GJ HVC, weighted average of technology routes WITHOUT premium factors
    PriceSecFuel[NRC,NS,NEC](t) 			    = FILE("../data/exogenous/scenario/PriceSecFuel.scn"),          ! US$/GJin	Price of energy carrier (incl. totals). Includes effect of carbon price
    PriceSecFuelExclTax[NRC,NS,NEC](t)	        = FILE("../data/exogenous/scenario/PriceSecFuelExclTax.scn"),	! Price of secondary fuels without any taxes and subsidies
    PriceSecFuelNonEn[NRC,FOSSIL+2](t)		    = FILE("../data/exogenous/scenario/PriceSecFuelNonEn.scn"),     ! $(2005)/GJ, 		Energy prices including (carbon) taxes). Used for energy-for-energy only. Corrected for ActiveFuel, 1 = Coal, 2=Oil, 3=N.Gas, 4=BSF, 5=BLF
    RefiNet_noBitumen[NRC,7](t) 		        = FILE("../data/exogenous/scenario/RefiNet_noBitumen.scn"),     ! GJ, Sum of all refinery products but bitumen reorganized
    REFIShares2[4]				                = FILE("../data/exogenous/scenario/REFIShares2.scn"),           ! Update refinery shares for extended refinery products (incl. propylene & C4)
    SecBioEff_Agr[NRC,2](t) 		            = FILE("../data/exogenous/scenario/SecBioEff_Agr.scn"),         ! -		 Aggregate efficiency of conversion from biomass to biofuel, 1. BLF, 2. BSF
    StmCrGross_BioSE[NRC,7](t)		            = FILE("../data/exogenous/scenario/StmCrGross_BioSE.scn"),      ! GJ-Prim, except for BLF;
    StmCrProd[NRC,5](t) 			            = FILE("../data/exogenous/scenario/StmCrProd.scn");             ! Energy carriers bound in HVC products

DOUBLE
    LandPrice[NRC](t)                       	= FILE("../data/exogenous/scenario/LandPrice.scn");             ! $/Ha        	Price of land, using GDP per capita as an indicator for income
    

! ************* DEFINITION OF VARIABLES *************
REAL 	
! Integration of plastics
	PlasticNet[NRC,NEUF](t),					! GJ		Plastic resin demand by region and by source (NEUF) in GJ
	PlasticNetTot[NRC](t),						! GJ		Total Plastic resin demand by region (sum of sources) in GJ
	sPlasticNetTot[NRC](t),						! GJ 		Total SECONDARY = RECYCLED Plastic resin demand by region in GJ	
	pPlasticNetTot[NRC](t),						! GJ		Total PRIMARY Plastic resin demand by region in GJ (excluding recycled plastics)
	NonEnFuncTot2[NRC,NEUF](t),					! -			NEUF with extended refinery products, including propylene and C4 outputs
	NonEnFuncTot2_Base[NRC,NEUF](t),			! -			NEUF with extended refinery products, including propylene and C4 outputs
	PlasticNet_Base[NRC,NEUF](t),				! GJ		Plastic resin demand by region and by source (NEUF) in GJ
	PlasticNetTot_Base[NRC](t),					! GJ		Total Plastic resin demand by region (sum of sources) in GJ
	NonEnFuncTotNew[NRC,NEUF](t),				! -			New NEDE product aggregation, deducting plastic demand from original classification
	PlaPolymEnReq[NRC,2](t),					! GJ		Energy use for plastic polymerisation in GJ electricity (1) and heat (2) per GJ plastics; Weighted average based on Plastics Europe Eco-profiles (+ Ecoinvent) and Geyer et al 2017 for shares
	PlaPolymEnTot[NRC,8](t),					! GJ		Total energy use for polymerisation in GJ of primary plastics by energy carrier (EC1-6=0, 7= electricity, 8= heat)
	PlaTransEff[NRC](t),						! %			Efficiency of plastic transformation: plastic product / plastic resin 
	PlaTransfEnReq[NRC](t),						! GJ		Electricity requirement in GJ for transforming 1 GJ of plastic resin into a plastic product
	PlaTransfEnTot[NRC,ECP](t),					! GJ		Total energy use (only electricity) of transforming plastic resins into plastic products (required for both primary and secondary plastics)
	PLAinNEUFGross[NRC,ECP](t),					! % 		Share of plastics gross energy (without polymeristaion & EoL) in total nonen gross energy (without biomass limits)
	pPlasticGrossUp2[NRC,ECP](t),				! GJ		Total Primary energy demand in GJ for upstream primary plastic production (=monomers) before biomass limitation (excl. polymerisation)
	pPlasticGrossUp[NRC,ECP](t),				! GJ		Total Primary energy demand in GJ for upstream primary plastic production (=monomers) after biomass limitation (excl. polymerisation)
	pPlasticGross[NRC,ECP](t),					! GJ		Total Primary energy demand in GJ for primary plastic resin production after biomass limitation (incl. polymerisation)
	
	pPlasticGrossFossil[NRC](t),    			! GJ		fossil gross energy in primary plastics; excl. waste, electricity and heat as no feedstock for primary plastic
	pPlasticGrossBio[NRC](t),					! GJ		biobased gross energy in primary plastics; excl. waste, electricity and heat as no feedstock for primary plastic
	pPlasticFeed3[NRC,7](t),					! GJ		EC going into feedstocks for plastic production BEFORE biomass limitation(ignoring process energy, e.g. StmCrEn)
	PLAinNEUFfeed[NRC,ECP](t),					! % 		share of plastic feedstock energy carriers in total nonen gross energy (without biomass limits, without polymeristaion & EoL)
	pPlasticFeed[NRC,7](t),						! GJ prim	EC going into feedstocks for plastic production AFTER biomass limitation; BSF and BLF now in primary energy terms as well
	pPlasticFeedTot[NRC](t),					! GJ prim	Total feedstock energy carriers for primary plastics
	pPlasticShares[NRC,5](t),					! %			shares of feedstock energy carriers in primary plastics (Coal, Oil, Natural Gas, BSF, BLF) AFTER biomass limitation
	pPlasticSharesNoLimit[NRC,5](t),			! %			shares of feedstock energy carriers in primary plastics (Coal, Oil, Natural Gas, BSF, BLF) BEFORE biomass limitation
	pPlasticNetFeed[NRC,5](t),					! GJ		Primary plastics by feedstock (Coal, Oil, Natural Gas, BSF, BLF)
	PlasticSectors[NRC,PS](t),					! GJ		plastic demand by sector in GJ

! Plastic waste generation and collection
	PlasticWaste[NRC,PS](t),					! GJ	plastic waste by region & sector in GJ
	PlasticWaste_Base[NRC,PS](t),				! GJ	plastic waste by region & sector in GJ: Baseline
	PlasticWasteTot[NRC](t),					! GJ	Total plastic waste generated by region in GJ (sum of plastic sectors)
	PlasticWasteTransf[NRC,PS](t), 				! GJ 	Plastic resin transformation losses from the previous year (4%), assuming same losses in each sector
	PlasticCumu[NRC,PS](t),						! GJ	Cumulative plastic production over time per region and sector in GJ
	PlasticWasteCumu[NRC,PS](t),				! GJ	cumulative plastic waste by region & sector in GJ
	PlasticWasteCumuNoTransf[NRC,PS](t),		! GJ	cumulative plastic waste by region & sector in GJ, ignoring plastic transformation losses
	PlasticCumu2[NRC](t),						! GJ	Cumulative plastic production over time per region
	PlasticWasteCumu2[NRC](t),					! GJ	Cumulative plastic waste by region 
	PlasticStock[NRC,PS](t),					! GJ	plastics in use (= not emitted) by sector and region in GJ
	PlasticStockTot[NRC](t),					! GJ	plastics in use, sum of sectors in GJ
	WaCollRate[NRC](t),							! -		Post Consumer Waste collection rate per Income group (GNI/cap in 2005 USD assumed to equal GDP/cap); World Bank (2018): What A waste 2.0
	PlaWaColl[NRC](t),							! GJ	Plastic waste collected by region in GJ
	WaCollRateGlob(t),							! -		Global plastic waste collection rate
	PlaWaRemain[NRC](t),						! GJ	Remaining plastic waste in GJ (not collected)
	PlaWaOpenBurn[NRC](t),						! GJ	Uncollected plastic waste in GJ that will be openly burnt; 30% assumption based on World Bank 2018: What a Waste 2.0
	PlaWaOpenDump[NRC](t),						! GJ	Uncollected plastic waste openly dumped; assumption based on World Bank 2018: What a Waste 2.0
	
! For calculating plastics by resources (fossil, bio, recycled), all in GJ
	PlasticNetMS[NRC,PR](t),					! GJ		shares of plastics by resource (1= fossil primary, 2= fossil recycled, 3= biobased primarym 4= biobased recycled)
	PlasticNetRes[NRC,PR](t),					! GJ		plastic production by resource 
	PlasticCumuRes[NRC,PR](t),					! GJ		Cumulative plastic production over time per region, sector and resource in GJ
	PlasticSectorsRes[NRC,PS,PR](t),			! GJ		plastic demand by sector and resources in GJ
	PlasticWasteRes[NRC,PS,PR](t),				! GJ		plastic waste by region, sector & resource in GJ
	PlasticWasteTransfRes[NRC,PS,PR](t), 		! GJ 	Plastic resin transformation losses by resources from the previous year (4%), assuming same losses in each sector
	PlasticWasteResTot[NRC,PR](t),				! GJ		Total plastic waste generated by region & resource in GJ (sum of plastic sectors)
	PlasticWasteCumuRes[NRC,PR](t),				! GJ		cumulative plastic waste by region, sector & resource in GJ
	PlasticWasteCumuNoTransfRes[NRC,PR](t),		! GJ		cumulative plastic waste by region & resource in GJ, ignoring plastic transformation losses
	PlasticStockRes[NRC,PR](t),					! GJ		plastics in use (= not emitted) by resource and region in GJ
	PlaWaCollRes[NRC,PR](t),					! GJ		Plastic waste collected by region and resource in GJ
	PlaWaRemainRes[NRC,PR](t),					! GJ		Remaining plastic waste by resource in GJ (not collected)
	PlaWaOpenBurnRes[NRC,PR](t),				! GJ		Uncollected plastic waste in GJ by resource that will be openly burnt; 30% assumption based on World Bank 2018: What a Waste 2.0
	PlaWaOpenDumpRes[NRC,PR](t),				! GJ		Uncollected plastic waste by resource openly dumped; assumption based on World Bank 2018: What a Waste 2.0

! Waste management options (all options exclude waste collection and transport)
	! Costs of end of life options
	Price_pHVCplastic[NRC](t),					! $/GJ		price of HVC sourced plastics in $ / GJ plastics, incl. HVC production + plastic polymerisation (monomer to polymer)
	MR_Cost[NRC,4](t),							! 2005USD/GJ	Costs of Mechanical recycling of plastics waste in 2005 USD / GJ plastic waste; [,1] Constant cost factor (machinery, maintenance but also labour), [,2] Costs of Electricity, [,3] cost of heat, [,4] costs of carbon tax
	MRCF(t), 									! factor to decrease fixed costs of mechanical recycling (used in scenarios)
	PlaWa_SY(t),								! Sorting/pre treatment yields of plastic waste (excl. collection) for MR
	PlaWa_MRY(t),								! Recycling yield of plastic waste (output/input of mechanical recycling plants, excl. collection & pre-treatment/sorting)
	PlaWa_SF(t),								! substitution factor for substituting virgin plastics with recycled plastics (accounting for quality difference)
	PlaWa_SYpyr(t),								! Sorting/pre treatment yields of plastic waste (excl. collection) for pyrolysis (accepts less pure streams)
	MR_Benefit[NRC](t),							! 2005USD/GJ	Benefit of selling recycled plastics in 2005 USD/ GJ plastic waste
	MR_CostTot[NRC](t),							! 2005USD/GJ	Total costs of mechanical recycling incl. benefit of selling plastics; in  2005 USD/ GJ plastic waste
	WtE_Benefit[NRC,2](t),						! 2005USD/GJ?	Benefit in USD/GJ electricty [,1] and heat [,2] produced, assuming an average electricity efficiency of 9% and heat efficiency of 22% (European Commission 2018 (Biobased product), weighted average of EU waste incineration plants with and without energy recovery, covering a total capacity of 94.7 million tonnes of waste
	WtE_Cost[NRC,2](t),							! 2005USD/GJ	Costs of waste to energy plants in 2005 USD/ GJ plastic waste input; [,1] Constant cost estimate (machinery, maintenance but also labour) based on Faraca et al 2019 and Gradus et al 2017 (EU data); [,2] costs of carbon tax
	WtE_CostTot[NRC](t),						! 2005USD/GJ	Total costs of waste to energy incl. benefit of selling electricity and heat in  2005 USD/ GJ plastic waste
	EnPrice_GenVSFinal[NRC,2](t),				! 2005USD/GJ?	Test: Generator electricity price per FInal energy price (at industry); 1= electricity, 2= heat
	LandPriceAv(t),								! Global land price average (weighted)in $/ha
	LandPriceFac[NRC](t),						! Factor describing by how much a region land price (based on GDP, Pop & RegionSize) is higher or lower than the global average (=1)
	LandPriceAvBaseline(t),						! Baseline value for global average land price in USD (using value of year 2015 as baseline)
	LF_FixCostBaseline(t),						! Baseline value for fixed landfill costs in USD/GJ plastic waste
	LF_FixCostAv(t),							! Average global fixed landfill cost baseline
	Lf_Cost[NRC,4](t),							! 2005USD/GJ	Landfill Costs in 2005 USD / GJ plastic waste by region; [,1] constant costs based on EU28 average (incl. revenues from selling energy) from Hestin et al 2015; [,2] = Costs of electricity use, [,3] costs of diesel use, Based on Manfredi et al 2009 (elect. & diesel costs exclude landfill construction); [,4] costs of carbon tax/premium factor
	LF_CostTot[NRC](t),							! 2005USD/GJ	Total cost of landfilling in 2005 USD/GJ plastic waste
	PYR_cost[NRC,8](t),							! 2005USD/GJ?	Costs for chemically recycling plastic waste via pyrolisis in USD/GJ plastic waste
	PYR_Benefit[NRC](t),						! 2005USD/GJ?	Benefit of selling chem. recycled plastics in USD/GJ plastic waste
	PYR_CostTot[NRC](t),						! 2005USD/GJ?	Total costs of chem. rec. plastics via pyrolisis in USD/GJ plastic waste incl. benefit of selling recycled plastics
	PyrCF(t), 									! factor to change fixed costs of pyrolysis, used in scenarios and sensitivity analysis
	PyrYF(t),									! factor to change yields of pyrolysis, used in scenarios and sensitivity analysis
	EoL_CostTot[NRC,EOL](t),					! 2005USD/GJ?	Total cost summary of all EoL option in USD/GJ plastic waste; 1= MR, 2=WtE, 3= Lf, 4= pyrolisis
	EoL_CostTot2[NRC,EOL](t),					! 2005USD/GJ?	Total cost of EoL options, considering regional availability of the options
	EoL_CostTot3[NRC,EOL](t),					! 2005USD/GJ?	Total cost of EoL option before 1980 (all inactive (=1000) apart from landfilling)

! Determining market shares of end of life options via multinomial logit
	Active_EoL[NRC,EOL](t),						! -		determines which end of life options are active (1=MR, 2= WtE, 3= Lf, 4=pyrolysis
	EoL_FloorPrice[NRC](t),						! 2005USD/GJ?	Lowest wastetreatment cost in USD/GJ plastic waste(cheapest EoL option)
	EoL_ShareCalc[NRC,EOL](t),					! -		Nominator of Multinomial Logit (MNL) for EoL options; ,1= MR, ,2 = WtE, ,3= Lf
	EoL_ShareDenom[NRC](t),						! -		Denominator of Multinomial Logit (MNL) for EoL options
	EoL_MShareDes[NRC,EOL](t),					! -		Desired market shares of EoL options (MR, WtE, Lf), without limitations and caps
	EoL_MShareDes2[NRC,EOL](t),					! -		Market shares including WtE limit
	EoL_MShare2[NRC,EOL](t),					! -		final market shares of End of life options including caps for WtE and MR, not smoothened
	EoL_MShare3[NRC,EOL](t),					! -		Smoothened final market shares of End of life options including caps for WtE and MR
	EoL_MShare[NRC,EOL](t),						! -		Final market shares of End of life options including caps for WtE and MR, incl. historic values
	EoL_CostTot_noWtE[NRC,EOL](t),				! -		For second MNL without WtE
	EoL_FloorPrice_noWtE[NRC](t),				! -		For second MNL without WtE
	EoL_ShareCalc_noWtE[NRC,EOL](t),			! -		For second MNL without WtE
	EoL_ShareDenom_noWtE[NRC](t),				! -		For second MNL without WtE
	EoL_MShareDes_noWtE[NRC,EOL](t)	,			! -		For second MNL without WtE
	EoL_CostTot_noMR[NRC,EOL](t),				! -		For third MNL without MR
	EoL_FloorPrice_noMR[NRC](t),				! -		For third MNL without MR
	EoL_ShareCalc_noMR[NRC,EOL](t),				! -		For third MNL without MR
	EoL_ShareDenom_noMR[NRC](t),				! -		For third MNL without MR
	EoL_MShareDes_noMR[NRC,EOL](t),				! -		For third MNL without MR
! EoL flows by resources
	FlowsToEOLRes[NRC,EOL,PR](t),				! GJ		Waste in GJ SENT to different End of life options (i.e. before recycling process & its losses) by resources (PR)
	MR_plasticsRes[NRC,PR](t),					! GJ		Recycled plastics produced in GJ (to be deducted from total HVC demand) by resources (PR)
	MR_rejectsRes[NRC,PR](t),					! GJ		Rejects of plastic recycling going to WtE or Lf in GJ Difference between plastic waste going to recycling and recycled plastics produced by resources (PR)
	EoL_flowsRes[NRC,EOL,PR](t),				! GJ		Total plastics waste recycled, incinerated, pyrolysized and landfilled in GJ by resources (PR)
	PYR_plasticsRes[NRC,PR](t),					! GJ		plastics produced via pyrolysis in GJ by resources (PR)
	
! Summary EoL flows
	FlowsToEOL[NRC,EOL](t),						! -		Waste in GJ SENT to different End of life options (i.e. before recycling process & its losses)
	MR_rejects[NRC](t),							! -		Rejects of plastic recycling going to WtE, PYR or Lf in GJ; Difference between plastic waste going to recycling and recycled plastics produced
	EoL_flows[NRC,EOL](t),						! -		Total plastics waste recycled, incinerated, pyrolysized and landfilled in GJ
	EoL_rates[NRC,EOL](t),						! -		Final EoL rates (i.e. plastics recycled instead of plastics sent to recycling (which is EoL_MShare[R,1])
	
! Overall EoL costs
	EoL_costAv[NRC](t),							! 2005USD/GJ?	Average costs of treating plastc waste in USD / GJ plastic waste, weighted average by region
	Eol_CostAll[NRC,EOL](t),					! 2005USD?	Total costs of (collected) plastic waste treatment by EoL option and region in USD 
	Eol_CostTotAll[NRC](t),						! 2005USD?	Total cost of (collected) plastic waste treatment by region (sum of all options) in USD
	
! cumulative end of life flows
	EoL_flowsCumuRes[NRC,EOL,PR](t),			! GJ		Cumulative plastic waste mechanically recycled, incinerated, chem. recycled (pyrolysis), landfilled in GJ (by resource)
	PlaWaOpenDumpCumuRes[NRC,PR](t),			! GJ		Cumulative plastic waste openly dumped in GJ (by resource)
	PlaWaOpenBurnCumuRes[NRC,PR](t),			! GJ		Cumulative plastic waste openly burned in GJ (by resource)

! Energy use of end of life options
! 1 = Coal, 2= Oil, 3= Natural Gas, 4= BSF, 5= BLF, 6= Waste, 7= Electricity, 8= Heat; 
! In EoL only 7 & 8 used
	MR_EnergyTot[NRC,ECP](t),					! GJ		Total energy use in GJ of mechanical recycling 
	PYR_EnergyTot[NRC,ECP](t),					! GJ		Total energy use in GJ of pyrolysis 
	WtE_EnergyTot[NRC,ECP](t),					! GJ		Total energy benefit (thus negative) in GJ of waste to energy 
	LF_EnergyTot[NRC,ECP](t),					! GJ		Total energy use in GJ of landfilling
	EoL_EnergyTot[NRC,ECP](t),					! GJ		Total energy use in GJ for plastic waste treatment, sum of all options 

! Energy use in plastics production & End of Life (by production step and waste treatment)
! Energy carrier as above
	PlasticEnUse[NRC,ECP,8](t),					! GJ

! Plastics & emission variables needed in Other modules
	MR_plastics[NRC](t),						! Recycled plastics produced in GJ (to be deducted from total HVC demand)
	PYR_plastics[NRC](t),						! plastics produced via pyrolysis in GJ
	Prop_C4 = 1.3,	  							! Units of Propylene (0.5) and C4 (0.8) produced per unit of aromatics in a refinery (based on data of Levi & Cullen 2018, see excel file "Plastic shares_HVC_REF_Meth_(Levi&Cullen data).xls"
	EOLfate[NRC,3](t),							! Fate of total plastic waste (recycled, sequestered, burnt), incl. uncollected waste: Shares of [1] plastic waste recycled (MR+PYR], [2] sequestered (landfilled+dumped), [3] burnt (WtE+open burn)
	NEUFtoPla[NEUF](t),							! Shares of NEUF going to plastics; based on Levi & Cullen (2018); For refinery it includes the amount of refinery aromatics, propylene and C4 to plastic (=REFIShares[3] * Prop_C4 * share of them going to plastics (0,59, see plastic shares excel))
	PlaWaResShare[NRC,2](t),					! GJ		Resource Shares in plastic waste; 1= fossil, 2= bio
	NEUFinPLA_Base[NRC,NEUF](t),				! Shares of NEUF in plastics
	NEUFinPLA[NRC,NEUF](t),						! Shares of NEUF in plastics

! Post processing outputs
	Plastics_IN[NRC,12](t),		! Plastics produced in GJ by resource (fossil, bio) and by production pathway (primary, MR, PYR)
    PlasticEnUse_EC[NRC,ECP](t),	! Global Energy carrier use for plastics in GJ
	FlowsToEOL_Sankey[NRC,7](t),	! total waste flows to EoL, used for sankey diagram (1 = MR, 2= WtE, 3= PYR, 4= LF, 5= collected plastic waste (sum of 1:4), 6= opendump, 7= openburn)
	MRrejflows[NRC,EOL](t),
	    Plastics_Sankey[NRC,26](t);

! ************* DEFINITION OF PARAMETRIC CONSTANTS *************
REAL
	LogitPar_NonEn	= 0.75,				        !			Logit parameter, defines the sensitivity of the MNLs. 
	AlphaPla 		= 7.508, 					! -		AlphaPl and BetaPl are constants (regression coefficients) derived from analyzing the historic plastic demand per capita in relation to historic GDP per capita.	
	BetaPla 		= 14525,			 
	ElecGenShare 	= 0.57,						! %		Share of electricity generation in electricity price (generation+network) excl. taxes; assumption based on EU 28 averages non-household and USA data
	WtE_cap 		= 1,						! %		Maximum share of Waste to Energy
	MR_cap 			= 1;						! %		Maximum share of Waste sent to MR; Set to 1 = no limit set; the maximum recycling rate possible (in the circular scenario) is 80% (56% in all other scenarios), limited by sorting & recycling yields which are not exceeding 90%. This is in line with maximum recyclability assumptions of Ellen McArthur Foundation and Hestin et al

