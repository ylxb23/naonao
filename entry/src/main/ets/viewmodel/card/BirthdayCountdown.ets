
import { formatDate, lastDaysOfDate } from './Countdown';
/**
 * 展示在面板上的对象
 */
export interface BirthdayCountdownItem {
  id: number
  username: string
  lastDays: number
  birthday: string
}

/**
 * 原数据对象
 */
export interface BirthdayItem {
  id: number
  username: string
  birthday: Date
}

export const birthdayList: BirthdayItem[] = [
  { id: 1, username: '墨墨', birthday: new Date(2023, 8-1, 2) },
  { id: 2, username: '蕊蕊', birthday: new Date(1993, 6-1, 17) },
  { id: 3, username: '我的', birthday: new Date(1994, 9-1, 25) },
]

export function transferBirthdayItemList(list: BirthdayItem[]): BirthdayCountdownItem[] {
  return list.map((item, _idx, _list) => {return transferBirthdayItem(item)})
}

export function transferBirthdayItem(birthdayItem: BirthdayItem): BirthdayCountdownItem {
  const now = new Date();
  var birthday = new Date(birthdayItem.birthday)
  birthday.setFullYear(now.getFullYear())
  if (now.getTime() > birthday.getTime()) {
    // 今年生日已过，年份+1，计算到明年的天数
    birthday.setFullYear(now.getFullYear() + 1)
  }

  return {
    id: birthdayItem.id,
    username: birthdayItem.username,
    lastDays: lastDaysOfDate(birthday),
    birthday: formatDate(birthdayItem.birthday)
  }
}

export function sortByLastDays(a: BirthdayCountdownItem, b: BirthdayCountdownItem): number {
  return a.lastDays - b.lastDays;
}

export function sortBirthdayCountdownList(list: BirthdayCountdownItem[]): BirthdayCountdownItem[] {
  return list.sort((a, b) => {
    return sortByLastDays(a, b)
  })
}

export default class BirthdayCountdownDataSource implements IDataSource {
  private list: BirthdayCountdownItem[] = []
  private listeners: DataChangeListener[] = []

  constructor(elements: BirthdayItem[]) {
    for (let i = 0; i < elements.length; i++) {
      this.list.push(transferBirthdayItem(elements[i]))
    }
    this.list = sortBirthdayCountdownList(this.list)
  }

  public size(): number {
    return this.list.length
  }

  public get(i: number): BirthdayCountdownItem {
    return this.list[i]
  }

  public exist(id: number): boolean {
    for (let index = 0; index < this.list.length; index++) {
      if (id == this.list[index].id) {
        return true;
      }
    }
    return false;
  }

  public indexOf(id: number): number {
    for (let index = 0; index < this.list.length; index++) {
      if (id == this.list[index].id) {
        return index;
      }
    }
    return -1;
  }

  public add(idx: number, item: BirthdayCountdownItem): void {
    if(!this.exist(item.id)) {
      this.list.splice(idx, 0, item)
      this.list = sortBirthdayCountdownList(this.list)
      this.notifyDataAdd(this.indexOf(item.id))
    }
  }

  public push(item: BirthdayCountdownItem): void {
    if(!this.exist(item.id)) {
      this.list.push(item)
      this.list = sortBirthdayCountdownList(this.list)
      this.notifyDataAdd(this.indexOf(item.id))
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener)
    if (pos > -1) {
      this.listeners.splice(pos, 1)
    }
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      // 已经加入的就不用再加入了
      this.listeners.push(listener)
    }
  }

  getData(index: number) {
    return this.get(index)
  }

  totalCount(): number {
    return this.size()
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index)
    })
  }

  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded()
    })
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index)
    })
  }

  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index)
    })
  }

  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to)
    })
  }
}