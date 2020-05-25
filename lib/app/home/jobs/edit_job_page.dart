import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/common_widgets/platform_alert_dialog.dart';
import 'package:time_tracker/app/common_widgets/platform_exception.dart';
import 'package:time_tracker/app/home/models/jobs.dart';

import 'package:time_tracker/servises/database.dart';
import 'package:flutter/services.dart';
class EditJobPage extends StatefulWidget {
  const EditJobPage({Key key, @required this.database, this.job}) : super(key: key);
  final Database database;
  final Job job;


  static Future<void> show(BuildContext context, {Database database, Job job}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
          builder: (context) => EditJobPage(database: database,job: job,), fullscreenDialog: true),
    );
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  int _ratePerHour;


  @override
  void initState() {
    super.initState();
    if(widget.job != null) {
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
    }
  }

  bool _validateAndSaveForm(){
    final form = _formKey.currentState;
    if (form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm())
    try{
      final job = await widget.database.jobsStream().first;
      final allNames = job.map((job) => job.name).toList();
      if(widget.job != null) {
        allNames.remove(widget.job.name); 
      }
      if (allNames.contains(_name)){
        PlatformAlertDialog(
          title: 'Name already in use',
          content: 'Please chose a different name',
          defaultActionText: 'OK',
        ).show(context);
      }else {
        final id  = widget.job?.id ?? documentIdFromCurrentDate();
        final job = Job(id: id, name: _name, ratePerHour: _ratePerHour);
        await widget.database.setJob(job);
        Navigator.of(context).pop();
      }
    }
    on PlatformException catch(e){
      PlatformExceptionAlertDialog(
        title: "failed",
        exception: e,
      ).show(context);
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job == null ? "New Job" : "Edit job"),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Save",
              style: TextStyle(
                color: Colors.white
              ),
            ),
            onPressed: _submit,
          )
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            initialValue: _name,
            onSaved: (value) => _name = value,
            validator: (value) => value.isNotEmpty ? null : "name cannot be empty",
            decoration: InputDecoration(
              labelText: "Job Name",
            ),
          ),
          TextFormField(
            initialValue: _ratePerHour != null ? "$_ratePerHour" : null ,
            decoration: InputDecoration(
              labelText: "Rate Per Hour",
            ),
            keyboardType: TextInputType.numberWithOptions(
              signed: false,
              decimal: false,
            ),
            onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
          ),
        ],
      ),
    );
  }
}
