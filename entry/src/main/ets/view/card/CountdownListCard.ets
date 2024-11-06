import { CARD_FRONT_FONT_OPACITY } from '../../common/Constants';
import { formatDate, nextAnniversaryDays } from '../../common/DateUtil';
import { deleteCardRequest } from '../../common/HttpUtil';
import { Logger } from '../../common/Logger';
import { photoPickOne } from '../../common/PickerUtil';
import {
  CardObject,
  CountdownListCardItem,
  DISPLAY_BIG_HEIGHT,
  DISPLAY_BIG_LEFT_INFO_HEIGHT,
  DISPLAY_BIG_LEFT_INFO_WIDTH,
  DISPLAY_BIG_RIGHT_LIST_HEIGHT,
  DISPLAY_BIG_RIGHT_LIST_WIDTH,
  DISPLAY_BIG_WIDTH,
  getNextAnniversaryDayCountdownItem,
  getSortedAnniversaryDayCountdownList,
  NamedDateItem,
  NamedDateItemObject
} from '../../viewmodel/card/Card'
import { router } from '@kit.ArkUI';


const logger: Logger = new Logger("Home")
const BASE_FONT_SIZE: number = 10

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


  aboutToAppear() {
    logger.info("倒计时列表卡片: %{public}s", JSON.stringify(this.info))
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

      // 左边展示最近一个倒计时内容，和标题
      Column() {
        this.TopItemDetail(info.title, getNextAnniversaryDayCountdownItem(info))
      }
      .width(DISPLAY_BIG_LEFT_INFO_WIDTH)
      .height(DISPLAY_BIG_LEFT_INFO_HEIGHT)
      .padding(10)
      .align(Alignment.TopStart)
      .borderRadius(6)

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
      // .backgroundColor('#777')
      .opacity(CARD_FRONT_FONT_OPACITY)

    }.width(DISPLAY_BIG_WIDTH).height(DISPLAY_BIG_HEIGHT)
    .borderRadius(10)
    .backgroundColor('#ccc').bindContextMenu(this.PopMenu(), ResponseType.LongPress)
  }


  @Builder
  TopItemDetail(title: string, item: NamedDateItem) {
    Row() {
      Column() {
        Image(item.avatar)
          .zIndex(-2)
          .position({ x: 0, y: 0 })
          .height('100%')
          .width('100%')
          .align(Alignment.Center)
          .borderRadius(10)
          .objectFit(ImageFit.Cover)
          .opacity(CARD_FRONT_FONT_OPACITY)
        Column() {
        }
        .zIndex(-1)
        .position({ x: 0, y: 0 })
        .height('100%')
        .width('100%')
        .borderRadius(10)
        .opacity(1-CARD_FRONT_FONT_OPACITY)

        Text(title)
          .fontSize(BASE_FONT_SIZE + 4).fontColor(Color.White).fontWeight(FontWeight.Bold)
          .width('100%').padding({left: 20, top: 5})
        Text(item.name)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontSize(BASE_FONT_SIZE + 3)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .padding({ left: 20, top: 10 })
          .width('100%')
        Row() {
          Text(nextAnniversaryDays(item.date) + '')
            .fontSize(BASE_FONT_SIZE + 12).fontColor(Color.White).fontWeight(FontWeight.Bold)
            .padding({ left: 20, top: 10 })
          Text($r('app.string.days'))
            .fontSize(BASE_FONT_SIZE + 1).fontColor(Color.White).fontWeight(FontWeight.Bold)
        }.width('100%').alignItems(VerticalAlign.Bottom)

        Text(formatDate(item.date))
          .fontSize(BASE_FONT_SIZE + 2)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .padding({ left: 20, top: 10 })
          .width('100%')
      }.alignItems(HorizontalAlign.Start)
    }.height('100%').width('100%')
  }

  @Builder
  ItemListSummary(item: NamedDateItem) {
    Row() {
      Column() {
        Text(item.name)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontSize(BASE_FONT_SIZE + 4)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Start)
        Text(formatDate(item.date))
          .fontSize(BASE_FONT_SIZE + 3)
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
            .fontSize(BASE_FONT_SIZE + 8)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)

          Text($r('app.string.days'))
            .fontSize(BASE_FONT_SIZE + 2).fontColor(Color.White).fontWeight(FontWeight.Bold)
        }.width('100%').margin({ right: 10 }).alignItems(VerticalAlign.Bottom)

      }.width('40%').alignItems(HorizontalAlign.End).align(Alignment.Bottom)
    }
    .margin({ top: 10 })
    .borderWidth({ bottom: 1 })
    .borderStyle({ bottom: BorderStyle.Dashed })
    .borderColor(Color.White)
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


