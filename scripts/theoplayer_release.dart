import 'dart:convert';
import 'dart:io';

const packagePubspecs = <String, String>{
  'theoplayer_platform_interface': 'flutter_theoplayer_sdk/flutter_theoplayer_sdk_platform_interface/pubspec.yaml',
  'theoplayer_android': 'flutter_theoplayer_sdk/flutter_theoplayer_sdk_android/pubspec.yaml',
  'theoplayer_ios': 'flutter_theoplayer_sdk/flutter_theoplayer_sdk_ios/pubspec.yaml',
  'theoplayer_web': 'flutter_theoplayer_sdk/flutter_theoplayer_sdk_web/pubspec.yaml',
  'theoplayer': 'flutter_theoplayer_sdk/flutter_theoplayer_sdk/pubspec.yaml',
};

const packageChangelogs = <String>[
  'flutter_theoplayer_sdk/flutter_theoplayer_sdk_platform_interface/CHANGELOG.md',
  'flutter_theoplayer_sdk/flutter_theoplayer_sdk_android/CHANGELOG.md',
  'flutter_theoplayer_sdk/flutter_theoplayer_sdk_ios/CHANGELOG.md',
  'flutter_theoplayer_sdk/flutter_theoplayer_sdk_web/CHANGELOG.md',
  'flutter_theoplayer_sdk/flutter_theoplayer_sdk/CHANGELOG.md',
];

const platformDependencies = <String, List<String>>{
  'theoplayer_android': ['theoplayer_platform_interface'],
  'theoplayer_ios': ['theoplayer_platform_interface'],
  'theoplayer_web': ['theoplayer_platform_interface'],
  'theoplayer': ['theoplayer_platform_interface', 'theoplayer_android', 'theoplayer_ios', 'theoplayer_web'],
};

const publishedPackages = <String>[
  'theoplayer_platform_interface',
  'theoplayer_android',
  'theoplayer_ios',
  'theoplayer_web',
  'theoplayer',
];

final stableVersionPattern = RegExp(r'^\d+\.\d+\.\d+$');

Future<void> main(List<String> arguments) async {
  try {
    final invocation = Invocation.parse(arguments);
    final repository = Directory(invocation.root).absolute;
    switch (invocation.command) {
      case 'preflight':
        preflight(repository, invocation.version);
        return;
      case 'check-upstream':
        await checkUpstream(invocation.version);
        return;
      case 'check-unpublished':
        await checkUnpublished(invocation.version);
        return;
      case 'update-changelogs':
        updateChangelogs(repository, invocation.version);
        return;
      case 'verify':
        verify(repository, invocation.version);
        return;
      default:
        throw ReleaseException('Unknown command: ${invocation.command}');
    }
  } on ReleaseException catch (error) {
    stderr.writeln(error.message);
    exitCode = 1;
  } on FileSystemException catch (error) {
    stderr.writeln(error.message);
    exitCode = 1;
  } on FormatException catch (error) {
    stderr.writeln(error.message);
    exitCode = 1;
  }
}

void preflight(Directory repository, String targetVersion) {
  final target = Version.parse(targetVersion);
  final versions = packagePubspecs.map((name, path) => MapEntry(name, readPubspecVersion(repository, path)));
  final currentVersion = versions.values.first;

  for (final entry in versions.entries) {
    require(entry.value == currentVersion, '${entry.key} is ${entry.value}, expected all packages to be $currentVersion.');
  }
  verifyInternalDependencies(repository, currentVersion);
  require(target > Version.parse(currentVersion), 'Target version $targetVersion must be newer than $currentVersion.');
  stdout.writeln('Current Flutter SDK: $currentVersion');
  stdout.writeln('Requested release: $targetVersion');
}

Future<void> checkUpstream(String version) async {
  Version.parse(version);
  final escapedVersion = RegExp.escape(version);
  final maven = await fetchText('https://maven.theoplayer.com/releases/com/theoplayer/theoplayer-sdk-android/core/maven-metadata.xml');
  require(RegExp('<version>$escapedVersion</version>').hasMatch(maven), 'Android core $version is not available in Maven metadata.');

  await checkCocoaPodsVersion('THEOplayerSDK-core', version);
  await checkCocoaPodsVersion('THEOplayer-Integration-THEOlive', version);

  final npm = jsonDecode(await fetchText('https://registry.npmjs.org/theoplayer/$version'));
  require(npm is Map<String, dynamic> && npm['name'] == 'theoplayer' && npm['version'] == version, 'Web SDK $version is not available on npm.');

  final changelog = await fetchText('https://optiview.dolby.com/docs/theoplayer/changelog.md');
  require(RegExp('^## 🚀 $escapedVersion \\(', multiLine: true).hasMatch(changelog), 'THEOplayer $version is missing from the official changelog.');
  stdout.writeln('THEOplayer $version is available for Android, iOS core, iOS THEOlive, Web, and in the official changelog.');
}

