import { formatDate, nextAnniversaryDays } from '../../common/DateUtil';
import { Logger } from '../../common/Logger';
import {
  CountdownListCardItem,
  DISPLAY_BIG_HEIGHT,
  DISPLAY_BIG_LEFT_INFO_HEIGHT,
  DISPLAY_BIG_LEFT_INFO_WIDTH,
  DISPLAY_BIG_RIGHT_LIST_HEIGHT,
  DISPLAY_BIG_RIGHT_LIST_WIDTH,
  DISPLAY_BIG_WIDTH,
  getNextAnniversaryDayCountdownItem,
  getSortedAnniversaryDayCountdownList,
  NamedDateItem
} from '../../viewmodel/card/Card'


const logger: Logger = new Logger("Home")

/**
 * 生日倒计时面板
 * 分成两列，左边是最近一个生日倒计时展示内容，右边是所有生日倒计时列表。
 */
@Preview({
  title: "BirthdayCountdown"
})
@Component
export struct CountdownListCard {
  private info?: CountdownListCardItem
  @StorageProp('fontSize') fontSize: number = 10;

  aboutToAppear() {
    logger.info("get info: %s", JSON.stringify(this.info))
  }

  build() {
    Flex({ justifyContent: FlexAlign.SpaceAround, wrap: FlexWrap.Wrap, alignContent: FlexAlign.SpaceEvenly }) {
      if(this.info != undefined) {
        this.CountdownList(this.info)
      }
    }
  }

  @Builder
  CountdownList(info: CountdownListCardItem) {
    Row() {
      // 左边展示最近一个倒计时内容，和标题
      Column() {
        this.TopItemDetail(info.title, getNextAnniversaryDayCountdownItem(info))
      }
      .width(DISPLAY_BIG_LEFT_INFO_WIDTH)
      .height(DISPLAY_BIG_LEFT_INFO_HEIGHT)
      .margin(10)
      .align(Alignment.TopStart)
      .alignItems(HorizontalAlign.Start)
      .borderRadius(6)
      .backgroundColor('#555')
      .opacity(0.5)

      // 右边展示所有倒计时列表
      Column() {
        Scroll() {
          List() {
            ForEach(getSortedAnniversaryDayCountdownList(this.info), (di: NamedDateItem, _idx) => {
              ListItem() {
                Column() {
                  this.ItemListSummary(di)
                }
              }
            })
          }.width('100%').height('100%')
        }
      }
      .width(DISPLAY_BIG_RIGHT_LIST_WIDTH)
      .height(DISPLAY_BIG_RIGHT_LIST_HEIGHT)
      .margin({ top: 10, bottom: 10 })
      .borderRadius(6)
      .backgroundColor('#777')
      .opacity(0.5)

    }.width(DISPLAY_BIG_WIDTH).height(DISPLAY_BIG_HEIGHT)
    .borderRadius(10)
    .backgroundColor('#ccc')
  }


  @Builder
  TopItemDetail(title: string, item: NamedDateItem) {
    Row() {
      Column() {
        Text(title)
          .fontSize(this.fontSize + 4).fontColor(Color.White).fontWeight(FontWeight.Bold)
          .width('100%')
        Text(item.name)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontSize(this.fontSize + 3)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 10 })
          .width('100%')
        Row() {
          Text(nextAnniversaryDays(item.date) + '')
            .fontSize(this.fontSize + 12).fontColor(Color.White).fontWeight(FontWeight.Bold)
            .margin({ top: 10 })
          Text($r('app.string.days'))
            .fontSize(this.fontSize + 1).fontColor(Color.White).fontWeight(FontWeight.Bold)
        }.width('100%').alignItems(VerticalAlign.Bottom)

        Text(formatDate(item.date))
          .fontSize(this.fontSize + 2)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 10 })
          .width('100%')
      }.alignItems(HorizontalAlign.Start).padding({ left: 10 })
    }.height('100%').width('100%')
  }

  @Builder
  ItemListSummary(item: NamedDateItem) {
    Row() {
      Column() {
        Text(item.name)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontSize(this.fontSize + 4)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Start)
        Text(formatDate(item.date))
          .fontSize(this.fontSize + 3)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Start)
          .margin({ top: 10 / 2 })
      }.width('60%').alignItems(HorizontalAlign.Start).align(Alignment.BottomStart)
      .padding({ left: 10 })

      Column() {
        Row() {
          Blank()

          Text(nextAnniversaryDays(item.date) + '')
            .textAlign(TextAlign.End)
            .fontSize(this.fontSize + 8)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)

          Text($r('app.string.days'))
            .fontSize(this.fontSize + 2).fontColor(Color.White).fontWeight(FontWeight.Bold)
        }.width('100%').margin({ right: 10 }).alignItems(VerticalAlign.Bottom)

      }.width('40%').alignItems(HorizontalAlign.End).align(Alignment.Bottom)
    }
    .margin({ top: 10 })
    .borderWidth({ bottom: 1 })
    .borderStyle({ bottom: BorderStyle.Dashed })
    .borderColor(Color.White)
  }
}