/**
 * 生日倒计时面板
 * 分成两列，左边是最近一个生日倒计时展示内容，右边是所有生日倒计时列表。
 */
@Preview({
  title: "BirthdayCountdownEdit"
})
@Component
export struct CountdownListCardEdit {
  @Link cardObject: CardObject

  aboutToAppear() {
    logger.info("倒计时列表卡片: %{public}s", JSON.stringify(this.cardObject))
    if(this.cardObject.list == undefined || this.cardObject.list.length == 0) {
      let list: NamedDateItemObject[] = []
      list.push({date: formatDate(new Date())})
      this.cardObject.list = list
      logger.info("初始化第一个Item")
    }
  }

  build() {
    Flex({ justifyContent: FlexAlign.SpaceAround, wrap: FlexWrap.Wrap, alignContent: FlexAlign.SpaceEvenly }) {
      if(this.cardObject != undefined) {
        this.CountdownListEdit()
      }
    }
  }

  @Builder
  CountdownListEdit() {
    Row() {
      Image(this.cardObject.background)
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

      // 左边展示最近一个倒计时内容，和标题
      Column() {
        this.TopItemDetailEdit()
      }
      .width(DISPLAY_BIG_LEFT_INFO_WIDTH)
      .height(DISPLAY_BIG_LEFT_INFO_HEIGHT)
      .padding(10)
      .align(Alignment.TopStart)
      .borderRadius(6)

      // 右边展示所有倒计时列表
      Column() {
        this.ItemListSummaryEdit()
      }
      .width(DISPLAY_BIG_RIGHT_LIST_WIDTH)
      .height(DISPLAY_BIG_RIGHT_LIST_HEIGHT)
      .margin({ top: 10, bottom: 10 })
      .opacity(CARD_FRONT_FONT_OPACITY)

    }.width(DISPLAY_BIG_WIDTH).height(DISPLAY_BIG_HEIGHT)
    .borderRadius(10)
    .backgroundColor('#ccc')
  }


  @Builder
  TopItemDetailEdit() {
    Row() {
      Column() {
        Image(this.cardObject.background == undefined ? $r('app.media.camerax') : this.cardObject.background)
          .zIndex(-1)
          .position({ x: 0, y: 0 })
          .height('100%')
          .width('100%')
          .align(Alignment.Center)
          .borderRadius(10)
          .objectFit(ImageFit.Cover)

        TextInput({ text: this.cardObject.title, placeholder: $r('app.string.Card_InputTitle') })
          .width('100%')
          .height(30)
          .textAlign(TextAlign.Center)
          .fontSize(13)
          .fontColor(Color.White)
          .placeholderColor('#eee')
          .placeholderFont({ size: 13, weight: FontWeight.Bold })
          .fontWeight(FontWeight.Bold)
          .opacity(CARD_FRONT_FONT_OPACITY)
          .borderRadius({ topLeft: 10, topRight: 10, bottomLeft: 0, bottomRight: 0 })
          .onChange((v) => {
            this.cardObject.title = v
          })
        Blank().height('100%').width('100%')
          .onClick(() => {
            let picked: Promise<string> = photoPickOne()
            picked.then((res) => {
              this.cardObject.background = res
            }).catch( () => {
              logger.error("选取图片异常")
            })
          })

      }.alignItems(HorizontalAlign.Start)
    }.height('100%').width('100%')
  }

