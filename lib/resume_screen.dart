import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:interview_resume_builder/resume_details.dart';
import 'package:interview_resume_builder/resume_form.dart';
import 'package:sizer/sizer.dart';

class ResumeScreen extends StatefulWidget {
  @override
  _ResumeScreenState createState() => _ResumeScreenState();
}

class _ResumeScreenState extends State<ResumeScreen> {
  final CollectionReference resumeCollection =
      FirebaseFirestore.instance.collection('resumes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resume App'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('resumes').snapshots(),
        builder: (BuildContext context, AsyncSnapshot streamSnapshot) {
          if (streamSnapshot.hasData) {
            List<DocumentSnapshot> resumeDocs = streamSnapshot.data.docs;

            return Padding(
              padding:  EdgeInsets.all(8.0.sp),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: resumeDocs.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ResumeDetails(
                          email: resumeDocs[index]["email"].toString(),
                          isEditScreen: false,
                          phoneNumber:
                              resumeDocs[index]["phoneNumber"].toString(),
                          docId: resumeDocs[index].id,
                          name: resumeDocs[index]["title"],
                          description: resumeDocs[index]["description"],
                          address: resumeDocs[index]["address"],
                          skills: resumeDocs[index]["skills"],
                          education: resumeDocs[index]["education"],
                          experience: resumeDocs[index]["experience"],
                          position: resumeDocs[index]["position"],
                        ),
                      ));
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 50.h,
                          width: 50.w,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(20)),
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                " Name: ${resumeDocs[index]["title"]}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 1.0.h),
                              Text(
                                " Description: ${resumeDocs[index]["description"]}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 1.0.h),
                              Text(
                                " Address: ${resumeDocs[index]["address"]}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 1.0.h),
                              Text(
                                " Skills: ${resumeDocs[index]["skills"]}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 1.sp,
                          right: 20.sp,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20.sp,
                                child: IconButton(
                                  color: Colors.black54,
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    _deleteResumeItem(resumeDocs[index].id);
                                  },
                                ),
                              ),
                             SizedBox(width: 15.sp,),
                             SizedBox(
                               width: 20.sp,
                               child:  IconButton(
                                 color: Colors.black54,
                                 icon: Icon(Icons.edit),
                                 onPressed: () {
                                   _navigateToResumeForm(resumeDocs[index]);
                                 },
                               ),
                             )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          } else if (streamSnapshot.hasError) {
            debugPrint("Error: ${streamSnapshot.error}");
          }
          return Center(child: const CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ResumeForm()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _navigateToResumeForm(DocumentSnapshot resumeDoc) async {
    debugPrint("Document ID: ${resumeDoc.id}");
    debugPrint("Title: ${resumeDoc["title"]}");
    debugPrint("Description: ${resumeDoc["description"]}");
    debugPrint("Address: ${resumeDoc["address"]}");
    debugPrint("Skills: ${resumeDoc["skills"]}");

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResumeForm(
          email: resumeDoc["email"],
          isEditScreen: true,
          phoneNumber: resumeDoc["phoneNumber"],
          docId: resumeDoc.id,
          title: resumeDoc["title"],
          description: resumeDoc["description"],
          address: resumeDoc["address"],
          skills: resumeDoc["skills"],
          edutcation: resumeDoc["education"],
          position: resumeDoc["position"],
          experiance: resumeDoc["experience"],
        ),
      ),
    );
  }

  void _deleteResumeItem(String id) async {
    try {
      await resumeCollection.doc(id).delete();
      debugPrint("Deleted document with ID: $id");
    } catch (e) {
      debugPrint("Error deleting document: $e");
    }
  }
}
