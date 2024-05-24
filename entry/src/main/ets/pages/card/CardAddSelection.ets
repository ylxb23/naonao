
import router from '@ohos.router';
import { AbsCard } from '../../viewmodel/card/Card';


@Preview({
  title: "CardAdd"
})
@Entry
@Component
struct CardAddSelection {
  @State fromCardType: AbsCard | null = (router.getParams() as AbsCard);

  build() {
    Flex({justifyContent: FlexAlign.SpaceAround}) {
      Text(this.fromCardType == null ? '未获取到类型' : this.fromCardType.type.toString())
    }.width('100%').height('100%')
  }
}