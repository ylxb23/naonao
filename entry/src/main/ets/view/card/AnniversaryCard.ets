import { Logger } from '../../common/Logger'
import { AnniversaryCardItem, DISPLAY_MIDDLE_HEIGHT, DISPLAY_MIDDLE_WIDTH } from '../../viewmodel/card/Card'
import { daysPassedOfDate, formatDate } from '../../viewmodel/card/Countdown'


const logger: Logger = new Logger("Home")

@Preview({
  title: "Anniversary"
})
@Component
export struct AnniversaryCard {
  private info: AnniversaryCardItem


  aboutToAppear() {
    logger.info("get info: %s", JSON.stringify(this.info))
  }

  build() {
    Flex({ justifyContent: FlexAlign.SpaceAround, wrap: FlexWrap.Wrap, alignContent: FlexAlign.SpaceEvenly }) {
      this.Anniversary(this.info)
    }
  }

  @Builder
  Anniversary(info: AnniversaryCardItem) {
    Column() {
      Text(info.title)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width('100%')
        .height(30)
        .margin({ top: 5 })
        .textAlign(TextAlign.Center)
        .fontSize(20)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
      Row() {
        Text(daysPassedOfDate(info.date) + ' ').textAlign(TextAlign.Center)
          .fontSize(45).fontColor(Color.White).fontWeight(FontWeight.Bolder)
        Text($r('app.string.DaysPassed')).textAlign(TextAlign.Center)
          .fontSize(10).fontColor(Color.White).fontWeight(FontWeight.Bold)
      }.width('100%').height(80).align(Alignment.Bottom).justifyContent(FlexAlign.Center)

      Text(formatDate(info.date))
        .width('100%')
        .height(30)
        .padding({ top: 5 })
        .textAlign(TextAlign.Center)
        .fontSize(20)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
    }
    .width(DISPLAY_MIDDLE_WIDTH)
    .height(DISPLAY_MIDDLE_HEIGHT)
    .alignItems(HorizontalAlign.Center)
    .borderRadius(10)
    .backgroundColor('#ccc')
    .priorityGesture(LongPressGesture({repeat: false}).onAction((e) => {
      // 长按事件动作

    }).onActionEnd((e) => {
      //
    }), GestureMask.Normal)
  }
}