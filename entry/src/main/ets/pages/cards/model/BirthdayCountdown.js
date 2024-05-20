export const birthdayCountdownItemList = [
    { id: 1, username: '王大', lastDays: 18, birthday: '1993/03/17' },
    { id: 2, username: '李二', lastDays: 189, birthday: '1993/04/17' },
    { id: 3, username: '张三', lastDays: 281, birthday: '1993/06/17' },
    { id: 4, username: '薛五', lastDays: 301, birthday: '1993/12/17' },
];
export default class BirthdayListDataSource {
    constructor(elements) {
        this.list = [];
        this.listeners = [];
        for (let index = 0; index < birthdayCountdownItemList.length; index++) {
            this.list.push(elements[index]);
        }
    }
    size() {
        return this.list.length;
    }
    get(i) {
        return this.list[i];
    }
    exist(id) {
        for (let index = 0; index < birthdayCountdownItemList.length; index++) {
            const element = birthdayCountdownItemList[index];
            if (id == element.id) {
                return true;
            }
        }
        return false;
    }
    add(idx, item) {
        this.list.splice(idx, 0, item);
        this.notifyDataAdd(idx);
    }
    push(item) {
        this.list.push(item);
        this.notifyDataAdd(this.list.length - 1);
    }
    unregisterDataChangeListener(listener) {
        const pos = this.listeners.indexOf(listener);
        if (pos > -1) {
            this.listeners.splice(pos, 1);
        }
    }
    registerDataChangeListener(listener) {
        if (this.listeners.indexOf(listener) < 0) {
            // 已经加入的就不用再加入了
            this.listeners.push(listener);
        }
    }
    getData(index) {
        return this.get(index);
    }
    totalCount() {
        return this.size();
    }
}
//# sourceMappingURL=BirthdayCountdown.js.map