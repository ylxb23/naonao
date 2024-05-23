import { AnniversaryCard } from '../view/card/AnniversaryCard'
import { CountdownListCard } from '../view/card/CountdownListCard'
import { CountdownCard } from '../view/card/CountdownCard'
import { AbsCard, AnniversaryCardItem, CountdownCardItem, CountdownListCardItem } from '../viewmodel/card/Card'
import { Logger } from '../common/Logger'
import distributedObject from '@ohos.data.distributedDataObject';

const logger: Logger = new Logger("Home")
const stored_cards_key = 'custom.stored_cards'
let distributedDataObject: distributedObject.DataObject | null

@Preview({
  title: "Home"
})
@Component
export struct Home {
  birthdayList: CountdownListCardItem = {
    title: '下一个生日',
    list: [
      { name: '墨墨', date: new Date('2023-08-02') },
      { name: '蕊蕊', date: new Date('1993-06-17') },
      { name: '我呀', date: new Date('1994-09-25') },
      { name: '爷爷', date: new Date('1968-08-08') },
      { name: '奶奶', date: new Date('1968-09-23') },
    ]
  }
  yearEndCountdown: CountdownCardItem = { title: '距离过年', date: new Date('2025-01-01') }
  marryDate: AnniversaryCardItem = { title: '结婚已经', date: new Date('2022-03-03') }
  birthDate: AnniversaryCardItem = { title: '墨墨出生', date: new Date('2023-08-02') }
  workInDate: AnniversaryCardItem = { title: '已经入职', date: new Date('2023-04-24') }

  // 当前页面需要展示所有卡片列表
  @State cards: AbsCard[] = []
  mockInitCards() {
    this.cards.push(this.birthdayList)
    this.cards.push(this.yearEndCountdown)
    this.cards.push(this.marryDate, this.birthDate, this.workInDate)
  }

  async aboutToAppear() {
    await this.mockInitCards()
    distributedDataObject = distributedObject.create(getContext(this), this.cards)
  }

  build() {
    Scroll() {
      Flex({ justifyContent: FlexAlign.SpaceBetween, wrap: FlexWrap.Wrap, alignContent: FlexAlign.SpaceEvenly }) {
        CountdownListCard({ info: this.birthdayList }).width(360).height(150)
          .margin(10)

        CountdownCard({ info: this.yearEndCountdown }).width(150).height(150)
          .margin(10)

        AnniversaryCard({ info: this.marryDate }).width(150).height(150)
          .margin(10)
        AnniversaryCard({ info: this.birthDate }).width(150).height(150)
          .margin(10)
        AnniversaryCard({ info: this.workInDate }).width(150).height(150)
          .margin(10)
      }
    }.width('100%')
  }
}