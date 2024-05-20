
import BirthdayListDataSource, { birthdayCountdownItemList, BirthdayCountdownItem } from './model/BirthdayCountdown'

@Preview({
  title: "BirthdayCountdownPanel"
})

/**
 * 生日倒计时面板
 * 分成两列，左边是最近一个生日倒计时展示内容，右边是所有生日倒计时列表。
 */
@Component
export struct BirthdayCountdownPanel {
  // 左边正方形尺寸
  leftInfoWidth = 126
  leftInfoHeight= this.leftInfoWidth
  // 右边长方形尺寸
  rightListWidth  = 198
  rightListHeight = this.leftInfoHeight
  // 留白部分尺寸
  marginLength = 12

  @StorageProp('fontSize') fontSize: number = 10



  build() {
    Row() {
      Row() {
        // 左边展示最近一个生日倒计时内容
        Column() {
          this.TopBirthdayItem('铁铁', 23, '2024/06/17')
        }.width(this.leftInfoWidth).height(this.leftInfoHeight)
        .margin({left: this.marginLength, top: this.marginLength, bottom: this.marginLength})
        .align(Alignment.TopStart)
        .alignItems(HorizontalAlign.Start)
        .backgroundColor('#555')
        .borderRadius(6)
        .opacity(0.7)

        // 右边展示所有生日倒计时列表
        Column() {
          Scroll() {
            List() {
              LazyForEach(new BirthdayListDataSource(birthdayCountdownItemList), (item: BirthdayCountdownItem) => {
                ListItem() {
                  Column() {
                    this.BirthdayItemList(item.id, item.username, item.lastDays, item.birthday)
                  }
                }
              }, (item: BirthdayCountdownItem) => item.id.toString())
            }.width('100%').height('100%')
          }
        }.width(this.rightListWidth).height(this.rightListHeight)
        .margin({left: this.marginLength, top: this.marginLength, bottom: this.marginLength})
        .borderRadius(6)
        .backgroundColor('#333')
        .opacity(0.5)

      }.width('100%').height(150)
      .borderRadius(10)
      .backgroundColor('#ccc')
      .opacity(0.7)
    }
  }


  lineMarginLength: number = 10
  textPaddingLength: number = this.lineMarginLength
  @Builder
  TopBirthdayItem(username: string, lastDays: number, birthday: string) {
    Row() {
      Column() {
        Text($r('app.string.BirthdayCountdownPanel_NextInfoTitle'))
          .fontSize(this.fontSize + 5).fontColor(Color.White).fontWeight(FontWeight.Bold)
          .margin({top: this.lineMarginLength})
          .width('100%')
        Text(username)
          .fontSize(this.fontSize + 4).fontColor(Color.White).fontWeight(FontWeight.Bold)
          .margin({top: this.lineMarginLength})
          .width('100%')
        Row() {
          Text(`${lastDays}`+' ')
            .fontSize(this.fontSize + 10).fontColor(Color.White).fontWeight(FontWeight.Bold)
            .margin({top: this.lineMarginLength})
          Text($r('app.string.days'))
            .fontSize(this.fontSize + 3).fontColor(Color.White).fontWeight(FontWeight.Bold)
        }.width('100%').alignItems(VerticalAlign.Bottom)
        Text(birthday)
          .fontSize(this.fontSize + 3).fontColor(Color.White).fontWeight(FontWeight.Bold)
          .margin({top: this.lineMarginLength})
          .width('100%')
      }.alignItems(HorizontalAlign.Start).padding({left: this.textPaddingLength})
    }.height('100%').width('100%')
  }

  @Builder
  BirthdayItemList(_id: number, username: string, lastDays: number, birthday: string) {
    Row() {
      Column() {
        Text(username)
          .fontSize(this.fontSize + 4).fontColor(Color.White).fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Start)
        Text(birthday)
          .fontSize(this.fontSize + 3).fontColor(Color.White).fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Start).margin({top: this.lineMarginLength / 2})
      }.width('60%').alignItems(HorizontalAlign.Start).align(Alignment.BottomStart)
      .padding({left: this.textPaddingLength})
      Column() {
        Row() {
          Text(lastDays + '')
            .width('80%').textAlign(TextAlign.End)
            .fontSize(this.fontSize + 5).fontColor(Color.White).fontWeight(FontWeight.Bold)
          Text($r('app.string.days'))
            .width('20%')
            .fontSize(this.fontSize + 2).fontColor(Color.White).fontWeight(FontWeight.Normal)
        }.width('100%').alignItems(VerticalAlign.Bottom)
      }.width('40%').align(Alignment.BottomEnd)
    }.margin({top: this.lineMarginLength})
  }
}
