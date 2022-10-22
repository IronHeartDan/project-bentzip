class School{
  String? name;
  String? email;
  String? doi;
  String? id;
  String? contact;
  String? principal;
  String? website;
  String? state;
  String? city;
  String? address;
  bool? active;

  Map<String, dynamic> toJson(){
     return {
       "_id":id,
       "name":name,
       "principal":principal,
       "email":email,
       "state":state,
       "city":city,
       "address":address,
       "contact":List.of({contact}),
       "doi":doi.toString(),
       "active":active
     };
   }

}