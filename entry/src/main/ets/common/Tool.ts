

/**
 * 判断年份是否为闰年
 * @param year
 * @returns
 */
export function isLeapYear(year: number): boolean {
  return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
}
