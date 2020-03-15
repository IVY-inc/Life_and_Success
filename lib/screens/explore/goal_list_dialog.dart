import 'package:flutter/material.dart';
import '../../models/constants.dart';
import 'package:provider/provider.dart';
import '../../providers/goal.dart';

class GoalListDialog extends StatelessWidget {
  final GoalType type;
  GoalListDialog({@required this.type});
  addNewGoal({@required Goal provider,@required BuildContext context}){
    showModalBottomSheet(context:context, builder: (ctx)=>NewGoalBottomSheet());
  }
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Goal>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
            '${type == GoalType.Long ? 'LIFETIME GOALS' : 'INSTANT GOALS'}'),
        actions: <Widget>[
          FlatButton(
            padding: EdgeInsets.all(0),
            child: Text(
              'NEW GOAL',
            ),
            onPressed: ()=>addNewGoal(provider:provider,context: context),
          )
        ],
      ),
      body: FutureBuilder<bool>(
          future: type == GoalType.Long
              ? provider.fetchLongGoals()
              : provider.fetchShortGoals(),
          builder: (ctx, snapshot) {
            if (snapshot.hasError || snapshot?.data == false)
              return Center(child: Text('Error displaying goals..'));
            else if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            return Consumer<Goal>(builder: (ctxt, goal, ch) => Container());
          }),
    );
  }
}
class NewGoalBottomSheet extends StatefulWidget {
  @override
  _NewGoalBottomSheetState createState() => _NewGoalBottomSheetState();
}

class _NewGoalBottomSheetState extends State<NewGoalBottomSheet> {
  TextEditingController titleController;
  TextEditingController descriptionController;
  final formKey = GlobalKey<FormState>();
  @override
  void initState(){
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: <Widget>[
          TextFormField(),
          TextFormField(),
          Row(children: [Expanded(child: TextFormField()),Icon(Icons.calendar_today),])
        ],),
      ),
    );
  }
}
