import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ResumeDetails extends StatefulWidget {
  final String email;
  final bool isEditScreen;
  final String phoneNumber;
  final String docId;
  final String name;
  final String description;
  final String address;
  final String skills;
  final String? education;
  final String? experience;
  final String? position;

  ResumeDetails({
    required this.email,
    required this.isEditScreen,
    required this.phoneNumber,
    required this.docId,
    required this.name,
    required this.description,
    required this.address,
    required this.skills,
    required this.education,
    required this.position,
    required this.experience,
  });

  @override
  _ResumeDetailsState createState() => _ResumeDetailsState();
}

class _ResumeDetailsState extends State<ResumeDetails> {
  List<Widget> _buildFieldCards() {
    return [
      _buildFieldCard('Name', widget.name),
      _buildFieldCard('Description', widget.description),
      _buildFieldCard('Address', widget.address),
      _buildFieldCard('Skills', widget.skills),
      _buildFieldCard('Email', widget.email),
      _buildFieldCard('Phone Number', widget.phoneNumber),
      _buildFieldCard('Education', widget.education ?? ""),
      _buildFieldCard('Position', widget.position ?? " "),
      _buildFieldCard('Experience', widget.experience ?? " "),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resume Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.sp),
        child: SingleChildScrollView(
          child: ReorderableListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: _buildFieldCards().map((widget) {
              return ListTile(
                key: Key(widget.key.toString()),
                contentPadding: EdgeInsets.zero,
                title: widget,
              );
            }).toList(),
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final Widget item = _buildFieldCards().removeAt(oldIndex);
                _buildFieldCards().insert(newIndex, item);
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFieldCard(String label, String value) {
    return Card(
      key: ValueKey(value), // Key for reordering
      elevation: 2.0.sp,
      child: Padding(
        padding: EdgeInsets.all(12.0.sp),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$label: ',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.0.sp),
            Expanded(
              child: Text(
                value,
                style: TextStyle(fontSize: 12.sp),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
