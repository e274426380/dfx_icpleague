/// Logger.mo

import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import List "mo:base/List";
import Time "mo:base/Time";

import Sequence "mo:sequence/Sequence";

import Types "./Types";

/// 通用的日志服务，单例actor object，可以被其他canister引用。
/// 不能是actor class，否则被依赖时编译会报错.
/// Logger提供通用的deb(motoko中debug貌似是保留字，用deb代替之)、info、warn、error方法
/// 日志最大数量是100W条，超过后删除最旧的日志，确保日志数量不会超过100W，100W的数字由Canister只能使用4G内存，假设每条记录是1kb
actor Logger {

    type Log = Types.Log;
    type LogLevel = Types.LogLevel;
    type CanisterId = Types.CanisterId;
    type Message = Types.Message;
    type UserPrincipal = Types.UserPrincipal;

    type Sequence<X> = Sequence.Sequence<X>;
    
    /// 日志记录数容量为1,000,000条，超过会自动删掉时间最久的的10000条
    let LOG_CAPACITY = 1000000;
    let LOG_AUTO_DELETE_NUM = 10000;

    stable var logs = Sequence.empty<Log>();
    stable var idGenerator: Nat = 0;
    stable var logCount :  Nat = 0;


    let append = Sequence.defaultAppend();

    /// -------- Query  ----------- ///
    /// Canister健康检查
    public query func healthcheck() : async Bool { true };

    /// 获取最新的日志
    public query func latest() : async ?Log {
        let log = Sequence.peekFront<Log>(logs);
        log
    };

    /// 获取日志总数，通过日志计算数据集记录数，比较低效
    public query func countLogTotal() : async Nat {
        countCurrentTotal()
    };

    /// 获取最新的num条日志
    public query func take(num: Nat) : async Sequence<Log> {
        Sequence.split<Log>(logs, num).0
    }; 

    /// 按日志级别返回前n条记录
    public query func findByLevel(level: LogLevel, n: Nat) : async [Log] {
        findBy(logs, n, func (l: Log) : Bool { l.level == level })
    };

    /// 按产生日志的canister返回前n条记录
    public query func findByCanister(canisterId: CanisterId, n: Nat) : async [Log] {
        findBy(logs, n, func (l: Log) : Bool { l.canisterId == canisterId })
    };

    /// 按日志的前端调用者caller返回前n条记录
    public query func findByCaller(caller: UserPrincipal, n: Nat) : async [Log] {
        findBy(logs, n, func (l: Log) : Bool { l.caller == caller })
    };

    /// -------- Update ----------- ///
    public func deb(msg: Text, cansiterId: CanisterId, caller: UserPrincipal) : async () {
        write(msg, "debug", cansiterId, caller);
    };

    public func info(msg: Text, cansiterId: CanisterId, caller: UserPrincipal) : async () {
        write(msg, "info", cansiterId, caller);
    };

    public func warn(msg: Text, canisterId: CanisterId, caller: UserPrincipal) : async () {
        write(msg, "warn", canisterId, caller);
    };

    public func error(msg: Text, canisterId: CanisterId, caller: UserPrincipal) : async () {
        write(msg, "error", canisterId, caller);
    };
    
    /// 删除最久的日志，按指定数量删除
    public func deleteOldestLog(n: Nat) : async () {
        deleteOldestLog_(n)
    };

    func write(msg: Text, level: Text, canisterId: CanisterId, caller: UserPrincipal) {
        let log: Log = {
            logId = Nat.toText(idGenerator);
            msg = msg;
            level = level;
            happenAt = Time.now();
            canisterId = canisterId;
            caller = caller;
        };
        write_(log);
    };

    func write_(log: Log) {
        Debug.print("logger: writing log .......");
        logs := append<Log>(Sequence.make(log), logs);
        logCount += 1;
        idGenerator += 1;
        Debug.print("logger: writed completed ........");

        if (Nat.sub(countCurrentTotal(), LOG_CAPACITY) >= LOG_AUTO_DELETE_NUM) {
            Debug.print("logger: deleting the oldest log " # Nat.toText(LOG_AUTO_DELETE_NUM));
            deleteOldestLog_(LOG_AUTO_DELETE_NUM);
            Debug.print("logger: deleted the oldest log " # Nat.toText(LOG_AUTO_DELETE_NUM));
        }
    };

    func findBy(logs_: Sequence<Log>, n: Nat, filter: (Log) -> Bool) : [Log] {
        let iter = Sequence.iter<Log>(logs, #fwd);

        let b = Buffer.Buffer<Log>(0);
        var counter = 0;

        while (counter < n) {
            let logOpt = iter.next();
            switch (logOpt) {
                case (?log) {
                    if (filter(log)) {
                        b.add(log);
                        counter += 1;
                    };
                };
                case null {
                    // do nothing
                };               
            }
        };

        b.toArray()
    };

    /// 辅助方法，删除最久的日志，按指定数量删除
    func deleteOldestLog_(n: Nat) {
        var counter = 0;
        var tempLogs: Sequence<Log> = logs;

        while (counter < n) {
            let pbo = Sequence.popBack(tempLogs);
            switch (pbo) {
                case (?pb) {
                    tempLogs := pb.0;
                    counter += 1;
                    // 日志总数减1
                    logCount -= 1;
                };
                case null {
                    counter := n;
                };
            }
            
        };

        logs := tempLogs;
    };

    func countCurrentTotal(): Nat {
        logCount
    };


};