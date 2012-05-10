@rem ----------------------------------------------------------------------------
@rem Copyright (c) 2011, 2012 Antonio Alvarado Hernández - All rights reserved
@rem ----------------------------------------------------------------------------
@rem
@rem   Licensed under the Apache License, Version 2.0 (the "License");
@rem   you may not use this file except in compliance with the License.
@rem   You may obtain a copy of the License at
@rem
@rem       http://www.apache.org/licenses/LICENSE-2.0
@rem
@rem   Unless required by applicable law or agreed to in writing, software
@rem   distributed under the License is distributed on an "AS IS" BASIS,
@rem   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@rem   See the License for the specific language governing permissions and
@rem   limitations under the License.
@rem
@rem ----------------------------------------------------------------------------
@rem $Id$
@rem ----------------------------------------------------------------------------

@set NAME=%~n0 && shift

@if [%0] == [-10] set VSVARSPATH=%VS100COMNTOOLS%vsvars32.bat
@if [%0] == [-9] set VSVARSPATH=%VS90COMNTOOLS%vsvars32.bat

@if not defined VSVARSPATH goto :syntax
@if not exist "%VSVARSPATH%" goto :notfound

:execute
@call "%VSVARSPATH%"
@goto :eof

:syntax
@echo. 1>&2
@echo Fatal: invalid command line arguments 1>&2
@echo. 1>&2
@echo   Syntax: %NAME% [-9^|-10] 1>&2
@goto :eof

:notfound
@echo. 1>&2
@echo Fatal: not found file "%VSVARSPATH%" 1>&2
@goto :eof

:eof