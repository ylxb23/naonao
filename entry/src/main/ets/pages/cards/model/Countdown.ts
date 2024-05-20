export interface DateItem {
  id: number
  title: string
  date: Date
}


const DAY_OF_TIME_MILLISECOND = 24 * 3600 * 1000;

export function lastDaysOfDate(date: Date): number {
  const now = new Date();
  return Math.ceil((date.getTime() - now.getTime()) / DAY_OF_TIME_MILLISECOND)
}

export function daysPassedOfDate(date: Date): number {
  const now = new Date();
  return Math.floor((now.getTime() - date.getTime()) / DAY_OF_TIME_MILLISECOND)
}

export function formatDateTime(date: Date): string {
  return `${date.getFullYear()}/${date.getMonth() + 1}/${date.getDate()} ${date.getHours()}:${date.getMinutes()}:${date.getSeconds()}`
}

export function formatDate(date: Date): string {
  return `${date.getFullYear()}/${date.getMonth() + 1}/${date.getDate()}`
}