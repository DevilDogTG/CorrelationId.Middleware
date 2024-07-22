$workspace = "$PSScriptRoot\.."
$projectName = "DMNSN.AspNetCore.Middlewares.CorrelationId"
$project = "$workspace\src\$projectName\$projectName.csproj"
$solution = "$workspace\CorrelationIdMiddleware.sln"
$releaseNotes = "Initial release. Starting base version with version of dotnet"
$tagPrefix = ""
$nugetSource = "nuget.org"
##############################################################
# Under this line will be replace automatically when updated #
##############################################################
try {
    Write-Host "Step 1: Running tests"
    dotnet test $solution -c Release
    if ($LASTEXITCODE -ne 0) { throw "Test failed. Please fix issue before next process." }

    Write-Host "Step 2: Check current code can build successfully"
    dotnet build $project -c Release
    if ($LASTEXITCODE -ne 0) { throw "Build failed. Please fix issue before next process." }

    Write-Host "Step 3: Check if current workspace has been already committed"
    $status = & git status --porcelain

    if ($null -ne $status) { throw "Workspace not up to date. Please commit any change before publish package." }

    Write-Host "Step 4: Automatic running package version"
    $PrjContent = Get-Content $project
    $versionRegex = '(?<=<Version>)(\d+)\.(\d+)\.(\d+)(?=</Version>)'
    $match = [regex]::Match($PrjContent, $versionRegex)

    if (-not $match.Success) { throw "Cannot find <Version> tag in .csproj" }
    $major = $match.Groups[1].Value
    $minor = $match.Groups[2].Value
    $patch = $match.Groups[3].Value
    $patchNew = [int]$match.Groups[3].Value + 1
    $curVersion = "$major.$minor.$patch"
    $newVersion = "$major.$minor.$patchNew"
    Write-Host ".. Version: $curVersion -> $newVersion"
    $PrjContent -replace "<Version>$major.$minor.$patch</Version>", "<Version>$newVersion</Version>" | Set-Content -Path $project

    $tagName = "${tagPrefix}v${newVersion}"
    $commitMessage = "Automated version tag $tagName"

    Write-Host "Step 5: Commit version information."
    & git add -A
    & git commit -m $commitMessage
    if ($LASTEXITCODE -ne 0) { throw "Git commit failed" }

    Write-Host "Step 6: Tag current working"
    & git tag $tagName
    if ($LASTEXITCODE -ne 0) { throw "Git tag failed" }

    Write-Host "Step 7: Get current branch name"
    $currentBranch = git rev-parse --abbrev-ref HEAD
    Write-Host ".. Branch: $currentBranch"
    if ($LASTEXITCODE -ne 0) { throw "Failed to get current branch name" }

    Write-Host "Step 8: Push commit and tag to origin"
    $pushOutput = git push origin $currentBranch --tags 2>&1
    if ($LASTEXITCODE -ne 0) { throw "Git push failed with error: $pushOutput" }

    Write-Host "Step 9: Start packing nuget package"
    if (!(Test-Path -Path "$workspace\publish")) {
        New-Item -ItemType Directory -Force -Path "$workspace\publish"
    }
    dotnet pack $project -c Release -o "$workspace\publish" --no-build /p:PackageReleaseNotes="$releaseNotes"
    if ($LASTEXITCODE -ne 0) { throw "Packing failed, aborting" }

    Write-Host "Step 10: Publish package to nuget.org"
    nuget push "$workspace\publish\$projectName.$newVersion.nupkg" -Source $nugetSource
    if ($LASTEXITCODE -ne 0) { throw "Pushing package failed. please manual pushing package" }
} catch {
    Write-Error "An error occurred: $_"
}
