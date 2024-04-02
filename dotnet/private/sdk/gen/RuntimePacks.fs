module RuntimePacks


open System.IO
open System.Text.Json
open System.Collections.Generic
open System.Text

type RuntimePack = { id: string; version: string }

let private runtimePackLabel projectSdk tfm rid =
    $"//dotnet/private/sdk/runtime_packs:{projectSdk}_{tfm}_{rid}"

let updateRuntimePacks runtimePacksFile =
    let runtimePacks = File.ReadAllText runtimePacksFile

    let runtimePacks =
        JsonSerializer.Deserialize<Dictionary<string, Dictionary<string, Dictionary<string, RuntimePack[]>>>>(
            runtimePacks
        )

    let updatedRuntimePacks =
        Dictionary<string, Dictionary<string, Dictionary<string, RuntimePack[]>>>()

    for sdk in runtimePacks do
        let updatedtfmPacks = Dictionary<string, Dictionary<string, RuntimePack[]>>()

        for tfmPacks in sdk.Value do
            let updatedRidPacks = Dictionary<string, RuntimePack[]>()

            for ridPacks in tfmPacks.Value do
                let mutable updatedPacks: RuntimePack[] = Array.empty

                for pack in ridPacks.Value do
                    let majorVersion = pack.version.Split('.')[0]
                    let featureVersion = pack.version.Split('.')[1]

                    let latestVersion =
                        NugetHelpers.getAllVersions pack.id
                        |> List.filter (fun v -> v.ToFullString().StartsWith($"{majorVersion}.{featureVersion}"))
                        |> List.max

                    let updatedPack =
                        { pack with
                            version = latestVersion.ToFullString() }

                    updatedPacks <- Array.append updatedPacks [| updatedPack |]

                updatedRidPacks.Add(ridPacks.Key, updatedPacks |> Array.sortBy (fun p -> p.id))

            updatedtfmPacks.Add(tfmPacks.Key, updatedRidPacks)

        updatedRuntimePacks.Add(sdk.Key, updatedtfmPacks)

    let updatedRuntimePacksJson =
        JsonSerializer.Serialize(updatedRuntimePacks, options = JsonSerializerOptions(WriteIndented = true))

    File.WriteAllText(runtimePacksFile, updatedRuntimePacksJson)
    ()

let writeRuntimePackLookupTable runtimePacksFile output =
    let runtimePacksJson = File.ReadAllText runtimePacksFile

    let runtimePacks =
        JsonSerializer.Deserialize<Dictionary<string, Dictionary<string, Dictionary<string, RuntimePack[]>>>>(
            runtimePacksJson
        )

    let lookupTable =
        Dictionary<string, Dictionary<string, Dictionary<string, string>>>()

    for sdk in runtimePacks do
        lookupTable.Add(sdk.Key, Dictionary<string, Dictionary<string, string>>())

        for tfmPacks in sdk.Value do
            lookupTable.[sdk.Key].Add(tfmPacks.Key, Dictionary<string, string>())

            for ridPacks in tfmPacks.Value do
                let label = runtimePackLabel sdk.Key tfmPacks.Key ridPacks.Key
                lookupTable.[sdk.Key].[tfmPacks.Key].Add(ridPacks.Key, label)

    let lookupTableJson =
        JsonSerializer.Serialize(lookupTable, options = JsonSerializerOptions(WriteIndented = true))

    let sb = new StringBuilder()

    sb.AppendLine("\"GENERATED BY SDK GENERATOR\"") |> ignore
    sb.AppendLine() |> ignore
    sb.Append("runtime_pack_lookup_table = ") |> ignore
    sb.Append(lookupTableJson) |> ignore
    sb.Append("\n") |> ignore

    File.WriteAllText(output, sb.ToString())
    ()


let generateRuntimePackTargets runtimePacksFile output =
    let runtimePacksJson = File.ReadAllText runtimePacksFile

    let runtimePacks =
        JsonSerializer.Deserialize<Dictionary<string, Dictionary<string, Dictionary<string, RuntimePack[]>>>>(
            runtimePacksJson
        )

    let sb = new StringBuilder()

    sb.AppendLine("\"GENERATED BY SDK GENERATOR\"") |> ignore
    sb.AppendLine() |> ignore

    sb.AppendLine("load(\"//dotnet/private/sdk/runtime_packs:runtime_pack.bzl\", \"runtime_pack\")")
    |> ignore

    sb.AppendLine() |> ignore
    sb.AppendLine("# buildifier: disable=unnamed-macro") |> ignore
    sb.AppendLine("def runtime_packs():") |> ignore
    sb.AppendLine("    \"\"\"runtime packs\"\"\"") |> ignore
    sb.AppendLine() |> ignore

    for sdk in runtimePacks do
        for tfmPacks in sdk.Value do
            for ridPacks in tfmPacks.Value do
                let packs =
                    ridPacks.Value
                    |> Array.map (fun p -> $"\"@dotnet.runtime_packs//{p.id.ToLower()}.v{p.version}\"")
                    |> String.concat ", "

                let label = $"{sdk.Key}_{tfmPacks.Key}_{ridPacks.Key}"

                sb.AppendLine(
                    $"    runtime_pack(name = \"{label}\", packs = [{packs}], target_framework = \"{tfmPacks.Key}\", runtime_identifier = \"{ridPacks.Key}\")"
                )
                |> ignore

    File.WriteAllText(output, sb.ToString())

    ()

let generateRuntimePacksNugetRepo runtimePacksFile outputFolder =
    let runtimePacksJson = File.ReadAllText runtimePacksFile

    let runtimePacks =
        JsonSerializer.Deserialize<Dictionary<string, Dictionary<string, Dictionary<string, RuntimePack[]>>>>(
            runtimePacksJson
        )

    let repoPackages: NugetRepo.NugetRepoPackage seq =
        runtimePacks
        |> Seq.collect (fun sdk ->
            sdk.Value
            |> Seq.collect (fun tfmPacks -> tfmPacks.Value |> Seq.collect (fun ridPacks -> ridPacks.Value)))
        |> Seq.distinctBy (fun p -> $"{p.id}.{p.version}")
        |> Seq.map (fun pack ->
            let packageInfo =
                NugetHelpers.getPackageInfo pack.id pack.version NugetHelpers.nugetV3Feed

            { name = $"{pack.id.ToLower()}.v{pack.version}"
              id = pack.id
              version = pack.version
              sha512 = packageInfo.sha512sri
              sources = [ NugetHelpers.nugetV3Feed ]
              netrc = None
              dependencies = Dictionary<string, string seq>()
              targeting_pack_overrides = packageInfo.overrides
              framework_list = packageInfo.frameworkList })

    NugetRepo.generateBazelFiles "runtime_packs" repoPackages outputFolder "dotnet."
    ()
