!************************************************************************************** 
!********************* THE PLASTICS INTEGRATED ASSESSMENT MODEL  **********************
!*********************************** PLAIA ******************************************** 
!************************************************************************************** 
! Methodology Developed by: 	Paul Stegmann and Vassilis Daioglou (Universiteit Utrecht, PBL Netherlands Environmental Assessment Agency)
! Dependencies:		The IMAGE-TIMER model, specifically the Non-Energy Demand and Emissions module (NEDE)
! Publications:
!	- Method: 		Stegmann, P., Daioglou, V., Londo, M. and Junginger, M., 2022. 
!					The plastics integrated assessment model (PLAIA): Assessing emission mitigation pathways and circular economy strategies for the plastics sector.
!					MethodsX, 9, p.101666.
!	- Application:	Stegmann, P., Daioglou, V., Londo, M., van Vuuren, D. and Junginger, M., (accepted).
!					Plastic Futures and thier CO2 emissions
!					Nature			
!	
!	- Dependencies: Van Vuuren, D., Stehfest, E., Gernaat, D., de Boer, H.S., Daioglou, V., Doelman, J., 
!					Edelenbosch, O., Harmsen, M., van Zeist, W.J., van den Berg, M. and Dafnomilis, I., 2021. 
!					The 2021 SSP scenarios of the IMAGE 3.2 model.
!
!					Daioglou, V., Faaij, A.P., Saygin, D., Patel, M.K., Wicke, B. and van Vuuren, D.P., 2014. 
!					Energy demand and emissions of the non-energy sector. Energy & Environmental Science, 7(2), pp.482-498.
!
!************************************************************************************** 
!********************************** STRUCTURE *****************************************
!************************************************************************************** 
! 0. DEFINITION OF PARAMETERS AND VARIABLES FOR PLASTICS MODULE

! 1. INTEGRATION OF PLASTICS IN NEDE
! 1.1. Plastic demand as function of NEUF: Determine the amount of plastics produced by region and source in GJ, Assuming fixed shares of HVC, refinery and methanol going to plastics; shares calculated from 2013 MFA data of Levi & Cullen 2018
! 1.2. Reorganizing product aggregation in NEDE: Deduct plastic demand from HVC, refinery and methanol.
! 1.3. Calculate primary energy demand for plastics production based on NEUF efficiencies and additional energy requirements from monomers to plastic polymers (based on Plastics Europe Eco profiles)
! 1.4. Show Plastics production by resources (fossil, fossil recycled, biobased, biobased recycled)

! 2. PLASTIC USES (SECTORS)
! Define plastic sectors and their use lifetime according to Geyer et al 2017 (Production, Use, And Fate Of All Plastics Ever Made)

! 3. PLASTIC WASTE GENERATION
! Calculate plastic waste generated according to plastic sector lifetimes (from Geyer et al 2017)

! 4. COLLECTED & DUMPED/BURNT PLASTIC WASTE 
! Calculate amount of collected plastic wastes as a function of GDP per capita (according to World Bank (2018): What A waste 2.0)
! Make assumptions what happened to remaining waste (open dumps, open burn)

! 5. WASTE MANAGEMENT OF COLLECTED PLASTIC WASTE
! 5.1. Define costs of end of life options
! 5.2. Calculate shares of these options in plastic waste treatment
! 5.3. Summary of end of life flows and costs

! 6. TRANSFORMATION OF PLASTIC RESINS INTO (semi-finished) PLASTIC PRODUCTS

! 7. PLASTIC STOCKS AND CUMULATIVE PLASTIC PRODUCTION, WASTE GENERATION & END OF LIFE OPTIONS

! GENERAL REMARKS
! all key plastics variables will also be shown by their resources (fossil, fossil recycled, biobased, biobased recycled) in a mirror variable, expressed by the addon "Res"

!************* TIME DEFINITION *************
T.MIN     	= 1971.0;
T.MAX     	= 2100.0;

T.STEP    	= 1.0;
T.SAMPLE  	= 1.0;
T.METHOD  	= RK1;

! ************* INITIALIZE MODULE *************
#INCLUDE constants.m

MODULE main;
BEGIN

#INCLUDE declarations.M

! ************* GENERIC VARIABLES *************
REAL Convergence(t);    ! Convergence variable to gradually implement scenario values, linear interpolation

Convergence  = SWITCH( t < Tstart ? 
					0,
				t >= Tstart AND t < TconvScen ?
					(t - Tstart)/(TconvScen - Tstart),
				t > TconvScen ? 
					1
				ELSE 1);  


!*************** 1. INTEGRATION OF PLASTICS ****************
!*** 1.1 Plastic demand as function of NEUF***
! Assuming fixed shares of HVC, refinery and methanol going to plastics; shares calculated from 2013 MFA data of Levi & Cullen (2018)
! We exclude bitumen and lubricants as this is not used in plastics (and because refprods.m calculate bitumen feedstocks separately from other refinery products (allocates all to Oil))

NonEnFuncTot2_Base[R,i]		= NonEnFuncTot_Base[R,i], R = 1 TO 26, i = 1 to 3;	! NEUF 1 to 3 stay the same
NonEnFuncTot2_Base[R,4] 	= NonEnFuncTot_Base[R,4] * LSUM(i = 3 to 4, REFIShares2[i]), R = 1 TO 26;  ! Refinery products now contain Aromatics, C4 and propylene but exclude Bitumen and lubricants 
						
NonEnFuncTot2_Base[NRC,i] 	= LSUM(R= 1 TO 26, NonEnFuncTot2_Base[R,i]), i= 1 TO NEUF;
	
! 1.1.2) Determine the amount of plastics by region and source (NEUF) in GJ

! Shares of NEUF going to plastics; based on Levi & Cullen (2018)
NEUFtoPla[i] 	= SWITCH( 	i = 1 ?
								0.84,				! HVC (steam cracking)
			  				i = 2 ?
								0,					! Ammonia	  
			  				i = 3 ?
								0.4,				! Methanol	  
				ELSE	0.59 	! Refinery products; 0.59 from Levi & Cullen (2018) of refinery sourced olefines to plastics; multiplied by share of aromatics, C4 and propylene in refinery products (bitumen & lubricants dont go to plastics)
				), i = 1 TO NEUF;	

PlasticNet_Base[R,i] 	= NonEnFuncTot2_Base[R,i] * NEUFtoPla[i], R = 1 TO NRC2, i = 1 to NEUF;! Regional plastic resin demand by sources in GJ; i= 1= Plastic from HVC, 2= Plastic from ammonia, 3= plastic from methanol, 4= plastic from refinery
PlasticNet_Base[NRC,i] 	= LSUM(R= 1 TO NRC2,PlasticNet_Base[R,i]), i= 1 TO NEUF;		! Global plastic resin demand by sources in GJ

PlasticNetTot_Base[R]	= LSUM(i= 1 TO NEUF,PlasticNet_Base[R,i]), R= 1 TO NRC;		! Regional plastic resin demand total in GJ (sum of sources)	

! Shares of NEUFs in plastics
NEUFinPLA_Base[R,i]		= SWITCH( 	i = 1?
									PlasticNet_Base[R,1] / PlasticNetTot_Base[R],
								i = 2?
									PlasticNet_Base[R,2] / PlasticNetTot_Base[R],
								i = 3?
									PlasticNet_Base[R,3] / PlasticNetTot_Base[R]
								ELSE
									PlasticNet_Base[R,4] / PlasticNetTot_Base[R]), R = 1 to NRC, i = 1 to NEUF;	
							
NonEnFuncTot2[R,i]	= NonEnFuncTot2_Base[R,i], R = 1 TO 26, i = 1 to NEUF; 
						
NonEnFuncTot2[NRC,i] 	= LSUM(R= 1 TO 26, NonEnFuncTot2[R,i]), i= 1 TO NEUF;	


PlasticNet[R,i] 	= NonEnFuncTot2[R,i] * NEUFtoPla[i], R = 1 TO NRC2, i = 1 to NEUF;! Regional plastic resin demand by sources in GJ; i= 1= Plastic from HVC, 2= Plastic from ammonia, 3= plastic from methanol, 4= plastic from refinery
PlasticNet[NRC,i] 	= LSUM(R= 1 TO NRC2,PlasticNet[R,i]), i= 1 TO NEUF;		! Global plastic resin demand by sources in GJ

PlasticNetTot[R]	= LSUM(i= 1 TO NEUF,PlasticNet[R,i]), R= 1 TO NRC;		! Regional plastic resin demand total in GJ (sum of sources)	

! Recycled plastics (=secondary plastics)
sPlasticNetTot[R]	= MR_plastics[R] + PYR_plastics[R], R= 1 TO 26;
sPlasticNetTot[NRC]	= LSUM(R= 1 TO 26,sPlasticNetTot[R]);	

! primary plastics
pPlasticNetTot[R]	= PlasticNetTot[R] - sPlasticNetTot[R], R= 1 TO NRC;! Demand for primary plastics (excluding recycled plastics)

! Shares of NEUFs in plastics
NEUFinPLA[R,i]		= SWITCH( 	i = 1?
									PlasticNet[R,1] / PlasticNetTot[R],
								i = 2?
									PlasticNet[R,2] / PlasticNetTot[R],
								i = 3?
									PlasticNet[R,3] / PlasticNetTot[R]
								ELSE
									PlasticNet[R,4] / PlasticNetTot[R]), R = 1 to NRC, i = 1 to NEUF;

