module ApphostPacks


open System.IO
open System.Text.Json
open System.Collections.Generic
open System.Text

type ApphostPack = { id: string; version: string }

let private apphostPackLabel tfm rid =
    $"//dotnet/private/sdk/apphost_packs:{tfm}_{rid}"

let updateApphostPacks apphostPacksFile =
    let apphostPacks = File.ReadAllText apphostPacksFile

    let apphostPacks =
        JsonSerializer.Deserialize<Dictionary<string, Dictionary<string, ApphostPack[]>>>(apphostPacks)

    let updatedApphostPacks = Dictionary<string, Dictionary<string, ApphostPack[]>>()

    for tfmPacks in apphostPacks do
        let updatedtfmPacks = Dictionary<string, ApphostPack[]>()

        for ridPacks in tfmPacks.Value do
            let mutable updatedPacks: ApphostPack[] = Array.empty

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

            updatedtfmPacks.Add(ridPacks.Key, updatedPacks |> Array.sortBy (fun p -> p.id))

        updatedApphostPacks.Add(tfmPacks.Key, updatedtfmPacks)

    let updatedApphostPacksJson =
        JsonSerializer.Serialize(updatedApphostPacks, options = JsonSerializerOptions(WriteIndented = true))

    File.WriteAllText(apphostPacksFile, updatedApphostPacksJson)
    ()

let writeApphostPackLookupTable apphostPacksFile output =
    let apphostPacksJson = File.ReadAllText apphostPacksFile

    let apphostPacks =
        JsonSerializer.Deserialize<Dictionary<string, Dictionary<string, ApphostPack[]>>>(apphostPacksJson)

    let lookupTable = Dictionary<string, Dictionary<string, string>>()

    for tfmPacks in apphostPacks do
        lookupTable.Add(tfmPacks.Key, Dictionary<string, string>())

        for ridPacks in tfmPacks.Value do
            let label = apphostPackLabel tfmPacks.Key ridPacks.Key
            lookupTable.[tfmPacks.Key].Add(ridPacks.Key, label)

    let lookupTableJson =
        JsonSerializer.Serialize(lookupTable, options = JsonSerializerOptions(WriteIndented = true))

    let sb = new StringBuilder()

    sb.AppendLine("\"GENERATED BY SDK GENERATOR\"") |> ignore
    sb.AppendLine() |> ignore
    sb.Append("apphost_pack_lookup_table = ") |> ignore
    sb.Append(lookupTableJson) |> ignore
    sb.Append("\n") |> ignore

    File.WriteAllText(output, sb.ToString())
    ()


let generateApphostPackTargets apphostPacksFile output =
    let apphostPacksJson = File.ReadAllText apphostPacksFile

    let apphostPacks =
        JsonSerializer.Deserialize<Dictionary<string, Dictionary<string, ApphostPack[]>>>(apphostPacksJson)

    let sb = new StringBuilder()

    sb.AppendLine("\"GENERATED BY SDK GENERATOR\"") |> ignore
    sb.AppendLine() |> ignore

    sb.AppendLine("load(\"//dotnet/private/sdk/apphost_packs:apphost_pack.bzl\", \"apphost_pack\")")
    |> ignore

    sb.AppendLine() |> ignore
    sb.AppendLine("def apphost_packs():") |> ignore
    sb.AppendLine("    \"\"\"apphost packs\"\"\"") |> ignore
    sb.AppendLine() |> ignore

    for tfmPacks in apphostPacks do
        for ridPacks in tfmPacks.Value do
            let packs =
                ridPacks.Value
                |> Array.map (fun p -> $"\"@dotnet.apphost_packs//{p.id.ToLower()}.v{p.version}\"")
                |> String.concat ", "

            let label = $"{tfmPacks.Key}_{ridPacks.Key}"

            sb.AppendLine(
                $"    apphost_pack(name = \"{label}\", packs = [{packs}], target_framework = \"{tfmPacks.Key}\", apphost_identifier = \"{ridPacks.Key}\")"
            )
            |> ignore

    File.WriteAllText(output, sb.ToString())

    ()

let generateApphostPacksNugetRepo apphostPacksFile outputFolder =
    let apphostPacksJson = File.ReadAllText apphostPacksFile

    let apphostPacks =
        JsonSerializer.Deserialize<Dictionary<string, Dictionary<string, ApphostPack[]>>>(apphostPacksJson)

    let repoPackages: NugetRepo.NugetRepoPackage seq =
        apphostPacks
        |> Seq.collect (fun sdk -> sdk.Value |> Seq.collect (fun tfmPacks -> tfmPacks.Value))
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

    NugetRepo.generateBazelFiles "apphost_packs" repoPackages outputFolder "dotnet."
    ()