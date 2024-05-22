import { DateItem, daysPassedOfDate, formatDate } from '../../viewmodel/card/Countdown'

@Preview({
  title: "Anniversary"
})

@Component
export struct AnniversaryCard {
  displayWith = 150
  displayHeight = 150
  info1: DateItem = { id: 1, title: '已经入职', date: new Date('2023-04-24') }
  info2: DateItem = { id: 2, title: '墨墨出生', date: new Date('2023-08-02') }
  info3: DateItem = { id: 3, title: '结婚已经', date: new Date('2022-03-03') }

  build() {
    Flex({ justifyContent: FlexAlign.SpaceAround, wrap: FlexWrap.Wrap, alignContent: FlexAlign.SpaceEvenly }) {
      this.Anniversary(this.info1)
      this.Anniversary(this.info2)
      this.Anniversary(this.info3)
    }.width('100%').height('100%')
  }

  @Builder
  Anniversary(info: DateItem) {
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
    .width(this.displayWith)
    .height(this.displayHeight)
    .alignItems(HorizontalAlign.Center)
    .borderRadius(10)
    .backgroundColor('#ccc')
  }
}