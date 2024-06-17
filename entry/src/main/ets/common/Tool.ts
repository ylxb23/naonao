

/**
 * 判断年份是否为闰年
 * @param year
 * @returns
 */
export function isLeapYear(year: number): boolean {
  return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
}

const CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz"

/**
 * 随机字符串
 * @param length
 * @returns
 */
export function random(length: number): string {
  var res = "";
  if(length < 1) {
    return res;
  }
  for(var i=0; i<length; i++) {
    res += CHARS.charAt(Math.floor(Math.random() * CHARS.length) % CHARS.length);
  }
  return res;
}
/**
 * 随机大写字符串
 * @param length
 * @returns
 */
export function randomUpper(length: number): string {
  return random(length).toLocaleUpperCase()
}
/**
 * 随机小写字符串
 * @param length
 * @returns
 */
export function randomLower(length: number): string {
  return random(length).toLocaleLowerCase()
}