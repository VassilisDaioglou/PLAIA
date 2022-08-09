! This module contains:
!   - Global constants used for the functioning of the model
!   - Counters used for variables for which operations are done over a loop
!   - Flags used to change model settings

! ************* DEFINITION OF MODEL CONSTANTS *************
CONST 

! Constants from the TIMER model
NRC	    = 27,			! Number of world regions
NRC2    = 26,			! Number of regions excluding global
NRCT    = 28,           ! Number of regions + 1

NEUF    = 4,			! Non Energy Use Functions 1. Steam Cracking, 2. Ammonia, 3. Methanol, 4. Refinery Products

NEC     = 8,            ! Number of energy carriers in secondary fuel use
					    ! 1 = Solid fuel: coal (incl. cokes and other commercial solid fuels)
					    ! 2 = Liquid fuel: oil as Light Liquid Fuel (LLF) or Heavy Liquid Fuel (HLF)
					    ! and commercial liquid fuel from biomass (BLF), coal etc. 
					    ! 3 = Gaseous fuel: natural gas and gaseous fuel from biomass (BGF), coal etc.
					    ! 4 = Hydrogen
					    ! 5 = Modern BioFuel 
					    ! 6 = Secondary Heat
					    ! 7 = Traditional BioFuel
					    ! 8 = Electricity

FOSSIL      = 3,    	! Number for the fossil energy carriers

NS     	    = 5,    	! Number of sectors: industry, transport, residential, services, other

EPS		    = 1.0E-6,   ! Smallest real number, needed to avoid divide-by-zero errors

Tstart      = 2020,		! Year in which scenario values start to be gradually implemented

TconvScen   = tstart+10, ! Year in which scenario values are fully implemented (2030); before gradual development from tstart

! Constants specifically for PLAIA
PLASTICFEED = 10,   !--- Feedstocks-to-HVC production                           [Process]			            (Technology)		
                    !1.  Coal to Methanol					                    [Gasification]						
                    !2.  Coal to Naphtha					                    [pyrolysis cracking (>750C)]	(liquid cracking furnace)
                    !3.  Oil to Naphtha					                        [pyrolysis cracking (>750C)]	(liquid cracker furnace)
                    !4.  BSF to Naphtha					                        [pyrolysis cracking (>750C))]	(liquid cracker furnace)
                    !5.  Waste (HVC) to Naphtha (BtF)			                [pyrolysis cracking (>750C)]	(liquid cracker furnace)
                    !6.  Nat. Gas to Ethane 					                [pyrolysis cracking (>750C))]	(Gas cracker furnace)
                    !7.  Liquid Biofuel (BLF) to Ethanol or Methanol  	        [BETE?/Hydrogenation  < 400C]	(process reactor)
                    !--- Secondary Feedstocks (Carbon Looping) (PLASTICFEED)
                    !8. [Parking slot] (sometimes BLF, sometimes MR waste) 
                    !9.  Black liquor-2-Methanol (cross-linked with PPI)	    [Gasification]			        (pressurized reactor)!											
                    !10. CO2-2-Methanol (NonEn process emissions)		        [Hydrogenation < 400C]		    (HTFT process reactor)!											
                    !
                    !	Ye et al. (2019) CO2 hydrogenation to HVC https://www.nature.com/articles/s41467-019-13638-9!											
                    !	Cracker of the future https://www.chemicals-technology.com/news/patrochemicals-consortium-steam-cracker/!											
	
PS	= 8, 			! Plastic sectors (PS), acc. to Geyer et al (2017)
					!  1. Packaging
					!  2. Transportation
					!  3. Building & Construction
					!  4. Electrical/Electronic
					!  5. Consumer & Institutional Products
					!  6. Industrial Machinery
					!  7. Textiles
					!  8. Other

EOL	= 4,			! End of life options for plastic waste: 
					! 1 = Mechanical recycling, 
					! 2 = Waste to energy, 
					! 3 = Pyrolysis
					! 4 = Landfill
		
PR	= 4,			! Plastics by resources; 
					! 1 = fossil primary production,
					! 2 = fossil recycled, 
					! 3 = Biobased primary production, 
					! 4 = biobased recycled

ECP	= 8; 			! Energy carrier in plastics
					!  1. Coal
					!  2. Oil
					!  3. Natural Gas
					!  4. BSF
					!  5. BLF
					!  6. Plastic Waste
					!  7. Electricity
					!  8. Heat

! ************* DEFINITION OF COUNTERS *************
INTEGER
	EC,     ! Counter for energy carriers
 	R;      ! Counter for regions

DOUBLE
    pp;

! ************* DEFINITION OF FLAGS *************
INTEGER
    FLAG_highRec		= 0, 	! Flag for increasing sorting and recycling yield as well as substitution factor for Mechanical recycling; decreasing costs for pyrolysis
    FLAG_LandfillBan	= 0; 	! Flag for banning landfilling of plastics globally starting 2030; 1= Ban in place; 
		