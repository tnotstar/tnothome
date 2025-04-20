@rem Copyright 2025, Antonio Alvarado Hernández <tnotstar@gmail.com>
@rem -*- coding: utf-8 -*-

@set dbname=MSSQLLocalDB
@if not "%1" == "" @set dbname=%1
@echo Connecting to ^"(localdb)\%dbname%^"...
@call sqlcmd -S "(localdb)\%dbname%" -E
@goto eof

:eof
