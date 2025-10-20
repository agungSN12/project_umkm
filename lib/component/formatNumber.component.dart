class FormatNumber {
  String formatIndoPhone(String? number) {
    if (number == null || number.isEmpty) return '-';

    // hapus semua karakter non-digit
    number = number.replaceAll(RegExp(r'\D'), '');

    // ganti 0 diawal menjadi +62
    if (number.startsWith('0')) {
      number = '+62' + number.substring(1);
    }

    // optional: bikin readable dengan spasi atau strip
    if (number.length > 6) {
      // minimal panjang untuk format
      number = number.replaceRange(
        3,
        number.length - 4,
        ' ${number.substring(3, number.length - 4)}-',
      );
    }

    return number;
  }
}
