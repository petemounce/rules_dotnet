using System.Linq;
using NuGet.Packaging.Core;
using NuGet.Versioning;
using nuget2bazel;
using Xunit;

namespace nuget2bazel_test
{
    public class WorkspaceWriterT
    {
        [Fact]
        public void SingleEntry()
        {
            var data = @"
### Generated by the tool
nuget_package(
   name = ""remotion.linq"",
   package = ""remotion.linq"",
   version = ""2.2.0"",
)
### End of generated by the tool
";
            var writer = new WorkspaceWriter();
            var section = writer.ExtractSection(data);

            var parser = new WorkspaceParser(section);
            var result = parser.Parse();
            Assert.Single(result);
            var entry = result.First();
            Assert.Equal("remotion.linq", entry.PackageIdentity.Id);
            Assert.Equal("2.2.0", entry.PackageIdentity.Version.ToString());
        }

        [Fact]
        public void AddEntry()
        {
            var data = @"
### Generated by the tool
### End of generated by the tool
";
            var writer = new WorkspaceWriter();
            var entry = new WorkspaceEntry()
            {
                PackageIdentity = new PackageIdentity("remotion.linq", new NuGetVersion(2, 2, 0))
            };

            var result = writer.AddEntry(data, entry, false);
            result = result.Replace("\r", "");

            var tocompare = @"
### Generated by the tool
nuget_package(
    name = ""remotion.linq"",
    package = ""remotion.linq"",
    version = ""2.2.0"",
)
### End of generated by the tool
".Replace("\r", "");

            Assert.Equal(tocompare, result);
        }

        [Fact]
        public void AddEntryIndented()
        {
            var data = @"
    ### Generated by the tool
    ### End of generated by the tool
";
            var writer = new WorkspaceWriter();
            var entry = new WorkspaceEntry()
            {
                PackageIdentity = new PackageIdentity("remotion.linq", new NuGetVersion(2, 2, 0))
            };

            var result = writer.AddEntry(data, entry, true);
            result = result.Replace("\r", "");

            var tocompare = @"
    ### Generated by the tool
    nuget_package(
        name = ""remotion.linq"",
        package = ""remotion.linq"",
        version = ""2.2.0"",
    )
    ### End of generated by the tool
".Replace("\r", "");

            Assert.Equal(tocompare, result);
        }
    }
}