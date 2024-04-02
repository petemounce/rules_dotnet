"GENERATED BY SDK GENERATOR"

load("//dotnet/private/sdk/apphost_packs:apphost_pack.bzl", "apphost_pack")

def apphost_packs():
    """apphost packs"""

    apphost_pack(name = "netcoreapp3.0_linux-x64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.linux-x64.v3.0.3", target_framework = "netcoreapp3.0", runtime_identifier = "linux-x64")
    apphost_pack(name = "netcoreapp3.0_linux-arm64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.linux-arm64.v3.0.3", target_framework = "netcoreapp3.0", runtime_identifier = "linux-arm64")
    apphost_pack(name = "netcoreapp3.0_osx-x64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.osx-x64.v3.0.3", target_framework = "netcoreapp3.0", runtime_identifier = "osx-x64")
    apphost_pack(name = "netcoreapp3.0_win-x64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.win-x64.v3.0.3", target_framework = "netcoreapp3.0", runtime_identifier = "win-x64")
    apphost_pack(name = "netcoreapp3.0_win-arm64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.win-arm64.v3.0.3", target_framework = "netcoreapp3.0", runtime_identifier = "win-arm64")
    apphost_pack(name = "netcoreapp3.1_linux-x64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.linux-x64.v3.1.32", target_framework = "netcoreapp3.1", runtime_identifier = "linux-x64")
    apphost_pack(name = "netcoreapp3.1_linux-arm64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.linux-arm64.v3.1.32", target_framework = "netcoreapp3.1", runtime_identifier = "linux-arm64")
    apphost_pack(name = "netcoreapp3.1_osx-x64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.osx-x64.v3.1.32", target_framework = "netcoreapp3.1", runtime_identifier = "osx-x64")
    apphost_pack(name = "netcoreapp3.1_win-x64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.win-x64.v3.1.32", target_framework = "netcoreapp3.1", runtime_identifier = "win-x64")
    apphost_pack(name = "netcoreapp3.1_win-arm64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.win-arm64.v3.1.32", target_framework = "netcoreapp3.1", runtime_identifier = "win-arm64")
    apphost_pack(name = "net5.0_linux-x64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.linux-x64.v5.0.17", target_framework = "net5.0", runtime_identifier = "linux-x64")
    apphost_pack(name = "net5.0_linux-arm64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.linux-arm64.v5.0.17", target_framework = "net5.0", runtime_identifier = "linux-arm64")
    apphost_pack(name = "net5.0_osx-x64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.osx-x64.v5.0.17", target_framework = "net5.0", runtime_identifier = "osx-x64")
    apphost_pack(name = "net5.0_win-x64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.win-x64.v5.0.17", target_framework = "net5.0", runtime_identifier = "win-x64")
    apphost_pack(name = "net5.0_win-arm64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.win-arm64.v5.0.17", target_framework = "net5.0", runtime_identifier = "win-arm64")
    apphost_pack(name = "net6.0_linux-x64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.linux-x64.v6.0.28", target_framework = "net6.0", runtime_identifier = "linux-x64")
    apphost_pack(name = "net6.0_linux-arm64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.linux-arm64.v6.0.28", target_framework = "net6.0", runtime_identifier = "linux-arm64")
    apphost_pack(name = "net6.0_osx-x64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.osx-x64.v6.0.28", target_framework = "net6.0", runtime_identifier = "osx-x64")
    apphost_pack(name = "net6.0_osx-arm64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.osx-arm64.v6.0.28", target_framework = "net6.0", runtime_identifier = "osx-arm64")
    apphost_pack(name = "net6.0_win-x64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.win-x64.v6.0.28", target_framework = "net6.0", runtime_identifier = "win-x64")
    apphost_pack(name = "net6.0_win-arm64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.win-arm64.v6.0.28", target_framework = "net6.0", runtime_identifier = "win-arm64")
    apphost_pack(name = "net7.0_linux-x64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.linux-x64.v7.0.17", target_framework = "net7.0", runtime_identifier = "linux-x64")
    apphost_pack(name = "net7.0_linux-arm64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.linux-arm64.v7.0.17", target_framework = "net7.0", runtime_identifier = "linux-arm64")
    apphost_pack(name = "net7.0_osx-x64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.osx-x64.v7.0.17", target_framework = "net7.0", runtime_identifier = "osx-x64")
    apphost_pack(name = "net7.0_osx-arm64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.osx-arm64.v7.0.17", target_framework = "net7.0", runtime_identifier = "osx-arm64")
    apphost_pack(name = "net7.0_win-x64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.win-x64.v7.0.17", target_framework = "net7.0", runtime_identifier = "win-x64")
    apphost_pack(name = "net7.0_win-arm64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.win-arm64.v7.0.17", target_framework = "net7.0", runtime_identifier = "win-arm64")
    apphost_pack(name = "net8.0_linux-x64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.linux-x64.v8.0.3", target_framework = "net8.0", runtime_identifier = "linux-x64")
    apphost_pack(name = "net8.0_linux-arm64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.linux-arm64.v8.0.3", target_framework = "net8.0", runtime_identifier = "linux-arm64")
    apphost_pack(name = "net8.0_osx-x64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.osx-x64.v8.0.3", target_framework = "net8.0", runtime_identifier = "osx-x64")
    apphost_pack(name = "net8.0_osx-arm64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.osx-arm64.v8.0.3", target_framework = "net8.0", runtime_identifier = "osx-arm64")
    apphost_pack(name = "net8.0_win-x64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.win-x64.v8.0.3", target_framework = "net8.0", runtime_identifier = "win-x64")
    apphost_pack(name = "net8.0_win-arm64", pack = "@dotnet.apphost_packs//microsoft.netcore.app.host.win-arm64.v8.0.3", target_framework = "net8.0", runtime_identifier = "win-arm64")
