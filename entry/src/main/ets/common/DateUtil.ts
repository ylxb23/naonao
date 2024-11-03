
const DAY_OF_TIME_MILLISECOND = 24 * 3600 * 1000;

export function nextAnniversaryDays(date: Date, _of?: Date | null): number {
  if(_of == null) {
    _of = new Date()
  }
  let _date = new Date(date)
  _date.setHours(23, 59, 59, 999);  // 当天最后时间点
  _of.setHours(23, 59, 58, 999);  // 当天最后时间点

  _date.setFullYear(_of.getFullYear())
  if (_of.getTime() > _date.getTime()) {
    // 今年生日已过，年份+1，计算到明年的天数
    _date.setFullYear(_of.getFullYear() + 1)
  }
  return Math.floor((_date.getTime() - _of.getTime()) / DAY_OF_TIME_MILLISECOND)
}


export function lastDaysOfDate(date: Date): number {
  const now = new Date();
  return Math.ceil((date.getTime() - now.getTime()) / DAY_OF_TIME_MILLISECOND)
}

export function daysPassedOfDate(date: Date): number {
  const now = new Date();
  return Math.floor((now.getTime() - date.getTime()) / DAY_OF_TIME_MILLISECOND)
}

export function formatDateTime(date: Date): string {
  return `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()} ${date.getHours()}:${date.getMinutes()}:${date.getSeconds()}`
}

export function formatDate(date: Date): string {
  return `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}`
}