import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kpostal/kpostal.dart';

class RegisterStore extends StatefulWidget {
  const RegisterStore({super.key});
  static const route = '/register-store';

  @override
  State<RegisterStore> createState() => _RegisterStoreState();
}

class _RegisterStoreState extends State<RegisterStore> {
  final _addressTextController = TextEditingController();

  late var formData;
  final List<Map<String, String>> fileList = [];

  var filePaths = [];

  Future<void> uploadFiles() async {
    // file picker를 통해 파일 여러개 선택
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      // allowedExtensions: ['pdf', 'jpg', 'png'],
    );

    if (result != null) {
      filePaths = result.paths; //파일들의 경로 리스트

      // 파일 경로를 통해 formData 생성
      var dio = Dio();

      formData = FormData();
      setState(() {
        for (var i = 0; i < filePaths.length; i++) {
          var file = MultipartFile.fromFileSync(filePaths[i]!);
          fileList.add(
            {
              'file': '${file.filename}',
              'file_size': '${file.length}',
            },
          );
          print('파일 : ${file.filename}');
          print('파일 크기 : ${file.length}');
          formData.files.add(MapEntry('key', file));
        }
      });

      // 업로드 요청
      // final response = await dio.post('/upload', data: formData);
    } else {
      // 아무런 파일도 선택되지 않음.
    }
  }

  Widget buildFileList() {
    if (filePaths.isEmpty) {
      return const Center(
        child: Text('파일을 첨부해주세요'),
      );
    } else {
      return ListView.builder(
        itemCount: fileList.length,
        itemBuilder: (context, index) {
          Map<String, String> map = fileList[index];
          return ListTile(
            title: Text(
              '${map['file']}',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            trailing: Text('${map['file_size']} bytes'),
            onTap: () {
              print(index);
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text('매장 등록'),
            elevation: 10,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: SizedBox(
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          hintText: '업체명을 입력해주세요.',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                            borderSide: BorderSide(
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: SizedBox(
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          hintText: '사업자 등록 번호를 입력해주세요.',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                            borderSide: BorderSide(
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _addressTextController,
                                enabled: false,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                  hintText: '업체 주소를 검색해주세요.',
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.01,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                print('searchButton Clicked');
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return KpostalView(
                                        callback: (Kpostal result) {
                                          _addressTextController.text =
                                              result.address;
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                              ),
                              child: const Text(
                                '검색',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              hintText: '상세 주소를 입력해주세요.',
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                                borderSide: BorderSide(
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          '사업자 등록증을 첨부해주세요(PDF, JPG, PNG)',
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _fileInput(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: ElevatedButton(
                            onPressed: () {
                              print('매장 등록');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                            ),
                            child: const Text(
                              '등록하기',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row _fileInput() {
    return Row(
      children: [
        Container(
          height: 30,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextButton(
            onPressed: () {
              uploadFiles();
            },
            child: const Text(
              '파일선택',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 60,
            width: 200,
            child: buildFileList(),
          ),
        ),
      ],
    );
  }
}