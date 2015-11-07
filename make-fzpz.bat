@ECHO OFF
REM make-fzpz
REM Author: Mike Pilgrem

REM Creates a *.fzpz file for a single Fritzing part. For further information
REM run:
REM make-file --help

REM Check for help options:
IF "%1" == "/?" GOTO HELP
IF "%1" == "-h" GOTO HELP
IF "%1" == "--help" GOTO HELP

REM Check all is in order
IF NOT EXIST part\%1.fzp (
    ECHO File part\%1.fzp expected but not found.
    GOTO END
)
IF NOT EXIST svg\icon\%1_icon.svg (
    ECHO File svg\icon\%1_icon.svg expected but not found.
    GOTO END
)
IF NOT EXIST svg\breadboard\%1_breadboard.svg (
    ECHO svg\breadboard\%1_breadboard.svg expected but not found.
    GOTO END
)
IF NOT EXIST svg\schematic\%1_schematic.svg (
    ECHO svg\schematic\%1_schematic.svg expected but not found.
    GOTO END
)
IF NOT EXIST svg\pcb\%1_pcb.svg (
    ECHO File svg\pcb\%1_pcb.svg expected but not found.
    GOTO END
)

REM Remove partname.fzpz file if it already exists, with warning
IF EXIST %1.fzpz (
    ECHO File %1.fzpz already exists.
    ECHO It will be erased if you continue.
    CHOICE /N /M "Do you want to continue (Y/N)?"
    IF ERRORLEVEL 2 GOTO END
    DEL %1.fzpz
)

REM Prepare copies of files for archive, silently
COPY part\%1.fzp part.%1.fzp >NUL
COPY svg\icon\%1_icon.svg svg.icon.%1_icon.svg >NUL
COPY svg\breadboard\%1_breadboard.svg svg.breadboard.%1_breadboard.svg >NUL
COPY svg\schematic\%1_schematic.svg svg.schematic.%1_schematic.svg >NUL
COPY svg\pcb\%1_pcb.svg svg.pcb.%1_pcb.svg >NUL

REM Add the files to the zip archive partname.fzpz, silently
7z a -tzip %1.fzpz part.%1.fzp svg.icon.%1_icon.svg svg.breadboard.%1_breadboard.svg svg.schematic.%1_schematic.svg svg.pcb.%1_pcb.svg >NUL

REM Clean up
DEL part.%1.fzp svg.icon.%1_icon.svg svg.breadboard.%1_breadboard.svg svg.schematic.%1_schematic.svg svg.pcb.%1_pcb.svg

REM Report
ECHO New file %1.fzpz has been created.

GOTO END

:HELP
ECHO Creates a *.fzpz file for a single Fritzing part. Requires application
ECHO 7-Zip (7z.exe) to be in the path.
ECHO.
ECHO.  make-fzpz [/?^|-h^|--help] ^<partname^>
ECHO.
ECHO ^<partname^>     Name of the Fritzing part. The name must not include
ECHO.               spaces.
ECHO./?^|-h^|--help   Displays this message.
ECHO.
ECHO The *.fzp and *.svg files for the part are assumed to exist in folders
ECHO \part, \svg\icon, \svg\breadboard, \svg\schematic and \svg\pcb, with names
ECHO ^<partname^>.fzp
ECHO ^<partname^>_^<view^>.svg
ECHO.
ECHO Where ^<view^> is one of icon, breadboard, schematic or pcb.
ECHO.

:END

REM ----------------------------------------------------------------------------
REM Copyright (c) 2015, Mike Pilgrem
REM All rights reserved.

REM Redistribution and use in source and binary forms, with or without
REM modification, are permitted provided that the following conditions are met:

REM 1. Redistributions of source code must retain the above copyright notice,
REM    this list of conditions and the following disclaimer.

REM 2. Redistributions in binary form must reproduce the above copyright notice,
REM    this list of conditions and the following disclaimer in the documentation
REM    and/or other materials provided with the distribution.

REM THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
REM AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
REM IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
REM ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
REM LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
REM CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
REM SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
REM INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
REM CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
REM ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
REM POSSIBILITY OF SUCH DAMAGE.
REM ----------------------------------------------------------------------------