@rem ---------------------------------------------------------------------------
@rem Copyright (c) 2012-2019 Antonio Alvarado Hernández - All rights reserved
@rem ---------------------------------------------------------------------------
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
@rem ---------------------------------------------------------------------------
@rem $Id$
@rem ---------------------------------------------------------------------------

@setlocal EnableExtensions

@for /f "usebackq delims=" %%n in (`cmd /c "where node.exe 2> NUL"`) do @(
    "%%n" "%~dp0\..\lib\node\modules\tnotnode\jsbeauty\jsbeauty.js" %*
    goto :eof
)

:error
@echo Error: unabled to find node.js run-time.
@goto :eof

:eof
@endlocal