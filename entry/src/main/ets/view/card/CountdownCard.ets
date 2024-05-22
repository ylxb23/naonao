import { DateItem, formatDate, lastDaysOfDate } from '../../viewmodel/card/Countdown'

@Preview({
  title: "Countdown"
})
@Component
export struct CountdownCard {
  displayWith = 150
  displayHeight = 150
  info: DateItem = { id: 1, title: '距离过年', date: new Date('2025-01-01') }

  build() {
    Flex({ justifyContent: FlexAlign.SpaceAround, wrap: FlexWrap.Wrap, alignContent: FlexAlign.SpaceEvenly }) {
      this.Countdown(this.info)
    }.width('100%').height('100%')
  }

  @Builder
  Countdown(info: DateItem) {
    Column() {
      Text(info.title)
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
    .width(this.displayWith)
    .height(this.displayHeight)
    .alignItems(HorizontalAlign.Center)
    .borderRadius(10)
    .backgroundColor('#ccc')
  }
}