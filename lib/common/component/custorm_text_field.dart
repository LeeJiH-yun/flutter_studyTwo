import 'package:flutter/material.dart';
import 'package:flutter_studytwo/common/const/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintTxt;
  final String? errorTxt;
  final bool obscureTxt;
  final bool autofocus;
  final ValueChanged<String>? onChanged;

  const CustomTextFormField({
    this.hintTxt,
    this.errorTxt,
    this.obscureTxt = false,
    this.autofocus = false,
    required this.onChanged,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: INPUT_BORDER_COLOR,
        width: 1.0
      )
    );

    return TextFormField(
      cursorColor: PRIMARY_COLOR,
      obscureText: obscureTxt, //비밀번호 입력할 때 글자 가려지기
      autofocus: autofocus, //포커스가 자동으로 넣어줄 것인지
      onChanged: onChanged, //값이 바뀔 때마다 실행 되는 콜백
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(20),
        hintText: hintTxt,
        errorText: errorTxt,
        hintStyle: TextStyle(
          color: BODY_TEXT_COLOR,
          fontSize: 14.0
        ),
        fillColor: INPUT_BG_COLOR,
        filled: true, //false - 배경색 없음 , true - 배경색 있음
        border: baseBorder, //모든 input 상태의 기본 스타일 세팅
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith( //포커스 상태가 된 보더를 값 변경
          //baseBorder의 값을 유지한 채로 boderSide만 변경한다. .copyWith
          borderSide: baseBorder.borderSide.copyWith(
            //baseBorder의 borderSide에서 색상만 변경해서 넣겠다.
            color: PRIMARY_COLOR
          )
        ),
      ),
    );
  }
}
