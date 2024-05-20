export interface BirthdayCountdownItem {
  id: number
  username: string
  lastDays: number
  birthday: string
}

export const birthdayCountdownItemList: BirthdayCountdownItem[] = [
  { id: 1, username: '王大', lastDays: 18, birthday: '1993/03/17' },
  { id: 2, username: '李二', lastDays: 189, birthday: '1993/04/17' },
  { id: 3, username: '张三', lastDays: 281, birthday: '1993/06/17' },
  { id: 4, username: '薛五', lastDays: 301, birthday: '1993/12/17' },
]

export default class BirthdayListDataSource implements IDataSource {
  private list: BirthdayCountdownItem[] = []
  private listeners: DataChangeListener[] = []

  constructor(elements: BirthdayCountdownItem[]) {
    for (let index = 0; index < birthdayCountdownItemList.length; index++) {
      this.list.push(elements[index])
    }
  }

  public size(): number {
    return this.list.length
  }

  public get(i: number): BirthdayCountdownItem {
    return this.list[i]
  }

  public exist(id: number): boolean {
    for (let index = 0; index < birthdayCountdownItemList.length; index++) {
      const element = birthdayCountdownItemList[index];
      if(id == element.id) {
        return true;
      }
    }
    return false;
  }

  public add(idx: number, item: BirthdayCountdownItem): void {
    this.list.splice(idx, 0, item)
    this.notifyDataAdd(idx)
  }

  public push(item: BirthdayCountdownItem): void {
    this.list.push(item)
    this.notifyDataAdd(this.list.length - 1)
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener)
    if(pos > -1) {
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