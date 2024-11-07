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
  public sort?: number

  constructor(t: CardTypeEnum, s?: SizeEnum, o?: number) {
    this.type = t
    if (s != undefined) {
      this.size = s
    }
    if (o != undefined) {
      this.sort = o
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

  constructor(t: string, d: Date, img?: string) {
    super(CardTypeEnum.Anniversary)
    this.title = t
    this.date = d
    this.backgroundImgUri = img
  }
}

export class NamedDateItem {
  name: string
  date: Date
  avatar: string

  constructor(n: string, d: Date, a?: string) {
    this.name = n
    this.date = d
    this.avatar = a
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
  backgroundImgUri: string

  constructor(t: string, d: Date, img?: string) {
    super(CardTypeEnum.Countdown)
    this.title = t
    this.date = d
    this.backgroundImgUri = img
  }
}

/**
 * 倒计时列表使用的数据结构
 */
export class CountdownListCardItem extends AbsCard {
  title: string
  list: NamedDateItem[]
  backgroundImgUri: string

  constructor(title: string, list: NamedDateItem[], background?:string) {
    super(CardTypeEnum.CountdownList)
    this.title = title
    this.list = list
    this.backgroundImgUri = background
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
  Empty = 0,
  /**
   * 纪念日卡片
   */
  Anniversary = 1,
  /**
   * 纪念日列表卡片
   */
  AnniversaryList = 2,
  /**
   * 倒计时卡片
   */
  Countdown = 3,
  /**
   * 倒计时列表卡片
   */
  CountdownList = 4,
  /**
   * 进度卡片
   * TODO: 还未进行
   */
  Progress = 5,
  /**
   * 代办列表卡片
   * TODO: 还未进行
   */
  ToDoList = 6,
}


export class CardRequest {
  openid?: string
  operation?: string
  card?: CardObject
}
export class CardResponse {
  message?: string
  total?: number
  cards?: CardObject[]
  success?: string
}

export class CardObject {
  operation?: string
  sort?: number
  type?: number
  title?: string
  date?: string
  background?: string
  list?: NamedDateItemObject[]
  debug: number = 0 // 解决class类型mvvm属性内的属性变更导致的同步不及时问题，使最上层属性得到变更即可出发view的变更
}
export class NamedDateItemObject {
  idx: number = 0
  name?: string
  date?: string
  avatar?: string
}

export class CardRouterParam {
  operation: string
  card: AbsCard
}