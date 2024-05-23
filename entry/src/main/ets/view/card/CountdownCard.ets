import { CountdownCardItem, DISPLAY_MIDDLE_HEIGHT, DISPLAY_MIDDLE_WIDTH } from '../../viewmodel/card/Card'
import { formatDate, lastDaysOfDate } from '../../viewmodel/card/Countdown'

@Preview({
  title: "Countdown"
})
@Component
export struct CountdownCard {
  private info: CountdownCardItem

  build() {
    Flex({ justifyContent: FlexAlign.SpaceAround, wrap: FlexWrap.Wrap, alignContent: FlexAlign.SpaceEvenly }) {
      this.Countdown(this.info)
    }
  }

  @Builder
  Countdown(info: CountdownCardItem) {
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
          .fontSize(45).fontColor(Color.White).fontWeight(FontWeight.Bolder)
        Text($r('app.string.DaysLeft')).textAlign(TextAlign.Center)
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
  }
}