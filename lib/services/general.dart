import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class GeneralService {
  uploadToSignedUrl({required XFile file, required String signedUrl, required String imageType}) async {
    List<int> content = await file.readAsBytes();

    var streamed = http.StreamedRequest("PUT", Uri.parse(signedUrl));
    streamed.headers["Content-Type"] = imageType;
    streamed.headers["Content-Length"] = "${content.length}";
    streamed.sink.add(content);
    streamed.sink.close();

    await streamed.send();
  }
}