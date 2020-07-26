import 'firestore_service.dart';

class AddCategories {

  static updateCategoryData(String cat , String url) async{

    print(url);
    String path = 'Users/vQ8CMAJZo4at0MmZKhFaGLPRwo93/Categories/$cat';
    final temp = await FirestoreService.instance.getData(docPath:'Users/vQ8CMAJZo4at0MmZKhFaGLPRwo93/Categories/$cat' );
    print(temp.data);
    List links = temp.data['Links'];
    print(links);
    if(!links.contains(url)) {

      links.add(url);

      FirestoreService.instance.updateData(docPath: path, data: {'name':cat,'Links':links});
    }


  }
  static addCategory(String cat){
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