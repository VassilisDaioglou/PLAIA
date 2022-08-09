echo off

set SCEN_NAME=%1%

echo Start Running Scenario: %SCEN_NAME%, at: %date% and %time% >> log.txt

REM Create an "in" file, which contains all the commands needed to run the model
REM with the relevant scenario inputs

REM Read in relevant scenario data
echo sce ..\data\scenario\scenario_input.sce >> in_%SCEN_NAME% 
echo rsc %SCEN_NAME% >> in_%SCEN_NAME%
call ..\data\scenario\%SCEN_NAME%\scenario_settings.bat

REM Run model
echo run >> in_%SCEN_NAME%

REM Identify required outputs
echo SCE ..\data\scenario\scenario_output.sce >> in_%SCEN_NAME%
echo wsc %SCEN_NAME% >> in_%SCEN_NAME%

REM Copy the "in" file to the model location
copy in_%SCEN_NAME% ..\code\in_%SCEN_NAME%

REM Go to the model location
cd ..\code

echo.

REM Read the "in" file into the model
mcui plaia.mdl < in_%SCEN_NAME%

REM return to the original position
cd ..\batches\

echo Done Running Scenario: %SCEN_NAME%, at: %date% and %time% >> log.txt
echo. >> log.txt

del in_%SCEN_NAME%