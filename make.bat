:: Install py37 for site-packages:
call conda create -p py37 -qy python=3.7 wheel                  || goto :error
call conda activate .\py37                                      || goto :error
call conda install -qy nsis -c nsis                             || goto :error
call conda install -qy 7za pywget                               || goto :error

:: Download embeddable python:
set "ZIP=python-3.7.3-embed-amd64.zip"
set "URL=https://www.python.org/ftp/python/3.7.3/%ZIP%"
call python -m wget "%URL%" -o "%ZIP%"                          || goto :error
call 7za x -y -opkg "%ZIP%"                                     || goto :error

:: Install py34 for mingwpy:
call conda create -p py34 -qy python=3.4                        || goto :error
call conda install -p py34 -qy mingwpy -c conda-forge           || goto :error

set "gcc=py34\Scripts\gcc.exe"
set "windres=py34\Scripts\windres.exe"
set "cflags=-Ipy37\include -DUNICODE -D_UNICODE"
set "lflags=-Lpy37\libs -lpython37"

call %gcc% %cflags% python.c %lflags% -o pkg\python.exe         || goto :error

@exit /b 0

:error
@set errcode=%ERRORLEVEL%
@echo "Previous command returned error code: %errcode%"
@exit /b %errcode%
