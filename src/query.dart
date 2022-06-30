class TargetQuery {
  String query;
  TargetQuery(this.query) {}

  Get(String _name) {
    var _ = this.query.split("&");
    var val = "";
    _.forEach((element) { 
      var name = element.split("=")[0];
      if(name == _name) {
        val = element.split("=")[1];
      }
    });

    return val;
  }
}