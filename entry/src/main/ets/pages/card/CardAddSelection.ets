import router from '@ohos.router';
import { Logger } from '../../common/Logger';
import { AnniversaryCardEdit } from '../../view/card/AnniversaryCard';
import {
  AbsCard,
  AnniversaryCardItem,
	CardTypeEnum,
  CountdownCardItem,
  CountdownListCardItem,
  EmptyCardItem
} from '../../viewmodel/card/Card';


const logger: Logger = new Logger("CardAddSelection")

@Preview({
  title: "CardAdd"
})
@Entry
@Component
struct CardAddSelection {
  @State fromCard: AbsCard | null = (router.getParams() as AbsCard);

  constructor() {
    super()
    this.fromCard = (router.getParams() as AbsCard);
  }

  aboutToAppear() {
    if (this.fromCard.type == CardTypeEnum.Empty) {
      this.fromCard = new AnniversaryCardItem('', new Date())
    }
  }

  build() {
    Column() {
      // 功能选项
      Row() {
        Image($r('app.media.reject2')).height(30).width(30).margin({left: 16}).onClick(() => {
          router.back()
        })
        Blank()
        Image($r('app.media.accept2')).height(30).width(30).margin({right: 16}).onClick(() => {
          logger.debug("confirmed item info: %s", JSON.stringify(this.fromCard))
        })
      }.height(50).width('100%').margin({top: 10})

      Flex({justifyContent: FlexAlign.Center}) {
        if (this.fromCard instanceof AnniversaryCardItem) {
          AnniversaryCardEdit({cardItem: $fromCard}).width(150).height(150)
            .margin(10)
        } else if (this.fromCard instanceof CountdownCardItem) {

        } else if (this.fromCard instanceof CountdownListCardItem) {

        } else {
          AnniversaryCardEdit({cardItem: $fromCard}).width(150).height(150)
            .margin(10)
        }
      }.margin({top: 30})
    }.width('100%').height('100%').alignItems(HorizontalAlign.Start)
  }
}