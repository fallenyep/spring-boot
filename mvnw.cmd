@REM @REM ----------------------------------------------------------------------------
@REM @REM Licensed to the Apache Software Foundation (ASF) under one
@REM @REM or more contributor license agreements.  See the NOTICE file
@REM @REM distributed with this work for additional information
@REM @REM regarding copyright ownership.  The ASF licenses this file
@REM @REM to you under the Apache License, Version 2.0 (the
@REM @REM "License"); you may not use this file except in compliance
@REM @REM with the License.  You may obtain a copy of the License at
@REM @REM
@REM @REM    https://www.apache.org/licenses/LICENSE-2.0
@REM @REM
@REM @REM Unless required by applicable law or agreed to in writing,
@REM @REM software distributed under the License is distributed on an
@REM @REM "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
@REM @REM KIND, either express or implied.  See the License for the
@REM @REM specific language governing permissions and limitations
@REM @REM under the License.
@REM @REM ----------------------------------------------------------------------------
@REM
@REM @REM ----------------------------------------------------------------------------
@REM @REM Maven2 Start Up Batch script
@REM @REM
@REM @REM Required ENV vars:
@REM @REM JAVA_HOME - location of a JDK home dir
@REM @REM
@REM @REM Optional ENV vars
@REM @REM M2_HOME - location of maven2's installed home dir
@REM @REM MAVEN_BATCH_ECHO - set to 'on' to enable the echoing of the batch commands
@REM @REM MAVEN_BATCH_PAUSE - set to 'on' to wait for a key stroke before ending
@REM @REM MAVEN_OPTS - parameters passed to the Java VM when running Maven
@REM @REM     e.g. to debug Maven itself, use
@REM @REM set MAVEN_OPTS=-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=8000
@REM @REM MAVEN_SKIP_RC - flag to disable loading of mavenrc files
@REM @REM ----------------------------------------------------------------------------
@REM
@REM @REM Begin all REM lines with '@' in case MAVEN_BATCH_ECHO is 'on'
@REM @echo off
@REM @REM set title of command window
@REM title %0
@REM @REM enable echoing my setting MAVEN_BATCH_ECHO to 'on'
@REM @if "%MAVEN_BATCH_ECHO%" == "on"  echo %MAVEN_BATCH_ECHO%
@REM
@REM @REM set %HOME% to equivalent of $HOME
@REM if "%HOME%" == "" (set "HOME=%HOMEDRIVE%%HOMEPATH%")
@REM
@REM @REM Execute a user defined script before this one
@REM if not "%MAVEN_SKIP_RC%" == "" goto skipRcPre
@REM @REM check for pre script, once with legacy .bat ending and once with .cmd ending
@REM if exist "%HOME%\mavenrc_pre.bat" call "%HOME%\mavenrc_pre.bat"
@REM if exist "%HOME%\mavenrc_pre.cmd" call "%HOME%\mavenrc_pre.cmd"
@REM :skipRcPre
@REM
@REM @setlocal
@REM
@REM set ERROR_CODE=0
@REM
@REM @REM To isolate internal variables from possible post scripts, we use another setlocal
@REM @setlocal
@REM
@REM @REM ==== START VALIDATION ====
@REM if not "%JAVA_HOME%" == "" goto OkJHome
@REM
@REM echo.
@REM echo Error: JAVA_HOME not found in your environment. >&2
@REM echo Please set the JAVA_HOME variable in your environment to match the >&2
@REM echo location of your Java installation. >&2
@REM echo.
@REM goto error
@REM
@REM :OkJHome
@REM if exist "%JAVA_HOME%\bin\java.exe" goto init
@REM
@REM echo.
@REM echo Error: JAVA_HOME is set to an invalid directory. >&2
@REM echo JAVA_HOME = "%JAVA_HOME%" >&2
@REM echo Please set the JAVA_HOME variable in your environment to match the >&2
@REM echo location of your Java installation. >&2
@REM echo.
@REM goto error
@REM
@REM @REM ==== END VALIDATION ====
@REM
@REM :init
@REM
@REM @REM Find the project base dir, i.e. the directory that contains the folder ".mvn".
@REM @REM Fallback to current working directory if not found.
@REM
@REM set MAVEN_PROJECTBASEDIR=%MAVEN_BASEDIR%
@REM IF NOT "%MAVEN_PROJECTBASEDIR%"=="" goto endDetectBaseDir
@REM
@REM set EXEC_DIR=%CD%
@REM set WDIR=%EXEC_DIR%
@REM :findBaseDir
@REM IF EXIST "%WDIR%"\.mvn goto baseDirFound
@REM cd ..
@REM IF "%WDIR%"=="%CD%" goto baseDirNotFound
@REM set WDIR=%CD%
@REM goto findBaseDir
@REM
@REM :baseDirFound
@REM set MAVEN_PROJECTBASEDIR=%WDIR%
@REM cd "%EXEC_DIR%"
@REM goto endDetectBaseDir
@REM
@REM :baseDirNotFound
@REM set MAVEN_PROJECTBASEDIR=%EXEC_DIR%
@REM cd "%EXEC_DIR%"
@REM
@REM :endDetectBaseDir
@REM
@REM IF NOT EXIST "%MAVEN_PROJECTBASEDIR%\.mvn\jvm.config" goto endReadAdditionalConfig
@REM
@REM @setlocal EnableExtensions EnableDelayedExpansion
@REM for /F "usebackq delims=" %%a in ("%MAVEN_PROJECTBASEDIR%\.mvn\jvm.config") do set JVM_CONFIG_MAVEN_PROPS=!JVM_CONFIG_MAVEN_PROPS! %%a
@REM @endlocal & set JVM_CONFIG_MAVEN_PROPS=%JVM_CONFIG_MAVEN_PROPS%
@REM
@REM :endReadAdditionalConfig
@REM
@REM SET MAVEN_JAVA_EXE="%JAVA_HOME%\bin\java.exe"
@REM set WRAPPER_JAR="%MAVEN_PROJECTBASEDIR%\.mvn\wrapper\maven-wrapper.jar"
@REM set WRAPPER_LAUNCHER=org.apache.maven.wrapper.MavenWrapperMain
@REM
@REM set DOWNLOAD_URL="https://repo.maven.apache.org/maven2/io/takari/maven-wrapper/0.5.3/maven-wrapper-0.5.3.jar"
@REM
@REM FOR /F "tokens=1,2 delims==" %%A IN ("%MAVEN_PROJECTBASEDIR%\.mvn\wrapper\maven-wrapper.properties") DO (
@REM     IF "%%A"=="wrapperUrl" SET DOWNLOAD_URL=%%B
@REM )
@REM
@REM @REM Extension to allow automatically downloading the maven-wrapper.jar from Maven-central
@REM @REM This allows using the maven wrapper in projects that prohibit checking in binary data.
@REM if exist %WRAPPER_JAR% (
@REM     echo Found %WRAPPER_JAR%
@REM ) else (
@REM 	if not "%MVNW_REPOURL%" == "" (
@REM 	  SET DOWNLOAD_URL="%MVNW_REPOURL%/io/takari/maven-wrapper/0.5.3/maven-wrapper-0.5.3.jar"
@REM 	)
@REM     echo Couldn't find %WRAPPER_JAR%, downloading it ...
@REM 	echo Downloading from: %DOWNLOAD_URL%
@REM
@REM     powershell -Command "&{"^
@REM 		"$webclient = new-object System.Net.WebClient;"^
@REM 		"if (-not ([string]::IsNullOrEmpty('%MVNW_USERNAME%') -and [string]::IsNullOrEmpty('%MVNW_PASSWORD%'))) {"^
@REM 		"$webclient.Credentials = new-object System.Net.NetworkCredential('%MVNW_USERNAME%', '%MVNW_PASSWORD%');"^
@REM 		"}"^
@REM 		"[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $webclient.DownloadFile('%DOWNLOAD_URL%', '%WRAPPER_JAR%')"^
@REM 		"}"
@REM     echo Finished downloading %WRAPPER_JAR%
@REM )
@REM @REM End of extension
@REM
@REM %MAVEN_JAVA_EXE% %JVM_CONFIG_MAVEN_PROPS% %MAVEN_OPTS% %MAVEN_DEBUG_OPTS% -classpath %WRAPPER_JAR% "-Dmaven.multiModuleProjectDirectory=%MAVEN_PROJECTBASEDIR%" %WRAPPER_LAUNCHER% %MAVEN_CONFIG% %*
@REM if ERRORLEVEL 1 goto error
@REM goto end
@REM
@REM :error
@REM set ERROR_CODE=1
@REM
@REM :end
@REM @endlocal & set ERROR_CODE=%ERROR_CODE%
@REM
@REM if not "%MAVEN_SKIP_RC%" == "" goto skipRcPost
@REM @REM check for post script, once with legacy .bat ending and once with .cmd ending
@REM if exist "%HOME%\mavenrc_post.bat" call "%HOME%\mavenrc_post.bat"
@REM if exist "%HOME%\mavenrc_post.cmd" call "%HOME%\mavenrc_post.cmd"
@REM :skipRcPost
@REM
@REM @REM pause the script if MAVEN_BATCH_PAUSE is set to 'on'
@REM if "%MAVEN_BATCH_PAUSE%" == "on" pause
@REM
@REM if "%MAVEN_TERMINATE_CMD%" == "on" exit %ERROR_CODE%
@REM
@REM exit /B %ERROR_CODE%
