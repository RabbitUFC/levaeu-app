final RegExp emailValidatorRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

const String nameNullError = "Por favor informe o seu nome completo";
const String collegeEnrollmentNullError = "Por favor informe a sua matrícula";
const String genderNullError = "Por favor informe o seu gênero";
const String districtNullError = "Por favor informe o seu bairro";
const String emailNullError = "Por favor informe o seu e-mail";
const String passwordNullError = "Por favor informe a sua senha";
const String shortPasswordError = "A senha deve conter no mínimo 8 caracteres";
const String matchPasswordError = "As senhas informadas não são iguais";

const String invalidEmailError = "Por favor informe um e-mail válido";
const String acceptTermsError = "Por favor leia e aceite os Termos de uso e Privacidade";

bool isPasswordValid(String? password, [int minLength = 8]) {
  if (password == null || password.isEmpty) {
    return false;
  }

  bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
  bool hasDigits = password.contains(RegExp(r'[0-9]'));
  bool hasLowercase = password.contains(RegExp(r'[a-z]'));
  bool hasSpecialCharacters = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  bool hasMinLength = password.length >= minLength;

  return hasDigits & hasUppercase & hasLowercase & hasSpecialCharacters & hasMinLength;
}