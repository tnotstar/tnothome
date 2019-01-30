@rem -*- coding: utf-8 -*-
@rem
@rem Copyright (c) 2019 Antonio Alvarado Hernández - All rights reserved
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

@if "%1" == "" goto :error

@echo gswin64c -dBATCH -dNOPAUSE -sDEVICE=jpeg -r96 -dJPEGQ=100 "-sOutputFile=%~n1.jpg" "%~n1.pdf"

:error
@echo Oops: invalid command line arguments
@echo.
@echo     %~n0 ^<input-filename-without-extension^>