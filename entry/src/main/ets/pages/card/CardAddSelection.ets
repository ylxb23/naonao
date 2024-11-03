import router from '@ohos.router';

import { Logger } from '../../common/Logger';
import { AnniversaryCardEdit } from '../../view/card/AnniversaryCard';
import {
  CardObject,
  CardTypeEnum,
} from '../../viewmodel/card/Card';
import { addCardRequest, uploadFileRequest } from '../../common/HttpUtil';


const logger: Logger = new Logger("CardAddSelection")

@Preview({
  title: "CardAdd"
})
@Entry
@Component
struct CardAddSelection {
  @State cardObject: CardObject = {} as CardObject
  @State selectedCardTypeName: string = ""

  constructor() {
    super()
    logger.debug("fromCard get form router params is: %s", JSON.stringify(this.cardObject))
  }

  aboutToAppear() {
    // init
    this.selectedCardTypeName = getContext(this).resourceManager.getStringSync($r('app.string.Card_Type_Anniversary'));
    this.cardObject.type = CardTypeEnum.Anniversary.valueOf()
  }

  build() {
    Column() {
      // 功能选项
      Row() {
        Image($r('app.media.reject2')).height(30).width(30).margin({ left: 16 }).onClick(() => {
          router.back()
        })
        Blank()
        Text($r('app.string.Card_AddCard')).height(30).width(100)
        Blank()
        Image($r('app.media.accept2')).height(30).width(30).margin({ right: 16 }).onClick(() => {
          logger.info("保存的卡片信息为: %{public}s", JSON.stringify(this.cardObject))
          // upload image
          let uploaded: Promise<string> = uploadFileRequest(this.cardObject.background, getContext())
          uploaded.then((uri) => {
            logger.info("上传图片[%{public}s]结果: [%{public}s]", this.cardObject.background, uploaded)
            this.cardObject.background = uri
            // add card item
            let added: Promise<boolean> = addCardRequest(this.cardObject)
            logger.info("实际保存的卡片信息为: %{public}s", JSON.stringify(this.cardObject))
            added.then( (yes) => {
              if(yes) {
                AlertDialog.show({
                  title: $r('app.string.Info'),
                  message: $r('app.string.Card_AddSuccess')
                })
                router.back()
              } else {
                AlertDialog.show({
                  title: $r('app.string.Warning'),
                  message: $r('app.string.Card_AddFailed')
                })
              }
            })
          })
        })
      }.height(50).width('100%').margin({ top: 10 })

      // 卡片类型选择
      Text(this.selectedCardTypeName)
        .height(40)
        .lineHeight(40)
        .width('100%')
        .fontWeight(FontWeight.Medium)
        .fontSize(23)
        .fontColor(Color.Grey)
        .textAlign(TextAlign.Center)
        .borderRadius(3)
        .backgroundColor('#eee')
        .onClick(() => {
          let rm = getContext(this).resourceManager
          TextPickerDialog.show({
            range: [
            rm.getStringSync($r('app.string.Card_Type_Empty')), // 0
            rm.getStringSync($r('app.string.Card_Type_Anniversary')), // 1
            rm.getStringSync($r('app.string.Card_Type_AnniversaryList')), // 2
            rm.getStringSync($r('app.string.Card_Type_Countdown')), // 3
            rm.getStringSync($r('app.string.Card_Type_CountdownList')), // 4
            rm.getStringSync($r('app.string.Card_Type_Progress')), // 5
            rm.getStringSync($r('app.string.Card_Type_ToDoList')), // 6
            ],
            value: this.selectedCardTypeName,
            onAccept: (v: TextPickerResult) => {
              this.selectedCardTypeName = v.value.toString()
              logger.debug("选择的卡片类型是: %{public}s, idx: %{public}d", this.selectedCardTypeName, v.index)
              switch (this.selectedCardTypeName) {
                case rm.getStringSync($r('app.string.Card_Type_Empty')):
                  this.cardObject.type = CardTypeEnum.Empty.valueOf()
                  break
                case rm.getStringSync($r('app.string.Card_Type_Anniversary')):
                  this.cardObject.type = CardTypeEnum.Anniversary.valueOf()
                  break
                case rm.getStringSync($r('app.string.Card_Type_AnniversaryList')):
                  this.cardObject.type = CardTypeEnum.AnniversaryList.valueOf()
                  break
                case rm.getStringSync($r('app.string.Card_Type_Countdown')):
                  this.cardObject.type = CardTypeEnum.Countdown.valueOf()
                  break
                case rm.getStringSync($r('app.string.Card_Type_CountdownList')):
                  this.cardObject.type = CardTypeEnum.CountdownList.valueOf()
                  break
                case rm.getStringSync($r('app.string.Card_Type_Progress')):
                  this.cardObject.type = CardTypeEnum.Progress.valueOf()
                  break
                case rm.getStringSync($r('app.string.Card_Type_ToDoList')):
                  this.cardObject.type = CardTypeEnum.ToDoList.valueOf()
                  break
              }
            }
          })
        })

      Flex({ justifyContent: FlexAlign.Center }) {
        // todo: 选择不同卡片
        if (this.cardObject.type == CardTypeEnum.Anniversary.valueOf()) {
          AnniversaryCardEdit({ cardObject: this.cardObject }).width(150).height(150)
            .margin(10)
        } else if (this.cardObject.type == CardTypeEnum.AnniversaryList.valueOf()) {

        } else if (this.cardObject.type == CardTypeEnum.Countdown.valueOf()) {

        } else {
          AnniversaryCardEdit({ cardObject: this.cardObject }).width(150).height(150)
            .margin(10)
        }
      }.margin({ top: 30 })

      Text(this.selectedCardTypeName)
        .height(40)
        .lineHeight(40)
        .width('100%')
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.Grey)
        .textAlign(TextAlign.Center)
    }.width('100%').height('100%')
  }
}