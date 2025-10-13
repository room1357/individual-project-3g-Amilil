// lib/utils/validators.dart

class Validators {
  /// Validasi nama lengkap (tidak boleh kosong dan minimal 3 huruf)
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama lengkap tidak boleh kosong';
    } else if (value.trim().length < 3) {
      return 'Nama lengkap terlalu pendek';
    }
    return null;
  }

  /// Validasi email (harus ada @ dan domain)
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  /// Validasi username (tidak boleh kosong dan minimal 4 karakter)
  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username tidak boleh kosong';
    } else if (value.trim().length < 4) {
      return 'Username minimal 4 karakter';
    }
    return null;
  }

  /// Validasi password (minimal 6 karakter)
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    } else if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  /// Validasi konfirmasi password (harus sama dengan password)
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    } else if (value != password) {
      return 'Password tidak cocok';
    }
    return null;
  }
}
