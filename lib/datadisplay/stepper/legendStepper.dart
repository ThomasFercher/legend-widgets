import 'package:flutter/material.dart';
import 'package:legend_design_widgets/datadisplay/stepper/legendStepperItem.dart';

class LegendStepper extends StatefulWidget {
  int index;
  final List<LegendStepperItem> stepperItems;
  StepperType? type;
  Function(int, int)? stepState;
  //controlsBuilder isn't adjustable right now 
  Widget Function(BuildContext, ControlsDetails)? controlsBuilder;

  LegendStepper({
    required this.index,
    required this.stepperItems,
    this.type,
    this.stepState,
    this.controlsBuilder,
  });

  @override
  State<LegendStepper> createState() => _LegendStepperState();
}

class _LegendStepperState extends State<LegendStepper> {
  late int legendindex;

  _getType(StepperType? type) {
    if (type == null) {
      type = StepperType.vertical;
      return type;
    } else {
      return type;
    }
  }

  _stepState(int step) {
    if (legendindex > step) {
      return StepState.complete;
    } else {
      return StepState.indexed;
    }
  }

  _getStepStates(int index) {
    if (widget.stepState == null) {
      return _stepState(index);
    } else {
      return widget.stepState!(index, legendindex);
    }
  }

 

  
  List<Step> getSteps() {
    List<Step> steps = [];
    steps = widget.stepperItems
        .map((item) => Step(title: item.title, content: item.content))
        .toList();
    List<Step> legendSteps = [];
    for (var i = 0; i < widget.stepperItems.length; i++) {
      legendSteps.add(Step(
        title: steps[i].title,
        content: steps[i].content,
        state: _getStepStates(i),
        isActive: legendindex == i,
      ));
    }
    return legendSteps;
  }

  @override
  void initState() {
    legendindex = this.widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stepper(
      type: _getType(widget.type),
      
      controlsBuilder: (context, details) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            children: <Widget>[
              ElevatedButton(
                onPressed: details.onStepContinue,
                child: const Text('NEXT'),
              ),
              if (legendindex != 0)
                TextButton(
                  onPressed: details.onStepCancel,
                  child: const Text(
                    'BACK',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
            ],
          ),
        );
      },
 
      currentStep: legendindex,
      onStepCancel: () {
        if (legendindex > 0) {
          setState(() {
            legendindex -= 1;
          });
        }
      },
      onStepContinue: () {
        setState(() {
          if (legendindex < widget.stepperItems.length - 1) {
            legendindex += 1;
          } else {
            legendindex = 0;
          }
        });
      },
      onStepTapped: (int index) {
        setState(() {
          legendindex = index;
        });
      },
      steps: getSteps(),
    );
  }
}
