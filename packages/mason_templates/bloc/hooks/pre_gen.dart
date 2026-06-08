import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) {
  try {
    // if (!isCalledFromParent) {
    //   validateName(
    //     context,
    //     defaultValue: 'counter',
    //     label: 'What is the bloc name? (e.g. auth, home, profile)',
    //     hint: 'without bloc/cubit suffix',
    //   );
    // }

    // resolveOutputDir(context);
    // _resolveBlocType(context);
    // resolveBuildRunner(context);

    // // Semua vars sudah terset, baru parse config
    // final config = BlocConfig.fromContext(context);
    // final folderPath = '${config.outputDir}/${config.name}_${config.blocType}';

    // checkExistingFolder(context, folderPath: folderPath);
    context.logger.info('TESTING');
  } catch (e) {
    context.logger.err('Generation Aborted! $e');
    exit(1);
  }
}
