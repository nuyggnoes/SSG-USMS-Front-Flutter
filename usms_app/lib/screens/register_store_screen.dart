import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kpostal/kpostal.dart';
import 'package:provider/provider.dart';
import 'package:usms_app/services/show_dialog.dart';
import 'package:usms_app/services/store_service.dart';
import 'package:usms_app/utils/user_provider.dart';
import 'package:usms_app/widget/custom_textFormField.dart';

class RegisterStore extends StatefulWidget {
  const RegisterStore({
    super.key,
    required this.uid,
  });

  final int uid;

  @override
  State<RegisterStore> createState() => _RegisterStoreState();
}

class _RegisterStoreState extends State<RegisterStore> {
  final _formKey = GlobalKey<FormState>();
  final StoreService storeService = StoreService();

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
  var filePath;

  void callCustomDialog(String title, String message, Function onPressed) {
    customShowDialog(
      context: context,
      title: title,
      message: message,
      onPressed: () => onPressed(),
    );
  }

  Future<void> uploadFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      int maxSizeInBytes = 125 * 1024 * 1024; // 125MB
      if (result.files.single.size > maxSizeInBytes) {
        callCustomDialog(
          '파일 용량 초과',
          '첨부파일의 최대 크기는 125MB 입니다.',
          () {
            Navigator.pop(context);
          },
        );
      } else {
        filePath = result.files.single.path;

        var file = await MultipartFile.fromFile(filePath!);

        setState(() {
          fileList.add({
            'file': '${file.filename}',
            'file_size': '${file.length}',
          });
        });
        formData.files.add(MapEntry('businessLicenseImg', file));
        formData.fields.addAll([
          MapEntry('storeName', _storeNameController.text),
          MapEntry('businessLicenseCode',
              '${_storeNumController1.text}-${_storeNumController2.text}-${_storeNumController3.text}'),
          MapEntry('storeAddress',
              '${_addressTextController.text} ${_detailAddressController.text}'),
        ]);
      }
    }
  }

  Widget buildFileList() {
    if (filePath == null) {
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
          String fileName;
          if (map['file']!.length > 5) {
            fileName = "${map['file']!.substring(0, 5)} ...";
          } else {
            fileName = map['file']!;
          }

          return ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text('${map['file_size']} bytes'),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  filePath = null;
                  // filePaths.removeAt(index);
                  fileList.removeAt(index);
                });
              },
            ),
          );
        },
      );
    }
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
      home: Scaffold(
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
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                          maxLength: 42,
                          counterText: '',
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
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            await storeService.requestStore(
                                formData: formData,
                                uid: Provider.of<UserProvider>(context,
                                        listen: false)
                                    .user
                                    .id!,
                                context: context);
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
              fileList.isEmpty
                  ? uploadFiles()
                  : customShowDialog(
                      context: context,
                      title: '파일 첨부 오류',
                      message: '첨부파일은 1개만 등록 가능합니다.',
                      onPressed: () {
                        Navigator.pop(context);
                      });
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
