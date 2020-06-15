import 'package:wechat_flutter/provider/login_model.dart';
import 'package:wechat_flutter/tools/shared_util.dart';

class LoginLogic {
  final LoginModel _model;

  LoginLogic(this._model);

  ///获取当前选择的地区号码
  Future getArea() async {
    final area = await SharedUtil.instance.getString(Keys.area);
    if (area == null) return;
    if (area == _model.area) return;
    _model.area = area;
  }
}
