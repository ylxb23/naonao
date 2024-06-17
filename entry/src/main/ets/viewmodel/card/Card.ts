import hilog from '@ohos.hilog'
import { nextAnniversaryDays } from '../../common/DateUtil'

export const DISPLAY_BIG_WIDTH = 360

export const DISPLAY_BIG_HEIGHT = 150

export const DISPLAY_BIG_LEFT_INFO_WIDTH = 130

export const DISPLAY_BIG_LEFT_INFO_HEIGHT = DISPLAY_BIG_LEFT_INFO_WIDTH

export const DISPLAY_BIG_RIGHT_LIST_WIDTH = 200

export const DISPLAY_BIG_RIGHT_LIST_HEIGHT = DISPLAY_BIG_LEFT_INFO_HEIGHT

export const DISPLAY_MIDDLE_WIDTH = DISPLAY_BIG_HEIGHT

export const DISPLAY_MIDDLE_HEIGHT = DISPLAY_MIDDLE_WIDTH

export const DISPLAY_SMALL_WIDTH = DISPLAY_MIDDLE_WIDTH

export const DISPLAY_SMALL_HEIGHT = DISPLAY_SMALL_WIDTH / 3

/**
 * 所有卡片共有的属性
 */
export abstract class AbsCard {
  public readonly type?: CardTypeEnum
  public size?: SizeEnum

  constructor(t: CardTypeEnum, s?: SizeEnum) {
    this.type = t
    if (s != undefined) {
      this.size = s
    }
  }
}

/**
 * 空卡片
 */
export class EmptyCardItem extends AbsCard {
  constructor() {
    super(CardTypeEnum.Empty)
  }
}

/**
 * 纪念日使用的数据结构
 */
export class AnniversaryCardItem extends AbsCard {
  title: string
  date: Date
  backgroundImgUri: string

  constructor(t: string, d: Date) {
    super(CardTypeEnum.Anniversary)
    this.title = t
    this.date = d
  }
}

export class NamedDateItem {
  name: string
  date: Date

  constructor(n: string, d: Date) {
    this.name = n
    this.date = d
  }
  /**
   * 计算得出，每种计时规则使用不同的算法得出，用于排序
   * 已经过去的天数
   */
  // private days: number
  /**
   * 计算得出：
   * 剩余时间的详细计数：年，月，日，时，分，秒
   */
  // detail: [number, number, number, number, number, number]
}

function compareAnniversaryDayCountdownTo(a: NamedDateItem, b: NamedDateItem, _of?: Date | undefined): number {
  let aVal = nextAnniversaryDays(a.date, _of)
  let bVal = nextAnniversaryDays(b.date, _of)
  return aVal - bVal
}

/**
 * 纪念日列表使用的数据结构
 */
export class AnniversaryListCardItem extends AbsCard {
  title: string
  list: NamedDateItem[]

  constructor(t: string, l: NamedDateItem[]) {
    super(CardTypeEnum.AnniversaryList)
    this.title = t
    this.list = l
  }
}

/**
 * 倒计时使用的数据结构
 */
export class CountdownCardItem extends AbsCard {
  title: string
  date: Date

  constructor(title: string, date: Date) {
    super(CardTypeEnum.Anniversary)
    this.title = title
    this.date = date
  }
}

/**
 * 倒计时列表使用的数据结构
 */
export class CountdownListCardItem extends AbsCard {
  title: string
  list: NamedDateItem[]

  constructor(title: string, list: NamedDateItem[]) {
    super(CardTypeEnum.CountdownList)
    this.title = title
    this.list = list
  }
}

/**
 * 获取纪念日最近的一个倒计时时间项
 * @returns
 */
export function getNextAnniversaryDayCountdownItem(item: CountdownListCardItem): NamedDateItem {
  if (item.list == undefined || item.list.length == 0) {
    return undefined
  }
  let now = new Date()
  item.list.find
  let sorted = item.list.sort((a, b) => {
    return compareAnniversaryDayCountdownTo(a, b, now)
  })
  hilog.debug(0x0000, "Card", "list size: %d, top: %s", item.list.length, JSON.stringify(sorted[0]))
  return sorted[0]
}

export function getSortedAnniversaryDayCountdownList(item: CountdownListCardItem): NamedDateItem[] {
  let now = new Date()
  return item.list.sort((a, b) => {
    return compareAnniversaryDayCountdownTo(a, b, now)
  })
}


/**
 * 卡片大小类型枚举
 */
enum SizeEnum {
  /**
   * 长x宽=360x150 大小
   */
  BIG,
  /**
   * 长x宽=150x150 大小
   */
  MIDDLE,
  /**
   * 长x宽=150x50 大小
   */
  SMALL
}
/**
 * 卡片类型枚举
 */
export enum CardTypeEnum {
  /**
   * 空卡片
   */
  Empty,
  /**
   * 纪念日卡片
   */
  Anniversary,
  /**
   * 纪念日列表卡片
   */
  AnniversaryList,
  /**
   * 倒计时卡片
   */
  Countdown,
  /**
   * 倒计时列表卡片
   */
  CountdownList,
  /**
   * 进度卡片
   * TODO: 还未进行
   */
  Progress,
  /**
   * 代办列表卡片
   * TODO: 还未进行
   */
  ToDoList,

}