"""
Rules to load all the .NET SDK & framework dependencies of rules_dotnet.
"""

load("//dotnet/private:toolchains_repo.bzl", "PLATFORMS", "toolchains_repo")
load("//dotnet/private/sdk:versions.bzl", "TOOL_VERSIONS")

########
# Remaining content of the file is only used to support toolchains.
########
_DOC = "Fetch external tools needed for dotnet toolchain"
_ATTRS = {
    "dotnet_version": attr.string(mandatory = True, values = TOOL_VERSIONS.keys()),
    "platform": attr.string(mandatory = True, values = PLATFORMS.keys()),
}

def _dotnet_repo_impl(repository_ctx):
    url = TOOL_VERSIONS[repository_ctx.attr.dotnet_version][repository_ctx.attr.platform]["url"]
    repository_ctx.download_and_extract(
        url = url,
        integrity = TOOL_VERSIONS[repository_ctx.attr.dotnet_version][repository_ctx.attr.platform]["hash"],
    )
    build_content = """#Generated by dotnet/repositories.bzl
load("@rules_dotnet//dotnet:toolchain.bzl", "dotnet_toolchain")
load("@rules_dotnet//dotnet:defs.bzl", "import_dll")

filegroup(
    name = "csc_binary",
    srcs = [
        "sdk/{sdk_version}/Roslyn/bincore/csc.dll",
    ],
    data = glob([
        "sdk/{sdk_version}/Roslyn/bincore/**/*",
        "host/**/*",
    ]),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "runtime",
    srcs = select({{
        "@bazel_tools//src/conditions:windows": ["dotnet.exe"],
        "//conditions:default": ["dotnet"],
    }}),
    data = glob([
        "host/**/*",
        "sdk/**/*",
        "shared/Microsoft.NETCore.App/**/*",
    ]),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "apphost",
    srcs = glob([
        "sdk/**/AppHostTemplate/apphost.exe", # windows
        "sdk/**/AppHostTemplate/apphost",
    ]),
    visibility = ["//visibility:public"],
)

import_dll(
    name = "host_model",
    version = "{runtime_version}",
    dll = "sdk/{sdk_version}/Microsoft.NET.HostModel.dll",
)

filegroup(
    name = "fsc_binary",
    # We glob both fsc.dll and fsc.exe for backwards compatibility
    # Pre .Net 5.0 the file was called fsc.exe but has been changed to fsc.dll
    srcs = glob([
        "sdk/**/FSharp/fsc.dll*",
        "sdk/**/FSharp/fsc.exe*",
    ]),
    data = glob([
        "host/**/*",
        "sdk/{sdk_version}/FSharp/**/*.dll",
    ]) + [
        "sdk/{sdk_version}/FSharp/fsc.runtimeconfig.json",
    ],
    visibility = ["//visibility:public"],
)

dotnet_toolchain(
    name = "dotnet_toolchain", 
    runtime = ":runtime",
    csharp_compiler = ":csc_binary",
    fsharp_compiler = ":fsc_binary",
    apphost = ":apphost",
    host_model = ":host_model",
    sdk_version = "{sdk_version}",
    runtime_version = "{runtime_version}",
    runtime_tfm = "{runtime_tfm}",
    csharp_default_version = "{csharp_default_version}",
    fsharp_default_version = "{fsharp_default_version}",
)
""".format(
        sdk_version = repository_ctx.attr.dotnet_version,
        runtime_version = TOOL_VERSIONS[repository_ctx.attr.dotnet_version]["runtimeVersion"],
        runtime_tfm = TOOL_VERSIONS[repository_ctx.attr.dotnet_version]["runtimeTfm"],
        csharp_default_version = TOOL_VERSIONS[repository_ctx.attr.dotnet_version]["csharpDefaultVersion"],
        fsharp_default_version = TOOL_VERSIONS[repository_ctx.attr.dotnet_version]["fsharpDefaultVersion"],
    )

    # Base BUILD file for this repository
    repository_ctx.file("BUILD.bazel", build_content)

dotnet_repositories = repository_rule(
    _dotnet_repo_impl,
    doc = _DOC,
    attrs = _ATTRS,
)

# Wrapper macro around everything above, this is the primary API
def dotnet_register_toolchains(name, dotnet_version, register = True, **kwargs):
    """Convenience macro for users which does typical setup.

    - create a repository for each built-in platform like "dotnet_linux_amd64" -
      this repository is lazily fetched when node is needed for that platform.
    - create a repository exposing toolchains for each platform like "dotnet_platforms"
    - register a toolchain pointing at each platform
    Users can avoid this macro and do these steps themselves, if they want more control.
    Args:
        name: base name for all created repos, like "dotnet"
        dotnet_version: The .Net SDK version to use e.g. 8.0.100
        register: whether to call through to native.register_toolchains.
            Should be True for WORKSPACE users, but false when used under bzlmod extension
        **kwargs: passed to each dotnet_repositories call
    """
    for platform in PLATFORMS.keys():
        dotnet_repositories(
            name = name + "_" + platform,
            platform = platform,
            dotnet_version = dotnet_version,
            **kwargs
        )
        if register:
            native.register_toolchains("@%s_toolchains//:%s_toolchain" % (name, platform))

    toolchains_repo(
        name = name + "_toolchains",
        user_repository_name = name,
    )
