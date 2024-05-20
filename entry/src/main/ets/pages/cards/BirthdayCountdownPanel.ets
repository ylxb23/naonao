
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
  // 宽度
  displayWidth = 120
  // 长度
  displayHeight= 50
  // 左边正方形尺寸
  leftInfoWidth = 42
  leftInfoHeight= 42
  // 右边长方形尺寸
  rightListWidth  = 66
  rightListHeight = 42
  // 留白部分尺寸
  marginLength = 4

  @StorageProp('fontSize') fontSize: number = 0



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
        .borderRadius(2)
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

            }
          }.height(this.rightListHeight)
        }.width(this.rightListWidth).height(this.rightListHeight)
        .margin({left: this.marginLength, top: this.marginLength, bottom: this.marginLength})
        .borderRadius(2)
        .backgroundColor('#333')
        .opacity(0.5)

      }.width('100%')
      .borderRadius(3)
      .backgroundColor('#ccc')
      .opacity(0.7)
    }
  }


  @Builder
  TopBirthdayItem(username: string, lastDays: number, birthday: string) {
    Row() {
      Column() {
        Text($r('app.string.BirthdayCountdownPanel_NextInfoTitle'))
          .fontSize(this.fontSize + 5).fontColor(Color.White).fontWeight(FontWeight.Bold)
          .margin({top: 3})
          .width('100%')
        Text(username)
          .fontSize(this.fontSize + 4).fontColor(Color.White).fontWeight(FontWeight.Bold)
          .margin({top: 3})
          .width('100%')
        Row() {
          Text(`${lastDays}`+" ")
            .fontSize(this.fontSize + 10).fontColor(Color.White).fontWeight(FontWeight.Bold)
            .margin({top: 3})
            .width('30%')
          Text($r('app.string.days'))
            .fontSize(this.fontSize + 3).fontColor(Color.White).fontWeight(FontWeight.Bold)
            .width('70%')
        }.width('100%')
        Text(birthday)
          .fontSize(this.fontSize + 3).fontColor(Color.White).fontWeight(FontWeight.Bold)
          .margin({top: 3})
          .width('100%')
      }.alignItems(HorizontalAlign.Start).padding({left: 2})
    }.height('100%').width('100%')
  }

  @Builder
  BirthdayItemList(id: number, username: string, lastDays: number, birthday: string) {
    Row() {
      Column() {
        Text(username)
          .fontSize(this.fontSize + 4).fontColor(Color.White).fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Start)
        Text(birthday)
          .fontSize(this.fontSize + 3).fontColor(Color.White).fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Start).margin({top: 1})
      }.width('40%').alignItems(HorizontalAlign.Start).padding({left: 3})
      Column() {
        Row() {
          Text(lastDays + '')
            .width('80%').textAlign(TextAlign.End)
            .fontSize(this.fontSize + 5).fontColor(Color.White).fontWeight(FontWeight.Bold)
          Text($r('app.string.days'))
            .width('20%')
            .fontSize(this.fontSize + 3).fontColor(Color.White).fontWeight(FontWeight.Lighter)
        }.width('100%').alignItems(VerticalAlign.Bottom)
      }.width('60%')
    }.margin({top: 3})
  }
}
