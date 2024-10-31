import UIAbility from '@ohos.app.ability.UIAbility';
import window from '@ohos.window';
import { Logger } from '../common/Logger';
import relationalStore from '@ohos.data.relationalStore';
import { http } from '@kit.NetworkKit';

const logger: Logger = new Logger('EntryAbility')
export var sqlite: relationalStore.RdbStore;

export default class EntryAbility extends UIAbility {


  onCreate(want, launchParam) {
    logger.debug("onCreate, want: %s, launchParam: %s", JSON.stringify(want), JSON.stringify(launchParam))
    let context = this.context
    // const kvManagerConfig = {
    //   context: context,
    //   bundleName: 'com.zero.hm.naonao',
    // }
    // try {
    //   kvManager = distributedKVStore.createKVManager(kvManagerConfig);
    //   const options = {
    //     createIfMissing: true,
    //     encrypt: false,
    //     backup: false,
    //     autoSync: true,
    //     kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION,
    //     securityLevel: distributedKVStore.SecurityLevel.S2,
    //   };
    //   kvManager.getAllKVStoreId(BUNDLE_NAME, (err, data) => {
    //     if(err) {
    //       logger.error("getAllKVStoreId, err: %s", err)
    //       return
    //     }
    //     logger.info("getAllKVStoreId, data: %s", JSON.stringify(data))
    //   })
    //
    //   kvManager.getKVStore("index", options, function (err, store) {
    //     if(err) {
    //       logger.error(`Failed to get kvStore, code: ${err.code}, message: ${err.message}`);
    //       return
    //     }
    //     kvStore = store as distributedKVStore.SingleKVStore;
    //     logger.debug("getKVStore: %s", JSON.stringify(store))
    //   });
    //
    //   // 判断数据是否存在
    //   kvStore.put('main_number', 998).catch((reason) => {
    //     logger.error("put value(main_number=998) rejected: %s", reason)
    //   })
    //
    //   kvStore.get("main_number").then((data) => {
    //     logger.info(`Get stored main number is ${data}`)
    //   })
    // } catch (e) {
    //   logger.error(`kvStore undefined: ${e}`)
    // }
    // logger.info(`get kvStore: %s`, kvStore)


    // 初始化db lite
    const STORE_CONFIG = {
      name: "naonao.db",
      securityLevel: relationalStore.SecurityLevel.S1
    }
    relationalStore.getRdbStore(this.context, STORE_CONFIG).then((rdbStore) => {
      logger.info("获取RdbStore成功");
      sqlite = rdbStore;
      // sqlite.executeSql("DROP TABLE CARD IF EXISTS;").then(() => {
      //   logger.info("删除CARD表成功...");
      // }).catch((err) => {
      //   logger.warn("删除CARD表失败...")
      // });
    }).catch((err) => {
      logger.error("获取RdbStore失败, %d, %s", err.code, err.message);
    });
    logger.info('%{public}s', '首页 Ability onCreate');
    // 插入条目

    // 获取当前顺序最大的条目

    // http请求数据
    let url = "http://192.168.43.167:8080/cards/nwx_001"
    let httpRequest = http.createHttp()
    let httpRequestOptions : http.HttpRequestOptions = {
      method: http.RequestMethod.GET,
      header: { 'Content-Type': 'application/json' },
      readTimeout: 50000,
      connectTimeout: 50000
    }
    httpRequest.on("dataReceive", function(data) {
      AppStorage.setOrCreate("nwx_001-cards-pkg-size", data.byteLength)
    })
    httpRequest.requestInStream(url, httpRequestOptions)
    httpRequest.request(url, httpRequestOptions, function (err: Error, data: http.HttpResponse) {
      if(err != null) {
        logger.error("请求卡片列表失败")
      }
      if(data.responseCode == http.ResponseCode.OK) {
        logger.info("请求获取到卡片列表: %s", data.result)
        AppStorage.setOrCreate("nwx_001-cards", data.result)
      } else {
        logger.warn("请求卡片列表失败, code: %s", data.responseCode)
      }
    })
  }

  onDestroy() {
    logger.info('%{public}s', '首页 Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    logger.info('%{public}s', '首页 Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        logger.error('首页 Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      logger.info('首页 Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    logger.info('首页 %{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    logger.info('首页 %{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    logger.info('首页 %{public}s', 'Ability onBackground');
  }

}