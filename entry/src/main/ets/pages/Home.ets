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
} from '../viewmodel/card/Card'
import { Logger } from '../common/Logger'
import { EmptyCard } from '../view/card/EmptyCard'
import { loadAllCardItems } from '../common/DataUtil'

const logger: Logger = new Logger("Home")

@Preview({
  title: "Home"
})
@Component
export struct Home {
  birthdayList: CountdownListCardItem = new CountdownListCardItem('下一个生日', new Array(
    new NamedDateItem('墨墨', new Date('2023-08-02') ),
    new NamedDateItem('蕊蕊', new Date('1993-06-17') ),
    new NamedDateItem('我呀', new Date('1994-09-25') ),
    new NamedDateItem('老爸', new Date('1968-08-08') ),
    new NamedDateItem('老妈', new Date('1968-09-23') )))
  yearEndCountdown: CountdownCardItem = new CountdownCardItem('距离过年', new Date('2025-01-01'))
  marryDate: AnniversaryCardItem = new AnniversaryCardItem('结婚已经', new Date('2022-03-03'))
  birthDate1: AnniversaryCardItem = new AnniversaryCardItem('墨墨出生', new Date('2023-08-02'))
  birthDate2: AnniversaryCardItem = new AnniversaryCardItem('蕊蕊出生', new Date('1993-06-17'))
  birthDate3: AnniversaryCardItem = new AnniversaryCardItem('本人出生', new Date('1994-09-25'))
  birthDate4: AnniversaryCardItem = new AnniversaryCardItem('老爸出生', new Date('1968-08-08'))
  birthDate5: AnniversaryCardItem = new AnniversaryCardItem('老妈出生', new Date('1968-09-23'))
  workInDate: AnniversaryCardItem = new AnniversaryCardItem('已经入职', new Date('2023-04-24'))

  // 当前页面需要展示所有卡片列表
  @State cards: AbsCard[] = []

  async mockInitCards() {

    this.cards.push(this.birthdayList)
    this.cards.push(this.yearEndCountdown)
    this.cards.push(this.birthDate1)
    this.cards.push(this.birthDate2)
    this.cards.push(this.birthDate3)
    this.cards.push(this.birthDate4)
    this.cards.push(this.birthDate5)
    this.cards.push(this.marryDate)
    this.cards.push(this.workInDate)
    let allCardPromise: Promise<AbsCard[]> = loadAllCardItems();
    await allCardPromise.then((all: AbsCard[]) => {
      logger.info("获取到所有卡片列表: %s", JSON.stringify(all));
      for(let item of all) {
        this.cards.push(item);
      }
    })
    this.cards.push(new EmptyCardItem())
  }

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
        case CardTypeEnum.AnniversaryList.valueOf():
          if(element.title != undefined && element.date != undefined && element.list != undefined) {
            // this.cards.push(new )
          }
          break;
        case CardTypeEnum.Countdown.valueOf():
          if(element.title != undefined && element.date != undefined) {
            this.cards.push(new CountdownCardItem(element.title, new Date(element.date)))
          }
          break;
        case CardTypeEnum.CountdownList.valueOf():
          if(element.title != undefined && element.date != undefined && element.list != undefined) {
            let countdowns: NamedDateItem[] = []
            // TODO: 转换
            this.cards.push(new CountdownListCardItem(element.title, countdowns))
          }
          break;
          default :
            logger.warn("未知卡片类型: %d", element.type)
      }

    }
  }

  aboutToAppear() {
    // this.mockInitCards()
    this.getCardsFromStorage()
    logger.debug("获取到卡片列表: %s", JSON.stringify(this.cards))
    // TODO: 变更及保存
    // dataObject.save('local').then((result) => {
    //   logger.info("卡片数据存储到本地，结果: %{public}s", result)
    // }).catch((e) => {
    //   logger.error("卡片数据存储到本地异常, error code: %s, error message: %s", e.code, e.message)
    // })
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