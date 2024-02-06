import 'package:flutter/material.dart';
import 'package:usms_app/services/user_service.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key, required this.flagId});
  final int flagId;
  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  final UserService userService = UserService();

  String _authenticationMethod = "";
  String _code = "";
  bool methodState = true;

  bool phoneVerfication = false;
  bool emailVerification = false;
  final _phoneFormKey = GlobalKey<FormState>();
  final _emailFormKey = GlobalKey<FormState>();

  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
          title: const Text('본인 인증'),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TabBar(
              onTap: (value) {
                FocusScope.of(context).unfocus();
                setState(() {
                  phoneVerfication = false;
                  emailVerification = false;
                  methodState = !methodState;
                });
              },
              controller: _tabController,
              indicatorColor: Colors.blueAccent,
              labelColor: Colors.blueAccent,
              unselectedLabelColor: Colors.black54,
              tabs: const <Widget>[
                Tab(
                  text: "휴대폰 인증",
                ),
                Tab(
                  text: "이메일 인증",
                ),
              ],
            ),
            Container(
              height: 400,
              margin: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 50,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _textForm(
                      '휴대폰 번호',
                      TextInputType.number,
                      1,
                      phoneVerfication,
                      _phoneFormKey,
                      (value) {
                        setState(() {
                          phoneVerfication = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    width: 400,
                    margin: const EdgeInsets.symmetric(
                      vertical: 50,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: _textForm(
                      '이메일 주소',
                      TextInputType.emailAddress,
                      0,
                      emailVerification,
                      _emailFormKey,
                      (value) {
                        setState(() {
                          emailVerification = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textForm(
    String labelText,
    TextInputType type,
    int code,
    bool verification,
    GlobalKey<FormState> formKey,
    Function(bool) updateVerification,
  ) {
    GlobalKey<FormState> codeForm = GlobalKey<FormState>();
    return Column(
      children: [
        Form(
          key: formKey,
          child: SizedBox(
            height: 70,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    maxLength: 25,
                    keyboardType: type,
                    decoration: InputDecoration(
                      counterText: '',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                      labelText: labelText,
                      floatingLabelStyle: const TextStyle(
                        color: Colors.blueAccent,
                      ),
                      helperText: '',
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '입력값이 없습니다.';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _authenticationMethod = newValue!;
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      formKey.currentState!.save();
                      if (await userService.getVerificationNumber(
                        code: code,
                        value: _authenticationMethod,
                        context: context,
                      )) {
                        _focusNode.requestFocus();
                        updateVerification(true);
                      }
                    }
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    fixedSize:
                        const MaterialStatePropertyAll(Size.fromHeight(44)),
                    side: MaterialStateProperty.all(
                      const BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: Text(
                    '인증번호 받기',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        verification
            ? Form(
                key: codeForm,
                child: SizedBox(
                  height: 70,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _focusNode,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                            ),
                            hintText: '인증번호 입력',
                            helperText: '',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '입력값이 없습니다.';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _code = newValue!;
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (codeForm.currentState?.validate() ?? false) {
                            codeForm.currentState!.save();
                            userService.requestVerification(
                              context: context,
                              data: _authenticationMethod,
                              type: methodState,
                              routeCode: true,
                              code: _code,
                              flagId: widget.flagId,
                            );
                          }
                        },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          fixedSize: const MaterialStatePropertyAll(
                              Size.fromHeight(44)),
                          side: MaterialStateProperty.all(
                            const BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: Text(
                          '인증',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
