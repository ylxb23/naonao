
import { AbsCard } from '../viewmodel/card/Card'
class BasicCardDataSource implements IDataSource {
  private listeners: DataChangeListener[] = []

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const idx = this.listeners.indexOf(listener)
    if (idx > -1) {
      this.listeners.splice(idx, 1)
    }
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener)
    }
  }

  notifyDataReload() {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataReloaded()
    })
  }

  notifyDataAdd(index: number) {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataAdd(index)
    })
  }

  notifyDataChange(index: number) {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataChange(index)
    })
  }

  notifyDataDelete(index: number) {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataDelete(index)
    })
  }

  notifyDataMove(from: number, to: number) {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataMove(from, to)
    })
  }
  getData(index: number) {
    throw new Error('Method not implemented.')
  }

  totalCount(): number {
    throw new Error('Method not implemented.')
  }
}

/**
 *
 */
class CustomCardDataSource extends BasicCardDataSource {
  cards: Array<AbsCard> = []

  constructor(cards: Array<AbsCard>) {
    super()
    this.cards = cards
  }

  getData(index: number) {
    return this.cards[index]
  }
  totalCount(): number {
    return this.cards.length
  }

  public addData(index: number) {
    this.cards.splice(index, 0)
    this.notifyDataAdd(index)
  }

  public pushData(card: AbsCard) {
    this.cards.push(card)
    this.notifyDataAdd(this.cards.length - 1)
  }

  public replaceData(result: Array<AbsCard>) {
    this.cards = result
    this.notifyDataReload()
  }
}