!*** 1.2) Reorganizing the NEDE product aggregation: Deduct plastic demand from HVC, refinery and methanol.***
NonEnFuncTotNew[R,i]	= NonEnFuncTot2[R,i] - PlasticNet[R,i], R = 1 TO 26, i = 1 to NEUF;

!*** 1.3) Overall gross energy use of primary plastic resin production ***

! 1.3.1) Energy use for polymerisation: monomers (ethylene, propylene, aromatics) to plastic polymer resins
! Weighted average energy use based on polymer specific data from Plastics Europe Eco profiles (+Ecoinvent) and plastic sector shares from Geyer et al 2015 
! Weighted average includes HDPE, LDPE&LLDPE, PP, PET, PVC and PS, together representing 79% of plastic market; excludes PUR (polyurethanes), and PP&A (polyester, poly- amide, and acrylic)

PlaPolymEnReq[R,1]	= 0.057, R = 1 TO NRC;	! Electricity use in GJ/GJ plastics
PlaPolymEnReq[R,2]	= 0.077, R = 1 TO NRC;	! Heat use in GJ/GJ plastics

! Total energy use for polymerisation in GJ of primary plastics by energy carrier (EC 1-6= not used, 7= electricity, 8= heat)
PlaPolymEnTot[R,7]	= PlaPolymEnReq[R,1] * pPlasticNetTot[R], R = 1 TO NRC; ! electricity in GJ
PlaPolymEnTot[R,8]	= PlaPolymEnReq[R,2] * pPlasticNetTot[R], R = 1 TO NRC; ! Heat in GJ
PlaPolymEnTot[R,EC]	= 0, EC= 1 to 6, R = 1 TO NRC; 				! Other energy carriers are not used

! 1.3.2) Gross energy demand for (upstream) primary plastics production (=monomers) in GJ by energy carrier (as a share of total Nonen energy demand), before biomass limitation
! Ignoring polymerisation and plastic transformation (added later)
! For Refinery products we exclude bitumen (all oil) and take the Aromatics & Procp_C4 shares of the remaining energy carriers used in Refinery production
pPlasticGrossUp2[R,EC] 	= StmCrGross_BioSE[R,EC] * NEUFtoPla[1] + MethGross[R,EC] * NEUFtoPla[3] 
							+ AromaticsPropC4[R,EC] * NEUFtoPla[4], EC= 1 to 8, R = 1 to NRC;							

! 1.3.3) Calculate plastics gross AFTER biomass limitation

! Share of plastics gross energy (without polymeristaion & EoL) in total nonen gross energy (without biomass limits)
PLAinNEUFGross[R,EC] 	= SWITCH (NonEnTot2[R,EC] > EPS ? 	
					pPlasticGrossUp2[R,EC] / NonEnTot2[R,EC]
						ELSE 0) , EC= 1 to 8, R = 1 to NRC;	

! Gross energy demand for upstream primary plastics production (=monomers) in GJ (incl. biomass limitation), excl. polymerisation; BSF and BLF again in primary energy
pPlasticGrossUp[R,EC] 	= SWITCH( EC = 4?
									PLAinNEUFGross[R,EC] * NonEnTotal1[R,EC] / SecBioEff_Agr[R,2], 
								  EC = 5? 
									PLAinNEUFGross[R,EC] * NonEnTotal1[R,EC] / SecBioEff_Agr[R,1]
								ELSE PLAinNEUFGross[R,EC] * NonEnTotal1[R,EC]
									), EC= 1 to ECP, R = 1 to NRC;

pPlasticGrossUp[NRC,EC] = LSUM(R= 1 TO 26, pPlasticGrossUp[R,EC]), EC= 1 to ECP;

! Gross energy demand for primary plastic resins production in GJ (incl. biomass limitation), incl. polymerisation, excl. transformation
pPlasticGross[R,EC] 	= pPlasticGrossUp[R,EC] + PlaPolymEnTot[R,EC], EC= 1 to ECP, R = 1 to NRC;

pPlasticGrossFossil[R]	= LSUM(EC= 1 to 3,pPlasticGrossUp[R,EC]), R = 1 to NRC;	! fossil gross energy in primary plastics; excl. waste, electricity and heat as no feedstock for primary plastic
pPlasticGrossBio[R]	= LSUM(EC= 4 to 5,pPlasticGrossUp[R,EC]), R = 1 to NRC;	! biobased gross energy in primary plastics; excl. waste, electricity and heat as no feedstock for primary plastic

!*** Plastics by resources (fossil/bio) ***
! 1. Determine demand for EC going into plastic products (ignoring process energy, e.g. StmCrEn and transformation losses)
pPlasticFeed3[R,EC]	= StmCrProd[R,EC] * NEUFtoPla[1]
				+ MethNet[R,EC] * NEUFtoPla[3]	
				+ NEUFtoPla[4] * LSUM(i = 3 to 4, REFIShares2[i])/LSUM(i = 2 to 4, REFIShares2[i]) * RefiNet_noBitumen[R,EC], R = 1 to NRC, EC= 1 to 5;
				
! Plastic shares before biomass limitation
pPlasticSharesNoLimit[R,EC] = pPlasticFeed3[R,EC]/LSUM(i = 1 TO 5, pPlasticFeed3[R,i]), R= 1 TO NRC, EC = 1 TO 5;
pPlasticSharesNoLimit[NRC,EC]	= LSUM(R= 1 to 26,pPlasticFeed3[R,EC]) / LSUM(R= 1 to 26, LSUM(i = 1 TO 5, pPlasticFeed3[R,i])), EC = 1 TO 5;
				
! 2. Calculate share of plastics feedstock energy carriers in total nonen gross energy (without biomass limits, without polymeristaion & EoL)
PLAinNEUFfeed[R,EC] 	= SWITCH (NonEnTot2[R,EC] > EPS ? 	
					pPlasticFeed3[R,EC] / NonEnTot2[R,EC]
						ELSE 0) , EC= 1 to 5, R = 1 to NRC;
! 3. Calculate plastics feedstock energy carriers in total nonen gross energy AFTER biomass limitation

pPlasticFeed[R,EC]	= PLAinNEUFfeed[R,EC] * NonEnTotal1[R,EC], EC= 1 to 5, R = 1 to NRC;
			  	
pPlasticFeed[NRC,EC]	= LSUM(R= 1 to 26,pPlasticFeed[R,EC]), EC= 1 to 5;
			  	
! 4. Calculate shares of feedstock energy carriers	
pPlasticFeedTot[R]	= LSUM(EC = 1 TO 5, pPlasticFeed[R,EC]), R= 1 TO NRC;	! Total feedstock energy carriers for primary plastics in GJ	(1= coal, 2= oil, 3= N gas, 4= BSF, 5= BLF)
		
pPlasticShares[R,EC]	= SWITCH(pPlasticFeedTot[R] > EPS?
							pPlasticFeed[R,EC]/pPlasticFeedTot[R]
						ELSE 0) , R= 1 TO NRC, EC = 1 TO 5;

pPlasticShares[NRC,EC]	= SWITCH(LSUM(R= 1 to 26, pPlasticFeedTot[R]) > EPS?
							LSUM(R= 1 to 26,pPlasticFeed[R,EC]) / LSUM(R= 1 to 26, pPlasticFeedTot[R])
						ELSE 0), EC = 1 TO 5;

! 5. Show primary plastics by resource (Coal, Oil, Natural Gas, BSF, BLF) in GJ
pPlasticNetFeed[R,EC]	= pPlasticNetTot[R] * pPlasticShares[R,EC], R= 1 TO NRC, EC = 1 TO 5;		

! 6. Calculate resource shares for plastics (fossil, fossil recycled, bio-based, bio-based recycled)

PlasticNetMS[R,1]	= SWITCH(PlasticNetTot[R] > EPS?
						LSUM(EC= 1 to 3, pPlasticNetFeed[R,EC]) /PlasticNetTot[R]	! fossil primary plastics; excl. waste, electricity and heat as no feedstock for primary plastics
					ELSE 0), R = 1 TO 26;

PlasticNetMS[R,2]	= SWITCH( LSUM(j= 1 TO 2, MR_plasticsRes[R,j]+ PYR_plasticsRes[R,j]) > EPS?
						LSUM(j= 1 TO 2, MR_plasticsRes[R,j]+ PYR_plasticsRes[R,j])/PlasticNetTot[R]
					ELSE 0), R = 1 TO NRC; 									! fossil recycled plastics
PlasticNetMS[R,3]	= SWITCH(PlasticNetTot[R] > EPS?
						LSUM(EC= 4 to 5, pPlasticNetFeed[R,EC]) /PlasticNetTot[R]	! biobased primary plastics; excl. waste, electricity and heat as no feedstock for primary plastics
					ELSE 0), R = 1 TO 26;
	
PlasticNetMS[R,4]	= SWITCH( LSUM(j= 3 TO 4, MR_plasticsRes[R,j]+ PYR_plasticsRes[R,j]) > EPS?
						LSUM(j= 3 TO 4, MR_plasticsRes[R,j]+ PYR_plasticsRes[R,j])/PlasticNetTot[R]
					ELSE 0), R = 1 TO 26;						     			! biobased recycled plastics

PlasticNetMS[NRC,j] 	= SWITCH(PlasticNetTot[NRC] > EPS?
							LSUM(R= 1 TO 26, PlasticNetMS[R,j] * PlasticNetTot[R])/PlasticNetTot[NRC]	! Global shares
						ELSE 0), j=1 to PR;
