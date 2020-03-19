@rem -*- coding: utf-8 -*-                                                                   
@rem                                                                                         
@rem Copyright (c) 2020 Antonio Alvarado Hernández - All rights reserved                     
@rem                                                                                         
@rem Licensed under the Apache License, Version 2.0 (the "License");                         
@rem you may not use this file except in compliance with the License.                        
@rem You may obtain a copy of the License at                                                 
@rem                                                                                         
@rem     http://www.apache.org/licenses/LICENSE-2.0                                          
@rem                                                                                         
@rem Unless required by applicable law or agreed to in writing, software                     
@rem distributed under the License is distributed on an "AS IS" BASIS,                       
@rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.                
@rem See the License for the specific language governing permissions and                     
@rem limitations under the License.                                                          
@rem                                                                                         
                                      
									  
@set RESTY_PATH=.
@for /F %%p in ('scoop which openresty') do @set RESTY_PATH=%%~dpp

@if "%1" == "" goto :usage
@if "%1" == "-h" goto :usage
@if "%1" == "/?" goto :usage

@if "%1" == "start" goto :start
@if "%1" == "stop" goto :stop
@if "%1" == "test" goto :test

:start
@echo Starting up from "%RESTY_PATH%"...
@start /I /MIN openresty -p %RESTY_PATH%
@if %errorlevel% neq 0 @goto :error
@goto :eof

:stop
@echo Shutting down...
@openresty -s stop -p %RESTY_PATH%
@if %errorlevel% neq 0 @goto :error
@goto :eof

:test
@echo Testing configuration...
@openresty -t -p %RESTY_PATH%
@if %errorlevel% neq 0 @goto :error
@goto :eof

:usage
@echo Oops: invalid command line syntax
@echo.
@echo C:\^> %~nx0 start
@echo C:\^> %~nx0 stop
@echo.
@goto :eof

:error
@echo Oops: something is wrong (errorlevel=%errorlevel%)^!^!
@goto :eof

:eof