import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants/app_images.dart';
import '../utils/extensions/shared_extensions.dart';

class SelectableDropDownComponent extends StatefulWidget {
  const SelectableDropDownComponent({
    Key? key,
    required this.items,
    required this.hintText,
    this.buttonHeight,
    this.buttonWidth,
    this.dropDownHeight,
    this.dropDownWidth,
    this.showLeadingIcon = true,
    this.selectedValue,
  }) : super(key: key);

  final List<DropdownMenuItem<String>>? items;
  final String hintText;
  final double? buttonHeight;
  final double? buttonWidth;
  final double? dropDownHeight;
  final double? dropDownWidth;
  final bool showLeadingIcon;
  final void Function(String)? selectedValue;

  @override
  State<SelectableDropDownComponent> createState() =>
      _SelectableDropDownComponentState();
}

class _SelectableDropDownComponentState
    extends State<SelectableDropDownComponent> {
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        hint: Row(
          children: [
            if (widget.showLeadingIcon)
              SvgPicture.asset(
                AppImages.userSVG,
                fit: BoxFit.scaleDown,
                // ignore: deprecated_member_use
                color: const Color.fromRGBO(108, 106, 106, 1),
              ),
            if (widget.showLeadingIcon)
              SizedBox(
                width: context.width * 0.04,
              ),
            Expanded(
              child: Text(
                widget.hintText,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: const Color.fromRGBO(108, 106, 106, 1),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: widget.items,
        value: selectedValue,
        onChanged: (value) {
          setState(() {
            selectedValue = value as String;
          });
          widget.selectedValue!(value!);
        },
        buttonStyleData: ButtonStyleData(
          height: context.height * 0.068,
          width: double.infinity,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: const Color.fromRGBO(108, 106, 106, 1),
              width: 0.6,
            ),
            color: Colors.white,
          ),
          elevation: 0,
        ),
        style: GoogleFonts.outfit(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Colors.black87,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down_sharp),
          iconSize: 28,
          iconEnabledColor: Color.fromRGBO(122, 122, 122, 1),
          iconDisabledColor: Color.fromRGBO(122, 122, 122, 1),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: context.width * 0.92,
          padding: null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
          ),
          elevation: 1,
          offset: const Offset(0, 0),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all(6),
            thumbVisibility: MaterialStateProperty.all(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
}
