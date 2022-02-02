import 'package:intl/intl.dart';

final dateFormat = DateFormat('dd/MM/yyyy - HH:mm');

bool isImage(String imageType) {
  return imageType.startsWith('image/');
}

extension StringExtension on String {
  String truncateTo(int maxLength) {
    return length <= maxLength
      ? this
      : '${substring(0, maxLength)}...';
  }

  String removeLineBreaks() {
    return replaceAll('\n', ' ').trim();
  }

  String removeLeadingSpaces() {
    return replaceAll(RegExp(' +'), ' ');
  }

  String teamShortName() {
    return replaceAll(' ', '').substring(0, 3).toUpperCase();
  }

  String cleanPhoneNumber() {
    return '+55${replaceAll(RegExp('[^0-9]'), "").split(" ").join("")}';
  }
}

extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = Set();
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}
