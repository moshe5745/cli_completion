import 'package:cli_completion/cli_completion.dart';
import 'package:cli_completion/installer.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockLogger extends Mock implements Logger {}

class _MockCompletionInstallation extends Mock
    implements CompletionInstallation {}

class _TestCompletionCommandRunner extends CompletionCommandRunner<int> {
  _TestCompletionCommandRunner() : super('test', 'Test command runner');

  @override
  // Override acceptable for test files
  // ignore: overridden_fields
  final Logger completionInstallationLogger = _MockLogger();

  @override
  final CompletionInstallation completionInstallation =
      _MockCompletionInstallation();
}

void main() {
  group('InstallCompletionFilesCommand', () {
    late _TestCompletionCommandRunner commandRunner;

    setUp(() {
      commandRunner = _TestCompletionCommandRunner();
    });

    test('can be instantiated', () {
      expect(InstallCompletionFilesCommand<int>(), isNotNull);
    });

    test('is hidden', () {
      expect(InstallCompletionFilesCommand<int>().hidden, isTrue);
    });

    test('description', () {
      expect(
        InstallCompletionFilesCommand<int>().description,
        'Manually installs completion files for the current shell.',
      );
    });

    group('install completion files', () {
      test('forces install', () async {
        await commandRunner.run(['install-completion-files']);

        verify(
          () => commandRunner.completionInstallation
              .install(commandRunner.executableName, force: true),
        ).called(1);
      });

      test('when normal', () async {
        await commandRunner.run(['install-completion-files']);

        verify(
          () => commandRunner.completionInstallationLogger.level = Level.info,
        ).called(1);
      });

      test('when verbose', () async {
        await commandRunner.run(['install-completion-files', '--verbose']);

        verify(
          () {
            return commandRunner.completionInstallationLogger.level =
                Level.verbose;
          },
        ).called(1);
      });
    });
  });
}
