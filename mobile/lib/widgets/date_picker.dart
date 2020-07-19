import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:mobile/utils/index.dart';
import 'package:mobile/widgets/info_item.dart';

class MyDatePicker extends StatefulWidget {
  MyDatePicker(
      {Key key,
      this.value,
      this.initialDate,
      this.onChange,
      this.label = "Label",
      this.disableChange = false})
      : super(key: key);
  final String value;
  final String label;
  final String initialDate;
  final Function onChange;
  final bool disableChange;
  @override
  _MyDatePickerState createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<MyDatePicker> {
  @override
  Widget build(BuildContext context) {
    return widget.disableChange
        ? Info(
            label: widget.label,
            content: formatDateStringWithFormat(d: widget.value),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.label + ":"),
              FlatButton(
                child: Text(formatDateStringWithFormat(d: widget.value) ??
                    "Choose ${widget.label} date"),
                onPressed: () async {
                  var datePicked = await DatePicker.showSimpleDatePicker(
                    context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2050),
                    dateFormat: "dd-MMMM-yyyy",
                    locale: DateTimePickerLocale.en_us,
                    looping: true,
                  );
                  if (widget.onChange != null && datePicked != null) {
                    widget.onChange(datePicked);
                  }

                  final snackBar = SnackBar(
                      content: Text("Date Picked ${datePicked.toString()}"));
                  Scaffold.of(context).showSnackBar(snackBar);
                },
              ),
            ],
          );
  }
}
