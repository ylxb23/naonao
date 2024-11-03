import hilog from '@ohos.hilog'

export class Logger {
  private domain: number
  private tag: string

  constructor(tag: string) {
    this.tag = tag
    this.domain = 0x0000
  }

  isLoggable(level: hilog.LogLevel): boolean {
    return hilog.isLoggable(this.domain, this.tag, level)
  }

  debug(format: string, ...args: any[]) {
    hilog.debug(this.domain, this.tag, format, args)
  }

  info(format: string, ...args: any[]) {
    hilog.info(this.domain, this.tag, format, args)
  }

  warn(format: string, ...args: any[]) {
    hilog.warn(this.domain, this.tag, format, args)
  }

  error(format: string, ...args: any[]) {
    hilog.error(this.domain, this.tag, format, args)
  }

  fatal(format: string, ...args: any[]) {
    hilog.fatal(this.domain, this.tag, format, args)
  }
}