#!/usr/bin/env python3
"""Regenerate the checked-in Xcode project with Python 3; no XcodeGen dependency."""
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
objects = {}


def uid(name):
    return hashlib.sha256(name.encode()).hexdigest()[:24].upper()


def add(identifier, isa, **values):
    key = uid(identifier)
    objects[key] = {"isa": isa, **values}
    return key


def plist(value, level=0):
    pad = "\t" * level
    if isinstance(value, dict):
        return "{\n" + "".join(f"{pad}\t{json.dumps(k)} = {plist(v, level + 1)};\n" for k, v in value.items()) + pad + "}"
    if isinstance(value, list):
        return "(\n" + "".join(f"{pad}\t{plist(v, level + 1)},\n" for v in value) + pad + ")"
    return json.dumps(str(value))


sources = []
app_files = []
for path in sorted((ROOT / "Apps/iOS/Shapery").glob("*.swift")):
    ref = add(path.name, "PBXFileReference", lastKnownFileType="sourcecode.swift", path=path.name, sourceTree="<group>")
    app_files.append(ref)
    sources.append(add("build-" + path.name, "PBXBuildFile", fileRef=ref))

resources = []
for name, file_type in [("Assets.xcassets", "folder.assetcatalog"), ("PrivacyInfo.xcprivacy", "text.xml")]:
    ref = add(name, "PBXFileReference", lastKnownFileType=file_type, path=name, sourceTree="<group>")
    app_files.append(ref)
    resources.append(add("build-" + name, "PBXBuildFile", fileRef=ref))
app_files.append(add("Info.plist", "PBXFileReference", lastKnownFileType="text.plist.xml", path="Info.plist", sourceTree="<group>"))
app_group = add("app-group", "PBXGroup", children=app_files, path="Apps/iOS/Shapery", sourceTree="<group>")
config = add("base-config", "PBXFileReference", lastKnownFileType="text.xcconfig", path="Configuration/Base.xcconfig", sourceTree="<group>")
product = add("app-product", "PBXFileReference", explicitFileType="wrapper.application", includeInIndex=0, path="Shapery.app", sourceTree="BUILT_PRODUCTS_DIR")
products = add("products-group", "PBXGroup", children=[product], name="Products", sourceTree="<group>")
main_group = add("main-group", "PBXGroup", children=[app_group, config, products], sourceTree="<group>")
package = add("core-package", "XCLocalSwiftPackageReference", relativePath="Packages/ShaperyCore")
dependency = add("core-product", "XCSwiftPackageProductDependency", package=package, productName="ShaperyCore")
framework = add("core-framework", "PBXBuildFile", productRef=dependency)
phases = []
for name, isa, files in [
    ("sources", "PBXSourcesBuildPhase", sources),
    ("frameworks", "PBXFrameworksBuildPhase", [framework]),
    ("resources", "PBXResourcesBuildPhase", resources),
]:
    phases.append(add(name, isa, buildActionMask=2147483647, files=files, runOnlyForDeploymentPostprocessing=0))


def configurations(scope):
    configs = []
    for name in ("Debug", "Release"):
        settings = {}
        extra = {}
        if scope == "project":
            extra["baseConfigurationReference"] = config
            settings = {
                "SWIFT_OPTIMIZATION_LEVEL": "-Onone" if name == "Debug" else "-O",
                "DEBUG_INFORMATION_FORMAT": "dwarf" if name == "Debug" else "dwarf-with-dsym",
                "ENABLE_TESTABILITY": "YES" if name == "Debug" else "NO",
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG $(inherited)" if name == "Debug" else "$(inherited)",
                "SWIFT_COMPILATION_MODE": "singlefile" if name == "Debug" else "wholemodule",
            }
        configs.append(add(scope + name, "XCBuildConfiguration", buildSettings=settings, name=name, **extra))
    return add(scope + "-config-list", "XCConfigurationList", buildConfigurations=configs, defaultConfigurationIsVisible=0, defaultConfigurationName="Release")


target = add("app-target", "PBXNativeTarget", buildConfigurationList=configurations("target"), buildPhases=phases,
             buildRules=[], dependencies=[], name="Shapery", packageProductDependencies=[dependency], productName="Shapery",
             productReference=product, productType="com.apple.product-type.application")
project = add("project", "PBXProject", attributes={"BuildIndependentTargetsInParallel": "YES", "LastUpgradeCheck": "1600"},
              buildConfigurationList=configurations("project"), compatibilityVersion="Xcode 14.0", developmentRegion="en",
              hasScannedForEncodings=0, knownRegions=["en", "Base"], mainGroup=main_group,
              packageReferences=[package], productRefGroup=products, projectDirPath="", projectRoot="", targets=[target])
project_dir = ROOT / "Shapery.xcodeproj"
project_dir.mkdir(exist_ok=True)
(project_dir / "project.pbxproj").write_text("// !$*UTF8*$!\n" + plist({"archiveVersion": 1, "classes": {}, "objectVersion": 56, "objects": objects, "rootObject": project}) + "\n")
schemes = project_dir / "xcshareddata/xcschemes"
schemes.mkdir(parents=True, exist_ok=True)
reference = f'<BuildableReference BuildableIdentifier="primary" BlueprintIdentifier="{target}" BuildableName="Shapery.app" BlueprintName="Shapery" ReferencedContainer="container:Shapery.xcodeproj"/>'
(schemes / "Shapery.xcscheme").write_text(f'''<?xml version="1.0" encoding="UTF-8"?>
<Scheme LastUpgradeVersion="1600" version="1.3">
  <BuildAction parallelizeBuildables="YES" buildImplicitDependencies="YES">
    <BuildActionEntries><BuildActionEntry buildForTesting="YES" buildForRunning="YES" buildForProfiling="YES" buildForArchiving="YES" buildForAnalyzing="YES">{reference}</BuildActionEntry></BuildActionEntries>
  </BuildAction>
  <TestAction buildConfiguration="Debug" selectedDebuggerIdentifier="Xcode.DebuggerFoundation.Debugger.LLDB" selectedLauncherIdentifier="Xcode.IDEFoundation.Launcher.LLDB" shouldUseLaunchSchemeArgsEnv="YES"><Testables/></TestAction>
  <LaunchAction buildConfiguration="Debug" selectedDebuggerIdentifier="Xcode.DebuggerFoundation.Debugger.LLDB" selectedLauncherIdentifier="Xcode.IDEFoundation.Launcher.LLDB" launchStyle="0" useCustomWorkingDirectory="NO" ignoresPersistentStateOnLaunch="NO" debugDocumentVersioning="YES" debugServiceExtension="internal" allowLocationSimulation="YES"><BuildableProductRunnable runnableDebuggingMode="0">{reference}</BuildableProductRunnable></LaunchAction>
  <ProfileAction buildConfiguration="Release" shouldUseLaunchSchemeArgsEnv="YES" savedToolIdentifier="" useCustomWorkingDirectory="NO" debugDocumentVersioning="YES"><BuildableProductRunnable runnableDebuggingMode="0">{reference}</BuildableProductRunnable></ProfileAction>
  <AnalyzeAction buildConfiguration="Debug"/>
  <ArchiveAction buildConfiguration="Release" revealArchiveInOrganizer="YES"/>
</Scheme>
''')
print(f"Generated {project_dir.name} ({len(sources)} Swift app files)")
