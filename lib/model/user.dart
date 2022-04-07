class Todo{
  int?      id;
  int?      active;
  int?      layer;

  String?   name;
  String?   expiredate;
  String?   type;
  String?   brand;
  String?   barcode;

  int?      stakedcount;
  int?      targetcount;


  Todo({this.id, this.active, this.layer,
     this.name, this.expiredate , this.type, this.brand, this.barcode,
     this.stakedcount, this.targetcount  });


  Map<String, dynamic> toMap() {
    return {
      'id'              : id == 0? 0 :id    ,
      'active'          : active == null ?  0 : active    ,
      'layer'           : layer  == null ?  0 : layer     ,

      'name'            : name       , //1
      'expiredate'      : expiredate == null ?  '0' : expiredate  ,
      'type'            : type       == null ?  '0' : type   ,
      'brand'           : brand       , //2
      'barcode'         : barcode    == null ?  '0' : barcode   ,

      'stakedcount'     : stakedcount , //3
      'targetcount'     : targetcount , //4
    };
  }

}