PlasticNetRes[R,j] 	= PlasticNetTot[R] * PlasticNetMS[R,j], R = 1 TO 26, j= 1 TO PR;	! in GJ
PlasticNetRes[NRC,j]	= LSUM(R= 1 TO 26, PlasticNetRes[R,j]), j= 1 TO PR;
		
!******************* 2. PLASTIC USES (SECTORS) ******************
! sector & lifetime data according to Geyer et al 2017
! PlasticNetTot is the demand for plastic RESINS; When transforming these resins to plastic products ca 4% efficiency losses occur (see chapter 6); 
! Hence, the sum of PlasticSectors[R,i] is 4% lower than PlasticNetTot; The difference (= efficiency losses) is assumed to become waste (see chapter 3 on plastic waste generation)

PlaTransEff[R]		= 0.96, R= 1 TO NRC;			! Efficiency plastic product / plastic resin 

! needed for calculating impact of life time extension on demand: Baseline with default lifetime and demand linked to historic intensities (demand/ GDP/cap)
PlasticSectors[R,i]	= PlaTransEff[R] * PlasticNetTot_Base[R]* PlaSec[i,1], R= 1 TO NRC, i = 1 TO PS;	! Regional plastic product demand by sector in GJ (considering efficiency losses of 4% from plastic resin  transformation to plastic products)
PlasticSectors[NRC,i]	= LSUM(R= 1 TO 26, PlasticSectors[R,i]), i = 1 TO PS;	! Global plastic product demand by sector in GJ

! by resource in GJ
! Calculating the FOSSIL plastics per sector (Difference of Total plastic demand per sector and the total biobased plastic in the sector as calculated above)
PlasticSectorsRes[R,i,j]= 	PlasticNetMS[R,j] * PlasticSectors[R,i], R = 1 TO NRC, i = 1 TO PS, j = 1 TO 2; 

! Packaging(1 year lifetime)	
PlasticSectorsRes[R,1,j]= 	PlasticNetMS[R,j] * PlasticSectors[R,1], R = 1 TO NRC, j = 3 TO PR; 		

! Transportation (13 years lifetime)
PlasticSectorsRes[R,2,j] = 	PlasticNetMS[R,j] * PlasticSectors[R,2], R = 1 TO NRC, j = 3 TO PR; 

! Building & Construction (35 years lifetime)
PlasticSectorsRes[R,3,j] = 	PlasticNetMS[R,j] * PlasticSectors[R,3]	, R = 1 TO NRC, j = 3 TO PR; 

! Industrial Machinery (20 years lifetime)
PlasticSectorsRes[R,6,j] = 	PlasticNetMS[R,j] * PlasticSectors[R,6], R = 1 TO NRC, j = 3 TO PR; 

! Electrical/Electronic (8 years lifetime)
PlasticSectorsRes[R,4,j]= 	PlasticNetMS[R,j] * PlasticSectors[R,4], R = 1 TO NRC, j = 3 TO PR; 

! Textiles (5 years lifetime)
PlasticSectorsRes[R,7,j]= 	PlasticNetMS[R,j] * PlasticSectors[R,7], R = 1 TO NRC, j = 3 TO PR; 			

! Other (5 years lifetime)	
PlasticSectorsRes[R,8,j]= 	PlasticNetMS[R,j] * PlasticSectors[R,8], R = 1 TO NRC, j = 3 TO PR; 

! Consumer & Institutional Products (3 years lifetime)	
PlasticSectorsRes[R,5,j]= 	PlasticNetMS[R,j] * PlasticSectors[R,5], R = 1 TO NRC, j = 3 TO PR; 				

!******************* 3. PLASTIC WASTE GENERATION IN GJ ******************
! Plastic resin transformation losses from the previous year (4%), assuming same losses in each sector
PlasticWasteTransf[R,i] = SWITCH(t > 1971? 
							PlasticSectors[R,i](t-1)/PlaTransEff[R] - PlasticSectors[R,i](t-1)
						ELSE 0), R= 1 TO NRC, i = 1 TO PS; 

! for scenario with lifetime extension: Baseline with default lifetime and demand linked to historic intensities (demand/ GDP/cap)
! excl. transformation losses, as not used in LTE plastic demand calculation
PlasticWaste_Base[R,i] 		=  LSUM(j= 1 to 90, PPLD[j,i] *  NLAST(PlasticSectors[R,i], j, 0.0)), R= 1 TO NRC, i = 1 to PS;
PlasticWaste_Base[NRC,i] 		= LSUM(R= 1 TO 26,PlasticWaste_Base[R,i]), i = 1 TO PS;

! Baseline waste generation INCL. transformation losses
PlasticWaste[r,i] 			= LSUM(j= 1 to 90, PPLD[j,i] *  NLAST(PlasticSectors[R,i], j, 0.0)) + PlasticWasteTransf[R,i], R= 1 TO NRC, i = 1 to PS;
PlasticWaste[NRC,i] 		= LSUM(R= 1 TO 26,PlasticWaste[R,i]), i = 1 TO PS;

PlasticWasteTot[R] 		= LSUM(i= 1 TO PS,PlasticWaste[R,i]), R = 1 TO NRC;	! Total plastic waste (sum of sectors)
PlasticWasteTot[NRC] 	= LSUM(R= 1 TO 26,PlasticWasteTot[R]);

! Plastic waste BY RESOURCE (fossil & bio)
PlasticWasteTransfRes[R,i,j] = 	SWITCH(t > 1971? 
									PlasticSectorsRes[R,i,j](t-1)/PlaTransEff[R] - PlasticSectorsRes[R,i,j](t-1) ! Plastic resin transformation losses from the previous year (4%), assuming same losses in each sector
								ELSE 0), R= 1 TO NRC, i = 1 TO PS, j= 1 TO PR;

! Final Waste generation
PlasticWasteRes[R,i,j] = LSUM(k= 1 to 90, PPLD[k,i] *  NLAST(PlasticSectorsRes[R,i,j], k, 0.0)) + PlasticWasteTransfRes[R,i,j], R= 1 TO NRC, i = 1 to PS, j= 1 TO PR;
PlasticWasteRes[NRC,i,j]= LSUM(R= 1 TO 26,PlasticWasteRes[R,i,j]), i = 1 TO PS, j= 1 TO PR;

PlasticWasteResTot[R,j] = LSUM(i= 1 TO PS,PlasticWasteRes[R,i,j]), R = 1 TO NRC, j= 1 TO PR;	! Total plastic waste (sum of sectors)
PlasticWasteResTot[NRC,j]= LSUM(R= 1 TO 26,PlasticWasteResTot[R,j]), j = 1 TO PR;

! Resource shares in plastic waste (fossil & biobased)
PlaWaResShare[R,i] 	= SWITCH( LSUM( j = 1 TO PR, PlasticWasteResTot[R,j]) > EPS ?
						SWITCH( i = 1 ?
							LSUM(j= 1 to 2, PlasticWasteResTot[R,j])/ LSUM(j= 1 to PR, PlasticWasteResTot[R,j])	! Fossil
						ELSE 
							LSUM(j= 3 to PR, PlasticWasteResTot[R,j])/ LSUM(j= 1 to PR, PlasticWasteResTot[R,j])	! Biobased
						)
					ELSE	0.5), R = 1 TO NRC, i = 1 TO 2;

!******************* 4. PLASTIC WASTE COLLECTED & DUMPED/BURNT IN GJ ******************
WaCollRate[R] 		= Collrate(GDPpc[R]), R = 1 TO 26;			! Post Consumer Waste collection rate per Income group (GNI/cap in 2005 USD assumed to equal GDP/cap); World Bank (2018): What A waste 2.0
				
PlaWaColl[R] 		= MIN(WaCollRate[R],1) * PlasticWasteTot[R], R = 1 TO 26;		! Plastic waste collected by region in GJ
PlaWaColl[NRC] 		= LSUM(R= 1 TO 26, PlaWaColl[R]);			! Global plastic waste collected in GJ

WaCollRateGlob 		= SWITCH(PlasticWasteTot[NRC] > EPS ? PlaWaColl[NRC]/PlasticWasteTot[NRC] ELSE 0.0);			! Global plastic waste collection rate

PlaWaRemain[R] 		= PlasticWasteTot[R] - PlaWaColl[R], R = 1 TO NRC;	! Remaining plastic waste in GJ (not collected)
PlaWaOpenBurn[R]	= PlaWaRemain[R] * 0.3, R = 1 TO NRC;			! Uncollected plastic waste in GJ that will be openly burnt; 30% assumption based on World Bank 2018: What a Waste 2.0
PlaWaOpenDump[R]	= PlaWaRemain[R] - PlaWaOpenBurn[R], R = 1 TO NRC;	! Uncollected plastic waste openly dumped; assumption based on World Bank 2018: What a Waste 2.0

! by resource
PlaWaCollRes[R,j] 	=  WaCollRate[R] * PlasticWasteResTot[R,j], R = 1 TO 26, j = 1 TO PR;		! Plastic waste collected by region in GJ
PlaWaCollRes[NRC,j] 	= LSUM(R= 1 TO 26, PlaWaCollRes[R,j]), j = 1 TO PR;

