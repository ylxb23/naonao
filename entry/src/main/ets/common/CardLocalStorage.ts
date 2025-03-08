import { AbsCard,
  cardItemList2CardObjectList,
  CardObject,
  cardObject2CardItem,
  cardObjectList2CardItemList,
  CardRequest,
  CardTypeEnum} from "../viewmodel/card/Card";
import { CommonHttpResponse } from "./Common";
import { UID } from "./Constants";
import { Logger } from "./Logger";

const logger: Logger = new Logger('CardLocalStorage')

/**
 * 添加或更新卡片
 * @param request
 * @returns
 */
export function upsertCardLocal(request: CardRequest): CommonHttpResponse {
  logger.debug("插入卡片内容到本地: %{public}s", JSON.stringify(request))
  let commonRes: CommonHttpResponse = {status: 0}
  if(!cardContentCheck(request)) {
    logger.error("添加的卡片信息不准确，无法添加成功")
    commonRes.status = 400
    commonRes.message = "卡片信息不全"
    return
  }
  let cards: AbsCard[] = loadCardsFromStorage()
  let exists: boolean = false
  for(let idx = 0; idx<cards.length; idx ++) {
    // 如果在列表中，则替换它
    let item = cards[idx];
    if(item.getName() == request.card?.title) {
      cards[idx] = cardObject2CardItem(request.card)
      exists = true
      break
    }
  }
  if(!exists) {
    cards.push(cardObject2CardItem(request.card))
  }
  // 重新排序
  cards = cards.sort((a, b) => {
    let av = a.sort == undefined ? 0 : a.sort
    let bv = b.sort == undefined ? 0 : b.sort
    return av - bv
  })
  // 回写到本地存储
  let data = JSON.stringify(cardItemList2CardObjectList(cards))
  storageCardLocal(data)
  commonRes.status = 200
  commonRes.message = JSON.stringify(cards)
	return commonRes;
}

export function deleteCardLocal(request: CardRequest): CommonHttpResponse {
  let commonRes: CommonHttpResponse = {status: 0}
  let cards: AbsCard[] = loadCardsFromStorage()
  let newCards: AbsCard[] = []
  let exists: boolean = false
  for(let idx = 0; idx<cards.length; idx ++) {
    // 如果在列表中，则替换它
    let item = cards[idx];
    if(item.getName() != request.card?.title) {
      newCards.push(cards[idx])
    } else {
      exists = true
    }
  }
  // 回写到本地存储

  let data = JSON.stringify(cardItemList2CardObjectList(cards))
  storageCardLocal(data)
  commonRes.message = exists? "已删除": "本来就没有"
  return commonRes
}


export function storageCardLocal(data: string | undefined) {
  PersistentStorage.persistProp(UID + "-cards", data)
}
export function getCardLocal(): string|undefined {
  return AppStorage.get(UID + "-cards")
}

export function loadCardsFromStorage(): AbsCard[] {
  let resCards: AbsCard[] = []
  let stored: string|undefined = getCardLocal()
  logger.debug("从本地存储中获得卡片信息: %{public}s", stored)
  if(stored == undefined) {
    logger.info("从本地存储中获取到卡片列表为空...")
    return resCards
  }
  let res: CardObject[] = JSON.parse(stored)
  resCards = cardObjectList2CardItemList(res)
  if(resCards == undefined || resCards.length == 0) {
    logger.info("从本地存储中获取到卡片列表为空...")
    return resCards
  }
  resCards = resCards.sort((a, b) => {
    let av = a.sort == undefined ? 0 : a.sort
    let bv = b.sort == undefined ? 0 : b.sort
    return av - bv
  })
  logger.debug("获取到卡片列表: %{public}s", JSON.stringify(resCards))
  return resCards
}



function cardContentCheck(card: CardRequest) : boolean {
  // 必需内容
  if (card.openid == "") {
    logger.error("用户ID不允许为空")
    return false
  }
  if (card.card.type < 0 || card.card.type > 6) {
    logger.error("卡片类型不允许为空")
    return false
  }
  if (card.card.title == "") {
    logger.error("卡片标题不允许为空")
    return false
  }
  // 如果是删除卡片，则无需其他检查
  if (card.operation == "delete") {
    return true
  }
  // 卡片类型内容检查
  switch (card.card.type) {
    case CardTypeEnum.Empty.valueOf():
      break
    case CardTypeEnum.Anniversary.valueOf(), CardTypeEnum.Countdown.valueOf():
      if (card.card.date?.length < 1) {
        logger.error("日期不允许为空")
        return false
      }
      if (card.card.background == "") {
        logger.error("背景图不允许为空")
        return false
      }
    case CardTypeEnum.AnniversaryList.valueOf(), CardTypeEnum.CountdownList.valueOf():
      if (card.card.background == "") {
        logger.error("背景图不允许为空")
        return false
      }
      if (card.card.list?.length < 1) {
        logger.error("列表不允许为空")
        return false
      }
      for (let idx=0; idx < card.card.list?.length; idx++ ) {
        let item = card.card.list[idx]
        if (item.name == "") {
          logger.error("列表项标题不允许为空")
          return false
        }
        if (item.date == "") {
          logger.error("列表项日期不允许为空")
          return false
        }
        if (item.avatar == "") {
          logger.error("列表项图片不允许为空")
          return false
        }
      }
  }
  return true
}