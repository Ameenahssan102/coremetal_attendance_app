part of 'values.dart';

class TextStyles {
  static TextStyle custom({
    double textSize = Sizes.TEXT_SIZE_16,
    Color color = AppColors.white,
  }) {
    return GoogleFonts.roboto(
      fontSize: textSize,
      color: color,
      fontStyle: FontStyle.normal,
    );
  }

  static TextStyle textField1() {
    return GoogleFonts.roboto(
      fontSize: Sizes.TEXT_SIZE_20,
      color: AppColors.white,
      fontStyle: FontStyle.normal,
    );
  }

  static TextStyle white_16() {
    return GoogleFonts.roboto(
      fontSize: Sizes.TEXT_SIZE_16,
      color: AppColors.white,
      fontStyle: FontStyle.normal,
    );
  }

  static TextStyle white_18() {
    return GoogleFonts.roboto(
      fontSize: Sizes.TEXT_SIZE_18,
      color: AppColors.white,
      fontStyle: FontStyle.normal,
    );
  }

  static TextStyle white_18_700() {
    return GoogleFonts.roboto(
      fontSize: Sizes.TEXT_SIZE_18,
      color: AppColors.white,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
    );
  }

  static TextStyle white_20_700() {
    return GoogleFonts.roboto(
      fontSize: Sizes.TEXT_SIZE_20,
      color: AppColors.white,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
    );
  }

  static TextStyle white_22_700() {
    return GoogleFonts.roboto(
      fontSize: Sizes.TEXT_SIZE_22,
      color: AppColors.white,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
    );
  }

  static TextStyle white_24_700() {
    return GoogleFonts.roboto(
      fontSize: Sizes.TEXT_SIZE_24,
      color: AppColors.white,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
    );
  }

  static TextStyle black_18() {
    return GoogleFonts.roboto(
      fontSize: Sizes.TEXT_SIZE_18,
      color: AppColors.black,
      fontStyle: FontStyle.normal,
    );
  }

  static TextStyle black_18_500() {
    return GoogleFonts.roboto(
      fontSize: Sizes.TEXT_SIZE_18,
      color: AppColors.black,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
    );
  }

  static TextStyle black_20_700() {
    return GoogleFonts.roboto(
      fontSize: Sizes.TEXT_SIZE_20,
      color: AppColors.black,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
    );
  }

  static TextStyle hint_18() {
    return GoogleFonts.roboto(
      fontSize: Sizes.TEXT_SIZE_18,
      color: AppColors.hint,
      fontStyle: FontStyle.normal,
    );
  }
}