Future<void> checkUnpublished(String version) async {
  Version.parse(version);
  for (final package in publishedPackages) {
    final metadata = jsonDecode(await fetchText('https://pub.dev/api/packages/$package'));
    require(metadata is Map<String, dynamic>, 'Unexpected pub.dev metadata for $package.');
    final versions = metadata['versions'];
    require(versions is List, 'Missing pub.dev versions for $package.');
    final exists = versions.whereType<Map<String, dynamic>>().any((entry) => entry['version'] == version);
    require(!exists, '$package $version is already published on pub.dev.');
  }
  stdout.writeln('Version $version is not published for any Flutter package.');
}

void updateChangelogs(Directory repository, String version) {
  Version.parse(version);
  final versionHeading = '## $version';
  final updateLine = '* Updated THEOplayer to $version.';

  for (final path in packageChangelogs) {
    final file = repositoryFile(repository, path);
    final original = file.readAsStringSync();
    final newline = original.contains('\r\n') ? '\r\n' : '\n';
    require(!RegExp('^${RegExp.escape(versionHeading)}\$', multiLine: true).hasMatch(original), '$path already contains $versionHeading.');

    final unreleased = RegExp(r'^## Unreleased\r?$', multiLine: true).allMatches(original).toList();
    require(unreleased.length <= 1, '$path contains more than one Unreleased section.');

    late final String updated;
    if (unreleased.isEmpty) {
      updated = '$versionHeading$newline$newline$updateLine$newline$newline$original';
    } else {
      final heading = unreleased.single;
      final nextHeading = RegExp(r'^## ', multiLine: true).firstMatch(original.substring(heading.end));
      final sectionEnd = nextHeading == null ? original.length : heading.end + nextHeading.start;
      final section = original.substring(heading.end, sectionEnd);
      final replacement = section.contains(updateLine) ? versionHeading : '$versionHeading$newline$newline$updateLine';
      updated = original.replaceRange(heading.start, heading.end, replacement);
    }
    file.writeAsStringSync(updated);
  }
}

void verify(Directory repository, String version) {
  Version.parse(version);
  for (final entry in packagePubspecs.entries) {
    require(readPubspecVersion(repository, entry.value) == version, '${entry.key} does not have version $version.');
  }
  verifyInternalDependencies(repository, version);

  final androidPlugin = repositoryFile(repository, 'flutter_theoplayer_sdk/flutter_theoplayer_sdk_android/android/build.gradle').readAsStringSync();
  final androidExample = repositoryFile(repository, 'flutter_theoplayer_sdk/flutter_theoplayer_sdk/example/android/app/build.gradle').readAsStringSync();
  require(RegExp("def theoplayerVersion =\\s*'$version'").hasMatch(androidPlugin), 'Android plugin does not use THEOplayer $version.');
  require(RegExp("def theoplayerVersion =\\s*'$version'").hasMatch(androidExample), 'Android example does not use THEOplayer $version.');

  final podspec = repositoryFile(repository, 'flutter_theoplayer_sdk/flutter_theoplayer_sdk_ios/ios/theoplayer_ios.podspec').readAsStringSync();
  require(podspec.contains("s.dependency 'THEOplayerSDK-core', '$version'"), 'iOS core pod does not use THEOplayer $version.');
  require(podspec.contains("s.dependency 'THEOplayer-Integration-THEOlive', '$version'"), 'iOS THEOlive pod does not use $version.');

  final podfileLock = repositoryFile(repository, 'flutter_theoplayer_sdk/flutter_theoplayer_sdk/example/ios/Podfile.lock').readAsStringSync();
  require(podfileLock.contains('THEOplayerSDK-core ($version)'), 'Podfile.lock does not resolve THEOplayerSDK-core $version.');
  require(podfileLock.contains('THEOplayer-Integration-THEOlive ($version)'), 'Podfile.lock does not resolve THEOplayer-Integration-THEOlive $version.');

  final webRuntime = repositoryFile(repository, 'flutter_theoplayer_sdk/flutter_theoplayer_sdk/example/web/theoplayer/theoplayer.d.js').readAsStringSync();
  require(webRuntime.contains('Version: $version'), 'Bundled Web SDK does not report version $version.');

  for (final path in packageChangelogs) {
    final changelog = repositoryFile(repository, path).readAsStringSync();
    require(RegExp('^## ${RegExp.escape(version)}\$', multiLine: true).hasMatch(changelog), '$path has no $version section.');
    require(changelog.contains('* Updated THEOplayer to $version.'), '$path has no native SDK update entry for $version.');
  }

  final webRoot = repositoryFile(repository, 'flutter_theoplayer_sdk/flutter_theoplayer_sdk/example/web');
  const misplacedAssets = <String>[
    'THEOplayer.chromeless.js',
    'THEOplayer.js',
    'THEOplayer.transmux.js',
    'theoplayer.d.js',
    'theoplayer.sw.js',
    'ui.css',
  ];
  for (final asset in misplacedAssets) {
    require(!File('${webRoot.path}/$asset').existsSync(), 'Web SDK asset is misplaced at example/web/$asset.');
  }
  stdout.writeln('Release metadata is consistently set to $version.');
}

