String simplifyPhoneNumber(String phoneNumber) {
  String simplifiedNumber = phoneNumber.replaceAll(RegExp(r'[\s\-()\.]'), '');
  return simplifiedNumber;
}

void main() {
  String phoneNumber = '+66 90-962-1700';
  String simplifiedNumber = simplifyPhoneNumber(phoneNumber);

  print(simplifiedNumber); // Output: +66909621700
}