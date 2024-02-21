import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:interview_resume_builder/model.dart';
import 'package:sizer/sizer.dart';

class ResumeForm extends StatefulWidget {
  bool isEditScreen;
  final ResumeItem? resumeItem;
  final String? docId;
  final String? title;
  final String? description;
  final String? address;
  final String? skills;
  final String? email;
  final String? phoneNumber;
  final String? edutcation;
  final String? experiance;
  final String? position;

  ResumeForm({
    this.docId,
    this.email,
    this.phoneNumber,
    this.isEditScreen = false,
    this.title,
    this.description,
    this.address,
    this.skills,
    this.resumeItem,
    this.position,
    this.edutcation,
    this.experiance,
  });

  @override
  _ResumeFormState createState() => _ResumeFormState();
}

class _ResumeFormState extends State<ResumeForm> {
  TextEditingController? titleController;
  TextEditingController? emailController;
  TextEditingController? phoneController;
  TextEditingController? addressController;
  TextEditingController? descriptionController;
  TextEditingController? skillsController;
  TextEditingController? positionController;
  TextEditingController? educationController;
  TextEditingController? experienceController;

  @override
  void initState() {
    super.initState();
    initilizeController();
  }

  void initilizeController() {
    skillsController = TextEditingController(text: widget.skills);
    titleController = TextEditingController(text: widget.title);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.phoneNumber);
    addressController = TextEditingController(text: widget.address);
    descriptionController = TextEditingController(text: widget.description);
    positionController = TextEditingController(text: widget.position);
    educationController = TextEditingController(text: widget.edutcation);
    experienceController = TextEditingController(text: widget.experiance);
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.isEditScreen == false ? 'Create Resume' : 'Edit Resume'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.all(9.0.sp),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: positionController,
                    decoration: InputDecoration(labelText: 'Position'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please describe your position';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: educationController,
                    decoration: InputDecoration(labelText: 'Education'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tell us about your education';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (value.length < 10 || value.length > 10) {
                        return 'Phone number must be 10 digits long';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(labelText: 'Address'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: experienceController,
                    decoration: InputDecoration(labelText: 'Experiance'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'years of experience??';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tell us about your self..';
                      }
                      
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: skillsController,
                    decoration: InputDecoration(labelText: 'Skill'),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'What skills do you have?';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8.0.h),
                  ElevatedButton(
                    onPressed: () {
                      _saveResumeItem();
                    },
                    child: Text(widget.isEditScreen ? 'edit' : "save"),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void _saveResumeItem() async {
    if (_formKey.currentState!.validate()) {
      final CollectionReference resumeCollection =
          FirebaseFirestore.instance.collection('resumes');
      final title = titleController?.text;
      final email = emailController?.text;
      final phone = phoneController?.text;
      final address = addressController?.text;
      final description = descriptionController?.text;
      final skills = skillsController?.text;
      final position = positionController?.text;
      final experience = experienceController?.text;
      final education = educationController?.text;

      final result = ResumeItem(
        title: title,
        email: email,
        phoneNumber: phone,
        address: address,
        description: description,
        skills: skills,
        position: position,
        experience: experience,
        education: education,
      );

      if (widget.isEditScreen) {
        await resumeCollection.doc(widget.docId).update({
          "title": result.title,
          'email': result.email,
          'phoneNumber': result.phoneNumber,
          'address': result.address,
          'description': result.description,
          'skills': result.skills,
          'position': result.position,
          'experience': result.experience,
          'education': result.education,
        });
      } else {
        await resumeCollection.add({
          "title": result.title,
          'email': result.email,
          'phoneNumber': result.phoneNumber,
          'address': result.address,
          'description': result.description,
          'skills': result.skills,
          'position': result.position,
          'experience': result.experience,
          'education': result.education,
        });
      }

      Navigator.pop(context, result);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Fill all the details")));
    }
  }
}
