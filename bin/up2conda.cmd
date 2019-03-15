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

@setlocal enableExtensions
@setlocal disableDelayedExpansion

@call conda update -y conda
@call conda update -y --all

@for /f "usebackq" %%p in (`call conda info --json ^| jq ".envs_dirs[]"`) do @(
    @for /d %%d in (%%p\*) do @(
        @call conda update -y --name %%~nd --all
    )
)

:eof