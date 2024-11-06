import router from '@ohos.router';

import { Logger } from '../../common/Logger';
import { AnniversaryCardEdit } from '../../view/card/AnniversaryCard';
import { AbsCard, CardObject, CardResponse, CardTypeEnum,
} from '../../viewmodel/card/Card';
import { addCardRequest, doAddCardRequest, uploadFileRequest } from '../../common/HttpUtil';
import { CountdownCardEdit } from '../../view/card/CountdownCard';
import { CountdownListCardEdit } from '../../view/card/CountdownListCard';
import { CommonHttpResponse } from '../../common/Common';


const logger: Logger = new Logger("CardAddSelection")

@Preview({
  title: "CardAdd"
})
@Entry
@Component
struct CardAddSelection {
  private card?: AbsCard
  @State cardObject: CardObject = {} as CardObject
  @State selectedCardTypeName: string = ""

  constructor() {
    super()
    logger.debug("fromCard get form router params is: %s", JSON.stringify(this.cardObject))
    this.card = router.getParams() as AbsCard
  }

  aboutToAppear() {
    // init
    this.selectedCardTypeName = getContext(this).resourceManager.getStringSync($r('app.string.Card_Type_CountdownList'));
    this.cardObject.type = CardTypeEnum.CountdownList.valueOf()
    this.cardObject.sort = 1
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
          let addResult: Promise<CommonHttpResponse> = doAddCardRequest(this.cardObject, getContext())
          addResult.then((res) => {
            logger.info("实际保存的卡片信息为: %{public}s", JSON.stringify(this.cardObject))
            if(res.status == 200) {
              router.back({url: "/pages/Home", params: {refresh: true}})
              // 保存卡片内容到Storage
              AlertDialog.show({
                title: $r('app.string.Info'),
                message: $r('app.string.Card_AddSuccess')
              })
            } else {
              AlertDialog.show({
                title: $r('app.string.Warning'),
                subtitle: $r('app.string.Card_AddFailed'),
                message: res.message
              })
            }
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

        AnniversaryCardEdit({ cardObject: this.cardObject }).width(150).height(150)
          .margin(10).visibility(this.cardObject.type == CardTypeEnum.Anniversary.valueOf() ? Visibility.Visible : Visibility.None)
        CountdownCardEdit({ cardObject: this.cardObject }).width(150).height(150)
          .margin(10).visibility(this.cardObject.type == CardTypeEnum.Countdown.valueOf() ? Visibility.Visible : Visibility.None)
        CountdownListCardEdit({ cardObject: this.cardObject }).width(300).height(150)
          .margin(10).visibility(this.cardObject.type == CardTypeEnum.CountdownList.valueOf() ? Visibility.Visible : Visibility.None)

      }.margin({ top: 30 }).id("editPanel")

      TextInput({text: this.cardObject.sort + "", placeholder: $r('app.string.Card_InputSort')})
        .height(40)
        .lineHeight(40)
        .width('100%')
        .type(InputType.Number)
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.Grey)
        .textAlign(TextAlign.Center)
    }.width('100%').height('100%')
  }
}