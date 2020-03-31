load(
    "@io_bazel_rules_dotnet//dotnet/private:common.bzl",
    "as_iterable",
)
load(
    "@io_bazel_rules_dotnet//dotnet/private:context.bzl",
    "dotnet_context",
)
load(
    "@io_bazel_rules_dotnet//dotnet/private:providers.bzl",
    "DotnetLibrary",
)
load("@io_bazel_rules_dotnet//dotnet/private:rules/common.bzl", "collect_transitive_info")

def _stdlib_impl(ctx):
    dotnet = dotnet_context(ctx)
    if ctx.attr.dll == "":
        name = ctx.label.name
    else:
        name = ctx.attr.dll

    if dotnet.stdlib_byname == None:
        library = dotnet.new_library(dotnet = dotnet)
        return [library]

    result = dotnet.stdlib_byname(name = name, shared = dotnet.shared, lib = dotnet.lib, libVersion = dotnet.libVersion)

    (transitive_refs, transitive_runfiles, transitive_deps) = collect_transitive_info(ctx.attr.deps)

    direct_runfiles = []
    direct_runfiles.append(result)

    if ctx.attr.data:
        data_l = [f for t in ctx.attr.data for f in as_iterable(t.files)]
        direct_runfiles += data_l

    library = dotnet.new_library(
        dotnet = dotnet,
        name = name,
        deps = ctx.attr.deps,
        transitive = transitive_deps,
        runfiles = depset(direct = direct_runfiles, transitive = [transitive_runfiles]),
        result = result,
        transitive_refs = transitive_refs,
    )

    return [
        library,
        DefaultInfo(
            files = depset([library.result]),
            runfiles = ctx.runfiles(files = [], transitive_files = library.runfiles),
        ),
    ]

dotnet_stdlib = rule(
    _stdlib_impl,
    attrs = {
        "dll": attr.string(),
        "deps": attr.label_list(providers = [DotnetLibrary]),
        "data": attr.label_list(allow_files = True),
        "dotnet_context_data": attr.label(default = Label("@io_bazel_rules_dotnet//:dotnet_context_data")),
    },
    toolchains = ["@io_bazel_rules_dotnet//dotnet:toolchain"],
    executable = False,
)

core_stdlib = rule(
    _stdlib_impl,
    attrs = {
        "dll": attr.string(),
        "deps": attr.label_list(providers = [DotnetLibrary]),
        "data": attr.label_list(allow_files = True),
        "dotnet_context_data": attr.label(default = Label("@io_bazel_rules_dotnet//:core_context_data")),
    },
    toolchains = ["@io_bazel_rules_dotnet//dotnet:toolchain_core"],
    executable = False,
)

net_stdlib = rule(
    _stdlib_impl,
    attrs = {
        "dll": attr.string(),
        "deps": attr.label_list(providers = [DotnetLibrary]),
        "data": attr.label_list(allow_files = True),
        "dotnet_context_data": attr.label(default = Label("@io_bazel_rules_dotnet//:net_context_data")),
    },
    toolchains = ["@io_bazel_rules_dotnet//dotnet:toolchain_net"],
    executable = False,
)
