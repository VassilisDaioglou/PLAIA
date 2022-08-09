@ echo off
REM This batch file calls the go_scenarios.bat which prepares the required instruction to run the scenario

echo Start Running PLAIA scenarios at: %date% and %time%
echo Start Running PLAIA scenarios at: %date% and %time% > log.txt
echo. >> log.txt
echo.

call go_scenarios.bat SSP2_baseline 
call go_scenarios.bat SSP2_RCP26 
call go_scenarios.bat SSP2_RCP26_CE 
call go_scenarios.bat SSP2_RCP26_CBE 

echo Finished all runs at %date% and %time%! 
echo Finished all runs at %date% and %time%! >> log.txt
