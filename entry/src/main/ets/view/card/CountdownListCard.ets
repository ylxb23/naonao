import BirthdayCountdownDataSource, {
  BirthdayCountdownItem,
  sortBirthdayCountdownList,
  transferBirthdayItemList,
  birthdayList
,
} from '../../viewmodel/card/BirthdayCountdown'

@Preview({
  title: "BirthdayCountdownPanel"
})

  /**
   * 生日倒计时面板
   * 分成两列，左边是最近一个生日倒计时展示内容，右边是所有生日倒计时列表。
   */
@Component
export struct CountdownListCard {
  displayWidth = 360
  displayHeight = 150
  // 左边正方形尺寸
  leftInfoWidth = 126
  leftInfoHeight = this.leftInfoWidth
  // 右边长方形尺寸
  rightListWidth = 198
  rightListHeight = this.leftInfoHeight
  // 留白部分尺寸
  marginLength = 12
  @StorageProp('fontSize') fontSize: number = 10
  topBirthdayCountdownItem: BirthdayCountdownItem = sortBirthdayCountdownList(transferBirthdayItemList(birthdayList))[0]

  build() {
    Row() {
      Row() {
        // 左边展示最近一个生日倒计时内容
        Column() {
          this.TopBirthdayItem(this.topBirthdayCountdownItem.username, this.topBirthdayCountdownItem.lastDays, this.topBirthdayCountdownItem.birthday)
        }
        .width(this.leftInfoWidth)
        .height(this.leftInfoHeight)
        .margin({ left: this.marginLength, top: this.marginLength, bottom: this.marginLength })
        .align(Alignment.TopStart)
        .alignItems(HorizontalAlign.Start)
        .borderRadius(6)
        .backgroundColor('#555')
        .opacity(0.5)

        // 右边展示所有生日倒计时列表
        Column() {
          Scroll() {
            List() {
              LazyForEach(new BirthdayCountdownDataSource(birthdayList), (item: BirthdayCountdownItem) => {
                ListItem() {
                  Column() {
                    this.BirthdayItemList(item.id, item.username, item.lastDays, item.birthday)
                  }
                }
              }, (item: BirthdayCountdownItem) => item.id.toString())
            }.width('100%').height('100%')
          }
        }
        .width(this.rightListWidth)
        .height(this.rightListHeight)
        .margin({ left: this.marginLength, top: this.marginLength, bottom: this.marginLength })
        .borderRadius(6)
        .backgroundColor('#777')
        .opacity(0.5)

      }.width(this.displayWidth).height(this.displayHeight)
      .borderRadius(10)
      .backgroundColor('#ccc')
    }
  }

  lineMarginLength: number = 10
  textPaddingLength: number = this.lineMarginLength

  @Builder
  TopBirthdayItem(username: string, lastDays: number, birthday: string) {
    Row() {
      Column() {
        Text($r('app.string.BirthdayCountdownPanel_NextInfoTitle'))
          .fontSize(this.fontSize + 4).fontColor(Color.White).fontWeight(FontWeight.Bold)
          .width('100%')
        Text(username)
          .fontSize(this.fontSize + 3)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .margin({ top: this.lineMarginLength })
          .width('100%')
        Row() {
          Text(lastDays + '')
            .fontSize(this.fontSize + 12).fontColor(Color.White).fontWeight(FontWeight.Bold)
            .margin({ top: this.lineMarginLength })
          Text($r('app.string.days'))
            .fontSize(this.fontSize + 1).fontColor(Color.White).fontWeight(FontWeight.Bold)
        }.width('100%').alignItems(VerticalAlign.Bottom)

        Text(birthday)
          .fontSize(this.fontSize + 2)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .margin({ top: this.lineMarginLength })
          .width('100%')
      }.alignItems(HorizontalAlign.Start).padding({ left: this.textPaddingLength })
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
          .fontSize(this.fontSize + 3)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Start)
          .margin({ top: this.lineMarginLength / 2 })
      }.width('60%').alignItems(HorizontalAlign.Start).align(Alignment.BottomStart)
      .padding({ left: this.textPaddingLength })

      Column() {
        Row() {
          Blank()

          Text(lastDays + '')
            .textAlign(TextAlign.End)
            .fontSize(this.fontSize + 8)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)

          Text($r('app.string.days'))
            .fontSize(this.fontSize + 2).fontColor(Color.White).fontWeight(FontWeight.Bold)
        }.width('100%').margin({ right: this.lineMarginLength }).alignItems(VerticalAlign.Bottom)

      }.width('40%').alignItems(HorizontalAlign.End).align(Alignment.Bottom)
    }.margin({ top: this.lineMarginLength })
    .borderWidth({ bottom: 1 })
    .borderStyle({ bottom: BorderStyle.Dashed }).borderColor(Color.White)
  }
}
