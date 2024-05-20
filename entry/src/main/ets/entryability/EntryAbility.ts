import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import distributedKVStore from '@ohos.data.distributedKVStore';

let kvManager;
let kvStore;

export default class EntryAbility extends UIAbility {


  onCreate(want, launchParam) {
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
      kvManager.getKVStore("index", options, function (err, store) {
        if(err) {
          hilog.error(0x0000, 'testTag', `Failed to get kvStore, code: ${err.code}, message: ${err.message}`);
          return
        }
        kvStore = store;
      });
      kvStore.get("main_number").then((data) => {
        hilog.info(0x0000, 'testTag', `Get stored main number is ${data}`)
      })
    } catch (e) {
      hilog.error(0x0000, 'testTag', `err: ${e}`)
    }
    hilog.info(0x0000, 'testTag', `get kvStore: %s`, kvStore)

    hilog.info(0x0000, 'testTag', '%{public}s', '首页 Ability onCreate');
  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', '首页 Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', '首页 Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', '首页 Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', '首页 Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '首页 %{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '首页 %{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '首页 %{public}s', 'Ability onBackground');
  }

}
