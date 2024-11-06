import { Logger } from '../../common/Logger'
import { CardObject, CountdownCardItem, DISPLAY_MIDDLE_HEIGHT, DISPLAY_MIDDLE_WIDTH } from '../../viewmodel/card/Card'
import { formatDate, lastDaysOfDate } from '../../common/DateUtil'
import { CARD_FRONT_FONT_OPACITY } from '../../common/Constants'
import { photoPickOne } from '../../common/PickerUtil'
import { router } from '@kit.ArkUI'
import { deleteCardRequest } from '../../common/HttpUtil'

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
    .borderRadius(10).bindContextMenu(this.PopMenu(), ResponseType.LongPress)
  }


  @Builder
  PopMenu (){
    Menu() {
      MenuItem({content: $r('app.string.Card_AddCard'), endIcon: $r('app.media.addp2')}).onClick((event) => {
        router.pushUrl({url: "pages/card/CardAddSelection", params: this.info})
      })
      MenuItem({content: $r('app.string.Card_UpdateCard'), endIcon: $r('app.media.accept2')}).onClick((event) => {
        router.pushUrl({url: "pages/card/CardAddSelection", params: this.info})
      })
      MenuItem({content: $r('app.string.Card_DeleteCard'), endIcon: $r('app.media.reject2')}).onClick((event) => {
        let cardObject: CardObject = {
          type: this.info?.type?.valueOf(),
          title: this.info?.title,
          date: formatDate(this.info?.date),
          background: this.info?.backgroundImgUri,
          debug: 0
        }
        let yes: Promise<boolean> = deleteCardRequest(cardObject)
        yes.then((y) => {
          if(y) {
            AlertDialog.show({
              title: $r('app.string.Info'),
              message: $r('app.string.Card_DeleteSuccess')
            })
          } else {
            AlertDialog.show({
              title: $r('app.string.Warning'),
              message: $r('app.string.Card_DeleteFailed')
            })
          }
        })
      })
    }
  }
}


@Preview({
  title: "CountdownEdit"
})
@Component
export struct CountdownCardEdit {
  @Link cardObject: CardObject

  constructor() {
    super()
  }

  aboutToAppear() {
  }

  build() {
    Flex({ justifyContent: FlexAlign.SpaceAround, wrap: FlexWrap.Wrap, alignContent: FlexAlign.SpaceEvenly }) {
      this.CountdownEdit()
    }
  }

  @Builder CountdownEdit() {
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
          let picked: Promise<string> = photoPickOne()
          picked.then((res) => {
            this.cardObject.background = res
          }).catch( () => {
            logger.error("选取图片异常")
          })
        })

      Text(this.cardObject.date == undefined ? formatDate(new Date()) : this.cardObject.date)
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
