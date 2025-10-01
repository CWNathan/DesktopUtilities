@echo off
setlocal enabledelayedexpansion

goto START
****************************************************************************************************
*
*  Source Repository (GitHub):  CWNathan\DesktopUtilities
*  Filepath and name: \FileSystemUtilities\archive_local_COPY AND EDIT.bat
*  Version: 2025-10-01
*
*  When configured for a specific file, this utility copies the file to a subdirectory in the
*  directory named "Arc" and then adds a timestamp suffix to the file name.
*  
*  Configuration instructions:
*    Line 30 below: Edit the value of fname_base to match the filename (without extension) to be backed up
*    Line 31 below: Edit the value of fname_ext to match the filename extension (without period) to be backed up
*
*  Example:
*    set "fname_base=Daily Task List"
*    set "fname_ext=xlsx"
*
*  IMPORTANT: The batch file must be run from the directory in which the source file is located.
*       This happens by default if the batch is invoked  by double clicking from Microsoft
*       File Explorer.
****************************************************************************************************
:START

REM ----- CHANGE WITH EVERY INSTANCE: File Information -----

set "fname_base=archive_local (SOURCE - COPY AND EDIT)"
set "fname_ext=bat"

REM ----- SET working_dir VALUE DIRECTLY WHEN BATCH FILE  -----
REM ----- IS CALLED IN A SHELL WITH A CURRENT DIRECTORY   -----
REM ----- DIFFERENT THAN THE ONE WHERE THE FILE IS STORED -----

set "working_dir=%cd%"

REM ----- CHANGE RARELY: Archive directory standard name -----

set "STANDARD_ARCHIVE_DIRECTORY_NAME=Arc"

REM ----- CHANGE RARELY: Archive file suffix ="RO" for Read Only -----
set "BACKUP_SUFFIX=RO"

REM Later in code:
set "time_stamped_filename=%fname_base%_%datepretty% %BACKUP_SUFFIX%.%fname_ext%"

REM ----- CHANGE NEVER: Assign Working Variables -----

set "fname=%fname_base%.%fname_ext%"
set "source_dir=%working_dir%\"
set "target_dir=%working_dir%\%STANDARD_ARCHIVE_DIRECTORY_NAME%\"

REM ----- Verify the batch file has been correctly modified
if "%fname_base%"=="[ENTER FILENAME HERE]" (goto ERROR_SETUP_REQUIRED)
if "%fname_ext%"=="[ENTER FILE EXTENSION HERE]" (goto ERROR_SETUP_REQUIRED)

REM ----- Verify that the target file exists
if not exist "%source_dir%%fname%" (goto ERROR_SOURCE_NOT_FOUND)

REM ----- Make the archive directory if it does not already exist.  -----
if not exist "%target_dir%" (
	echo Directory "%target_dir%" does not exist. Creating it now...
	mkdir "%target_dir%"
	if errorlevel 1 (
	   	echo.
    	echo ERROR: Failed to create archive directory "%target_dir%"
	   	echo.
    	goto ENDPAUSE
	)
)

REM ----- Verify copy the file to the archive directory. -----
copy "%source_dir%%fname%" "%target_dir%%fname%" /V >nul 2>&1
if errorlevel 1 (
   	echo.
    echo ERROR: Failed to copy file "%source_dir%%fname%" to archive directory "%target_dir%%fname%"
   	echo.
    goto ENDPAUSE
)

REM ----- Use PowerShell to get the file's last modified timestamp (Windows 11 compatible replacement for WMIC) -----
for /f "delims=" %%A in ('powershell -Command "(Get-Item '%target_dir%%fname%').LastWriteTime.ToString('yyyyMMddHHmm')"') do (
    set "dateraw=%%A"
)
if "!dateraw!"=="" (
    echo.
	echo ERROR: Failed to get file timestamp
	echo.
    goto ENDPAUSE
)

set "datepretty=!dateraw:~0,4!-!dateraw:~4,2!-!dateraw:~6,2!-!dateraw:~8,4!"
set "time_stamped_filename=%fname_base%_%datepretty% %BACKUP_SUFFIX%.%fname_ext%"

REM ----- If the file has already been backed up, issue warning notice. Otherwise create timestamped file version. -----
if not exist "%target_dir%%time_stamped_filename%" (
	copy "%source_dir%%fname%" "%target_dir%%time_stamped_filename%" >nul 2>&1
	if errorlevel 1 (
    	echo.
		echo ERROR: Failed to copy file "%source_dir%%fname%" to archive directory "%target_dir%%time_stamped_filename%"
    	echo.
    	goto ENDPAUSE
	)	
	attrib +r "%target_dir%%time_stamped_filename%"
	if errorlevel 1 (
	    echo.
    	echo WARNING: Failed to set read-only attribute on backup file "%target_dir%%time_stamped_filename%"
		echo          Operation will continue after pause...
		echo.
		pause 
	)	


) else (
	echo.
	echo *****************************************************************************
	echo ***                                                                       ***
	echo ***  WARNING: A BACKUP FILE ALREADY EXISTS FOR THIS DATE AND TIMESTAMP.   ***
	echo ***                                                                       ***
	echo ***  Action: Compare the source file and earlier backup below to verify.  ***
	echo ***                                                                       ***
	echo *****************************************************************************
	echo.
	echo SOURCE AND BACKUP DIRECTORIES:
	dir "%source_dir%" | find "Directory"
	dir "%target_dir%" | find "Directory"
	echo.
	echo SOURCE AND BACKUP FILES:
	dir "%source_dir%%fname%" | find "%fname_base%"
	dir "%target_dir%%time_stamped_filename%" | find "%fname_base%"
	echo.

	goto ENDSLOW
)

REM ----- Verify the timestamped version exists. 
REM -----   If it DOES NOT EXIST -> Display an error message, pause and exit
REM -----   If it DOES EXIST     -> Display a success message, delete the non-timestamped file, pause and exit

if not exist "%target_dir%%time_stamped_filename%" (
	echo.
	echo *****************************************************************
	echo ***
	echo ***  ERROR: THE BACKUP FAILED
	echo ***
	echo ***  File "%time_stamped_filename%" was NOT created
	echo ***
	echo *****************************************************************
	echo.
) else (
	echo.
	echo *********************************************************************
	echo *** SUCCESS: Created backup file: "%time_stamped_filename%" ***
	echo *********************************************************************
	echo.
	del "%target_dir%%fname%"
)

dir "%target_dir%" | find "Directory"
echo.
dir "%target_dir%%fname_base%*" /od | find "%fname_base%"
echo.
goto ENDSLOW

:ERROR_SETUP_REQUIRED
echo.
echo *****************************************************************************
echo *
echo * ERROR: BACKUP UTILITY REQUIRES FILENAME AND FILE EXTENSION CUSTOMIZATION. 
echo *
echo *   Variable 'fname_base' is currently set to "%fname_base%"
echo *   Variable 'fname_ext'  is currently set to "%fname_ext%"
echo *
echo *****************************************************************************
echo.
pause
goto ENDPAUSE

:ERROR_SOURCE_NOT_FOUND
dir /od /a-d-s
echo.
echo ************************************************************************************
echo *
echo * ERROR: SOURCE FILE NOT FOUND.
echo *
echo *   File "%fname_base%.%fname_ext%" not found here (see directory listing above).
echo *
echo ************************************************************************************
echo.
goto ENDPAUSE

:ENDSLOW
timeout /T 5
exit

:ENDPAUSE
pause
exit

:ENDFAST
exit