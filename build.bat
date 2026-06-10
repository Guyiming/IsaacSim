:: SPDX-FileCopyrightText: Copyright (c) 2025 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
:: SPDX-License-Identifier: Apache-2.0
::
:: Licensed under the Apache License, Version 2.0 (the "License");
:: you may not use this file except in compliance with the License.
:: You may obtain a copy of the License at
::
:: http://www.apache.org/licenses/LICENSE-2.0
::
:: Unless required by applicable law or agreed to in writing, software
:: distributed under the License is distributed on an "AS IS" BASIS,
:: WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
:: See the License for the specific language governing permissions and
:: limitations under the License.

@echo off

:: Check EULA acceptance first
call "%~dp0tools\eula_check.bat"
if %errorlevel% neq 0 (
    echo Error: NVIDIA Software License Agreement and Product-Specific Terms for NVIDIA Omniverse must be accepted to proceed.
    exit /b 1
)

:: Check Windows Long Paths support
call "%~dp0tools\check_longpaths.bat"

:: Pin the MSVC toolset used for compilation to v143 (14.44.35207). The host VS2026
:: install defaults to the v145 toolset (14.50/14.51), whose STL headers cannot be
:: parsed by NVCC from the bundled CUDA 12.8, breaking all .cu compilation. MSBuild's
:: VCToolsVersion controls the cl.exe that NVCC uses for host compilation, so it must
:: be pinned here (repo.toml repo_build.msbuild.msvc_version=v143 only selects the
:: PlatformToolset targets, not the actual tools version).
set "VCToolsVersion=14.44.35207"

call "%~dp0repo" build %*
