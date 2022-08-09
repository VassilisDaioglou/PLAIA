:: reduce feedback
@echo off

REM Go to model code directory
cd ../code/

:: remove any leftovers from earlier compiles and runs
if exist plaia.mdl del plaia.mdl
if exist plaia.c del plaia.c

:: Multiple compile options. Only one should be used. Enable a compile option by removing 'rem'
:: Compile settings for regular timer runs. Only a limited amount of errors and warnings are shown
:: Warning 5 and 8 off (woff), feedback on sce errors (wfatalerror) runtime errors on (rte) compile errors on (e)
m2c -woff 5,8 -wfatalerror -rte error_runtime.txt -e error_compile.txt plaia.m 

:: Compile settings for fullwarn runs. More feedback on errors and warnings
rem m2c -wfatalerror -fullwarn -sbuwarning -rte error_runtime.txt -e error_compile.txt ..\code\plaia.m

:: make mdl executable
call mmake plaia.mdl

:: delete unneeded by-product
if exist vc140.pdb del vc140.pdb

:: it is important to empty libs and includes in order to avoid problems when compiling and running other MyM models
set OWNLIBS=
set OWNINCLUDE=

REM Return to original directory
cd ../batches
 
