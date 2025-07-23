
// DropDown Botton
// DropdownButtonFormField<String>(
//                           hint: Row(
//                             children: [
//                               Icon(Icons.location_searching_rounded),
//                               SizedBox(width: 15),
//                               Text("Select", style: smallTextStyle),
//                             ],
//                           ),
//                           value: selectedLewayaName,
//                           items:
//                               lewayaList.map((lewaya) {
//                                 return DropdownMenuItem<String>(
//                                   value: lewaya['name'],
//                                   child: Text(lewaya['name']),
//                                 );
//                               }).toList(),
//                           onChanged: (val) {
//                             setState(() {
//                               selectedLewayaName = val;
//                               selectedLId =
//                                   lewayaList.firstWhere(
//                                     (e) => e['name'] == val,
//                                   )['L_ID'];
//                             });
//                           },
//                           dropdownColor: greyColor,
//                           style: smallTextStyle,
//                           decoration: _inputDecoration(''),
//                         ),