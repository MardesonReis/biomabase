import 'package:pdf/widgets.dart' as pdf;
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class ImageToPdfConverter {
  static Future<pdf.Image> getImageFromUrl(String imageUrl) async {
    final http.Response response = await http.get(Uri.parse(imageUrl));
    final Uint8List bytes = response.bodyBytes;
    final pdf.ImageProvider imageProvider = pdf.MemoryImage(bytes);
    final pdf.Image pdfImage = pdf.Image(imageProvider,
        height: 40, width: 40, fit: pdf.BoxFit.contain);
    return pdfImage;
  }
}
