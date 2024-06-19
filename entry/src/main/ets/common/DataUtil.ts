import { Logger } from './Logger';
import fs from '@ohos.file.fs';
import { randomLower } from './Tool';
import image from '@ohos.multimedia.image';
import relationalStore from '@ohos.data.relationalStore';
import {
  AbsCard,
  AnniversaryCardItem,
  AnniversaryListCardItem,
  CardTypeEnum,
  CountdownCardItem,
  CountdownListCardItem
} from '../viewmodel/card/Card';

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

/**
 * 卡片表格列
 */
const CARD_TABLE = "CARD_"
const CARD_TABLE_COLUMN_ID = "ID_"
const CARD_TABLE_COLUMN_ORDER = "ORDER_"
const CARD_TABLE_COLUMN_TYPE = "TYPE_"
const CARD_TABLE_COLUMN_DATA = "DATA_"

/**
 * 插入卡片到存储中
 * @param context
 * @param item
 */
export function insertCardItem(context, item: AbsCard): void {
  // 初始化db lite
  var liteDb: relationalStore.RdbStore;
  const STORE_CONFIG = {
    name: "naonao.db",
    securityLevel: relationalStore.SecurityLevel.S1
  }

  relationalStore.getRdbStore(context, STORE_CONFIG).then(async (rdbStore) => {
    logger.info("获取RdbStore成功");
    liteDb = rdbStore;

    // 表或未初始化，执行初始化表
    const SQL = `CREATE TABLE IF NOT EXISTS ${CARD_TABLE} (
                    ${CARD_TABLE_COLUMN_ID} INTEGER PRIMARY KEY AUTOINCREMENT,
                    ${CARD_TABLE_COLUMN_ORDER} INTEGER NOT NULL,
                    ${CARD_TABLE_COLUMN_TYPE} TEXT NOT NULL,
                    ${CARD_TABLE_COLUMN_DATA} TEXT NOT NULL)`;

    let execPromise = liteDb.executeSql(SQL);
    logger.info("执行表初始化...");
    await execPromise.then(async () => {
      await logger.info("执行创建表语句结束...");
    }).catch(async (err) => {
      await logger.error("执行创建表语句失败: %s", JSON.stringify(err));
    });

    let allTablesPromise = liteDb.querySql(".tables ;")
    await allTablesPromise.then((resultSet) => {
      logger.debug("所有列：%s", JSON.stringify(resultSet.columnNames));
      while(resultSet.goToNextRow()) {
        logger.debug("表有: %s", resultSet)
      }
    })

    // get max id
    let predicates = new relationalStore.RdbPredicates(CARD_TABLE);
    predicates.orderByDesc(CARD_TABLE_COLUMN_ID).limitAs(1);
    var maxId = 0;
    let resultSetPromise = liteDb.query(predicates, [CARD_TABLE_COLUMN_ID, CARD_TABLE_COLUMN_ORDER, CARD_TABLE_COLUMN_TYPE, CARD_TABLE_COLUMN_DATA])
    await resultSetPromise.then(async (resultSet: relationalStore.ResultSet) => {
      logger.info("查询卡片成功, size: %d, names: %s", resultSet.rowCount, resultSet.columnNames);
      if (resultSet.rowCount > 0) {
        resultSet.goToFirstRow();
        maxId = resultSet.getLong(resultSet.getColumnIndex(CARD_TABLE_COLUMN_ID));
        //
        logger.info("查询卡片成功: %s", JSON.stringify(resultSet));
        let cards = readCardItemListFromDbRow(resultSet);
        logger.info("获取所有卡片列表: %s", JSON.stringify(cards));
      }
      // 插入最新的
      let data = JSON.stringify(item);
      const columnItem = {
        CARD_TABLE_COLUMN_ID: maxId + 1,
        CARD_TABLE_COLUMN_ORDER: maxId + 1,
        CARD_TABLE_COLUMN_TYPE: item.type,
        CARD_TABLE_COLUMN_DATA: data
      }
      // 插入行
      let insertPromise = liteDb.insert("CARD", columnItem)
      await insertPromise.then((rowId) => {
        logger.info("卡片插入成功: rowId: %d, data: %s", rowId, data);
      }).catch((err) => {
        if (err) {
          logger.error("插入卡片失败, %d, %s", err.code, err.message);
          return;
        }
      });
    }).catch((err) => {
      if (err) {
        logger.error("查询卡片失败, %d, %s", err.code, err.message);
        return;
      }
    });
  }).catch((err) => {
    logger.error("获取RdbStore失败, %d, %s", err.code, err.message);
  });
}

function readCardItemListFromDbRow(resultSet: relationalStore.ResultSet): AbsCard[] {
  let list: Array<AbsCard> = [];
  if (resultSet.goToFirstRow()) {
    do {
      let type = resultSet.getLong(resultSet.getColumnIndex(CARD_TABLE_COLUMN_TYPE));
      let data = resultSet.getString(resultSet.getColumnIndex(CARD_TABLE_COLUMN_DATA));
      let card: AbsCard;
      switch (type) {
        case CardTypeEnum.Anniversary.valueOf():
          card = JSON.parse(data) as AnniversaryCardItem;
        case CardTypeEnum.AnniversaryList.valueOf():
          card = JSON.parse(data) as AnniversaryListCardItem;
        case CardTypeEnum.Countdown.valueOf():
          card = JSON.parse(data) as CountdownCardItem;
        case CardTypeEnum.CountdownList.valueOf():
          card = JSON.parse(data) as CountdownListCardItem;
        default:
          logger.error("未知卡片类型[type=%d]: %s", type, data);
      }
      if (card != undefined) {
        list.push(card);
      }
    } while (resultSet.goToNextRow());
  }
  return list;
}


// 加载所有卡片列表
export function loadAllCardItems(): AbsCard[] {


  return [];
}