PlaWaRemainRes[R,j] 	= PlasticWasteResTot[R,j] - PlaWaCollRes[R,j], R = 1 TO NRC, j = 1 TO PR;	! Remaining plastic waste in GJ (not collected)
PlaWaOpenBurnRes[R,j] 	= PlaWaRemainRes[R,j] * 0.3, R = 1 TO NRC, j = 1 TO PR;			! Uncollected plastic waste in GJ that will be openly burnt; 30% assumption based on World Bank 2018: What a Waste 2.0
PlaWaOpenDumpRes[R,j] 	= PlaWaRemainRes[R,j] - PlaWaOpenBurnRes[R,j], R = 1 TO NRC, j = 1 TO PR;	! Uncollected plastic waste openly dumped; assumption based on World Bank 2018: What a Waste 2.0

!******************* 5. PLASTIC WASTE TREATMENT (of collected plastic waste) ******************
! 5.1. Calculate Costs of waste management treatment options (mechanical recycling, chemical recycling, waste to energy, landfilling)
! 5.2. Calculate "market shares" of these technologies in treating the collected waste
! 5.3. Summary of end of life flows and costs

!*** 5.1 Costs of plastic waste treatment options ***

! 5.1.1) price of HVC sourced plastics (to be substituted by recycling) in $ / GJ plastics (incl. monomer to plastic polymer step)
Price_pHVCplastic[R]	= Price_pHVC[R]+ PlaPolymEnReq[R,1] * PriceSecFuel[R,1,8]		! Electricity 
							+ PlaPolymEnReq[R,2] * PriceSecFuel[R,1,6], R = 1 TO NRC;	! Sec Heat

! 5.1.2) Costs of Mechanical recycling of plastic waste in USD/GJ plastic waste
! Cost factor to decrease fixed costs in scenarios; 
	! default = 1, no change in costs
	! Change in costs gradually implemented between Tstart and TconvScen
MRCF 	= 	SWITCH( FLAG_highRec= 1 ?		
				SWITCH( t < Tstart ? 
					1,
						t >= Tstart AND t < TconvScen ?
					(1-Convergence) * 1 + Convergence * 0.7,
				ELSE 
					0.7 )
			ELSE 
                1
            );  		
					
MR_Cost[R,1] 	= MRCF * PlaWa_EoL[1,1] , R = 1 TO 26; 						! Fixed cost factor
MR_Cost[R,2] 	= PlaWa_EoL[1,2] * PriceSecFuel[R,1,8] , R = 1 TO 26;			! Electricity costs
MR_Cost[R,3] 	= PlaWa_EoL[1,3] * PriceSecFuel[R,1,6] , R = 1 TO 26;			! Heat costs
MR_Cost[R,4] 	= 0, R = 1 TO 26;							! Carbon tax already included in PriceSecFuel; Could be used for premium factors if necessary

! Yields and substitution factor for mechanical recycling
	! include option to increase them for scenarios; gradual implementation of this increase

! Sorting/pre treatment yields of plastic waste (excl. collection); 
	! Default = Weighted average from EU data by sector, Hestin et al 2015 
PlaWa_SY = 	SWITCH( FLAG_highRec= 1 ?		! Flag for increasing sorting yield, e.g. via deposit system and more efficient technology
				SWITCH( t <= Tstart ? 
					0.75,
				t > Tstart AND t < TconvScen ?
					(1-Convergence) * 0.75 + Convergence * 0.9,
				ELSE 
					0.9 
				)
			ELSE
				 0.75
            );

! Recycling yield of plastic waste (output/input of mechanical recycling plants, excl. collection & pre-treatment/sorting); 
	! Default = Estimate based on Hestin et al 2015 (EU data) and Ellen MacArthur Foundation 2016
PlaWa_MRY = SWITCH( FLAG_highRec= 1 ?		! Flag for increasing recycling yield, e.g. via design for recycling, more efficient technology and cleaner input streams
				SWITCH( t <= Tstart ? 
					0.75,
				t > Tstart AND t < TconvScen ?
					(1-Convergence) * 0.75 + Convergence * 0.9,
				ELSE 
					0.9 
				)
				ELSE 0.75
                );

! Substitution factor for substituting virgin plastics with recycled plastics (accounting for quality difference)
	! Default = based on European Commission (2018)/ Rigamonti (2013) 
PlaWa_SF = SWITCH( FLAG_highRec= 1 ?		 ! Flag for increasing substitution factor, e.g. due to higher quality recycling outputs, achieved by purer input streams to recycling (see sorting & recycling yield)
				SWITCH( t <= Tstart ? 
					0.81,
				t > Tstart AND t < TconvScen ?
					(1-Convergence) * 0.81 + Convergence * 0.9,
				ELSE 
					0.9 
				)
			ELSE 0.81);  ! DEFAULT value
					
MR_Benefit[R] 	= Price_pHVCplastic[R] * PlaWa_SY * PlaWa_MRY * PlaWa_SF , R = 1 TO 26;	! Benefit from selling recycled plastics (HVC price + polymerisation costs, multiplied by substituted plastics)
MR_CostTot[R] 	= LSUM(i = 1 TO 4, MR_Cost[R,i]) - MR_benefit[R], R = 1 TO 26;		! Total costs of mechanical recycling incl. benefit from selling recycled plastics
MR_CostTot[NRC] = LSUM(R= 1 TO 26,MR_CostTot[R])/26;					! Average global cost

! 5.1.3) Costs of Waste to Energy (WtE) in USD / GJ of plastic waste 
WtE_Cost[R,1]	= PlaWa_EoL[2,1] , R = 1 TO 26; 		 
WtE_Cost[R,2] 	= PlaWaResShare[R,1] * CCpPlaWa[R]/1000 * CarbonTax[R], R = 1 TO 26;	
					
WtE_Benefit[R,1]= PlaWa_EoL[2,2] * ElecGenShare * PriceSecFuelExclTax[R,1,8] , R = 1 TO 26; 	
WtE_Benefit[R,2]= PlaWa_EoL[2,3] * PriceSecFuelExclTax[R,1,6] , R = 1 TO 26; 		
WtE_CostTot[R]  = LSUM(i = 1 TO 2, WtE_Cost[R,i]) + LSUM(i = 1 TO 2, WtE_Benefit[R,i]), R = 1 TO 26; ! Total WtE costs incl. benefit of selling electricity and heat (given as negative value)
WtE_CostTot[NRC]= LSUM(R= 1 TO 26,WtE_CostTot[R])/26;					! Average global cost

! Test: generator energy price vs final energy price
EnPrice_GenVSFinal[R,1] =  PriceSecFuelExclTax[R,1,8]/PriceSecFuel[R,1,8], R= 1 TO 26; ! Electricity
EnPrice_GenVSFinal[R,2] =  PriceSecFuelExclTax[R,1,6]/PriceSecFuel[R,1,6], R= 1 TO 26; ! Heat

! 5.1.4) Costs of Landfilling in USD / GJ of plastic waste 
{ Model differentiates between 3 types of landfill costs:
	 Lf_Cost[R,1]: Fixed costs: including Site Development & Construction, Equipment, personnel, monitoring, closure & post closure, taxes
	 Lf_Cost[R,2]: Electricity use for operation
	 Lf_Cost[R,3]: Diesel use for excavation works & daily on site operations (from Manfredi et al 2009)
The electricity and diesel costs are based on use data of Manfredi et al. (2009) and the energy prices generated in TIMER. 
They only account for a very marginal share in total landfill costs in the model, ranging from mostly less than 1 % up to ca 5% for some regions.

The dominant cost factor are the fixed costs which can vary significantly, ranging from a minimum of 10 USD/t in low-income countries to 100 USD/t in high income countries (Silpa Kaza et al. 2018). 
Including landfill taxes the costs could increase further: for example Sweden has an average landfill cost of 155 Euro/t and individual landfills could also be more costly as an example of 219 Euro/t in Austria shows (European Environmental Agency (EEA) 2013).

These differences are not just due to location specific conditions (e.g. terrain, climatic factors, scale, personnel costs) but are also driven by regulations, policies and the availability of suitable land. 
This leads to major differences also between high income countries: 
While less densely populated countries like USA or Australia show a high share of landfilling and lower costs, Japan and countries within the European Union have higher costs and lower shares going to landfills  (Collins 2009; European Environmental Agency (EEA) 2013; Plastic Waste Management Institute 2019; Waste360 2017). 

Approach for fixed costs of landfilling:
We chose to model regional and future variations in costs of landfilling based on differences in land prices, representing the GDP & population density of a region. 
The assumption behind our approach is that with rising land prices (representing GDP & population density), also costs of landfilling rise and regions increasingly switch to recycling and waste to energy. 
We calibrated the model by defining a baseline value for landfill costs that keeps the model within realistic landfill cost ranges as reported in literature (Collins 2009; European Environmental Agency (EEA) 2013; Silpa Kaza et al. 2018; Waste360 2017). NEDE uses the land prices which are generated in IMAGE TIMER based on GDP per capita, population size and usable area in each IMAGE region.

Steps: 
	a. Calculate a weighted global land price average
	b. Calculate a landprice factor showing by how much a region deviates from the global average (results show differences of max. 5 times higher land prices (Japan) to almost 3 times lower land prices.
	c. Define as a baseline a global average landfill fixed cost for the year 2015 of 30 USD/t. Considering the landprice variations calculated in step 2 this baseline allows all regions to stay within the price range identified in literature of minimum 10 USD/t up to almost 160 USD/t 
	d. Fix cost baseline will be adapted based on changes in the global land price average
	e. The fixed landfill costs per region are calculated as a function of the fixed cost basline and the land price factor (Regional land price/global average land price)
}

! a) Calculate average global land price (weighted) in $/ha
LandPriceAv=  SWITCH(LSUM(R=1 to 26, RegionSizeNet[R]) > EPS ? 
				LSUM(R= 1 TO 26, LandPrice[R]*RegionSizeNet[R])/LSUM(R=1 to 26, RegionSizeNet[R])
			ELSE 1/26);	

