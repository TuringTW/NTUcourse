set files="*.wav"
for  %%i  in  (%files%) do (
 MD ..\%%~ni	
 MOVE .\%%i ..\%%~ni\
 )
pause