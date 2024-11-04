import { AnniversaryCard } from '../view/card/AnniversaryCard'
import { CountdownListCard } from '../view/card/CountdownListCard'
import { CountdownCard } from '../view/card/CountdownCard'
import {
  AbsCard,
  AnniversaryCardItem,
  CardObject,
  CardResponse,
  CardTypeEnum,
  CountdownCardItem,
  CountdownListCardItem,
  EmptyCardItem,
  NamedDateItem,
  NamedDateItemObject,
} from '../viewmodel/card/Card'
import { Logger } from '../common/Logger'
import { EmptyCard } from '../view/card/EmptyCard'

const logger: Logger = new Logger("Home")

@Preview({
  title: "Home"
})

@Entry
@Component
export struct Home {
  // 当前页面需要展示所有卡片列表
  @State cards: AbsCard[] = []

  getCardsFromStorage() {
    let stored: string | undefined = AppStorage.get("nwx_001-cards")
    logger.debug("从本地存储中获得卡片信息: %{public}s", stored)
    if(stored == undefined) {
      logger.info("从本地存储中获取到卡片列表为空...")
      return
    }
    let res: CardResponse = JSON.parse(stored)
    let cards = res.cards
    if(cards == undefined || cards.length == 0) {
      logger.info("从本地存储中获取到卡片列表为空...")
      return
    }
    for (let index = 0; index < cards.length; index++) {
      const element: CardObject = cards[index];
      switch (element.type) {
        case CardTypeEnum.Anniversary.valueOf():
          if(element.title != undefined && element.date != undefined) {
            this.cards.push(new AnniversaryCardItem(element.title, new Date(element.date), element.background))
          }
        break;
        case CardTypeEnum.Countdown.valueOf():
          if(element.title != undefined && element.date != undefined) {
            this.cards.push(new CountdownCardItem(element.title, new Date(element.date), element.background))
          }
          break;
        case CardTypeEnum.CountdownList.valueOf():
          if(element.title != undefined && element.date != undefined && element.list != undefined) {
            let countdowns: NamedDateItem[] = []
            for (let j = 0; j < element.list.length; j++) {
              const item: NamedDateItemObject = element.list[j];
              if(item.name != undefined && item.date != undefined && item.avatar != undefined) {
                countdowns.push(new NamedDateItem(item.name, new Date(item.date), item.avatar))
              }
            }
            this.cards.push(new CountdownListCardItem(element.title, countdowns, element.background))
          }
          break;
          default :
            logger.warn("未知卡片类型: %d", element.type)
      }
    }
  }

  aboutToAppear() {
    this.getCardsFromStorage()
    logger.debug("获取到卡片列表: %s", JSON.stringify(this.cards))
    if(this.cards.length == 0) {
      this.cards.push(new EmptyCardItem())
    }
  }

  build() {
    Scroll() {
      Flex({ justifyContent: FlexAlign.SpaceBetween, wrap: FlexWrap.Wrap, alignContent: FlexAlign.SpaceEvenly }) {
        ForEach(this.cards, (item: AbsCard, _id) => {
          if (item instanceof AnniversaryCardItem) {
            AnniversaryCard({ info: item as AnniversaryCardItem }).width(150).height(150)
              .margin(10)
          } else if (item instanceof CountdownCardItem) {
            CountdownCard({ info: item as CountdownCardItem }).width(150).height(150)
              .margin(10)
          } else if (item instanceof CountdownListCardItem) {
            CountdownListCard({ info: item as CountdownListCardItem }).width(360).height(150)
              .margin(10)
          } else if(item instanceof EmptyCardItem) {
            EmptyCard().width(360).height(150)
              .margin(10)
          } else {
            Text("没找到:" + item.type).fontSize(99).fontColor(Color.Red)
          }
        })
      }
    }.width('100%').height('100%')
  }
}