! b) Factor describing by how much a regions land price (based on GDP, Pop & RegionSize) is higher or lower than the global average
LandPriceFac[R]	= LandPrice[R]/LandPriceAv, R= 1 TO 26;

! c) Define baseline values (for year 2015)
LF_FixCostBaseline	= 30/35; 		! baseline value for fixed landfill cost(for year 2015)in USD/GJ plastic waste (30 USD/t, LHV plastic waste of 35 GJ/t)
LandPriceAvBaseline	= 256;			! Baseline value for global average land price in USD (using LandPriceAv value of year 2015 as baseline)

! d) Calculate past and future average baseline fixed costs based on changes in global land price averages
! Assumption: With rising global land price averages (representing GDP& population density), also the global average landfill cost rises
LF_FixCostAv	= SWITCH( t < 2015?
					LF_FixCostBaseline * LandPriceAv/LandPriceAvBaseline
				ELSE
			 		SWITCH (t = 2015?
						LF_FixCostBaseline
				  	ELSE LF_FixCostAv(2015) * LandPriceAv/LandPriceAv(2015)
					)
				);

! e) Calculate the regional fixed landfill cost ($) as a function of the fixed cost baseline and the land price factor (Regional land price/global average land price)
Lf_Cost[R,1] 	= LandPriceFac[R] * LF_FixCostAv, R = 1 to 26;
Lf_Cost[NRC,1]	= LF_FixCostAv;
!Lf_Cost[R,1] 	= PlaWa_EoL[3,1] , R = 1 TO 26;  				! Fixed costs

! Calculate the costs of electricity and diesel use
Lf_Cost[R,2] 	= PlaWa_EoL[3,2] * PriceSecFuel[R,1,8] , R = 1 TO 26;		! Electricity
Lf_Cost[R,3] 	= PlaWa_EoL[3,3] * PriceSecFuelNonEn[R,2] , R = 1 TO 26;	! Diesel 

Lf_Cost[R,4] 	= 0, R = 1 TO 26;						! Could be used for premium factors if necessary

Lf_CostTot[R] 	= LSUM(i = 1 TO 4, Lf_Cost[R,i]), R = 1 TO 26;		! Total costs
Lf_CostTot[NRC] = LSUM(R= 1 TO 26,Lf_CostTot[R])/26;			! Average global cost

! 5.1.5) Costs of chemical recycling (pyrolysis) in USD/GJ plastic waste

! Option to decrease fixed costs of pyrolysis & yields via factor (used in scenarios)
	! gradual implementation between Tstart and TconvScen
	! Default = 1, no change in costs and yields

PyrCF = SWITCH( FLAG_highRec= 1 ?		! Flag for decreasing fixed costs of pyrolysis
			SWITCH( t <= Tstart ? 
				1,
			t > Tstart AND t < TconvScen ?
				(1-Convergence) * 1 + Convergence * 0.7,
			ELSE 
				0.7 
			)
		ELSE 1
        );  ! DEFAULT value: Pyrolysis fixed costs stay unchanged

PyrYF = SWITCH( FLAG_highRec= 1 ?		! Flag for increasing yield of pyrolysis; same % increase in yield as for MR (which changes from 0.75 to 0.9)
			SWITCH( t <= Tstart ? 
				1,
			t > Tstart AND t < TconvScen ?
				(1-Convergence) * 1 + Convergence * 1.2,
			ELSE 
				1.2 
			)
		ELSE 1
        );  ! DEFAULT value: Pyrolysis yield stay unchanged
	

PlaWa_SYpyr = 0.9;	! higher sorting yield than for MR, as Pyrolysis accepts more mixed, low-quality plastics than MR; Only certain plastic types have to be sorted out (e.g. PVC)

PYR_cost[R,1] 	= PyrCF * ConvCostPRIMNE_in[5] * PlaWa_SYpyr * PyrYF * EffPRIMNE[R,5], R = 1 TO 26;				                            ! CapOm costs for plastic waste to waste naptha in USD/GJ plastic waste (ConvCost is in $/GJ naphtha)
PYR_cost[R,2] 	= PyrCF * ConvCostFEEDNE_in[5]  * PlaWa_SYpyr * PyrYF * EffPRIMNE[R,5] * PyrYF * EffFEEDNE[R,5], R = 1 TO 26;				! CapOm costs for waste naptha to HVC in USD/GJ plastic waste (ConvCost is in $/GJ HVC); same as in hvc.m
PYR_cost[R,3] 	= ConvEnUsePRIMNE_in[5] * PlaWa_SYpyr * PyrYF * EffPRIMNE[R,5] * PriceSecFuelNonEn[R,3], R = 1 TO 26; 	                    ! costs of heat for plastic waste to waste naptha in USD/GJ plastic waste
PYR_cost[R,4] 	= ConvEnUseFEEDNE_in[5] * PlaWa_SYpyr * PyrYF * EffPRIMNE[R,5] * PyrYF * EffFEEDNE[R,5] * PriceSecFuelNonEn[R,3], R = 1 TO 26; 	! costs of heat for waste naptha to HVC in USD/GJ plastic waste
PYR_cost[R,5] 	= PyrCF * 0.29 * PlaWa_EoL[1,1] + 0.0058 * PriceSecFuel[R,1,8], R = 1 TO 26;	                                            ! Costs of sorting (fixed costs + electricity costs, same as used for MR); 0.29 as that is the fixed cost share of sorting in total mech. recycling costs (from Hestin et al)
PYR_cost[R,6] 	= PlaWa_SYpyr * PyrYF * EffPRIMNE[R,5] * PyrYF * EffFEEDNE[R,5] * (PlaPolymEnReq[R,1] * PriceSecFuel[R,1,8]                 ! costs of polymerisation (electricity & heat)
					+ PlaPolymEnReq[R,2] * PriceSecFuel[R,1,6]) , R = 1 TO 26;	 					
PYR_cost[R,7] 	=  	(1- PyrYF * EffPRIMNE[R,5] * PyrYF * EffFEEDNE[R,5]) * 	                                                                ! plastic losses (=emitted) during chem. recycling
                    PlaWaResShare[R,1] * CCpPlaWa[R]/1000 * CarbonTax[R]                                                                    ! /1000 as carbon tax is per tonne and CCpPlawa is in kg; only fossil share of plastic waste is taxed
					, R = 1 TO 26;	
PYR_cost[R,8]	= 0, R = 1 TO 26; 

PYR_Benefit[R]	= Price_pHVC[R] *  PlaWa_SYpyr * PyrYF * EffPRIMNE[R,5] * PyrYF * EffFEEDNE[R,5], R = 1 TO 26; 			! Benefit from selling chem. recycled plastics in USD/GJ, assuming a market substitution factor of 1 (chem. rec. plastics has same quality as virgin plastics)
PYR_CostTot[R]	= LSUM(i = 1 TO 8, PYR_cost[R,i]) - PYR_Benefit[R] , R = 1 TO 26; 		! Total costs in USD/GJ plastic waste
PYR_CostTot[NRC]= LSUM(R= 1 TO 26,PYR_CostTot[R])/26;						! Average global cost

! 5.1.6 Total costs of waste management treatment options
EoL_CostTot[R,1] = MR_CostTot[R], R = 1 TO NRC;
EoL_CostTot[R,2] = WtE_CostTot[R], R = 1 TO NRC;
EoL_CostTot[R,3] = PYR_CostTot[R], R = 1 TO NRC;
EoL_CostTot[R,4] = Lf_CostTot[R], R = 1 TO NRC;

! *** 5.2. Calculate SHARES of these end of life options in treating the collected waste *** 

! 5.2.1 Exclude WtE & pyrolysis for regions whose GDP/cap is below 10000 USD/cap (as they are costly high tech solutions, and i.e. WtE requires low biological waste content to work properly which is not the case in developing economies)

Active_EoL[R,i] = 	SWITCH(t <= 2020? 
						Active_Eol_hist[R,i] 
					ELSE 
						SWITCH(GDPpc[R] > 10000 ? 
							Active_Eol_hitech[R,i]
						ELSE Active_Eol_lowtech[R,i]
						)
					), R = 1 TO 26, i = 1 TO EOL;

! Add limitations							
EoL_CostTot2[R,i]	= SWITCH(Active_EoL[R,i] = 1  ?
						EoL_CostTot[R,i]
					ELSE 1000), R = 1 TO 26, i = 1 TO EOL;

EoL_CostTot2[R,i] = SWITCH( t < 1980 ? 			! Only allowing for MR, WtE and Pyr after 1980
						1000
					ELSE EoL_CostTot2[R,i]), R= 1 TO NRC, i = 1 TO 3;
	
