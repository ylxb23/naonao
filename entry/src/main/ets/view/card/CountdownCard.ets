import { Logger } from '../../common/Logger'
import { CountdownCardItem, DISPLAY_MIDDLE_HEIGHT, DISPLAY_MIDDLE_WIDTH } from '../../viewmodel/card/Card'
import { formatDate, lastDaysOfDate } from '../../common/DateUtil'
import { CARD_FRONT_FONT_OPACITY } from '../../common/Constants'


const logger: Logger = new Logger("Countdown")

@Preview({
  title: "Countdown"
})
@Component
export struct CountdownCard {
  private info?: CountdownCardItem

  aboutToAppear() {
    if(this.info == undefined) {
      logger.error("卡片为空")
      return
    }
    logger.debug("倒计时卡片内容为: %{public}s", JSON.stringify(this.info))
  }

  build() {
    Flex({ justifyContent: FlexAlign.SpaceAround, wrap: FlexWrap.Wrap, alignContent: FlexAlign.SpaceEvenly }) {
      if(this.info != undefined) {
        this.Countdown(this.info)
      }
    }
  }

  @Builder
  Countdown(info: CountdownCardItem) {
    Column() {
      Image(info.backgroundImgUri)
        .zIndex(-2)
        .position({ x: 0, y: 0 })
        .height('100%')
        .width('100%')
        .align(Alignment.Center)
        .borderRadius(10)
        .objectFit(ImageFit.Cover)
      Column() {
      }
      .zIndex(-1)
      .position({ x: 0, y: 0 })
      .height('100%')
      .width('100%')
      .backgroundColor('#999')
      .borderRadius(10)
      .opacity(1 - CARD_FRONT_FONT_OPACITY)

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
          Text(lastDaysOfDate(info.date) + ' ').textAlign(TextAlign.Center)
            .fontSize(40).fontColor(Color.White).fontWeight(FontWeight.Bolder)
          Text($r('app.string.DaysLeft')).textAlign(TextAlign.Center)
            .fontSize(11).fontColor(Color.White).fontWeight(FontWeight.Bold)
            .margin({top: 20})
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
      .position({ x: 0, y: 0 })
      .borderRadius(10)
      .opacity(CARD_FRONT_FONT_OPACITY)
    }
    .width(DISPLAY_MIDDLE_WIDTH)
    .height(DISPLAY_MIDDLE_HEIGHT)
    .alignItems(HorizontalAlign.Center)
    .borderRadius(10)
  }
}