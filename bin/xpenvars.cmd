@rem Copyright 2024, Antonio Alvarado Hernández <tnotstar@gmail.com>
@rem -*- coding: utf-8 -*-

@for /f "tokens=1-3 delims=/" %%a in ('echo %date%') do @(
    @reg export "HKEY_CURRENT_USER\Environment" User-Envars_%%c%%b%%a.reg /y
    @reg export "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" System-Envars_%%c%%b%%a.reg /y
)
@goto eof

:eof
