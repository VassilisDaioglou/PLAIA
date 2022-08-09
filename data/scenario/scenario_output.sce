! PLAIA Outputs
DIRECTORY("../outputs/$1/");  

! Plastic flows and stocks
FILE("PlasticSectors.out","w")			= main.PlasticSectors;
FILE("Plasticsbyresources.out","w")		= main.Plastics_IN;
FILE("PlasticStock.out","w")			= main.PlasticStock;
FILE("Plasticstockbyresources.out","w")	= main.PlasticStockRes;

! energy
FILE("PlasticEnUse.out","w") 			= main.PlasticEnUse;
FILE("PlasticEnUse_EC.out","w") 		= main.PlasticEnUse_EC;

! waste
FILE("PlasticWaste.out","w")			= main.PlasticWaste;
FILE("FlowsToEOL.out","w")				= main.FlowsToEOL_Sankey;
FILE("EoL_flows.out","w")				= main.EoL_flows;
FILE("Plastics_Sankey.out","w")			= main.Plastics_Sankey;
