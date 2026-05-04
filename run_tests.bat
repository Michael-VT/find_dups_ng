@echo off
REM Run smoke tests for Windows

echo ========================================
echo find_dups Smoke Tests (Windows)
echo ========================================
echo.

REM Check if test data exists
if not exist test_data\scenario1 (
    echo Creating test data...
    call test_data\setup_test_data.bat
)

set PASS=0
set FAIL=0

echo.
echo Testing implementations...
echo.

REM Test Go
if exist find_dups_go\find_dups.exe (
    echo -n Testing Go...
    cd find_dups_go
    find_dups.exe ..\test_data\scenario1 >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        if exist duplicates_go.csv (
            echo [OK]
            set /a PASS+=1
        ) else (
            echo [FAIL] - missing output
            set /a FAIL+=1
        )
    ) else (
        echo [FAIL] - execution failed
        set /a FAIL+=1
    )
    cd ..
) else (
    echo [SKIP] Go - not built
)

REM Test Rust
if exist find_dups_rust\target\release\find_dups.exe (
    echo -n Testing Rust...
    cd find_dups_rust
    target\release\find_dups.exe ..\test_data\scenario1 >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        if exist duplicates_rs.csv (
            echo [OK]
            set /a PASS+=1
        ) else (
            echo [FAIL] - missing output
            set /a FAIL+=1
        )
    ) else (
        echo [FAIL] - execution failed
        set /a FAIL+=1
    )
    cd ..
) else (
    echo [SKIP] Rust - not built
)

REM Test Python
where python >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo -n Testing Python...
    cd find_dups_python
    python find_dups.py ..\test_data\scenario1 >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        if exist duplicates_py.csv (
            echo [OK]
            set /a PASS+=1
        ) else (
            echo [FAIL] - missing output
            set /a FAIL+=1
        )
    ) else (
        echo [FAIL] - execution failed
        set /a FAIL+=1
    )
    cd ..
) else (
    echo [SKIP] Python - not found
)

REM Test Node.js
where node >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo -n Testing JavaScript (Node)...
    cd find_dups_js
    node find_dups.js ..\test_data\scenario1 >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        if exist duplicates_js.csv (
            echo [OK]
            set /a PASS+=1
        ) else (
            echo [FAIL] - missing output
            set /a FAIL+=1
        )
    ) else (
        echo [FAIL] - execution failed
        set /a FAIL+=1
    )
    cd ..
) else (
    echo [SKIP] Node.js - not found
)

REM Test C++
if exist find_dups_cp\find_dups_cpp.exe (
    echo -n Testing C++...
    cd find_dups_cp
    find_dups_cpp.exe ..\test_data\scenario1 >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        if exist duplicates_cpp.csv (
            echo [OK]
            set /a PASS+=1
        ) else (
            echo [FAIL] - missing output
            set /a FAIL+=1
        )
    ) else (
        echo [FAIL] - execution failed
        set /a FAIL+=1
    )
    cd ..
) else (
    echo [SKIP] C++ - not built
)

echo.
echo ========================================
echo Results: %PASS% passed, %FAIL% failed
echo ========================================

if %FAIL% GTR 0 (
    exit /b 1
)
