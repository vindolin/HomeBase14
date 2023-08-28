// import 'package:flutter/material.dart';

// Future<bool> confirm(
//   BuildContext context, {
//   Widget? title,
//   Widget? content,
//   Widget? textOK,
//   Widget? textCancel,
// }) async {
//   final bool? isConfirm = await showDialog<bool>(
//     context: context,
//     builder: (_) => WillPopScope(
//       child: AlertDialog(
//         title: title,
//         content: content ?? const Text('Are you sure continue?'),
//         actions: <Widget>[
//           TextButton(
//             child: textCancel ?? const Text('Cancel'),
//             onPressed: () => Navigator.pop(context, false),
//           ),
//           TextButton(
//             child: textOK ?? const Text('OK'),
//             onPressed: () => Navigator.pop(context, true),
//           ),
//         ],
//       ),
//       onWillPop: () async {
//         Navigator.pop(context, false);
//         return true;
//       },
//     ),
//   );

//   return isConfirm ?? false;
// }
