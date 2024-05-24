import { AnniversaryCard } from '../view/card/AnniversaryCard'
import { CountdownListCard } from '../view/card/CountdownListCard'
import { CountdownCard } from '../view/card/CountdownCard'
import {
  AbsCard,
  AnniversaryCardItem,
  CountdownCardItem,
  CountdownListCardItem
} from '../viewmodel/card/Card'
import { Logger } from '../common/Logger'
import distributedObject from '@ohos.data.distributedDataObject';
import { CustomCardDataSource } from '../data/CardDataSource'

const logger: Logger = new Logger("Home")
const stored_cards_key = 'custom.stored_cards'
let dataObject: distributedObject.DataObject | null

@Preview({
  title: "Home"
})
@Component
export struct Home {
  birthdayList: CountdownListCardItem = new CountdownListCardItem('下一个生日', new Array(
    { name: '墨墨', date: new Date('2023-08-02') },
    { name: '蕊蕊', date: new Date('1993-06-17') },
    { name: '我呀', date: new Date('1994-09-25') },
    { name: '爷爷', date: new Date('1968-08-08') },
    { name: '奶奶', date: new Date('1968-09-23') }))
  yearEndCountdown: CountdownCardItem = new CountdownCardItem('距离过年', new Date('2025-01-01'))
  marryDate: AnniversaryCardItem = new AnniversaryCardItem('结婚已经', new Date('2022-03-03'))
  birthDate: AnniversaryCardItem = new AnniversaryCardItem('墨墨出生', new Date('2023-08-02'))
  workInDate: AnniversaryCardItem = new AnniversaryCardItem('已经入职', new Date('2023-04-24'))

  // 当前页面需要展示所有卡片列表
  @State cards: AbsCard[] = []

  mockInitCards() {
    this.cards.push(this.birthdayList)
    this.cards.push(this.yearEndCountdown)
    this.cards.push(this.marryDate, this.birthDate, this.workInDate)
  }

  aboutToAppear() {
    this.mockInitCards()
    logger.debug("获取到卡片列表: %s", JSON.stringify(this.cards))
    dataObject = distributedObject.create(getContext(this), this.cards)
    // TODO: 变更及保存
    dataObject.save('local').then((result) => {
      logger.info("卡片数据存储到本地，结果: %{public}s", result)
    }).catch((e) => {
      logger.error("卡片数据存储到本地异常, error code: %s, error message: %s", e.code, e.message)
    })
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
          } else {
            Text("没找到:" + item.type).fontSize(99).fontColor(Color.Red)
          }
        })
      }
    }.width('100%')
  }
}