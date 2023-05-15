setlocal

if defined https_proxy (
    dir %USERPROFILE%\.m2 >nul 2>nul || mkdir %USERPROFILE%\.m2 >nul 2>nul || mkdir %USERPROFILE%\.m2
    set "proto=%https_proxy:://=" & set "rem=%"
)
if defined https_proxy (
    set "hostname=%rem::=" & set "portnumber=%"
)
if defined https_proxy (
    (
        echo ^<settings^>
        echo   ^<proxies^>
        echo     ^<proxy^>
        echo       ^<active^>true^</active^>
        echo       ^<protocol^>%proto%^</protocol^>
        echo       ^<host^>%hostname%^</host^>
        echo       ^<port^>%portnumber%^</port^>
        echo     ^</proxy^>
        echo   ^</proxies^>
        echo ^</settings^>
    ) > %USERPROFILE%\.m2\settings.xml
)

echo ---------------------------- STARTING BUILD
set DISTUTILS_DEBUG=1
set
where python
call conda list

cmake -B build -S . ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DENABLE_FOLLY=off ^
      -DCMAKE_PREFIX_PATH=%PREFIX:\=/% ^
      -DCMAKE_INSTALL_PREFIX=%PREFIX:\=/% ^
      -DPython3_EXECUTABLE=%PYTHON:\=/% ^
      -G "Visual Studio 17 2022"

echo ---------------------------- AFTER CONFIGURE

cmake --build build --config Release --parallel -- /verbosity:normal

echo ---------------------------- AFTER BUILD

cmake --build build --config Release --target install -- /verbosity:normal

echo ---------------------------- AFTER INSTALL