! Landfill Ban
REAL  LandfillBan[NRC](t);
LandfillBan[R]	= 	SWITCH( t <= Tstart? 
						EoL_CostTot[R,4]		! Before Tstart use modeled costs
					ELSE 
						SWITCH (t > Tstart AND t <= 2050 ?					! between Tstart and 2050 smoothen between modeled costs and Landfill ban 
							((2050-t) * EoL_CostTot[R,4] + (t-Tstart) * EoL_CostTot[R,4] * 3)/(2050-Tstart)		! introducing a tripling of landfill costs until 2050
						ELSE 1000
						)
					), R = 1 to NRC;						! After 2050 apply full landfill ban 
			
EoL_CostTot2[R,4] 	= SWITCH(FLAG_LandfillBan = 1?
						LandfillBan[R]
					ELSE EoL_CostTot[R,4]), R = 1 to NRC;	
										
! Make sure that costs are not negative (could happen with large benefit of replacing energy or primary plastics); 
	! avoids "Inf" error in MNL		
	! +CorrectedMinCost to all EoL options to keep relative costs accurate
REAL CorrectedMinCost[NRC](t);

CorrectedMinCost[R] = SWITCH( LMIN(i = 1 TO EOL, EoL_CostTot2[R,i]) < EPS ? ! take lowest cost EoL option and check if it is negative
							-1 * LMIN(i = 1 TO EOL, EoL_CostTot2[R,i]) ! if negative, make it positive
					ELSE 0.0), R = 1 TO NRC;
												
EoL_CostTot3[R,i]	= EoL_CostTot2[R,i] + CorrectedMinCost[R] + EPS, R = 1 TO 26, i = 1 TO EOL; ! Add it to all EoL options to keep relative costs accurate

! Calculate desired "market shares" of these technologies in treating the collected waste (without limitations & caps) via Multinomial logit (MNL)
EoL_FloorPrice[R]	= MAX(0,(LMIN(i=1 TO EOL, (EoL_CostTot3[R,i])))), R = 1 TO NRC; 				! Cheapest EoL option
EoL_ShareCalc[R,i] 	= EXP(-LogitPar_NonEn*(EoL_CostTot3[R,i] - EoL_FloorPrice[R])), R=1 to NRC, i=1 to EOL;	! nominator of MNL
EoL_ShareDenom[R] 	= LSUM(i = 1 to EOL,EoL_ShareCalc[R,i]), R = 1 to NRC;					! denominator of MNL
EoL_MShareDes[R,i] 	= SWITCH(EoL_ShareDenom[R] > EPS ?							! Desired market shares of EoL options (share of plastic waste sent to MR, WtE & Lf)
				EoL_ShareCalc[R,i] / EoL_ShareDenom[R],
				ELSE 1/4), R=1 to NRC2, i=1 to EOL;

EoL_MShareDes[NRC,i]	= SWITCH(PlaWaColl[NRC] > EPS ?
							LSUM(R= 1 TO 26, EoL_MShareDes[R,i]*PlaWaColl[R]/PlaWaColl[NRC])
						ELSE 1/EOL), i=1 to EOL;		! Weighted global average market shares

EoL_MShareDes[NRC,i]	= SWITCH( PlaWaColl[NRC] > EPS ?
							LSUM(R= 1 TO 26, EoL_MShareDes[R,i]*PlaWaColl[R]/PlaWaColl[NRC])
						ELSE 1/EOL), i=1 to EOL;		! Weighted global average market shares

!*** APPLY CAPS OF EoL options ***
! market shares without WtE
EoL_CostTot_noWtE[R,i] = EoL_CostTot3[R,i], R=1 to NRC, i=1 to EOL;
EoL_CostTot_noWtE[R,2] = 1000, R=1 to NRC;

EoL_FloorPrice_noWtE[R]	= MAX(0,(LMIN(i=1 TO EOL, (EoL_CostTot_noWtE[R,i])))), R = 1 TO NRC; 				! Cheapest EoL option
EoL_ShareCalc_noWtE[R,i]= EXP(-LogitPar_NonEn*(EoL_CostTot_noWtE[R,i] - EoL_FloorPrice_noWte[R])), R=1 to NRC, i=1 to EOL;	! nominator of MNL
EoL_ShareDenom_noWtE[R] = LSUM(i = 1 to EOL,EoL_ShareCalc_noWte[R,i]), R = 1 to NRC;					! denominator of MNL
EoL_MShareDes_noWtE[R,i]= SWITCH(EoL_ShareDenom_noWte[R] > EPS ?							! Desired market shares of EoL options (share of plastic waste sent to MR, WtE & Lf)
							EoL_ShareCalc_noWte[R,i] / EoL_ShareDenom_noWte[R],
						ELSE 1/3), R=1 to NRC, i=1 to EOL;

! Market shares if WtE is above limit				
EoL_MShareDes2[R,1] 	= SWITCH(EoL_MShareDes[R,2] > WtE_cap ?		! Mechanical recycling
							EoL_MShareDes_noWtE[R,1] * (1-WtE_cap),
						ELSE EoL_MShareDes[R,1]), R=1 to NRC;

EoL_MShareDes2[R,2] 	= MIN(EoL_MShareDes[R,2], WtE_cap), R = 1 TO NRC;	! Waste to Energy

EoL_MShareDes2[R,i] 	= SWITCH(EoL_MShareDes[R,2] > WtE_cap ?		! Pyrolysis and landfill
							EoL_MShareDes_noWtE[R,i] * (1-WtE_cap),
						ELSE EoL_MShareDes[R,i]), R=1 to NRC, i = 3 TO EOL;

! market shares without MR
REAL EoL_MShareDes_noMR2[NRC,EOL](t); 

EoL_CostTot_noMR[R,1] 	= 10000, R=1 to NRC;
EoL_CostTot_noMR[R,i] 	= EoL_CostTot3[R,i], R=1 to NRC, i=2 to EOL;

EoL_FloorPrice_noMR[R]	= MAX(0,(LMIN(i=1 TO EOL, (EoL_CostTot_noMR[R,i])))), R = 1 TO NRC; 					! Cheapest EoL option
EoL_ShareCalc_noMR[R,i] = EXP(-LogitPar_NonEn*(EoL_CostTot_noMR[R,i] - EoL_FloorPrice_noMR[R])), R=1 to NRC, i=1 to EOL;! nominator of MNL
EoL_ShareDenom_noMR[R] 	= LSUM(i = 1 to EOL,EoL_ShareCalc_noMR[R,i]), R = 1 to NRC;						! denominator of MNL
EoL_MShareDes_noMR2[R,i]= SWITCH(EoL_ShareDenom_noMR[R] > EPS ?								! Desired market shares of EoL options (share of plastic waste sent to MR, WtE & Lf)
							EoL_ShareCalc_noMR[R,i] / EoL_ShareDenom_noMR[R],
						ELSE 1/3), R=1 to NRC, i=1 to EOL;

! smoothen market shares over 10 years
EoL_MShareDes_noMR[R,i] = LAVG(k=1 to 15,NLAST(EoL_MShareDes_noMR2[R,i],k,EoL_MShareDes_noMR2[R,i])), R = 1 TO NRC, i = 1 TO EOL;				

! EoL MARKET SHARES incl. cap of mechanical recycling & WtE (Collected plastic waste sent to MR, WtE, Pyr & Landfill)
EoL_MShare2[R,1] 	= MIN(EoL_MShareDes2[R,1], MR_cap), R = 1 TO NRC;		! Mechanical recycling
			
EoL_MShare2[R,i] 	= SWITCH(EoL_MShareDes2[R,1] > MR_cap ?			! Waste to Energy, Pyrolysis and landfill
						EoL_MShareDes_noMR[R,i] * (1-MR_cap),
					ELSE EoL_MShareDes2[R,i]), R=1 to NRC, i = 2 TO EOL;
				
! smoothened EoL MARKET SHARES				
EoL_MShare3[R,i] = LAVG(k=1 to 15,NLAST(EoL_MShare2[R,i],k,EoL_MShare2[R,i])), R = 1 TO NRC, i = 1 TO EOL;

! FINAL EoL MARKET SHARES incl. historic values where available	(USA, EU, Japan)
EoL_MShare[R,i]= SWITCH( LSUM (j = 1 To EOL, EoL_MShare_Hist[R,j]) > 0 AND t <= 2017 AND t >= 1980 ?  ! Use historic values before 2017 if available
					EoL_MShare_Hist[R,i]
				ELSE 
					SWITCH( LSUM (j = 1 To EOL, EoL_MShare_Hist[R,j]) > 0 AND t > 2017 AND t <= 2035 ?
						((2035-t) * EoL_MShare_Hist[R,i] + (t-2017) * EoL_MShare3[R,i])/(2035-2017)					
					ELSE EoL_MShare3[R,i] ! Smoothened Model results
					)	
				), R = 1 TO NRC, i = 1 TO EOL;
			
EoL_MShare[NRC,i] 	= SWITCH(PlaWaColl[NRC] > EPS ? 
						LSUM(R= 1 TO 26, EoL_MShare[R,i]*PlaWaColl[R])/PlaWaColl[NRC]
					ELSE 1/EOL), i=1 to EOL;		! Weighted global average market shares


! *** 5.3) SUMMARY of end of life flows and costs
! Waste in GJ SENT to different EoL
FlowsToEOLRes[R,i,j]	= EoL_MShare[R,i] * PlaWaCollRes[R,j], R=1 to NRC2, i=1 to EOL, j = 1 TO PR;	
FlowsToEOLRes[NRC,i,j]	= LSUM(R= 1 TO 26, FlowsToEOLRes[R,i,j]), i=1 to EOL, j = 1 TO PR;

