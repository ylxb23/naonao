import { AnniversaryCard } from '../view/card/AnniversaryCard'
import { CountdownListCard } from '../view/card/CountdownListCard'
import { CountdownCard } from '../view/card/CountdownCard'
import {
  AbsCard,
  AnniversaryCardItem,
  CountdownCardItem,
  CountdownListCardItem,
  EmptyCardItem,
} from '../viewmodel/card/Card'
import { Logger } from '../common/Logger'
import { EmptyCard } from '../view/card/EmptyCard'
import { loadCardsFromStorage } from '../common/CardLocalStorage'

const logger: Logger = new Logger("Home")

@Preview({
  title: "Home"
})

@Entry
@Component
export struct Home {
  // 当前页面需要展示所有卡片列表
  @State cards: AbsCard[] = []

  reloadCards(): void {
    this.cards = loadCardsFromStorage()
    logger.debug("HOME获取到卡片列表: %{public}s", JSON.stringify(this.cards))
    if(this.cards.length == 0) {
      this.cards.push(new EmptyCardItem())
    }
  }

  aboutToReuse(): void {
    logger.debug("aboutToReuse")
  }

  aboutToRecycle(): void {
    logger.debug("aboutToRecycle")
  }

  onPageShow(): void {
    logger.debug("onPageShow")
    this.reloadCards()
  }

  aboutToAppear() {
    logger.debug("aboutToAppear")
    this.reloadCards()
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