@ECHO OFF
IF NOT "%~f0" == "~f0" GOTO :WinNT
@"ruby.exe" "C:/Users/Koulujuttuja/Documents/GithubRepositories/ratebeer/vendor/bundle/ruby/2.1.0/bin/thor" %1 %2 %3 %4 %5 %6 %7 %8 %9
GOTO :EOF
:WinNT
@"ruby.exe" "%~dpn0" %*