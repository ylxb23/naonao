import { Logger } from './Logger';
import fs from '@ohos.file.fs';
import { randomLower } from './Tool';
import image from '@ohos.multimedia.image';

let logger: Logger = new Logger("DataUtil");

export function copyPickedFile(srcUri: string | undefined, dstDir: string): string | undefined {
  let dstUri = dstDir + "/cards";
  fs.access(dstUri, (exists) => {
    if (!exists) {
      fs.mkdir(dstUri);
    }

    dstUri += "/" + randomLower(32);
    logger.debug("目标文件路径将为: %s", dstUri);
    fs.open(srcUri, fs.OpenMode.READ_ONLY, (err, srcFile: fs.File) => {
      if (err) {
        logger.error("打开源文件失败, message: %s, code: %d", err.message, err.name);
      } else {
        logger.info("打开源文件: %s, fd: %d", srcUri, srcFile.fd);
        fs.open(dstUri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE, (err, dstFile: fs.File) => {
          if (err) {
            logger.error("创建本地文件失败, message: %s, name: %d", err.message, err.name);
          } else {
            logger.info("打开目标文件: %s, fd: %d", dstUri, dstFile.fd);
            fs.copyFile(srcFile.fd, dstFile.fd, 0)
              .then(() => {
                logger.debug("文件复制成功, dstFile fd: %d", dstFile.fd);
                fs.close(dstFile);
                fs.close(srcFile);
                return dstUri;
              }).catch((err) => {
              logger.warn("图片复制失败, message: %s, name: %d", err.message, err.code);
            });
          }
        });
      }
    });
  });
  return undefined;
}

export function loadDiskImageToPixelMap(uri: string): image.PixelMap | undefined {
  var res: image.PixelMap
  let imgFile: fs.File = fs.openSync(uri, fs.OpenMode.READ_ONLY)
  logger.debug("打开图片文件: uri: %s, fd: %d", uri, imgFile.fd);
  image.createImageSource(imgFile.fd).createPixelMap().then((v) => {
    res = v;
  }).catch((err) => {
    logger.error("加载图片失败: %s, %s", err.name, err.message);
    res = undefined;
  })
  return res;
}