void verifyInternalDependencies(Directory repository, String version) {
  for (final entry in platformDependencies.entries) {
    final pubspec = repositoryFile(repository, packagePubspecs[entry.key]!).readAsStringSync();
    for (final dependency in entry.value) {
      final match = RegExp('^  ${RegExp.escape(dependency)}:\\s*(\\S+)\\s*\$', multiLine: true).firstMatch(pubspec);
      require(match != null, '${entry.key} does not declare $dependency.');
      require(match!.group(1) == version, '${entry.key} requires $dependency ${match.group(1)}, expected $version.');
    }
  }
}

String readPubspecVersion(Directory repository, String path) {
  final pubspec = repositoryFile(repository, path).readAsStringSync();
  final matches = RegExp(r'^version:\s*(\S+)\s*$', multiLine: true).allMatches(pubspec).toList();
  require(matches.length == 1, '$path must contain exactly one package version.');
  return matches.single.group(1)!;
}

Future<void> checkCocoaPodsVersion(String package, String version) async {
  final metadata = jsonDecode(await fetchText('https://trunk.cocoapods.org/api/v1/pods/$package'));
  require(metadata is Map<String, dynamic>, 'Unexpected CocoaPods metadata for $package.');
  final versions = metadata['versions'];
  require(versions is List, 'Missing CocoaPods versions for $package.');
  final exists = versions.whereType<Map<String, dynamic>>().any((entry) => entry['name'] == version);
  require(exists, '$package $version is not available on CocoaPods.');
}

Future<String> fetchText(String url) async {
  final client = HttpClient()..userAgent = 'THEOplayer-Flutter-release-preparation';
  try {
    final request = await client.getUrl(Uri.parse(url));
    final response = await request.close();
    final body = await utf8.decoder.bind(response).join();
    require(response.statusCode == HttpStatus.ok, 'Request to $url failed with HTTP ${response.statusCode}.');
    return body;
  } finally {
    client.close(force: true);
  }
}

File repositoryFile(Directory repository, String path) => File('${repository.path}/$path');

void require(bool condition, String message) {
  if (!condition) {
    throw ReleaseException(message);
  }
}

final class Version implements Comparable<Version> {
  Version(this.major, this.minor, this.patch);

  factory Version.parse(String value) {
    if (!stableVersionPattern.hasMatch(value)) {
      throw ReleaseException('Version must use stable numeric SemVer (x.y.z): $value');
    }
    final parts = value.split('.').map(int.parse).toList();
    return Version(parts[0], parts[1], parts[2]);
  }

  final int major;
  final int minor;
  final int patch;

  @override
  int compareTo(Version other) {
    final majorComparison = major.compareTo(other.major);
    if (majorComparison != 0) return majorComparison;
    final minorComparison = minor.compareTo(other.minor);
    if (minorComparison != 0) return minorComparison;
    return patch.compareTo(other.patch);
  }

  bool operator >(Version other) => compareTo(other) > 0;
}

final class Invocation {
  Invocation(this.root, this.command, this.version);

  factory Invocation.parse(List<String> arguments) {
    var root = '.';
    final remaining = [...arguments];
    if (remaining.length >= 2 && remaining.first == '--root') {
      root = remaining[1];
      remaining.removeRange(0, 2);
    }
    if (remaining.length != 2) {
      throw ReleaseException('Usage: dart run scripts/theoplayer_release.dart [--root PATH] <preflight|check-upstream|check-unpublished|update-changelogs|verify> <x.y.z>');
    }
    return Invocation(root, remaining[0], remaining[1]);
  }

  final String root;
  final String command;
  final String version;
}

final class ReleaseException implements Exception {
  ReleaseException(this.message);

  final String message;
}