FlowsToEOL[R,i]			= EoL_MShare[R,i] * PlaWaColl[R], R=1 to NRC2, i=1 to EOL;
FlowsToEOL[NRC,i]		= LSUM(R = 1 to 26, FlowsToEOL[R,i]), i=1 to EOL;

!*** EoL PLASTIC FLOWS by resources: Total plastics recycled, incinerated, pyrolysized and landfilled ***
MR_plasticsRes[R,j]		= FlowsToEOLRes[R,1,j] * PlaWa_SY * PlaWa_MRY,  R = 1 TO NRC, j = 1 TO PR; 	! recycled plastics produced in GJ (to be deducted from total HVC demand)
MR_rejectsRes[R,j] 		= FlowsToEOLRes[R,1,j] - MR_plasticsRes[R,j], R = 1 TO NRC, j = 1 TO PR;  		! Rejects of plastic recycling going back to plastic waste in GJ: Difference between plastic waste going to recycling and recycled plastics produced

EoL_flowsRes[R,i,j]	= SWITCH(i =1?	! MR (excl. efficiency losses, those are sent to the other EoL options)
						MR_plasticsRes[R,j],	
							i=2? 	! WtE
						FlowsToEOLRes[R,2,j] + EoL_MShareDes_noMR[R,2] * MR_rejectsRes[R,j],
							i=3?	! sent to Pyrolysis, still efficiency losses
						FlowsToEOLRes[R,3,j] + EoL_MShareDes_noMR[R,3] * MR_rejectsRes[R,j]
					ELSE 	! Landfill
						FlowsToEOLRes[R,4,j] + EoL_MShareDes_noMR[R,4] * MR_rejectsRes[R,j]
					), R=1 to NRC2, i= 1 TO EOL, j = 1 TO PR;
							
EoL_flowsRes[NRC,i,j]	= LSUM(R = 1 TO 26, EoL_flowsRes[R,i,j]), i= 1 to EOL, j = 1 TO PR;

PYR_plasticsRes[R,j]	= EoL_flowsRes[R,3,j] * PyrYF * EffPRIMNE[R,5] * PyrYF * EffFEEDNE[R,5], R = 1 TO NRC, j = 1 TO PR;	! plastics produced via pyrolysis in GJ

! total EOL plastic flows (sum of resources)
MR_plastics[R]		= FlowsToEOL[R,1] * PlaWa_SY * PlaWa_MRY,  R = 1 TO NRC;
MR_plastics[NRC]	= LSUM(R= 1 TO 26, MR_plastics[R]);

MR_rejects[R]		= FlowsToEOL[R,1] - MR_plastics[R],  R = 1 TO NRC;	
MR_rejects[NRC]		= LSUM(R= 1 TO 26, MR_rejects[R]);


EoL_flows[R,i]		= 	SWITCH(i =1?	! MR (excl. efficiency losses, those are sent to the other EoL options)
								MR_plastics[R],	
							i=2? 	! WtE
								FlowsToEOL[R,2] + EoL_MShareDes_noMR[R,2] * MR_rejects[R],
							i=3?	! sent to Pyrolysis, still efficiency losses
								FlowsToEOL[R,3] + EoL_MShareDes_noMR[R,3] * MR_rejects[R]
						ELSE 	! Landfill
								FlowsToEOL[R,4] + EoL_MShareDes_noMR[R,4] * MR_rejects[R]
						), R=1 to NRC2, i= 1 TO EOL;
EoL_flows[NRC,i]	= LSUM(R = 1 TO 26, EoL_flows[R,i]), i= 1 TO EOL;

PYR_plastics[R]		= EoL_flows[R,3] *  PyrYF * EffPRIMNE[R,5] * PyrYF * EffFEEDNE[R,5], R = 1 TO NRC; ! recycled plastics via pyrolysis
PYR_plastics[NRC]	= LSUM(R= 1 TO 26, PYR_plastics[R]);

