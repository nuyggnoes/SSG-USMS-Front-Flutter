import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kpostal/kpostal.dart';
import 'package:usms_app/widget/custom_textFormField.dart';

class RegisterStore extends StatefulWidget {
  const RegisterStore({super.key});
  static const route = '/register-store';

  @override
  State<RegisterStore> createState() => _RegisterStoreState();
}

class _RegisterStoreState extends State<RegisterStore> {
  final _formKey = GlobalKey<FormState>();

  final _storeNameController = TextEditingController();
  final _storeNumController1 = TextEditingController();
  final _storeNumController2 = TextEditingController();
  final _storeNumController3 = TextEditingController();
  final _addressTextController = TextEditingController();
  final _detailAddressController = TextEditingController();

  final _focusNode1 = FocusNode();
  final _focusNode2 = FocusNode();

  final formData = FormData();
  final List<Map<String, String>> fileList = [];

  var filePaths = [];

  Future<void> uploadFiles() async {
    // file picker를 통해 파일 여러개 선택
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      filePaths = result.paths; //파일들의 경로 리스트

      // 파일 경로를 통해 formData 생성

      // formData = FormData();
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
      // formData.fields.addAll([
      //   MapEntry('storeName', _storeNameController.text),
      //   MapEntry('businessLicenseCode',
      //       '${_storeNumController1.text}-${_storeNumController2.text}-${_storeNumController3.text}'),
      //   MapEntry('storeAddress',
      //       '${_addressTextController.text} ${_detailAddressController.text}'),
      // ]);

      // 업로드 요청
    } else {
      // 아무런 파일도 선택되지 않음.
    }
  }

  Widget buildFileList() {
    if (filePaths.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        alignment: Alignment.center,
        child: const Text('파일을 첨부해주세요'),
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

  requestStore() async {
    print(
        '${_storeNumController1.text}-${_storeNumController2.text}-${_storeNumController3.text}');
    formData.fields.addAll([
      MapEntry('storeName', _storeNameController.text),
      MapEntry('businessLicenseCode',
          '${_storeNumController1.text}-${_storeNumController2.text}-${_storeNumController3.text}'),
      MapEntry('storeAddress',
          '${_addressTextController.text} ${_detailAddressController.text}'),
    ]);
    Response response;
    var baseoptions = BaseOptions(
      headers: {"Content-Type": "multipart/form-data;"},
      baseUrl: "https://usms.serveftp.com",
    );

    Dio dio = Dio(baseoptions);
    // try {
    //   // 업로드 요청
    //   final response = await dio.post('/api/users/1/stores', data: formData);
    //   if (response.statusCode == 200) {
    //     print('====================response 200=====================');
    //   }
    //   // 여기에서 응답 처리 로직 추가
    // } on DioException catch (e) {
    //   if (e.response?.statusCode == 400) {
    //     print("[Error] : [$e]");
    //   }
    // } catch (e) {
    //   print("[Server ERR] : $e");
    // }
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _storeNumController1.dispose();
    _storeNumController2.dispose();
    _storeNumController3.dispose();
    _addressTextController.dispose();
    _detailAddressController.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    super.dispose();
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
            title: const Text(
              '매장 등록',
              style: TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 50, horizontal: 25),
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          CustomTextFormField(
                            textController: _storeNameController,
                            labelText: '업체명을 입력해주세요.',
                            textType: TextInputType.text,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return '업체명을 입력해주세요';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(
                            width: double.infinity,
                            child: Text('사업자 등록 번호 10자리를 입력해주세요.'),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: CustomTextFormField(
                                  maxLength: 3,
                                  onChange: (value) {
                                    if (value.length == 3) {
                                      _focusNode1.requestFocus();
                                    }
                                  },
                                  textController: _storeNumController1,
                                  textType: TextInputType.number,
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return '사업자 등록번호를 입력해주세요';
                                    }
                                    if (value!.length != 3) {
                                      return '3자리의 숫자를 입력해주세요';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Icon(
                                Icons.maximize,
                                color: Color.fromARGB(255, 145, 140, 149),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                flex: 2,
                                child: CustomTextFormField(
                                  onChange: (value) {
                                    if (value.length == 2) {
                                      _focusNode2.requestFocus();
                                    }
                                  },
                                  maxLength: 2,
                                  focusNode: _focusNode1,
                                  textController: _storeNumController2,
                                  textType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return '사업자 등록번호를 입력해주세요';
                                    }
                                    if (value.length != 2) {
                                      return '2자리의 숫자를 입력해주세요';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.maximize,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                flex: 5,
                                child: CustomTextFormField(
                                  focusNode: _focusNode2,
                                  maxLength: 5,
                                  textController: _storeNumController3,
                                  textType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return '사업자 등록번호를 입력해주세요';
                                    }
                                    if (value.length != 5) {
                                      return '5자리의 숫자를 입력해주세요';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    CustomTextFormField(
                                      labelText: '업체 주소를 입력해주세요.',
                                      textController: _addressTextController,
                                      textType: TextInputType.text,
                                      isEnabled: false,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return '업체 주소를 입력해주세요';
                                        }
                                        return null;
                                      },
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        print('icon Clicked');
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
                                      icon: const Icon(Icons.search_rounded),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            labelText: '상세 주소를 입력해주세요.',
                            textController: _detailAddressController,
                            textType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '상세 주소를 입력해주세요';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              requestStore();
                            }
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
        Expanded(
          child: SizedBox(
            height: 60,
            width: 200,
            child: buildFileList(),
          ),
        ),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
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
      ],
    );
  }
}

// class CustomTextFormField extends StatelessWidget {
//   const CustomTextFormField({
//     super.key,
//     required this.textController,
//     required this.textType,
//     required this.validator,
//     this.labelText,
//     this.maxLength,
//     this.focusNode,
//     this.onChange,
//     this.enabled,
//   });

//   final TextEditingController textController;
//   final TextInputType textType;
//   final String? Function(String?) validator;
//   final String? labelText;
//   final int? maxLength;
//   final FocusNode? focusNode;
//   final bool? enabled;
//   final void Function(String)? onChange;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 70,
//       child: TextFormField(
//         enabled: enabled,
//         onChanged: onChange,
//         focusNode: focusNode,
//         maxLength: maxLength,
//         controller: textController,
//         keyboardType: TextInputType.text,
//         decoration: InputDecoration(
//           border: const OutlineInputBorder(
//             borderRadius: BorderRadius.all(
//               Radius.circular(6),
//             ),
//           ),
//           labelText: labelText,
//           floatingLabelStyle: const TextStyle(
//             color: Colors.blueAccent,
//           ),
//           helperText: '',
//           focusedBorder: const OutlineInputBorder(
//             borderRadius: BorderRadius.all(
//               Radius.circular(12),
//             ),
//             borderSide: BorderSide(
//               color: Colors.blueAccent,
//             ),
//           ),
//         ),
//         validator: validator,
//       ),
//     );
//   }
// }
