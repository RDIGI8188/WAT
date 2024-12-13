

class Pet {
  final int id;
  final String petDetail;
  final String reason;
  final String customerAddress;
  final String currentTimeStamp;
  final String? images;
  final String? gender;      
  final String? age;         
  final String? color;       
  final String? breed;       
  final int status;          

  Pet({
    required this.id,
    required this.petDetail,
    required this.reason,
    required this.customerAddress,
    required this.currentTimeStamp,
    this.images,
    this.gender,
    this.age,
    this.color,
    this.breed,
    required this.status,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      petDetail: json['petDetail'],
      reason: json['reason'],
      customerAddress: json['customer_address'],
      currentTimeStamp: json['current_timeStamp'],
      images: json['images'],
      gender: json['gender'],  
      age: json['age'],        
      color: json['color'],    
      breed: json['breed'],    
      status: json['status'],   
    );
  }
}
