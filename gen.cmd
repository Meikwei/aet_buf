@echo off
setlocal

rem Define array elements
set "PROTO_NAMES=common sys_user"

rem Loop through each element in the array
for %%i in (%PROTO_NAMES%) do (
    rem Generate Go code for Protobuf
    protoc --go_out=./%%i --go_opt=module=github.com/Meikwei/aet_buf/%%i %%i/%%i.proto
    rem Generate Go gRPC code for Protobuf
    protoc --go-grpc_out=./%%i --go-grpc_opt=module=github.com/Meikwei/aet_buf/%%i %%i/%%i.proto
    protoc --validate_out=lang=go,paths=source_relative:./ %%i/%%i.proto
    protoc --grpc-gateway_out=./%%i --grpc-gateway_opt=module=github.com/Meikwei/aet_buf/%%i %%i/%%i.proto
    protoc --openapiv2_out=./ %%i/%%i.proto
    if ERRORLEVEL 1 (
        echo error processing %%i.proto
        exit /b %ERRORLEVEL%
    )
)

rem Replace "omitempty" in *.pb.go files with UTF-8 encoding
for /r %%f in (*.pb.go) do (
    powershell -Command "(Get-Content -Path '%%f' -Encoding UTF8) -replace ',omitempty\"`"', '\"`"' | Set-Content -Path '%%f' -Encoding UTF8"
)


endlocal
