class FromValidator{

  static String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) return "*Required";
    if (!value.isValidEmail()) return "Invalid Email ID";
    return null;
  }

  static String? phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) return "*Required";
    if (value.length < 14) {
      return "Length should be ${14 - 4}";
    }
    if (!value.isValidPhone()) return "Invalid Phone Number";
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.trim().isEmpty) return "*Required";
    if (!value.isValidPassword()) return "Password must contain at least 8 characters.";
    return null;
  }

  static String? validateEmail({required String? value, String label = "Email", bool isRequired = true}){
    RegExp regex = RegExp(r"^[\w\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if(value?.isEmpty == true){
      return "$label can't be empty";
    }else if(!regex.hasMatch(value ?? "")){
      return "Please enter a valid $label";
    } else {
      return null;
    }
  }

  String? validateName({required String? value,
    required String label,
    bool isRequired = true,
    int minLength = 2,
    int maxLength = 30}) {
    if (value?.isEmpty == true) {
      if (isRequired) {
        return "$label can't be empty";
      } else {
        return null;
      }
    } else if (value!.length < minLength) {
      return "$label length can't be less than $minLength";
    } else if (value.length > maxLength) {
      return "$label length can't be greater than $maxLength";
    } else {
      return null;
    }
  }

  String? validatePhoneNumber({String? value,
    String label = "Phone number",
    bool isRequired = true,
    int minLength = 10}) {
    if (value?.isEmpty == true) {
      if (isRequired) {
        return "$label can't be empty";
      } else {
        return null;
      }
    } else if (value!.length < 10) {
      return "$label length can't be less than $minLength";
    } else {
      return null;
    }
  }

  String? validatePassword({
    String? value,
    String label = "Password",
    bool isRequired = true,
    int minLength = 6,
    int maxLength = 15,
  }) {
    RegExp passwordRegex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{6,15}$');



    if (value?.isEmpty == true) {
      if (isRequired) {
        return "$label can't be empty";
      } else {
        return null;
      }
    } else if (value!.length < minLength) {
      return "$label length can't be less than $minLength";
    } else if (value.length > maxLength) {
      return "$label length can't be greater than $maxLength";
    } else if (!passwordRegex.hasMatch(value ?? "")) {
      return "$label must contain at least uppercase letter, lowercase letter, special character, and number";
    } else {
      return "";
    }
  }

  static String? validateConfirmPassword({
    required String value,
    required String passwordValue,
    String label = "Password",
    bool isRequired = true,
  }) {
    if (value.isEmpty == true) {
      if (isRequired) {
        return "$label can't be empty";
      } else {
        return null;
      }
    } else if (value != passwordValue) {
      return "The passwords do not match. Please try again.";
    } else {
      return "";
    }
  }


  String? validateLoginPassword({
    String? value,
    String label = "Password",
    int minLength = 6,
    int maxLength = 15,
  }) {
    if (value?.isEmpty == true) {
      return "$label can't be empty";
    } else if (value!.length < minLength) {
      return "$label length can't be less than $minLength";
    } else {
      return null;
    }
  }
}

extension Validator on String {
  bool isValidEmail() {
    if (trim().isEmpty) {
      return false;
    }
    RegExp exp = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    bool result = exp.hasMatch(trim());
    return result;
  }

  bool isValidPassword() {
    if (trim().isEmpty) {
      return false;
    }
    RegExp exp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    bool result = exp.hasMatch(trim());
    return result;
  }

  bool isValidPhone() {
    if (trim().isEmpty) {
      return false;
    }
    RegExp exp = RegExp(r"\([2-9]\d{2}\)\s\d{3}-\d{4}");
    bool result = exp.hasMatch(trim());
    return result;
  }
}