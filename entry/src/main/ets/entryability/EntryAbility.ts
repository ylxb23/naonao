import UIAbility from '@ohos.app.ability.UIAbility';
import window from '@ohos.window';
import distributedKVStore from '@ohos.data.distributedKVStore';
import { Logger } from '../common/Logger';
import { BUNDLE_NAME } from '../common/Constants'

const logger: Logger = new Logger('EntryAbility')
let kvManager: distributedKVStore.KVManager;
let kvStore: distributedKVStore.SingleKVStore;

export default class EntryAbility extends UIAbility {


  onCreate(want, launchParam) {
    logger.debug("onCreate, want: %s, launchParam: %s", JSON.stringify(want), JSON.stringify(launchParam))
    let context = this.context
    const kvManagerConfig = {
      context: context,
      bundleName: 'com.zero.hm.naonao',
    }
    try {
      kvManager = distributedKVStore.createKVManager(kvManagerConfig);
      const options = {
        createIfMissing: true,
        encrypt: false,
        backup: false,
        autoSync: true,
        kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION,
        securityLevel: distributedKVStore.SecurityLevel.S2,
      };
      kvManager.getAllKVStoreId(BUNDLE_NAME, (err, data) => {
        if(err) {
          logger.error("getAllKVStoreId, err: %s", err)
          return
        }
        logger.info("getAllKVStoreId, data: %s", JSON.stringify(data))
      })

      kvManager.getKVStore("index", options, function (err, store) {
        if(err) {
          logger.error(`Failed to get kvStore, code: ${err.code}, message: ${err.message}`);
          return
        }
        kvStore = store as distributedKVStore.SingleKVStore;
        logger.debug("getKVStore: %s", JSON.stringify(store))
      });

      // 判断数据是否存在
      kvStore.put('main_number', 998).catch((reason) => {
        logger.error("put value(main_number=998) rejected: %s", reason)
      })

      kvStore.get("main_number").then((data) => {
        logger.info(`Get stored main number is ${data}`)
      })
    } catch (e) {
      logger.error(`kvStore undefined: ${e}`)
    }
    logger.info(`get kvStore: %s`, kvStore)

    logger.info('%{public}s', '首页 Ability onCreate');
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