import 'package:file_picker/file_picker.dart';



void OpenFileDialog() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: true,
    type: FileType.custom,
    allowedExtensions: ["pdf", "txt"]
  );

  if(result == null) return;

  List<PlatformFile> files = result.files;
  for(PlatformFile file in files){
    print(file.path);
  }

}
