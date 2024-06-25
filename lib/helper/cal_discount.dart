import 'package:mobilefinalhcmus/feature/book/views/models/service_model.dart';
import 'package:mobilefinalhcmus/feature/shop/models/voucher_model.dart';

int CalculateDiscount({required VoucherModel voucher,required ServiceModel chosenService}) {
  int afterDiscountPrice = 0;
  final discount = (voucher.discountPercent! * 100).toInt();
  final discountPrice = ((chosenService.price! * discount) ~/ 100).toInt();
  if (discountPrice > (voucher.maxDiscount)!.toInt()) {
    afterDiscountPrice = chosenService.price! - voucher.maxDiscount!.toInt();
  } else {
    afterDiscountPrice = chosenService!.price! - discountPrice;
  }
  return afterDiscountPrice;
}
