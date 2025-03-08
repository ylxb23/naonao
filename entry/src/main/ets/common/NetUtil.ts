import { Logger } from "./Logger";

const logger: Logger = new Logger('NetUtil')

export function enable(): boolean {
  // TODO: 默认离线
  logger.debug("Net mock to not enable.")
  return false;
}