// import 'package:flutter/material.dart';

// class VertificationTextField extends StatefulWidget {
//   final hintText;
//   final TextInputType textInputType;

//   const VertificationTextField({
//     super.key,
//     required this.hintText,
//     required this.textInputType,
//   });

//   @override
//   State<VertificationTextField> createState() => _CertificationTextFieldState();
// }

// class _CertificationTextFieldState extends State<VertificationTextField> {
//   bool isVerificationVisible = false;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           child: TextFormField(
//             keyboardType: widget.textInputType,
//             decoration: InputDecoration(
//               focusedBorder: const OutlineInputBorder(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(12),
//                   bottomLeft: Radius.circular(12),
//                 ),
//                 borderSide: BorderSide(
//                   color: Colors.blueAccent,
//                 ),
//               ),
//               border: const OutlineInputBorder(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(12),
//                   bottomLeft: Radius.circular(12),
//                 ),
//               ),
//               labelText: '${widget.hintText}',
//               helperText: '',
//             ),
//           ),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             setState(() {
//               print('인증번호받기');
//               isVerificationVisible = true;
//             });
//           },
//           style: ButtonStyle(
//             fixedSize: MaterialStateProperty.all(const Size(130, 44)),
//             shape: MaterialStateProperty.all(
//               const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.zero,
//               ),
//             ),
//           ),
//           child: Text(
//             '인증번호 받기',
//             style: TextStyle(
//               color: Colors.black.withOpacity(0.8),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

class RegisterStoreTextField extends StatelessWidget {
  const RegisterStoreTextField({
    super.key,
    required this.textController,
    required this.textType,
    required this.validator,
    this.labelText,
    this.maxLength,
    this.focusNode,
    this.onChange,
    this.isEnabled,
    this.counterText,
    this.isObcureText,
  });

  final TextEditingController textController;
  final TextInputType textType;
  final String? Function(String?) validator;
  final String? labelText;
  final int? maxLength;
  final FocusNode? focusNode;
  final bool? isEnabled;
  final String? counterText;
  final bool? isObcureText;
  final void Function(String)? onChange;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: TextFormField(
        enabled: isEnabled,
        obscureText: isObcureText ?? false,
        onChanged: onChange,
        focusNode: focusNode,
        maxLength: maxLength,
        controller: textController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(6),
            ),
          ),
          labelText: labelText,
          floatingLabelStyle: const TextStyle(
            color: Colors.black,
          ),
          helperText: '',
          counterText: counterText,
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(6),
            ),
            borderSide: BorderSide(
              color: Colors.blueAccent,
              width: 2,
            ),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
