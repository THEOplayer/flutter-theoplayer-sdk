import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:pigeon/pigeon_cl.dart' as pigeon_cl;

Builder mergerBuilder(BuilderOptions options) => MergerBuilder();

class MergerBuilder extends Builder {
  static const String outputFile = 'pigeons/pigeons_merged.dart';

  @override
  Map<String, List<String>> get buildExtensions => const {
    r'$package$': [ outputFile ],
  };

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    print('MergerBuilder - build started');
    StringBuffer output = StringBuffer();

    await appendPigeonConfig(buildStep, output);
    await appendModels(buildStep, output);
    await appendApis(buildStep, output);

    // write to single output file
    await buildStep.writeAsString(AssetId(buildStep.inputId.package, outputFile), output.toString());

    // run pigeon command to generate platform specific files
    print('MergerBuilder - generating pigeons');
    await pigeon_cl.runCommandLine([
      '--input', outputFile
    ]);

    print('MergerBuilder - build completed');
  }

  FutureOr<void> appendPigeonConfig(BuildStep buildStep, StringBuffer output) async {
    var pigeon_config_file = File('pigeons/pigeon_config.dart');
    print('MergerBuilder - reading pigeon config file: ${pigeon_config_file.path}');

    String pigeon_config = await pigeon_config_file.readAsString();
    output.write(pigeon_config);
    output.writeln();
  }

  FutureOr<void> appendModels(BuildStep buildStep, StringBuffer output) async {
    var models = await buildStep.findAssets(new Glob('pigeons/models/*.dart'));

    await for (final model in models) {
      print('MergerBuilder - reading model file: ${model.path}');

      String model_content = await File(model.path).readAsString();
      output.write(model_content);
      output.writeln();
    }
  }

  FutureOr<void> appendApis(BuildStep buildStep, StringBuffer output) async {
    var apis = await buildStep.findAssets(new Glob('pigeons/apis/*.dart'));

    await for (final api in apis) {
      print('MergerBuilder - reading api file: ${api.path}');

      String api_content = await File(api.path).readAsString();

      // remove: import 'package:pigeon/pigeon.dart';
      api_content = api_content.replaceAll("import 'package:pigeon/pigeon.dart';", "");

      // remove: import '../models/models.dart';
      api_content = api_content.replaceAll(RegExp(r'.*/models/.*\n'), "");

      output.write(api_content);
      output.writeln();
    }
  }
}
