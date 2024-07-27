::
:: Copyright (c) 2022-2023 Carbon Community 
:: All rights reserved
::
@echo off

pushd %~dp0..\..\..
set UPDATE_ROOT=%CD%
popd

rem Get the target depot argument
if "%1" EQU "" (
	set UPDATE_TARGET=public
) else (
	set UPDATE_TARGET=%1
)

"%UPDATE_ROOT%\Tools\Helpers\CodeGen.exe" ^
	--plugininput "%UPDATE_ROOT%\Carbon.Core\Carbon.Components\Carbon.Common\src\Carbon\Core" ^
	--pluginoutput "%UPDATE_ROOT%\Carbon.Core\Carbon.Components\Carbon.Common\src\Carbon\Core\Core.Plugin-Generated.cs"

for /d %%O in (%UPDATE_ROOT%\Carbon.Core\Carbon.Components\Carbon.Common\src\Carbon\Modules\*) do (
	"%UPDATE_ROOT%\Tools\Helpers\CodeGen.exe" ^
		--plugininput "%%O" ^
		--pluginoutput "%%O\%%~nO-Generated.cs" ^
		--pluginname "%%~nO" ^
		--pluginnamespace "Carbon.Modules" ^
		--basename "module"
)

for /d %%O in (%UPDATE_ROOT%\Carbon.Core\Carbon.Components\Carbon.Modules\src\*) do (
	"%UPDATE_ROOT%\Tools\Helpers\CodeGen.exe" ^
		--plugininput "%%O" ^
		--pluginoutput "%%O\%%~nO-Generated.cs" ^
		--pluginname "%%~nO" ^
		--pluginnamespace "Carbon.Modules" ^
		--basename "module"
)

FOR %%O IN (windows linux) DO (			
	echo Downloading %%O Rust files..

	rem Download rust binary libs
	"%UPDATE_ROOT%\Tools\DepotDownloader\DepotDownloader\bin\Release\net8.0\DepotDownloader.exe" ^
		-os %%O -validate -app 258550 -branch %UPDATE_TARGET% -filelist ^
		"%UPDATE_ROOT%\Tools\Helpers\258550_refs.txt" -dir "%UPDATE_ROOT%\Rust\%%O"

	echo Publicizing %%O Rust Assembly-CSharp..

	rem Show me all you've got baby
	"%UPDATE_ROOT%\Tools\Helpers\Publicizer.exe" ^
		--input "%UPDATE_ROOT%\Rust\%%O\RustDedicated_Data\Managed\Assembly-CSharp.dll"
		
	echo Publicizing %%O Rust Rust.Clans.Local...

	"%UPDATE_ROOT%\Tools\Helpers\Publicizer.exe" ^
		--input "%UPDATE_ROOT%\Rust\%%O\RustDedicated_Data\Managed\Rust.Clans.Local.dll"

	echo Publicizing %%O Rust Facepunch.Network...

	"%UPDATE_ROOT%\Tools\Helpers\Publicizer.exe" ^
		--input "%UPDATE_ROOT%\Rust\%%O\RustDedicated_Data\Managed\Facepunch.Network.dll"
)

dotnet restore "%UPDATE_ROOT%\Carbon.Core" --nologo
