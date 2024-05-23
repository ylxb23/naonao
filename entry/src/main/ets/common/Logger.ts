import hilog from '@ohos.hilog'

export class Logger {
  private domain: number
  private tag: string
  private format: string = `%{public}s, %{public}s`

  constructor(tag: string) {
    this.tag = tag
    this.domain = 0x0000
  }

  isLoggable(level: hilog.LogLevel): boolean {
    return hilog.isLoggable(this.domain, this.tag, level)
  }

  debug(...args: any[]) {
    hilog.debug(this.domain, this.tag, this.format, args)
  }

  info(...args: any[]) {
    hilog.info(this.domain, this.tag, this.format, args)
  }

  warn(...args: any[]) {
    hilog.warn(this.domain, this.tag, this.format, args)
  }

  error(...args: any[]) {
    hilog.error(this.domain, this.tag, this.format, args)
  }

  fatal(...args: any[]) {
    hilog.fatal(this.domain, this.tag, this.format, args)
  }
}