/// Types.mo

module {

    public type CanisterId = Text;
    public type Message = Text;
    public type Timestamp = Int;
    public type UserPrincipal = Text;
    
    public type LogLevel = Text;
    // public type LogLevel = {
    //     #deb;
    //     #info;
    //     #warn;
    //     #error;
    // };

    /// 日志数据结构
    public type Log = {
        msg: Message;
        level: LogLevel;
        canisterId : CanisterId;    /// 记录日志所在的Canister id
        caller: UserPrincipal;   // 调用者的Principal
        // actionName: ?Text;   // 方法名
        // args: ?[Text];       // 方法参数列表
        happenAt: Timestamp;    // 日志时间
    };

    
}