  @Builder
  ItemListSummaryEdit() {
    Row() {
      Scroll() {
        List() {
          ForEach(this.cardObject.list, (item: NamedDateItemObject, _idx: number) => {
            ListItem() {
              Column(){
                this.ItemEdit(item)
              }
            }
          })
        }.width('100%').height('100%')
      }
    }
    .margin({ top: 10 })
  }

  @Builder
  ItemEdit(item: NamedDateItemObject) {
    Row() {
      Column() {
        Row() {
          TextInput({ text: item.name, placeholder: $r('app.string.Card_InputName') })
            .placeholderFont({size: BASE_FONT_SIZE+1})
            .placeholderColor('#eee')
            .maxLength(10).padding(0)
            .fontColor(Color.White)
            .fontSize(BASE_FONT_SIZE + 1)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
            .borderRadius(0).showUnderline(true)
            .onChange((value) => {
              item.name = value
              this.cardObject.debug = this.cardObject.debug + 1
            })
        }.height(18)
        Row() {
          Text(item.date == undefined ? formatDate(new Date()):item.date)
            .width('100%')
            .height(10)
            .lineHeight(12)
            .fontSize(BASE_FONT_SIZE)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
            .opacity(CARD_FRONT_FONT_OPACITY)
            .onClick(() => {
              DatePickerDialog.show({
                start: new Date('1970-1-1'),
                end: new Date('2100-1-1'),
                selected: new Date(),
                onAccept: (value: DatePickerResult) => {
                  let selected = new Date();
                  selected.setFullYear(value.year, value.month, value.day)
                  item.date = formatDate(selected)
                  this.cardObject.debug = this.cardObject.debug + 1
                }
              })
            })
        }.height(12)
      }.width('60%')
      .alignItems(HorizontalAlign.Start)
      .align(Alignment.TopStart)

      Blank()

      Column() {
        Row() {
          Column(){
            Image(item.avatar == undefined ? $r('app.media.camerax') : item.avatar)
              .zIndex(-1)
              .position({ x: 0, y: 0 })
              .height(30)
              .width(30)
              .align(Alignment.Center)
              .objectFit(ImageFit.Cover)
              .onClick(async () => {
                let picked: Promise<string> = photoPickOne()
                await picked.then((res) => {
                  item.avatar = res
                  this.cardObject.debug = this.cardObject.debug + 1
                }).catch( () => {
                  logger.error("选取图片异常")
                })
              })
          }.width(30).height(30)
          Blank()
          Image($r('app.media.add'))
            .objectFit(ImageFit.Cover)
            .align(Alignment.Center).height(20).width(20).margin({left: 3})
            .onClick(() => {
              this.cardObject.list?.push({})
              this.cardObject.debug = this.cardObject.debug + 1
              logger.info("添加了一个: %{public}s", JSON.stringify(this.cardObject))
            })
          Image($r('app.media.delete'))
            .objectFit(ImageFit.Cover)
            .align(Alignment.Center).height(20).width(20).margin({left: 3})
            .onClick(() => {
              logger.info("移除前的列表为: %{public}s", JSON.stringify(this.cardObject))
              this.cardObject.list = this.cardObject.list?.filter((curr) => {
                return curr.name != item.name
              })
              this.cardObject.debug = this.cardObject.debug + 1
              logger.info("移除后的列表为: %{public}s", JSON.stringify(this.cardObject))
            })

        }.width('100%').padding({ right: 10 }).alignItems(VerticalAlign.Center)
      }.width('40%').alignItems(HorizontalAlign.End).align(Alignment.Bottom)
    }
    .borderWidth({ bottom: 1 })
    .borderStyle({ bottom: BorderStyle.Dashed })
    .borderColor(Color.White)
    .margin({bottom: 5})
  }
}
