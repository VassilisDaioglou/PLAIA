! These variables vary across scenarios 
! Determined during TIMER runs for the relevant scenario

DIRECTORY("../data/scenario/$1/from_image");
FILE("AromaticsPropC4.scn","r")				= main.AromaticsPropC4;
FILE("CarbonTax.scn","r")					= main.CarbonTax;
FILE("CCpPlaWa.scn","r")					= main.CCpPlaWa;
FILE("EffFEEDNE.scn","r")					= main.EffFEEDNE;
FILE("EffPRIMNE.scn","r")					= main.EffPRIMNE;
FILE("EnergyRequirement_En.scn","r")		= main.EnergyRequirement_En;
FILE("REFIShares2.scn","r")					= main.REFIShares2;
FILE("GDPpc.scn","r")						= main.GDPpc;
FILE("LandPrice.scn","r")					= main.LandPrice;
FILE("MethGross.scn","r")					= main.MethGross;
FILE("MethNet.scn","r")						= main.MethNet;
FILE("NonEnFuncTot_Base.scn","r")			= main.NonEnFuncTot_Base;
FILE("NonEnTot2.scn","r")					= main.NonEnTot2;
FILE("NonEnTotal1.scn","r")					= main.NonEnTotal1;
FILE("Price_pHVC.scn","r")					= main.Price_pHVC;
FILE("PriceSecFuel.scn","r")				= main.PriceSecFuel;
FILE("PriceSecFuelExclTax.scn","r")			= main.PriceSecFuelExclTax;
FILE("PriceSecFuelNonEn.scn","r")			= main.PriceSecFuelNonEn;
FILE("RefiNet_noBitumen.scn","r")			= main.RefiNet_noBitumen;
FILE("SecBioEff_Agr.scn","r")				= main.SecBioEff_Agr;
FILE("StmCrGross_BioSE.scn","r")			= main.StmCrGross_BioSE;
FILE("StmCrProd.scn","r")					= main.StmCrProd;

