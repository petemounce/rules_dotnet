"GENERATED BY SDK GENERATOR"

load("//dotnet/private/sdk/targeting_packs:targeting_pack.bzl", "targeting_pack")

def targeting_packs():
    """Targeting packs"""

    targeting_pack(name = "default_netstandard1.6", packs = ["@dotnet.targeting_packs//netstandard.library.v1.6.1"], target_framework = "netstandard1.6")
    targeting_pack(name = "default_netstandard2.0", packs = ["@dotnet.targeting_packs//netstandard.library.v2.0.3"], target_framework = "netstandard2.0")
    targeting_pack(name = "default_netstandard2.1", packs = ["@dotnet.targeting_packs//netstandard.library.ref.v2.1.0"], target_framework = "netstandard2.1")
    targeting_pack(name = "default_net20", packs = ["@dotnet.targeting_packs//microsoft.netframework.referenceassemblies.net20.v1.0.3"], target_framework = "net20")
    targeting_pack(name = "default_net35", packs = ["@dotnet.targeting_packs//microsoft.netframework.referenceassemblies.net35.v1.0.3"], target_framework = "net35")
    targeting_pack(name = "default_net40", packs = ["@dotnet.targeting_packs//microsoft.netframework.referenceassemblies.net40.v1.0.3"], target_framework = "net40")
    targeting_pack(name = "default_net45", packs = ["@dotnet.targeting_packs//microsoft.netframework.referenceassemblies.net45.v1.0.3"], target_framework = "net45")
    targeting_pack(name = "default_net451", packs = ["@dotnet.targeting_packs//microsoft.netframework.referenceassemblies.net451.v1.0.3"], target_framework = "net451")
    targeting_pack(name = "default_net452", packs = ["@dotnet.targeting_packs//microsoft.netframework.referenceassemblies.net452.v1.0.3"], target_framework = "net452")
    targeting_pack(name = "default_net46", packs = ["@dotnet.targeting_packs//microsoft.netframework.referenceassemblies.net46.v1.0.3"], target_framework = "net46")
    targeting_pack(name = "default_net461", packs = ["@dotnet.targeting_packs//microsoft.netframework.referenceassemblies.net461.v1.0.3"], target_framework = "net461")
    targeting_pack(name = "default_net462", packs = ["@dotnet.targeting_packs//microsoft.netframework.referenceassemblies.net462.v1.0.3"], target_framework = "net462")
    targeting_pack(name = "default_net47", packs = ["@dotnet.targeting_packs//microsoft.netframework.referenceassemblies.net47.v1.0.3"], target_framework = "net47")
    targeting_pack(name = "default_net471", packs = ["@dotnet.targeting_packs//microsoft.netframework.referenceassemblies.net471.v1.0.3"], target_framework = "net471")
    targeting_pack(name = "default_net472", packs = ["@dotnet.targeting_packs//microsoft.netframework.referenceassemblies.net472.v1.0.3"], target_framework = "net472")
    targeting_pack(name = "default_net48", packs = ["@dotnet.targeting_packs//microsoft.netframework.referenceassemblies.net48.v1.0.3"], target_framework = "net48")
    targeting_pack(name = "default_net481", packs = ["@dotnet.targeting_packs//microsoft.netframework.referenceassemblies.net481.v1.0.3"], target_framework = "net481")
    targeting_pack(name = "default_netcoreapp1.0", packs = ["@dotnet.targeting_packs//microsoft.netcore.app.v1.0.16"], target_framework = "netcoreapp1.0")
    targeting_pack(name = "default_netcoreapp1.1", packs = ["@dotnet.targeting_packs//microsoft.netcore.app.v1.1.13"], target_framework = "netcoreapp1.1")
    targeting_pack(name = "default_netcoreapp2.0", packs = ["@dotnet.targeting_packs//microsoft.netcore.app.v2.0.9"], target_framework = "netcoreapp2.0")
    targeting_pack(name = "default_netcoreapp2.1", packs = ["@dotnet.targeting_packs//microsoft.netcore.app.v2.1.30"], target_framework = "netcoreapp2.1")
    targeting_pack(name = "default_netcoreapp2.2", packs = ["@dotnet.targeting_packs//microsoft.netcore.app.v2.2.8"], target_framework = "netcoreapp2.2")
    targeting_pack(name = "default_netcoreapp3.0", packs = ["@dotnet.targeting_packs//microsoft.netcore.app.ref.v3.0.1"], target_framework = "netcoreapp3.0")
    targeting_pack(name = "default_netcoreapp3.1", packs = ["@dotnet.targeting_packs//microsoft.netcore.app.ref.v3.1.0"], target_framework = "netcoreapp3.1")
    targeting_pack(name = "default_net5.0", packs = ["@dotnet.targeting_packs//microsoft.netcore.app.ref.v5.0.0"], target_framework = "net5.0")
    targeting_pack(name = "default_net6.0", packs = ["@dotnet.targeting_packs//microsoft.netcore.app.ref.v6.0.28"], target_framework = "net6.0")
    targeting_pack(name = "default_net7.0", packs = ["@dotnet.targeting_packs//microsoft.netcore.app.ref.v7.0.17"], target_framework = "net7.0")
    targeting_pack(name = "default_net8.0", packs = ["@dotnet.targeting_packs//microsoft.netcore.app.ref.v8.0.3"], target_framework = "net8.0")
    targeting_pack(name = "web_netcoreapp2.1", packs = ["@dotnet.targeting_packs//microsoft.aspnetcore.app.v2.1.34", "@dotnet.targeting_packs//microsoft.netcore.app.v2.1.30"], target_framework = "netcoreapp2.1")
    targeting_pack(name = "web_netcoreapp2.2", packs = ["@dotnet.targeting_packs//microsoft.aspnetcore.app.v2.2.8", "@dotnet.targeting_packs//microsoft.netcore.app.v2.2.8"], target_framework = "netcoreapp2.2")
    targeting_pack(name = "web_netcoreapp3.0", packs = ["@dotnet.targeting_packs//microsoft.aspnetcore.app.ref.v3.0.1", "@dotnet.targeting_packs//microsoft.netcore.app.ref.v3.0.1"], target_framework = "netcoreapp3.0")
    targeting_pack(name = "web_netcoreapp3.1", packs = ["@dotnet.targeting_packs//microsoft.aspnetcore.app.ref.v3.1.10", "@dotnet.targeting_packs//microsoft.netcore.app.ref.v3.1.0"], target_framework = "netcoreapp3.1")
    targeting_pack(name = "web_net5.0", packs = ["@dotnet.targeting_packs//microsoft.aspnetcore.app.ref.v5.0.0", "@dotnet.targeting_packs//microsoft.netcore.app.ref.v5.0.0"], target_framework = "net5.0")
    targeting_pack(name = "web_net6.0", packs = ["@dotnet.targeting_packs//microsoft.aspnetcore.app.ref.v6.0.28", "@dotnet.targeting_packs//microsoft.netcore.app.ref.v6.0.28"], target_framework = "net6.0")
    targeting_pack(name = "web_net7.0", packs = ["@dotnet.targeting_packs//microsoft.aspnetcore.app.ref.v7.0.17", "@dotnet.targeting_packs//microsoft.netcore.app.ref.v7.0.17"], target_framework = "net7.0")
    targeting_pack(name = "web_net8.0", packs = ["@dotnet.targeting_packs//microsoft.aspnetcore.app.ref.v8.0.3", "@dotnet.targeting_packs//microsoft.netcore.app.ref.v8.0.3"], target_framework = "net8.0")
