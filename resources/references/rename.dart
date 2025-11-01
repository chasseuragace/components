import 'dart:io';

void main(List<String> args) async {
  // Default directory or use the one provided as argument
  final rootDir = args.isNotEmpty
      ? args[0]
      : '/Users/code_shared/portal/agency_research/code/variant_dashboard/lib/app/udaan_saarathi/features';

  print('Starting scan in directory: $rootDir');
  await processDirectory(Directory(rootDir));
  print('Scan complete!');
}

Future<void> processDirectory(Directory directory) async {
  try {
    await for (final entity in directory.list(recursive: true)) {
     
      if (entity is File && entity.path.endsWith('.dart')) {
        await processFile(entity);
      }
      else if(entity is Directory){
        await  processDirectory(entity);
      }
      else {
        print("skipping");
      }
    }
  } catch (e) {
    print('Error processing directory: ${directory.path}\nError: $e');
  }
}

Future<void> processFile(File file) async {
  try {
    String content = await file.readAsString();
    bool hasChanges = false;
    final lines = content.split('\n');
    final newLines = <String>[];

    for (var line in lines) {
      if (line.trim().startsWith('import')) {
        // Check if import statement contains uppercase letters
        final originalLine = line;
        // Convert the path part to lowercase
        final pattern = RegExp("'([^']+)'|\"([^\"]+)\"");
        
        line = line.replaceAllMapped(pattern, (match) {
          final path = match.group(1) ?? match.group(2) ?? '';
          if (path.contains(RegExp('[A-Z]'))) {
            return line.contains("'")
                ? "'${path.toLowerCase()}'"
                : '"${path.toLowerCase()}"';
          }
          return match.group(0)!;
        });

        if (originalLine != line) {
          hasChanges = true;
          print('In ${file.path}:');
          print('  Original: $originalLine');
          print('  Modified: $line');
        }
      }
      newLines.add(line);
    }

    if (hasChanges) {
      await file.writeAsString(newLines.join('\n'));
      print('Updated file: ${file.path}');
    }
  } catch (e) {
    print('Error processing file: ${file.path}\nError: $e');
  }
}