! Final EoL rates (i.e. plastics recycled instead of plastics sent to recycling (which is EoL_MShare[R,1])
EoL_rates[R,i]		= SWITCH( LSUM(j = 1 to EOL, EoL_flows[R,j]) > EPS ? 
						EoL_flows[R,i]/LSUM(j = 1 to EOL, EoL_flows[R,j])
					ELSE 0.0),  R=1 to NRC, i=1 to EOL;
EoL_rates[NRC,i]	= SWITCH( PlaWaColl[NRC] > EPS ? 
						LSUM(R= 1 TO 26, EoL_rates[R,i]*PlaWaColl[R]/PlaWaColl[NRC])
					ELSE 0.0), i=1 to EOL; ! Weighted global average EoL rates

! Fate of total plastic waste (recycled, sequestered, burnt), incl. uncollected waste: Shares of [1] plastic waste recycled (MR+PYR], [2] sequestered (landfilled+dumped), [3] burnt (WtE+open burn)
EOLfate[R,i]		= SWITCH( PlasticWasteTot[R] > EPS ? 
						SWITCH(	i=1?
							(MR_plastics[R]+PYR_plastics[R])/PlasticWasteTot[R],	! Share of recycled plastics
						i=2?
							(EoL_flows[R,4]+PlaWaOpenDump[R])/PlasticWasteTot[R]	! Share of plastics sequestred in landfills and dumps
						ELSE
							(EoL_flows[R,2]+PlaWaOpenBurn[R]+ EoL_flows[R,3]-PYR_plastics[R])/PlasticWasteTot[R])	! share of plastics burnt (in WtE or openly) or emitted (Pyrolysis)
					ELSE 0), R= 1 to 26, i= 1 TO 3;
					
EOLfate[NRC,i]		= SWITCH( PlasticWasteTot[NRC] > EPS ? 
						LSUM(R= 1 TO 26, EOLfate[R,i]*PlasticWasteTot[R])/PlasticWasteTot[NRC]
					ELSE 0.0), i= 1 to 3; ! Weighted global average EoL fate

! *** Total energy use for plastics end of life *** 
! Process energy or energy generated (WtE); Does not include plastic waste input
! Rearranged to 9 energy carriers: 1 = Coal, 2= Oil, 3= Natural Gas, 4= BSF, 5= BLF, 6= Waste, 7= Electricity, 8= Heat, 9 = Diesel; In EoL only 6 to 9 used (ignoring waste)

MR_EnergyTot[R,EC]	=SWITCH(EC = 7? FlowsToEOL[R,1] * PlaWa_EoL[1,2],	! Electricity use in GJ for Mechanical recycling
						EC = 8? FlowsToEOL[R,1] * PlaWa_EoL[1,3]	! Heat use in GJ for Mechanical recycling
					ELSE 0), EC = 1 TO ECP, R = 1 TO NRC;		! no other energy sources used (no Diesel use as as transportation is excluded in the model)
				
WtE_EnergyTot[R,EC]	=SWITCH(EC = 7? EoL_flows[R,2] * PlaWa_EoL[2,2],	! Electricity benefit in (minus) GJ for waste to energy
						EC = 8? EoL_flows[R,2] * PlaWa_EoL[2,3]		! Heat benefit in (minus) GJ for waste to energy
					ELSE 0), EC = 1 TO ECP, R = 1 TO NRC;		! no other energy sources used (no diesel use, as transportation is excluded in the model)

PYR_EnergyTot[R,EC]	=SWITCH(EC = 3? 
						EoL_flows[R,3] * (ConvEnUsePRIMNE_in[5]*   EffPRIMNE[R,5]+ ! Use of heat in GJ for pyrolysis 
						ConvEnUseFEEDNE_in[5] * PyrYF *  EffPRIMNE[R,5] * EffFEEDNE[R,5]),	
					EC = 7? 
						0.0058 * EoL_flows[R,3] ! electricity for sorting (same as for MR)
						+ PlaPolymEnReq[R,1] * PYR_plastics[R], ! electricity for polymerisation
					EC = 8? 
						PlaPolymEnReq[R,2] * PYR_plastics[R]	! heat for polymerisation
					ELSE 0), EC = 1 TO ECP, R = 1 TO NRC;				! no other energy sources used; no diesel use, as transportation is excluded in the model

Lf_EnergyTot[R,EC]	=SWITCH(EC = 7? 
						EoL_flows[R,4] * PlaWa_EoL[3,2],	! Electricity use in GJ for Landfilling
					EC = 2? 
						EoL_flows[R,4] * PlaWa_EoL[3,3]		! Diesel use in GJ for Landfilling (allocated to oil)
					ELSE 0), EC = 1 TO ECP, R = 1 TO NRC;		! no other energy sources used 


EoL_EnergyTot[R,EC] 	= MR_EnergyTot[R,EC] + WtE_EnergyTot[R,EC] 		! Total energy use of plastic waste treatment in GJ
						+ PYR_EnergyTot[R,EC] + Lf_EnergyTot[R,EC], R = 1 TO NRC, EC = 1 TO ECP; 

! EoL COSTS SUMMARY
EoL_costAv[R]		= LSUM(i = 1 TO EOL, EoL_MShare[R,i] *  EoL_CostTot[R,i]), R = 1 to NRC; 	! Average costs of treating plastc waste in USD / GJ plastic waste, weighted average

Eol_CostAll[R,i] 	= EoL_MShare[R,i] *  EoL_CostTot[R,i] * PlaWaColl[R],  R=1 to 26, i=1 to EOL;	! Total costs of (collected) plastic waste treatment by EoL option and region in USD 
Eol_CostAll[NRC,i]	= LSUM(R= 1 TO 26, Eol_CostAll[R,i]), i=1 to EOL;

Eol_CostTotAll[R]	= LSUM(i = 1 TO EOL, Eol_CostAll[R,i]), R = 1 to NRC; 				! Total cost of (collected) plastic waste treatment by region (sum of all options)

! ****************** 6. TRANSFORMATION OF PLASTIC RESINS INTO (semi-finished) PLASTIC PRODUCTS ******************
{Plastic resins are transformed to semi-finished plastic products via different technologies like calendaring, blow molding, compression molding, extrusion or injection molding.
We apply a weighted average energy use and efficiency for this production step, using 
	(1) data on energy use and efficiencies of these technologies (Keoleian et al 2012)
	(2) their use shares in transforming different plastic resins (Keoleian et al 2012) 
	(3) market shares of the plastic resins (from Geyer et al 2017); 
The available data just covers PP,PET,PVC & PE(LDPE,LLDPE,HDPE) but those resin types represent 72% of the plastic market and are thus used as a proxy
Plastic transformation is applied to both primary and secondary plastics}

PlaTransfEnReq[R]	= 0.252 * PlaTransEff[R], R= 1 TO NRC;	! Electricity requirement in GJ for transforming 1 GJ of plastic resin into a plastic product

! Total energy use in GJ of transforming plastic resins into plastic products
! Assumption: Only electricity used in transformation (which is almost only the case according to Keoleian et al 2012 and Franklin Associates 2011)
! Transformation is required for both primary and secondary plastics
PlaTransfEnTot[R,EC]	= SWITCH( EC = 7?
							PlaTransfEnReq[R] * PlasticNetTot[R]
						ELSE 0) , EC = 1 TO ECP, R= 1 TO NRC;

PlaTransfEnTot[NRC,EC]	= LSUM(R= 1 TO 26,PlaTransfEnTot[R,EC]), EC = 1 TO ECP;

!****************** 7. PLASTIC STOCKS AND CUMULATIVE PLASTIC PRODUCTION, WASTE GENERATION & END OF LIFE OPTIONS ******************
! *** 7.1 Cumulative plastic production in GJ ***
PlasticCumu[R,i] = SWITCH(t = 1971 ? 			! Cumulative plastic production over time per region and sector in GJ
					PlasticSectors[R,i]
				ELSE PlasticSectors[R,i] + LAST(PlasticCumu[R,i],0.0)), R = 1 TO NRC, i = 1 TO PS;
									
PlasticCumu2[R]= LSUM(i= 1 TO PS, PlasticCumu[R,i]), R = 1 TO NRC;  	! Total cumulated plastic (sum of sectors) in GJ

! same by resource
PlasticCumuRes[R,j]	= SWITCH(t = 1971 ? 							! Cumulative plastic production over time per region and resource in GJ
						PlasticNetRes[R,j]
					ELSE PlasticNetRes[R,j] + LAST(PlasticCumuRes[R,j],0.0)), R = 1 TO NRC, j = 1 TO PR;
                    
! *** 7.2 Cumulative plastic waste generation in GJ ***
PlasticWasteCumu[R,i] 	= SWITCH(t = 1971 ? 			! Cumulative plastic waste over time per region and sector in GJ
							PlasticWaste[R,i]
						ELSE PlasticWaste[R,i] + LAST(PlasticWasteCumu[R,i],0.0)), R = 1 TO NRC, i = 1 TO PS;

PlasticWasteCumu2[R]	= LSUM(i= 1 TO PS, PlasticCumu[R,i]),  R = 1 TO NRC;  	! Total cumulated plastic (sum of sectors) in GJ

! cumulative Plastic waste without plastic transformation losses (needed for calculating plastic stocks)
PlasticWasteCumuNoTransf[R,i] 	= SWITCH(t = 1971 ? 			! Cumulative plastic waste over time per region and sector in GJ
									PlasticWaste_Base[R,i]
								ELSE PlasticWaste_Base[R,i] + LAST(PlasticWasteCumuNoTransf[R,i],0.0)), R = 1 TO NRC, i = 1 TO PS;

! same by resource             		
PlasticWasteCumuRes[R,j]=  SWITCH(t = 1971 ? 							! Cumulative plastic waste over time per region and resource in GJ
								PlasticWasteResTot[R,j]
							ELSE PlasticWasteResTot[R,j] + LAST(PlasticWasteCumuRes[R,j],0.0)), R = 1 TO NRC, j = 1 TO PR;

PlasticWasteCumuNoTransfRes[R,j]=  SWITCH(t = 1971 ? 							! Cumulative plastic waste over time per region and resource in GJ without plastic transformation losses (needed for calculating plastic stocks)
										PlasticWasteResTot[R,j] - LSUM(i = 1 TO PS,PlasticWasteTransfRes[R,i,j])
                             		ELSE PlasticWasteResTot[R,j] - LSUM(i = 1 TO PS,PlasticWasteTransfRes[R,i,j]) + LAST(PlasticWasteCumuNoTransfRes[R,j],0.0)), R = 1 TO NRC, j = 1 TO PR;

! *** 7.3 Plastic stocks (= plastics in use) in GJ ***
PlasticStock[R,i] 	= PlasticCumu[R,i] - PlasticWasteCumuNoTransf[R,i] , R= 1 TO NRC, i = 1 TO PS; ! plastics in use (= not emitted) by sector and region in GJ
PlasticStock[NRC,i] = LSUM(R= 1 TO 26, PlasticStock[R,i]),i = 1 TO PS;

PlasticStockTot[R]	= LSUM(i = 1 TO PS, PlasticStock[R,i]), R= 1 TO NRC;

! same by resource      		
PlasticStockRes[R,j]	= PlasticCumuRes[R,j] - PlasticWasteCumuNoTransfRes[R,j], R= 1 TO NRC, j = 1 TO PR; ! Plastic stock (plastics in use) by resource in GJ
PlasticStockRes[NRC,j]	= LSUM(R= 1 TO 26, PlasticStockRes[R,j]),j = 1 TO PR;

!*** 7.4 Cumulative end of life options by resource *****
EoL_flowsCumuRes[R,i,j] 	= SWITCH(t = 1971 ? 			! Cumulative plastic waste mechanically recycled, incinerated, chem. recycled (pyrolysis), landfilled in GJ
								EoL_flowsRes[R,i,j]
							ELSE EoL_flowsRes[R,i,j] + LAST(EoL_flowsCumuRes[R,i,j],0.0)), R = 1 TO NRC, i = 1 TO EOL, j = 1 to PR;
EoL_flowsCumuRes[NRC,i,j]	= LSUM(R= 1 TO 26, EoL_flowsCumuRes[R,i,j]), i = 1 TO EOL, j = 1 TO PR;

PlaWaOpenDumpCumuRes[R,j] 	= SWITCH(t = 1971 ? 			! Cumulative plastic waste openly dumped in GJ
								PlaWaOpenDumpRes[R,j]
							ELSE PlaWaOpenDumpRes[R,j] + LAST(PlaWaOpenDumpCumuRes[R,j],0.0)), R = 1 TO NRC, j = 1 to PR;
PlaWaOpenDumpCumuRes[NRC,j] 	= LSUM(R= 1 TO 26, PlaWaOpenDumpCumuRes[R,j]),j = 1 TO PR;      
           
PlaWaOpenBurnCumuRes[R,j] 	= SWITCH(t = 1971 ? 			! Cumulative plastic waste openly burned in GJ
								PlaWaOpenBurnRes[R,j]
							ELSE PlaWaOpenBurnRes[R,j] + LAST(PlaWaOpenBurnCumuRes[R,j],0.0)), R = 1 TO NRC, j = 1 to PR;
PlaWaOpenBurnCumuRes[NRC,j] 	= LSUM(R= 1 TO 26, PlaWaOpenBurnCumuRes[R,j]),j = 1 TO PR; 


!****************** 8. OVERVIEW ENERGY USE FOR PLASTICS PRODUCTION AND WASTE MANAGEMENT ******************
! Energy use in plastics production and end of life in GJ (by production step and waste treatment)
PlasticEnUse[R,EC,i]	= SWITCH(i = 1 ?
							pPlasticGrossUp[R,EC],			! Upstream plastic monomer production
						i = 2?
				 			PlaPolymEnTot[R,EC],				! Polymerisation of primary plastic monomers
				 		i = 3?
				 			MR_EnergyTot[R,EC],				! Energy use in Mechanical recycling
						i = 4?
							WtE_EnergyTot[R,EC],				! Energy benefit in waste to energy
				 		i = 5?
							PYR_EnergyTot[R,EC],				! Energy use in pyrolysis
				 		i = 6?
							Lf_EnergyTot[R,EC],				! Energy use in landfilling
				 		i = 7?
							PlaTransfEnTot[R,EC]				! Energy use in transforming primary and recycled plastic resins to products
			  			ELSE 
							LSUM(k= 1 TO 7, PlasticEnUse[R,EC,k])			! Total energy use in plastics production and end of life
						), R = 1 TO 26, EC = 1 TO ECP, i= 1 TO 8;

PlasticEnUse[NRC,EC,i]	= LSUM(R= 1 TO 26,PlasticEnUse[R,EC,i]), EC = 1 TO ECP, i = 1 TO 8;							

END;