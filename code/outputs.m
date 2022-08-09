! Post processing of PLAIA results to produce specific outputs

! Plastics produced in GJ by resource (fossil, bio) and by production pathway (primary, MR, PYR)
Plastics_IN[R,1] 	= pPlasticNetFeed[R,1], R= 1 TO NRC;			! Coal
Plastics_IN[R,2] 	= pPlasticNetFeed[R,2], R= 1 TO NRC;			! Oil
Plastics_IN[R,3] 	= pPlasticNetFeed[R,3], R= 1 TO NRC;			! Natural Gas
Plastics_IN[R,4] 	= pPlasticNetFeed[R,4], R= 1 TO NRC;			! BSF
Plastics_IN[R,5] 	= pPlasticNetFeed[R,5], R= 1 TO NRC;			! BLF
Plastics_IN[R,6] 	= LSUM(j= 1 TO 2, MR_plasticsRes[R,j]), R= 1 TO NRC;	! Mechanically recycled plastics fossil
Plastics_IN[R,7] 	= LSUM(j= 3 TO PR, MR_plasticsRes[R,j]), R= 1 TO NRC;	! Mechanically recycled plastics bio
Plastics_IN[R,8]	= LSUM(j= 1 TO 2, PYR_plasticsRes[R,j]), R= 1 TO NRC;	! Chemically recycled plastics fossil (pyrolysis)
Plastics_IN[R,9] 	= LSUM(j= 3 TO PR, PYR_plasticsRes[R,j]), R= 1 TO NRC;	! Chemically recycled plastics bio (pyrolysis)
Plastics_IN[R,10] 	= LSUM(j= 1 TO 2, PlasticNetRes[R,j]), R= 1 TO NRC;	! TOTAL fossil based plastic produced
Plastics_IN[R,11] 	= LSUM(j= 3 TO PR, PlasticNetRes[R,j]), R= 1 TO NRC;	! TOTAL biobased based plastic produced
Plastics_IN[R,12] 	= LSUM(i = 6 to 9, Plastics_IN[R,i]), R= 1 TO NRC;	! TOTAL recycled plastic produced

! Flows to EoL from MR rejects in GJ
MRrejflows[R,i] 	=	EoL_flows[R,i] - FlowsToEOL[R,i], i = 1 TO EOL, R= 1 TO NRC;

! All data needed for sankey diagram in GJ
Plastics_Sankey[R,1] 	= pPlasticNetFeed[R,1], R= 1 TO NRC;			! Coal
Plastics_Sankey[R,2] 	= pPlasticNetFeed[R,2], R= 1 TO NRC;			! Oil
Plastics_Sankey[R,3] 	= pPlasticNetFeed[R,3], R= 1 TO NRC;			! Natural Gas
Plastics_Sankey[R,4] 	= pPlasticNetFeed[R,4], R= 1 TO NRC;			! BSF
Plastics_Sankey[R,5] 	= pPlasticNetFeed[R,5], R= 1 TO NRC;			! BLF
Plastics_Sankey[R,6] 	= LSUM(j= 1 TO 2, MR_plasticsRes[R,j]), R= 1 TO NRC;	! Mechanically recycled plastics fossil
Plastics_Sankey[R,7] 	= LSUM(j= 3 TO PR, MR_plasticsRes[R,j]), R= 1 TO NRC;	! Mechanically recycled plastics bio
Plastics_Sankey[R,8]	= LSUM(j= 1 TO 2, PYR_plasticsRes[R,j]), R= 1 TO NRC;	! Chemically recycled plastics fossil (pyrolysis)
Plastics_Sankey[R,9] 	= LSUM(j= 3 TO PR, PYR_plasticsRes[R,j]), R= 1 TO NRC;	! Chemically recycled plastics bio (pyrolysis)
Plastics_Sankey[R,10] 	= LSUM(j= 1 TO 2, PlasticStockRes[R,j]), R= 1 TO NRC;	;	! Fossil plastic stocks
Plastics_Sankey[R,11] 	= LSUM(j= 3 TO 4, PlasticStockRes[R,j]), R= 1 TO NRC;	; ! biobased plastic stocks
Plastics_Sankey[R,12]	= LSUM(j=1 to 2, PlasticWasteResTot[R,j]), R= 1 TO NRC;	! Fossil plastic waste in GJ IN
Plastics_Sankey[R,13]	= LSUM(j=3 to PR, PlasticWasteResTot[R,j]), R= 1 TO NRC;! Biobased plastic waste in GJ IN
Plastics_Sankey[R,14]	= FlowsToEOL[R,1], R= 1 TO NRC;	! Waste sent to MR
Plastics_Sankey[R,15]	= FlowsToEOL[R,2], R= 1 TO NRC;	! Waste sent to WtE
Plastics_Sankey[R,16]	= FlowsToEOL[R,3], R= 1 TO NRC;	! Waste sent to PYR
Plastics_Sankey[R,17]	= FlowsToEOL[R,4], R= 1 TO NRC; ! Waste sent to LF
Plastics_Sankey[R,18]	= PlaWaOpenDump[R], R= 1 TO NRC; ! Openly dumped plastic waste
Plastics_Sankey[R,19]	= PlaWaOpenBurn[R], R= 1 TO NRC; ! Openly burned plastic waste
Plastics_Sankey[R,20]	= MRrejflows[R,2] , R= 1 TO NRC; ! Rejects from MR sent to WtE
Plastics_Sankey[R,21]	= MRrejflows[R,3] , R= 1 TO NRC; ! Rejects from MR sent to PYR
Plastics_Sankey[R,22]	= MRrejflows[R,4] , R= 1 TO NRC; ! Rejects from MR sent to Landfill
Plastics_Sankey[R,23]	= LSUM(j= 1 TO 2, EoL_flowsCumuRes[R,4,j])  , R= 1 TO NRC; ! Fossil waste in landfills
Plastics_Sankey[R,24]	= LSUM(j= 3 TO 4, EoL_flowsCumuRes[R,4,j])  , R= 1 TO NRC; ! bio-based waste in landfills
Plastics_Sankey[R,25]	= LSUM(j= 3 TO 4, PlaWaOpenDumpCumuRes[R,j])  , R= 1 TO NRC; ! Fossil waste in dumps
Plastics_Sankey[R,26]	= LSUM(j= 3 TO 4, PlaWaOpenDumpCumuRes[R,j])  , R= 1 TO NRC; ! bio-based waste in dumps
Plastics_Sankey[NRC,i] = LSUM (R= 1 to 26, Plastics_Sankey[R,i]), i = 1 to 26;

! Energy use
PlasticEnUse_EC[R,EC]	= PlasticEnUse[R,EC,8], EC = 1 to ECP, R = 1 to NRC;

! Plastic waste
FlowsToEOL_Sankey[R,i] 	= FlowsToEOL[R,i], i = 1 TO EOL, R= 1 TO NRC;
FlowsToEOL_Sankey[R,5] 	= PlaWaColl[R], R= 1 TO NRC;
FlowsToEOL_Sankey[R,6] 	= PlaWaOpenDump[R], R= 1 TO NRC;
FlowsToEOL_Sankey[R,7] 	= PlaWaOpenBurn[R], R= 1 TO NRC;

