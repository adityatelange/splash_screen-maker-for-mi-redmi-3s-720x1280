@echo off
echo.------------------------------------------
echo. Splash Image Maker
echo.
echo.
echo.Created only for the following device:
echo.Xiaomi Redmi 3/3S/3X&echo
echo.------------------------------------------
echo.
echo.
set resolution=720x1280
echo.Creating splash.img of resolution 720x1280........
echo.
echo.
echo.


if not exist "OUTPUT\" mkdir "OUTPUT\"
echo.Deleting Previous OUTPUTs
del /Q OUTPUT\splash.img 2>NUL
del /Q OUTPUT\flashable_splash.zip 2>NUL


:VERIFY_FILES
set logo_path="not_found"
if exist "images\logo.png" set logo_path="images\logo.png"
if exist "images\logo.jpg" set logo_path="images\logo.jpg"
if exist "images\logo.jpeg" set logo_path="images\logo.jpeg"
if exist "images\logo.bmp" set logo_path="images\logo.bmp"
if exist "images\logo.gif" set logo_path="images\logo.gif"
if %logo_path%=="not_found" echo.logo.png or logo.jpg not found in 'images' folder.. EXITING&echo.&echo.&pause&exit

set fastboot_pic_path="not_found"
if exist "images\fastboot.png" set fastboot_pic_path="images\fastboot.png"
if exist "images\fastboot.jpg" set fastboot_pic_path="images\fastboot.jpg"
if exist "images\fastboot.jpeg" set fastboot_pic_path="images\fastboot.jpeg"
if exist "images\fastboot.bmp" set fastboot_pic_path="images\fastboot.bmp"
if exist "images\fastboot.gif" set fastboot_pic_path="images\fastboot.gif"
if %fastboot_pic_path%=="not_found" echo.fastboot.png or fastboot.jpg not found in 'images' folder.. EXITING&echo.&echo.&pause&exit


:CONVERT_TO_RAW
bin\win\ffmpeg\bin\ffmpeg.exe -hide_banner -loglevel quiet -i %logo_path% -f rawvideo -vcodec rawvideo -pix_fmt bgr24 -s %resolution% -y "OUTPUT\splash1.raw" > NUL || (goto :ERROR_EXIT)
bin\win\ffmpeg\bin\ffmpeg.exe -hide_banner -loglevel quiet -i %fastboot_pic_path% -f rawvideo -vcodec rawvideo -pix_fmt bgr24 -s %resolution% -y "OUTPUT\splash2.raw" > NUL || (goto :ERROR_EXIT)

:JOIN_ALL_RAW_FILES
:: Below is the default splash header for all pictures
set H="bin\%resolution%_header.img"
copy /b %H%+"OUTPUT\splash1.raw"+%H%+"OUTPUT\splash2.raw" OUTPUT\splash.img >NUL
del /Q OUTPUT\*.raw

:CHECK_IF_SUCCESSFUL
if exist "OUTPUT\splash.img" ( echo.SUCCESS!&echo.splash.img created in "OUTPUT" folder
) else (echo.PROCESS FAILED.. Try Again&echo.&echo.&pause&exit)

echo.&echo.&set /P INPUT=Do you want to create a flashable zip? [yes/no]
If /I "%INPUT%"=="y" goto :CREATE_ZIP
If /I "%INPUT%"=="yes" goto :CREATE_ZIP

echo.&echo.&echo Flashable ZIP not created..&echo.&echo.&pause&exit


:CREATE_ZIP
copy /Y bin\New_Splash.zip OUTPUT\flashable_splash.zip >NUL
cd OUTPUT
..\bin\win\7z\7za a flashable_splash.zip splash.img >NUL
cd..

if exist "OUTPUT\flashable_splash.zip" (
 echo.&echo.&echo.SUCCESS!
 echo.Flashable zip file created in "OUTPUT" folder
 echo.You can flash the flashable_splash.zip from any custom recovery like TWRP or CWM or Philz
) else ( echo.&echo.&echo Flashable ZIP not created.. )

echo.&echo.&pause&exit

:ERROR_EXIT
echo.ERROR in file.. Exitting
echo.&echo.&pause&exit