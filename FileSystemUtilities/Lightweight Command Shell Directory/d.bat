@ECHO OFF

REM ---------------- Works on DESKTOP-CWN (Acer) @ 11/04/2022 ----------------

SET SEARCH_ONLY=FALSE

SET DRIVE_D_BAT=%HOMEDRIVE%
SET PATH_D_BAT="\Program Files\batch\"

SET DRIVE_DATA=G:
SET PATH_DATA="\My Drive\AppData\Directory\"

SET SEARCH_EDIT_BATCH_FILE="%LOCALAPPDATA%\Directory\directory_search_edit.bat"

REM ------ Variables passed to and used in SEARCH_EDIT_BATCH_FILE context
SET filename=DIRECTRY.TXT
SET filenoext=DIRECTR
SET editor="C:\Program Files\Notepad++\notepad++.exe"


REM --------------------- Route logic based on input parameters ----------------

IF "%SEARCH_ONLY%"=="TRUE" IF "%1" == "" GOTO MESSAGE_SEARCH_ONLY 

IF "%1" == "-" GOTO MESSAGE_FILE_INFO 
IF "%1" == "?" GOTO MESSAGE_FILE_INFO 
IF "%1" == "/?" GOTO MESSAGE_FILE_INFO 

IF "%1" == "/h" GOTO MESSAGE_FILE_INFO 
IF "%1" == "/H" GOTO MESSAGE_FILE_INFO 

IF "%1" == "-h" GOTO MESSAGE_FILE_INFO 
IF "%1" == "-H" GOTO MESSAGE_FILE_INFO 

IF "%1" == "help" GOTO MESSAGE_FILE_INFO 
IF "%1" == "HELP" GOTO MESSAGE_FILE_INFO

IF "%1" == "info" GOTO MESSAGE_FILE_INFO 
IF "%1" == "INFO" GOTO MESSAGE_FILE_INFO

GOTO START

:START

REM Set active directory to location of the data files (DIRECTRY.TXT et al)
%DRIVE_DATA%
cd %PATH_DATA%

REM Verify DIRECTRY.TXT is actually found in the active directory
IF NOT EXIST %filename% GOTO MESSAGE_NO_FILE_FOUND

CALL %SEARCH_EDIT_BATCH_FILE% %1 %2 %3   

GOTO END

REM -----------------------------------------------------------------------------------------------------
:MESSAGE_FILE_INFO

%DRIVE_D_BAT%
cd %PATH_D_BAT%

ECHO.
ECHO   ==============================================================================
ECHO   =                                                                            =
ECHO   =  This batch file is "d.bat"                                                =
ECHO   =                                                                            =
ECHO   =  Location of d.bat:                                                        =
ECHO   =    Drive: %DRIVE_D_BAT%                                                               =
ECHO   =    Path:  %PATH_D_BAT%
ECHO   =                                                                            =
ECHO   =  It sets the active directory to:                                          =
ECHO   =    Drive: %DRIVE_DATA%                                                               =
ECHO   =    Path:  %PATH_DATA%
ECHO   =                                                                            =
ECHO   =  It then calls:                                                            =
ECHO   =    %SEARCH_EDIT_BATCH_FILE%
ECHO   =                                                                            =
ECHO   ==============================================================================
ECHO.
dir d.bat
ECHO.

GOTO END

:MESSAGE_SEARCH_ONLY
ECHO.
ECHO   =========================================================================
ECHO   =                                                                       =
ECHO   =    d.bat is configured to allow search only on this system.           =                                         
ECHO   =                                                                       =
ECHO   =    Please enter up to three search parameters on the command line.    = 
ECHO   =                                                                       =
ECHO   =    Enter "d help" for additional information.                         =                                         
ECHO   =                                                                       =
ECHO   =========================================================================

GOTO END

:MESSAGE_NO_FILE_FOUND
ECHO.
ECHO   =========================================================================
ECHO   =                                                                       =
ECHO   =   WARNING: DIRECTRY.TXT file is missing from the active directory     =
ECHO   =                                                                       =
ECHO   =     (1) Check configuration of d.bat at:                              =
ECHO   =           Drive: %DRIVE_D_BAT%                                                   =
ECHO   =           Path:  %PATH_D_BAT%
ECHO   =                                                                       =
ECHO   =     (2) If this is a read-only computer then download a current       =                                         
ECHO   =         copy of DIRECTRY.TXT into the active directory.               =
ECHO   =                                                                       =
ECHO   =========================================================================
ECHO.
dir /ON *.TXT
ECHO.
ECHO   *** DIRECTRY.TXT not found ***

GOTO END

:END