import router from '@ohos.router';

import { Logger } from '../../common/Logger';
import { AnniversaryCardEdit } from '../../view/card/AnniversaryCard';
import { AbsCard, AnniversaryCardItem, CardObject,
  CardRouterParam,
  CardTypeEnum, CountdownCardItem,
  CountdownListCardItem,
  NamedDateItem,
} from '../../viewmodel/card/Card';
import { doAddCardRequest } from '../../common/HttpUtil';
import { CountdownCardEdit } from '../../view/card/CountdownCard';
import { CountdownListCardEdit } from '../../view/card/CountdownListCard';
import { CommonHttpResponse } from '../../common/Common';
import { formatDate } from '../../common/DateUtil';
import { OperationType_Add, OperationType_Update, UID } from '../../common/Constants';


const logger: Logger = new Logger("CardAddSelection")

@Preview({
  title: "CardAdd"
})
@Entry
@Component
struct CardAddSelection {
  private fromCard?: AbsCard
  @State cardObject: CardObject = {list: [], debug: 0} as CardObject
  @State selectedCardTypeName: string = ""

  aboutToAppear() {
    let param: CardRouterParam = router.getParams() as CardRouterParam
    this.fromCard = param.card
    this.cardObject.operation = param.operation
    logger.debug("获取到参数: %{public}s", JSON.stringify(router.getParams()))
    logger.debug("参数转成卡片: %{public}s", JSON.stringify(this.fromCard))
    if(param.operation == OperationType_Update) {
      switch (this.fromCard.type?.valueOf()) {
        case CardTypeEnum.Anniversary.valueOf():
          let cardAnni: AnniversaryCardItem = this.fromCard as AnniversaryCardItem
          this.cardObject.type = CardTypeEnum.Anniversary.valueOf()
          this.cardObject.title = cardAnni.title
          this.cardObject.background = cardAnni.backgroundImgUri
          this.cardObject.date = formatDate(new Date(cardAnni.date))
          this.selectedCardTypeName = getContext().resourceManager.getStringSync($r('app.string.Card_Type_Anniversary'))
          break
        case CardTypeEnum.Countdown.valueOf():
          let cardCd: CountdownCardItem = this.fromCard as CountdownCardItem
          this.cardObject.type = CardTypeEnum.Countdown.valueOf()
          this.cardObject.title = cardCd.title
          this.cardObject.background = cardCd.backgroundImgUri
          this.cardObject.date = formatDate(new Date(cardCd.date))
          this.selectedCardTypeName = getContext().resourceManager.getStringSync($r('app.string.Card_Type_Countdown'))
          break
        case CardTypeEnum.CountdownList.valueOf():
          let cardCdList: CountdownListCardItem = this.fromCard as CountdownListCardItem
          this.cardObject.type = CardTypeEnum.CountdownList.valueOf()
          this.cardObject.title = cardCdList.title
          this.cardObject.background = cardCdList.backgroundImgUri
          this.cardObject.list = []
          for(let i=0; i<cardCdList.list.length; i++) {
            const item: NamedDateItem = cardCdList.list[i]
            this.cardObject.list.push({idx: i, name: item.name, date: formatDate(new Date(item.date)), avatar: item.avatar})
          }
          this.selectedCardTypeName = getContext().resourceManager.getStringSync($r('app.string.Card_Type_CountdownList'))
          break
        default :
          logger.warn("未知的来源卡片类型: %{public}s", this.fromCard.type?.valueOf())
          break;
      }
    } else if(param.operation == OperationType_Add) {
      // init
      this.selectedCardTypeName = getContext().resourceManager.getStringSync($r('app.string.Card_Type_CountdownList'))
      this.cardObject.type = CardTypeEnum.CountdownList.valueOf()
      this.cardObject.sort = 1
    }

  }

  build() {
    Column() {
      // 功能选项
      Row() {
        Image($r('app.media.reject2')).height(30).width(30).margin({ left: 16 }).onClick(() => {
          router.back()
        })
        Blank()
        Text(this.cardObject.operation == OperationType_Add ? $r('app.string.Card_AddCard') : $r('app.string.Card_UpdateCard'))
          .height(30).width(100)
        Blank()
        Image($r('app.media.accept2')).height(30).width(30).margin({ right: 16 }).onClick(() => {
          logger.info("保存的卡片信息为: %{public}s", JSON.stringify(this.cardObject))
          let addResult: Promise<CommonHttpResponse> = doAddCardRequest(this.cardObject, getContext())
          addResult.then((res) => {
            logger.info("实际保存的卡片信息为: %{public}s", JSON.stringify(this.cardObject))
            if(res.status == 200) {
              AlertDialog.show({
                title: $r('app.string.Info'),
                message: this.cardObject.operation == OperationType_Add ? $r('app.string.Card_AddSuccess') : $r('app.string.Card_UpdateSuccess')
              })
              router.back()
            } else {
              logger.warn("保存卡片失败, 卡片信息: %{public}s", JSON.stringify(this.cardObject))
              AlertDialog.show({
                title: $r('app.string.Warning'),
                subtitle: this.cardObject.operation == OperationType_Add ? $r('app.string.Card_AddFailed') : $r('app.string.Card_UpdateFailed'),
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
        .fontSize(20)
        .fontColor(Color.Grey)
        .textAlign(TextAlign.Center)
        .borderRadius(3)
        .backgroundColor('#eee')
        .onClick(() => {
          let rm = getContext(this).resourceManager
          TextPickerDialog.show({
            range: [
            rm.getStringSync($r('app.string.Card_Type_Anniversary')), // 1
            rm.getStringSync($r('app.string.Card_Type_AnniversaryList')), // 2
            rm.getStringSync($r('app.string.Card_Type_Countdown')), // 3
            rm.getStringSync($r('app.string.Card_Type_CountdownList')), // 4
            rm.getStringSync($r('app.string.Card_Type_Progress')), // 5
            rm.getStringSync($r('app.string.Card_Type_ToDoList')), // 6
            ],
            value: this.selectedCardTypeName?.toString(),
            onAccept: (v: TextPickerResult) => {
              this.selectedCardTypeName = v.value.toString()
              logger.debug("选择的卡片类型是: %{public}s, idx: %{public}d", this.selectedCardTypeName, v.index)
              switch (this.selectedCardTypeName) {
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

      TextInput({text: this.cardObject.sort+"", placeholder: $r('app.string.Card_InputSort')})
        .width('100%')
        .type(InputType.Number)
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.Grey)
        .textAlign(TextAlign.Center).onChange((v) => {
          this.cardObject.sort = Number.parseInt(v)
      })
    }.width('100%').height('100%')
  }
}