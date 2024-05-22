
/**
 * 所有卡片共有的属性
 */
abstract class AbsCard {
  public readonly type: CardTypeEnum
  public size: SizeEnum

  constructor(t: CardTypeEnum, s?: SizeEnum) {
    this.type = t
    if(s != undefined) {
      this.size = s
    }
  }
}

/**
 * 纪念日使用的数据结构
 */
export class AnniversaryCardItem extends AbsCard {
  title: string
  date: Date


  constructor(t: string, d: Date) {
    super(CardTypeEnum.Anniversary)
    this.title = t
    this.date = d
  }
}

export interface NamedDateItem {
  name: string
  date: Date
  /**
   * 计算得出：
   * 已经过去的天数
   */
  // days: number
  /**
   * 计算得出：
   * 剩余时间的详细计数：年，月，日，时，分，秒
   */
  // detail: [number, number, number, number, number, number]
}

/**
 * 纪念日列表使用的数据结构
 */
export class AnniversaryListCardItem extends AbsCard {
  title: string
  list: NamedDateItem[]

  constructor(t:string, l: NamedDateItem[]) {
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

  constructor(t: string, d: Date) {
    super(CardTypeEnum.Anniversary)
    this.title = t
    this.date = d
  }
}

/**
 * 倒计时列表使用的数据结构
 */
export class CountdownListCardItem extends AbsCard {
  title: string
  list: NamedDateItem[]

  constructor(t:string, l: NamedDateItem[]) {
    super(CardTypeEnum.CountdownList)
    this.title = t
    this.list = l
  }
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
enum CardTypeEnum {
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