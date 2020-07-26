import 'firestore_service.dart';

class AddCategories {

  static updateCategoryData(String cat){
    String path = 'Users/vQ8CMAJZo4at0MmZKhFaGLPRwo93/Categories/$cat';
    List links =['https://www.google.com/search?q=$cat'];
    FirestoreService.instance.updateData(docPath: path, data: {'name':cat,'Links':links});
  }

  static Future <List<String>> getCategories() async{
    final data =await FirestoreService.instance.getData(docPath:'Users/vQ8CMAJZo4at0MmZKhFaGLPRwo93');
    return data['Categories'];
  }
  static addToCategoryField(String cat) async{
    final document = await FirestoreService.instance.getData(docPath: 'Users/vQ8CMAJZo4at0MmZKhFaGLPRwo93');
    List data = document['Categories'];
    data.add(cat);
    FirestoreService.instance.updateData(docPath:'Users/vQ8CMAJZo4at0MmZKhFaGLPRwo93' , data: {'Categories':data});
  }
}