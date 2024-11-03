import { CARD_FRONT_FONT_OPACITY } from '../../common/Constants'
import { Logger } from '../../common/Logger'
import { AnniversaryCardItem, CardObject, DISPLAY_MIDDLE_HEIGHT, DISPLAY_MIDDLE_WIDTH } from '../../viewmodel/card/Card'
import { daysPassedOfDate, formatDate } from '../../common/DateUtil'
import { photoPickOne } from '../../common/PickerUtil'

const logger: Logger = new Logger("AnniversaryCard")

@Preview({
  title: "AnniversaryEdit"
})
@Component
export struct AnniversaryCardEdit {
  @Link cardObject: CardObject

  constructor() {
    super()
  }

  aboutToAppear() {
    logger.debug("get from card item: %s", JSON.stringify(this.cardObject))
  }

  build() {
    Flex({ justifyContent: FlexAlign.SpaceAround, wrap: FlexWrap.Wrap, alignContent: FlexAlign.SpaceEvenly }) {
      this.AnniversaryEdit()
    }
  }

  @Builder AnniversaryEdit() {
    Column() {
      Image(this.cardObject.background == undefined ? $r('app.media.camerax') : this.cardObject.background)
        .zIndex(-1)
        .position({ x: 0, y: 0 })
        .height('100%')
        .width('100%')
        .align(Alignment.Center)
        .borderRadius(10)
        .objectFit(ImageFit.Cover)

      TextInput({ text: this.cardObject.title, placeholder: $r('app.string.Card_InputName') })
        .width('100%')
        .height(30)
        .textAlign(TextAlign.Center)
        .fontSize(13)
        .fontColor(Color.White)
        .placeholderColor('#eee')
        .backgroundColor('#ccc')
        .placeholderFont({ size: 13, weight: FontWeight.Bold })
        .fontWeight(FontWeight.Bold)
        .opacity(CARD_FRONT_FONT_OPACITY)
        .borderRadius({ topLeft: 10, topRight: 10, bottomLeft: 0, bottomRight: 0 })
        .onChange((v) => {
          this.cardObject.title = v
        })
      Blank()
        .onClick(() => {
          logger.debug("打开图片选择器...");
          let picked: Promise<string> = photoPickOne()
          picked.then((res) => {
            logger.info("选择的图片为: %{public}s", res)
            this.cardObject.background = res
          }).catch( () => {
            logger.error("pick one photo err")
          })
        })

      Text(this.cardObject.date)
        .width('100%')
        .height(30)
        .lineHeight(30)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .backgroundColor('#ccc')
        .opacity(CARD_FRONT_FONT_OPACITY)
        .borderRadius({ topLeft: 0, topRight: 0, bottomLeft: 10, bottomRight: 10 })
        .onClick(() => {
          DatePickerDialog.show({
            start: new Date('1970-1-1'),
            end: new Date('2100-1-1'),
            selected: new Date(),
            onAccept: (value: DatePickerResult) => {
              let selected = new Date();
              selected.setFullYear(value.year, value.month, value.day)
              this.cardObject.date = formatDate(selected)
              console.info('select current date is: ' + JSON.stringify(this.cardObject.date))
            }
          })
        })
    }
    .width(DISPLAY_MIDDLE_WIDTH)
    .height(DISPLAY_MIDDLE_HEIGHT)
    .alignItems(HorizontalAlign.Center)
    .borderRadius(10)
    .backgroundColor('#eee')
  }
}


@Preview({
  title: "Anniversary"
})
@Component
export struct AnniversaryCard {
  private info?: AnniversaryCardItem

  aboutToAppear() {
    if(this.info == undefined) {
      logger.error("卡片为空")
      return
    }
    logger.debug("纪念日卡片内容为: %s", JSON.stringify(this.info))
  }

  build() {
    Flex({ justifyContent: FlexAlign.SpaceAround, wrap: FlexWrap.Wrap, alignContent: FlexAlign.SpaceEvenly }) {
      if(this.info != undefined) {
        this.Anniversary(this.info)
      }
    }
  }

  @Builder
  Anniversary(info: AnniversaryCardItem) {
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
          Text(daysPassedOfDate(info.date) + ' ')
            .textAlign(TextAlign.Center)
            .fontSize(40)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bolder)
          Text($r('app.string.DaysPassed'))
            .textAlign(TextAlign.Center)
            .fontSize(11)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
            .margin({top: 20})
        }.width('100%').height(80).align(Alignment.Bottom).justifyContent(FlexAlign.Center)

        Text(formatDate(info.date))
          .width('100%')
          .height(30)
          .margin({ top: 5 })
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
    .priorityGesture(LongPressGesture({ repeat: false }).onAction((_e) => {
      // 长按事件动作
      // TODO: 跳转到编辑页面
    }).onActionEnd((_e) => {
      // TODO: 更新当前卡片内容
    }), GestureMask.Normal)
  }
}
