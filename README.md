# The Plastics Integrated Assessment Model (PLAIA)

*Author: Paul Stegmann*\
*Contact: 
    Paul Stegmann - p.h.stegmann@uu.nl* **or** 
    *Vassilis Daioglou - vassilis.daioglou@pbl.nl | [@vassican](https://twitter.com/vassican)*

## Description
The PLAIA model diferent strategies of different strategies in the production, use, and waste management of plastics and how they affect the sector’s material flows, energy use, and emissions. Examples of such strategies include changes in plastic demand, renewable energy use, feedstock substitution in plastic production (e.g., biomass instead of coal and oil), product lifetime extension, reuse, and recycling. As part of an the [**IMAGE**](https://www.pbl.nl/en/image/home) integrated assessment model (IAM), PLAIA also provides insights into the interactions of the plastics sector with the energy and agricultural sectors as well as with the climate, water, and land systems (see the following section).

Key questions this model is designed to answer include:
- Quantifying the material and energy use of the plastics sector and the corresponding GHG emissions for different scenarios. 
- Quantifying the impact of different GHG mitigation strategies for the plastics sector on its material and energy use and GHG emissions. 
- Quantifying the impact of circular economy strategies for the plastics sector on its material and energy use and GHG emissions. 
- Analyzing the impact of other economic sectors and natural systems on the plastics sector and vice versa. 
- Analyzing trade-offs between sustainability targets, e.g., between climate and circular economy targets, or climate and land use.

## Folder Structure and Scripts
This repository has the following folders and scripts
#### [Code](code)
The source-code of PLAIA is located here. It is made of the following scripts:
- **[plaia.m](code/plaia.m)**: Main script of PLAIA which incorporates all of the calculations of the model
- **[constants.m](code/constants.m)**: Global constants and settings needed for the operation of PLAIA
- **[declarations.m](code/declarations.m)**: Declarations of all variables used in the model (exogenous, scenario, and endogenous)
- **[outputs.m](code/outputs.m)**: Post processing of PLAIA results to produce specific outputs

#### [Data](data)
The main data files needed to run PLAIA are located here. There are two main forms of data:
- **Exogenous**: Contains the main [exogenous data](data/exogenous/data) needed to run PLAIA, as well as default (SSP2) [scenario](data/exogenous/scenario) files 
- **[Scenario](data/scenario)**: Contains scenario files to allow the running of specific scenarios. These files are produced from scenario runs of the coupled IMAGE-TIMER-PLAIA model

#### [Batches](batches)
Contains batch (```.bat```) files which allow for proper running of the model.
- **[compile.bat](batches/compile.bat)**: Contains the compile statement which converts the source-code into an ```.mdl``` model
- **[call_scenarios.bat](batches/call_scenarios.bat)**: This batch file starts the scenario running process. Once called, it in turn calls the ```go_scenarios.bat``` file
-  **[go_scenarios.bat](batches/go_scenarios.bat)**: Produces all of the relevant commands needed to run the ```%SCENARIO%``` specified in the ```call_scenarios.bat``` and proceeds to pass these commands to ```plaia.mdl``` and run the model 

## Language
PLAIA is written in the My-M language, a simple numerical language designed for simulations of dynamic systems. The code is compiled into C++ and and subsequently an m-model (```plaia.mdl```). This model can then be used to run scenarios. 

For manuals and purchase of licenses please visit: [https://www.my-m.eu/](https://www.my-m.eu/)

## Compiling and Running Scenarios
NOTE: To compile and run the PLAIA model, a My-m license is needed. Please visit: [https://www.my-m.eu/](https://www.my-m.eu/)

#### Method
In order to run scenarios with the model, the following steps must be taken:
1. Compile the model by running the ```compile.bat```. This will produce ```plaia.mdl``` in the *source* folder. 
2. Run the ```call_scenarios.bat``` file. This will sequentially run all of the scenarios and produce outputs in an *output* folder

#### Scenarios
Data is provided for the following scenarios:
1. **SSP2 baseline**, based on the IMAGE implementation of this scenario (van Vuuren et al. 2021)
2. **SSP2 RCP2.6**, based on the IMAGE implementation of this scenario (van Vuuren et al. 2021)
3. **SSP2 RCP2.6 Circular-Economy**, A variation on *SSP2 RCP2.6*, where we assume a global paradigm shift toward a circular economy, including phasing out landfilling, policies incentivising circular product design, standardised plastic types, and avoiding additives, opaque colours, and multi-material plastic products, introduction of material markers, streamlined collection & sorting systems, and fostering deposit systems will further increase the sorting and recycling yields
4. **SSP2 RCP2.6 Circular-Bio-Economy**, same as *SSP2 RCP2.6 Circular-Economy*, with increased incentives (subsidy) for the use of bio-based feedstocks


## References
***PLAIA documentation***\
Stegmann, P., Daioglou, V., Londo, M. and Junginger, M., 2022. [The plastics integrated assessment model (PLAIA): Assessing emission mitigation pathways and circular economy strategies for the plastics sector](https://www.sciencedirect.com/science/article/pii/S2215016122000504). *MethodsX*, 9, p.101666.

***PLAIA Scenario Analysis***\
Stegmann, P., Daioglou, V., Londo, M., van Vuuren, D. P., and Junginger, M., (accepted). Plastic futures and thier CO<sub>2</sub> emissions. *Nature*

***Feedstocks modelling in IMAGE***\
Daioglou, V., Faaij, A.P., Saygin, D., Patel, M.K., Wicke, B. and van Vuuren, D.P., 2014. [Energy demand and emissions of the non-energy sector](https://pubs.rsc.org/en/content/articlehtml/2014/ee/c3ee42667j?casa_token=zeyvsPU2B4cAAAAA:8nxyWNmXewAbnL2YJpMYZZGFqerlcr6pyf-Q1xW0i75UriIJJEc0rl5HukPoo_fTjuZ2gwTwtivceQ). *Energy & Environmental Science*, 7(2), pp.482-498.

***Implementation of SSP scenarios in the IMAGE model***\
Van Vuuren, D., Stehfest, E., Gernaat, D., de Boer, H.S., Daioglou, V., Doelman, J., Edelenbosch, O., Harmsen, M., van Zeist, W.J., van den Berg, M. and Dafnomilis, I., 2021. [The 2021 SSP scenarios of the IMAGE 3.2 model](https://eartharxiv.org/repository/view/2759/). *EarthArXiv*



