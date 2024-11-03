import fs from '@ohos.file.fs';
import { Logger } from './Logger';
import { Context } from '@kit.AbilityKit';

const logger: Logger = new Logger('FileUtil')

function extractFileName(filePath: string): string {
  // 使用正则表达式匹配文件名
  // 这个正则表达式假设文件路径以 '/' 或 '\\' 分隔，并且文件名不包含这些字符
  const fileNameMatch = filePath.match(/[^\/\\]+$/);
  // 如果匹配成功，返回匹配到的文件名，否则返回空字符串
  return fileNameMatch ? fileNameMatch[0] : '';
}

function extractFileType(filePath: string): string {
  // 使用正则表达式匹配文件扩展名
  // 这个正则表达式假设文件扩展名以 '.' 开头，并且位于路径的末尾
  const fileTypeMatch = filePath.match(/\.([^\.]+)$/);
  // 如果匹配成功，返回匹配到的文件扩展名（不包括点），否则返回空字符串
  return fileTypeMatch ? fileTypeMatch[1] : '';
}

export function copyToTempDir(src: string, context: Context): string {
  let srcFile: fs.File = fs.openSync(src, fs.OpenMode.READ_ONLY)
  logger.info("打开源文件: %{public}s, fd: %{public}d", src, srcFile.fd);
  let filename = extractFileName(src)
  let dstUri: string = context.tempDir + "/" + filename
  logger.info("临时拷贝文件,源: %{public}s, 目标: %{public}s", src, dstUri)
  let dstFile: fs.File = fs.openSync(dstUri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
  fs.copyFileSync(srcFile.fd, dstFile.fd, 0)
  logger.info("复制文件目标文件: %{public}s, fd: %{public}d", dstUri, dstFile.fd);
  fs.close(dstFile);
  fs.close(srcFile);
  return dstUri
}
