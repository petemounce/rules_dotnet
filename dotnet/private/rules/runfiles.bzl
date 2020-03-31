def CopyRunfiles(dotnet, runfiles, copy, symlink, executable, subdir):
    copied = {}
    created = []
    nocopy_dir = executable.result.dirname
    for f in runfiles.files.to_list():
        found = copied.get(f.basename)
        if found:
            continue
        copied[f.basename] = True

        if f.basename == "mono" or f.basename == "mono.exe":
            newfile = dotnet.declare_file(dotnet, path = subdir + f.basename)
            dotnet.actions.run(
                outputs = [newfile],
                inputs = [f] + symlink.files.to_list(),
                executable = symlink.files.to_list()[0],
                arguments = [newfile.path, f.path],
                mnemonic = "LinkFile",
            )
            created.append(newfile)
        elif f.dirname != nocopy_dir:
            if f.basename.find("hostfxr") >= 0:
                version = f.path.split("/")
                newfile = dotnet.declare_file(dotnet, path = "{}/host/fxr/{}/{}".format(subdir, version[-2], version[-1]))
            else:
                newfile = dotnet.declare_file(dotnet, path = subdir + f.basename)
            dotnet.actions.run(
                outputs = [newfile],
                inputs = [f] + copy.files.to_list(),
                executable = copy.files.to_list()[0],
                arguments = [newfile.path, f.path],
                mnemonic = "CopyFile",
            )
            created.append(newfile)
        else:
            created.append(f)

    return dotnet._ctx.runfiles(files = created)
