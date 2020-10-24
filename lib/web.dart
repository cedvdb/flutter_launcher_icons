import 'dart:io';
import 'package:image/image.dart';
import 'package:flutter_launcher_icons/constants.dart' as constants;
import 'utils.dart';

class WebIconTemplate {
  WebIconTemplate({this.size, this.name, this.location=constants.webIconLocation});

  final String name;
  final int size;
  final String location;

  Image createFrom(Image image) {
    return createResizedImage(size, image);
  }

  void updateFile(Image image) {
    final Image newLauncher = createFrom(image);

    File(location + name).writeAsBytesSync(encodePng(newLauncher));
  }
}

List<WebIconTemplate> webIcons = <WebIconTemplate>[
  WebIconTemplate(name: 'Icon-192.png', size: 192), // Note: iOS Safari Web Apps seems
  WebIconTemplate(name: 'Icon-512.png', size: 512), // to require images of specific sizes,
  WebIconTemplate(name: 'favicon.png', size: 16,    // so these images will be stretched,
      location: constants.webFaviconLocation),      // unless already squares.
];

void createIcons(Map<String, dynamic> config) {
  final String filePath = config['image_path_web'] ?? config['image_path'];
  final Image image = decodeImage(File(filePath).readAsBytesSync());
  final dynamic webConfig = config['web'];

  // If a String is given, the user wants to be able to revert
  //to the previous icon set. Back up the previous set.
  if (webConfig is String) {
    // As there is only one favicon, fail. Request that the user
    //manually backup requested icons.
    print (constants.errorWebCustomLocationNotSupported);
  } else {
    print ('Overwriting web favicon and launcher icons...');
    
    for (WebIconTemplate template in webIcons) {
      overwriteDefaultIcon(template, image);
    }
  }
}

void overwriteDefaultIcon(WebIconTemplate template, Image image) {
  template.updateFile(image);
}