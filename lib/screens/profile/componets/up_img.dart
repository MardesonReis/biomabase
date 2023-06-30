import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/fidelimax.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/utils/app_routes.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImageUpload extends StatefulWidget {
  ImageUpload({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ImageUpload();
  }
}

class _ImageUpload extends State<ImageUpload> {
  var uploadimage = null; //variable for choosed file

  Future<void> chooseImage() async {
    var choosedimage =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    //set source: ImageSource.camera to get image from camera
    setState(() {
      uploadimage = choosedimage!;
    });
  }

  Future<void> uploadImage(String cpf) async {
    //show your own loading or progressing code here

    String uploadurl = "http://biotvindoor.com/bioma/imagens/image_upload.php";
    //dont use http://localhost , because emulator don't get that address
    //insted use your local IP address or use live URL
    //hit "ipconfig" in windows or "ip a" in linux to get you local IP

    try {
      Uint8List imageBytes = await uploadimage.readAsBytes();

      String baseimage = await base64Encode(imageBytes);
      //convert file image to Base64 encoding
      var response = await http.post(Uri.parse(uploadurl), body: {
        'image': baseimage,
        'usuario': cpf,
      });
      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body); //decode json data
        if (jsondata["error"]) {
          //check error sent from server
          print(jsondata["msg"]);
          //if error return from server, show message from server
        } else {
          print("Upload successful");
        }
      } else {
        print("Error during connection to server");
        //there is error during connecting to server,
        //status code might be 404 = url not found
      }
    } catch (e) {
      print("Error during converting to Base64" + e.toString());
      //there is error during converting file image to base64 encoding.
    }
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    Fidelimax fidelimax = auth.fidelimax;
    Paginas pages = auth.paginas;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: CustomAppBar('Alterar\n', 'Foto do Perfil', () {
          setState(() {
            pages.selecionarPaginaHome('Especialistas');
          });
        }, []),
      ),
      drawer: AppDrawer(),
      body: Container(
        height: 300,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, //content alignment to center
          children: <Widget>[
            Container(
                //show image here after choosing image
                child: uploadimage == null
                    ? Container(
                        //elese show image here
                        child: Container(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            elevation: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                  radius: 100,
                                  backgroundImage: NetworkImage(
                                      Constants.IMG_USUARIO +
                                          fidelimax.cpf +
                                          '.jpg')),
                              //  Image.file(File(uploadimage.path)),
                            ),
                          ),
                        ),
                      )
                    : //if uploadimage is null then show empty container
                    Container(
                        //elese show image here
                        child: Container(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            elevation: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 100,
                                backgroundImage:
                                    FileImage(File(uploadimage.path)),
                              ),
                              //  Image.file(File(uploadimage.path)),
                            ),
                          ),
                        ),
                      )),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      chooseImage();
                    },
                    child: Row(
                      children: [Icon(Icons.search), Text('Buscar')],
                    )),
                uploadimage != null
                    ? ElevatedButton(
                        onPressed: () {
                          setState(() async {
                            await uploadImage(fidelimax.cpf);

                            pages.selecionarPaginaHome('Meu Perfil');
                            imageCache.clear();
                            Navigator.of(context).pushReplacementNamed(
                              AppRoutes.AUTH_OR_HOME,
                            );
                          });
                        },
                        child: Row(
                          children: [Icon(Icons.upload), Text('Salvar ')],
                        ))
                    : Text(''),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        uploadimage = null;
                        pages.selecionarPaginaHome('Meu Perfil');
                        Navigator.of(context).pushReplacementNamed(
                          AppRoutes.AUTH_OR_HOME,
                        );
                      });
                    },
                    child: Row(
                      children: [Icon(Icons.cancel), Text('Cancelar ')],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  //   super.debugFillProperties(properties);
  //   properties
  //       .add(DiagnosticsProperty<File>('uploadimage', File(uploadimage.path)));
  // }
}
