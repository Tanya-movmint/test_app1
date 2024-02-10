
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt_package;


class EncryptData{
//for AES Algorithms

  static encrypt_package.Encrypted? encrypted;
  static var decrypted;
 


 static encryptAES(plainText){
   final key = encrypt_package.Key.fromUtf8('my 32 length key................');
   final iv = encrypt_package.IV.fromLength(16);
   final encrypter = encrypt_package.Encrypter(encrypt_package.AES(key));
    encrypted = encrypter.encrypt(plainText, iv: iv);
   print(encrypted!.base64);
 }

  static decryptAES(plainText){
    final key = encrypt_package.Key.fromUtf8('my 32 length key................');
    final iv = encrypt_package.IV.fromLength(16);
    final encrypter = encrypt_package.Encrypter(encrypt_package.AES(key));
    decrypted = encrypter.decrypt(encrypted!, iv: iv);
    print(decrypted);
  }
}


class Encrypt extends StatefulWidget {

  @override
  _Encrypt createState() => _Encrypt();
}

class _Encrypt extends State<Encrypt> {
  TextEditingController? _controller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: Text("Encrypt and Decrypt Data"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top:10,bottom: 10),
          child: _buildBody(),
        ),
      ),
    );
  }

 Widget _buildBody() {
    return Container(
      height: 280,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 10,right: 10),
      child: Card(
         elevation: 2,
        child:  Container(
          padding: EdgeInsets.only(left: 15,right: 15,top:
15,bottom: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Text',
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text("EncryptText : ${EncryptData.encrypted!=null?EncryptData.encrypted?.base64:''}",
                maxLines: 2,
                style:TextStyle(
                    color: Colors.black,
                    fontSize: 16
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10,),
              Expanded(
                child: Text("DecryptText : ${EncryptData.decrypted!=null?EncryptData.decrypted:''}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:TextStyle(
                        color: Colors.black,
                        fontSize: 16
                    )
                ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.pink.shade800, // background
                      onPrimary: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        EncryptData.encryptAES(_controller!.text);
                      });
                    },
                    child: Text('Encryption'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.pink.shade800, // background
                      onPrimary: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        EncryptData.decryptAES(_controller!.text);
                      });
                    },
                    child: Text('Decryption'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
 }
}