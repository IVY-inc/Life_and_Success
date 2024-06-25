import 'package:flutter/material.dart';

class WeightDecisionCard extends StatefulWidget {
  final String decision;
  final Function() onTap;
  final bool isSelected;
  const WeightDecisionCard(
      {required this.decision, required this.onTap, required this.isSelected});

  @override
  State<WeightDecisionCard> createState() => _WeightDecisionCardState();
}

class _WeightDecisionCardState extends State<WeightDecisionCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.28,
        height: MediaQuery.of(context).size.height * 0.07,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color:
              widget.isSelected ? Colors.green.withOpacity(0.2) : Colors.white,
        ),
        child: Text(
          widget.decision,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: widget.isSelected ? Colors.green : Colors.grey,
          ),
        ),
      ),
    );
  }
}
