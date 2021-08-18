
import Array "mo:base/Array";
import Bool "mo:base/Bool";
import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import Hash "mo:base/Hash";
import HashMap "mo:base/HashMap";
import Int "mo:base/Int";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Option "mo:base/Option";
import Order "mo:base/Order";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Time "mo:base/Time";
import Text "mo:base/Text";
import Trie "mo:base/Trie";

import Access "Access";
import Param "Param";
import Rel "Rel";
import RelObj "RelObj";
import State "State";

import Repository "./Repository";
import Types "./Types";
import Utils "./Utils";

import Logger "canister:log_service";
import PhotoService "canister:photo_service";

/// Dapp服务Canister，对外提供相应API
shared(msg) actor class Aggregate() = this {
    
    type Result<V, E> = Result.Result<V, E>;
    type HashMap<K, V> = HashMap.HashMap<K, V>;

    type Database<K, V> = Types.Database<K, V>;

    /// Dapp Types alias
    type DappId = Types.DappId;
    type DappProfile = Types.DappProfile;
    type Category = Types.Category;
    type Detail = Types.Detail;
    type DappStatus = Types.StatusEnum;
    type DappStatistics = Types.DappStatistics;
    type DappStatisticsOp = Types.DappStatisticsOp;
    type DappStatisticsItem = Types.DappStatisticsItem;

    type DappDetail = Types.DappDetail;

    type DappPage = Types.DappPage;

    type Error = Types.Error;
    type DappResult = Result.Result<DappStatistics, Error>;
    
    type DappDB = Database<DappId, DappProfile>;
    
    type DappStatisticsDB = Database<DappId, DappStatistics>;

    type DappRepository = Repository.Repository<DappId, DappStatistics>;

    /// User
    type UserId = Types.UserId;
    type UserPrincipal = Types.UserPrincipal;
    type UserPic = Types.UserPic;
    type UserProfile = Types.UserProfile;
    type UserSession = Types.UserSession;
    type UserDB = Database<UserPrincipal, UserProfile>;
    type UserPicDB = Database<UserPrincipal, UserPic>;
    type UserRepository = Repository.Repository<UserPrincipal, UserProfile>;
    type UserPicRepository = Repository.Repository<UserPrincipal, UserPic>;

    /// 点赞
    type Rel<X, Y> = RelObj.RelObj<X, Y>;
    type DappLikeRel = Rel<DappId, UserPrincipal>;
    type LikeDB = (Trie.Trie2D<DappId, UserPrincipal, ()>, Trie.Trie2D<UserPrincipal, DappId, ()>);

    type ShareId = Types.ShareId;
    type DappShare = Types.DappShare;
    type ShareDB = Database<ShareId, DappShare>;
    type ShareRepository = Repository.Repository<ShareId, DappShare>;

    /// 图片
    type PictureId = Types.PictureId;
    type Picture = Types.Picture;
    type PictureBin = Types.PictureBin;

    /// 权限相关
    type AccessEvent = Access.AccessEvent;

    /// 应用状态，保存在内存中，非持久存储
    type StateMem = State.StateMem;
    type StateShared = State.StateShared;
    
    /// Constants
    let STATUS_DISABLE = Types.STATUS_DISABLE;
    let STATUS_ENABLE = Types.STATUS_ENABLE;
    let STATUS_PENDING = Types.STATUS_PENDING;

    /// the Canister owner 
    let owner_ = Principal.toText(msg.caller);

    /// ID Generator
    stable var idGenerator : Nat = 1;

    var canisterIdOpt: ?Text = null;
    func getCanisterId() : Text {
        switch (canisterIdOpt) {
            case (?cid) cid ; 
            case (_) {               
                let cid = Principal.toText(Principal.fromActor(this));
                canisterIdOpt := ?cid;
                cid
            };
        }
    };
    
    /// 辅助方法，获取所有Dapp的总数
    func countDappTotal_(dappStatsDB_: DappStatisticsDB) : Nat {
        Trie.size<DappId, DappStatistics>(dappStatsDB_)
    };
    
    /// User DB and Repository
    stable var userDB : UserDB = Trie.empty<UserPrincipal, UserProfile>();
    let userRepository : UserRepository = Repository.Repository<UserPrincipal, UserProfile>();
    stable var userPicDB: UserPicDB = Trie.empty<UserPrincipal, UserPic>();
    let userPicRepository : UserPicRepository = Repository.Repository<UserPrincipal, UserPic>();

    /// 总用户数
    func countUserTotal_(userDB_ : UserDB) :  Nat {
        Trie.size<UserPrincipal, UserProfile>(userDB_)
    };

    /// DappStatistics Database
    stable var dappStatsDB: DappStatisticsDB = Trie.empty<DappId, DappStatistics>();

    /// Dapp和Owner关系，权限控制用
    var dappOwnerMap = HashMap.fromIter<DappId, UserPrincipal>(
        Iter.map<(DappId, DappStatistics), (DappId, UserPrincipal)>(
            Utils.iter<DappId, DappStatistics>(dappStatsDB), func (dappId: DappId, ds: DappStatistics) : (DappId, UserPrincipal) {
                (dappId, ds.profile.owner)
            }), countDappTotal_(dappStatsDB), Utils.dappEq, Hash.hash
    );

    // Dapp CRUD operation
    let dappRepository : DappRepository = Repository.Repository<DappId, DappStatistics>();

    /// dapp-user relation
    // let textPairEqual = (Text.equal, Text.equal);
    // let textPairHash = (Text.hash, Text.hash);
    let dappUserPairEqual = Types.natTextPairEqual;
    let dappUserPairHash = Types.natTextPairHash;

    /// 分享数据,不停的追加，同一用户可以多次分享同一个dapp，类似日志
    stable var shareDB : ShareDB = Trie.empty<ShareId, DappShare>();
    let shareRepository = Repository.Repository<ShareId, DappShare>();

    /// 点赞数据的持久存储
    stable var likeDB : LikeDB = (Trie.empty(), Trie.empty());

    /// 辅助方法， 获取点赞数据的临时存储，使用持久存储数据初始化
    func likeDBToRel(likeDB_ : LikeDB) : DappLikeRel {
        let likeMem : DappLikeRel = RelObj.RelObj(dappUserPairHash, dappUserPairEqual);
        let rel_ : Rel.Rel<DappId, UserPrincipal> = {
            forw = likeDB_.0;
            back = likeDB_.1;
            hash = dappUserPairHash;
            equal = dappUserPairEqual;
        };
        likeMem.setRel(rel_);

        likeMem
    };

    /// 整个应用的临时存储，重启需要从持久化存储中加载
    var stateMem : StateMem = State.init(owner_, dappOwnerMap, likeDBToRel(likeDB));

    /// 查看当前应用的状态，只有admin才能访问
    public query(msg) func displayState() : async Result<StateShared, Error> {
        let caller = Principal.toText(msg.caller);
        let ae = accessCheck(caller, #admin, #all);

        validAndProcess(ae, func () : Result<StateShared, Error> {
            let res = State.stateToShare(stateMem);
            #ok(res)
        })

    };

    /// Canister Upgrades 
    /// Canister停止前把非stable转成stable保存到内存中
    system func preupgrade() {
        let rel = stateMem.dappLikes.getRel();
        likeDB := (rel.forw, rel.back);
    };

    system func postupgrade() {
        likeDB := (Trie.empty(), Trie.empty());
    };

    /// ---------------------- public API ------------------------ ///
    public query func testArray() : async [(Text, Text)] {
        let res = Array.make<(Text, Text)>(("James", "Lakers"));
        let res2 = Array.append<(Text, Text)>(res, Array.make<(Text, Text)>(("twitter", "https://twitter.com/james")));
        res2
    };

    // public query func testHashMap() : async HashMap.HashMap<Nat, Nat> {
    //     HashMap.fromIter<Nat, Nat>(Iter.map<Nat, (Nat, Nat)>(Iter.range(1, 10), func (x: Nat): (Nat, Nat) { (x, x) }))
    // };

    /// 服务健康检测API
    /// Returns:
    ///     如果服务正常，返回true
    public query func healthcheck() : async Bool { true };

    
    /// 最新还没应用的id序列号, 比已经保存的记录大1
    public query func nextId() : async Nat { idGenerator };

    /// 返回本Canister的Controller
    public query func owner() : async Text {
        owner_
    };

    public shared query func admin() : async Text {
        stateMem.access.getAdmin()
    };

    /// 测试问候语
    public shared(msg) func greet(name: Text) : async Result<Text, Error> {
        let caller = Principal.toText(msg.caller);
        let ae = accessCheck(caller, #view, #pubView);
        
        ignore log(ae, caller);

        validAndProcess(ae, func () : Result<Text, Error> {
            let message = "恭喜您，" # Utils.toLowerCase(name) # "! \n欢迎光临ICPLeague!";
            Debug.print(message);
            
            #ok(message)
        })
        
    };

    /// 管理功能
    /// 脚本模式下的时间模式，按用整数模拟
    public shared(msg) func scriptTimeTick() : async Result<(), Error> {
        let caller = Principal.toText(msg.caller);
        let ae = accessCheck(caller, #admin, #all);
        ignore log(ae, caller);

        validAndProcess(ae, func (): Result<(), Error> {  
            assert (timeMode == #script);
            scriptTime := scriptTime + 1;
            #ok(())
        })
        
    };

    /// 重置时间模式和StateMem, 不建议使用
    public shared(msg) func reset( mode : { #ic ; #script : Int } ) : async Result<(), Error> {
        let caller = Principal.toText(msg.caller);
        let ae = accessCheck(caller, #admin, #all);
        ignore log(ae, caller);

        validAndProcess(ae, func (): Result<(), Error> {  
            reset_(mode);
            #ok(())
        })
    };

    /// 设置时间模式
    public shared(msg) func setTimeMode( mode : { #ic ; #script : Int } ) : async Result<(), Error> {
        let caller = Principal.toText(msg.caller);
        let ae = accessCheck(caller, #admin, #all);
        ignore log(ae, caller);

        validAndProcess(ae, func (): Result<(), Error> {  
            setTimeMode_(mode);
            #ok(())    
        })
    };


    /// --------------- User Query --------------- ///
    /// 总用户数
    public query func countUserTotal() : async Nat {
        countUserTotal_(userDB)
    };

    /// 获取用户信息
    public query(msg) func getUser(userPrincipal: UserPrincipal) : async Result<?UserProfile, Error> {
        let caller = Principal.toText(msg.caller);     

        let ae = accessCheck(caller, #update, #user userPrincipal);

        validAndProcess(ae, func() : Result<?UserProfile, Error> {
            #ok(getUser_(userDB, userPrincipal))
        })
    };

    /// 获取自己的用户信息
    public query(msg) func getSelf() : async Result<?UserProfile, Error> {
        let caller = Principal.toText(msg.caller);     

        let ae = accessCheck(caller, #view, #user caller);

        validAndProcess(ae, func() : Result<?UserProfile, Error> {
            #ok(getUser_(userDB, caller))
        })
    };

    /// 获取用户头像
    public query func getUserAvatar(userPrincipal: UserPrincipal) : async ?UserPic {
        getUserPic_(userPicDB, userPrincipal)
    };

    /// 获取自己头像
    public query func getSelfAvatar() : async ?UserPic {
        let caller = Principal.toText(msg.caller);     
        getUserPic_(userPicDB, caller)
    };


    /// --------------- User Update -------------- ///
    /// 用户注册，如果用户存在，返回存在的用户名
    public shared(msg) func registerUser(username: Text) : async Result<Text, Error> {

        let caller = Principal.toText(msg.caller);     

        let ae = accessCheck(caller, #create, #user caller);

        ignore log(ae, caller);

        validAndProcess(ae, func (): Result<Text, Error> {
            let name = Utils.toLowerCase(username);

            if (not Utils.validUsername(name)) {
                return #err(#invalidUsername);
            };

            switch (getUser_(userDB, caller)) {
                case (?u) {
                    Debug.print("The user principal: " # caller # " is already exists!");
                    let existsName = u.username;
                    #err(#userAlreadyExists existsName)
                };
                case (_) {

                    switch (findOneUserByName_(userDB, name)) {
                        case (?_) {
                            Debug.print("The username: " # name # " is already exists!");
                            #err(#usernameAlreadyExists)
                        };
                        case (_) {
                            let userId = getIdAndIncrementOne();
                            let currentTime = Time.now();
                            let newProfile : UserProfile = {
                                userId = userId;
                                principal = caller;
                                username = name;
                                status = STATUS_ENABLE;
                                createdBy = caller;
                                createdAt = currentTime;
                            };
                            userDB := updateUser_(userDB, newProfile);
                            // stateMem.access.
                            #ok(name)
                        };
                    }
                    
                };
            }
        })
        
    };

    /// 修改用户名
    public shared(msg) func modifyUsername(newName: Text) : async Result<Bool, Error> {
        let name = Utils.toLowerCase(newName);

        if (not Utils.validUsername(name)) {
            return #err(#invalidUsername);
        };

        let caller = Principal.toText(msg.caller);

        let ae = accessCheck(caller, #update, #user caller);

        ignore log(ae, caller);

        validAndProcess(ae, func (): Result<Bool, Error> {
            switch (getUser_(userDB, caller)) {
                case (?u) {
                    let newUser = {
                        userId = u.userId;
                        principal = u.principal;
                        username = name;
                        status = u.status;
                        createdBy = u.createdBy;
                        createdAt = u.createdAt;
                    };

                    userDB := updateUser_(userDB, newUser);
                    #ok(true)
                };
                case (null) {
                    #err(#userNotFound)
                };
            }
        })

    };

    /// 禁用用户
    public func disableUser(userPrincipal: UserPrincipal) : async Result<Bool, Error> {
        
        let caller = Principal.toText(msg.caller);

        let ae = accessCheck(caller, #admin, #user userPrincipal);

        ignore log(ae, caller);
        
        validAndProcess(ae, func (): Result<Bool, Error> {
            switch (getUser_(userDB, userPrincipal)) {
                case (?u) {
                    
                    let newUser = {
                        userId = u.userId;
                        principal = u.principal;
                        username = u.username;
                        status = STATUS_DISABLE;
                        createdBy = u.createdBy;
                        createdAt = u.createdAt;
                    };

                    userDB := updateUser_(userDB, newUser);
                    #ok(true)
                };
                case (_) {
                    Debug.print("The user: " # userPrincipal # " is not found");
                    #err(#userNotFound)
                };
            }
        })
        
    };

    /// 启用用户
    public func enableUser(userPrincipal: UserPrincipal) : async Result<Bool, Error> {
        
        let caller = Principal.toText(msg.caller);

        let ae = accessCheck(caller, #admin, #user userPrincipal);

        ignore log(ae, caller);

        validAndProcess(ae, func (): Result<Bool, Error> {
            switch (getUser_(userDB, userPrincipal)) {
                case (?u) {
                    
                    let newUser = {
                        userId = u.userId;
                        principal = u.principal;
                        username = u.username;
                        status = STATUS_ENABLE;
                        createdBy = u.createdBy;
                        createdAt = u.createdAt;
                    };

                    userDB := updateUser_(userDB, newUser);
                    #ok(true)
                };
                case (_) {
                    Debug.print("The user: " # userPrincipal # " is not found");
                    #err(#userNotFound)
                };
            }
        })
        
    };

    /// 用户登录
    public func login(userPrincipal: UserPrincipal) : async Result<UserSession, Error> {
        // TODO
        #err(#userNotFound)
    };

    /// 用户登出
    public func logout(userPrincipal: UserPrincipal) : async Result<Bool, Error> {
        // TODO
        #ok(true)
    }; 

    /// 上传用户头像
    public shared(msg) func uploadUserAvatar(pic: Picture, picBin: PictureBin) : async Result<PictureId, Error> {
        let caller = Principal.toText(msg.caller);

        let ae = accessCheck(caller, #update, #user caller);

        ignore log(ae, caller);

        let avatarOpt = await PhotoService.createPic(pic, picBin, caller # "'s avatar", "", caller);

        validAndProcess(ae, func (): Result<PictureId, Error> {
            
            switch (avatarOpt) {
                case (#ok(pid)) { 
                    let userPic : UserPic = { principal = caller; pictureId = pid };
                    let (newDB, _) = userPicRepository.update(userPicDB, userPic, Utils.keyOfUser(caller), Utils.userEq);
                    userPicDB := newDB;

                    #ok(pid) 
                };
                case (#err(_))  { 
                    Debug.print(caller # " upload the avatar failed");
                    #err(#uploadPicFailed) 
                };
            }
        })
        
    };  

    /// 删除用户头像
    public func deleteSelfAvatar() : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);

        let ae = accessCheck(caller, #update, #user caller);

        ignore log(ae, caller);

        validAndProcess(ae, func (): Result<Bool, Error> {
            let (newDB, _) = userPicRepository.delete(userPicDB, Utils.keyOfUser(caller), Utils.userEq);
            userPicDB := newDB;
            #ok(true)
        })
    }; 



    /// --------------- Dapp Query --------------- ///

    /// 查询Dapp总数
    /// Returns:
    ///     返回Dapp的总数，不包含已经删除的Dapp
    public query func countDappTotal() : async Nat {
        countDappTotal_(dappStatsDB)
    };

    /// 获取指定的DappProfile及行为统计,包含点赞数，分享数，打赏数，评论数
    /// Args:
    ///     |dappId|   需要获取的Dapp对应的id
    /// Returns:
    ///     如果找到对应的Dapp，返回?Dapp，否则返回null
    public query func getDapp(dappId: DappId) : async ?DappStatistics {
        getDapp_(dappStatsDB, dappId)
    };

    /// 获取指定的Dapp详情，包含点赞数，分享数，打赏数，评论内容
    /// Args:
    ///     |dappId|   需要获取的Dapp对应的id
    /// Returns:
    ///     如果找到对应的Dapp，返回?Dapp，否则返回null
    public query func getDappDetail(dappId: DappId) : async ?DappDetail {
        let dsOpt = getDapp_(dappStatsDB, dappId);
        let likes: [UserPrincipal] = findUserLikeByDapp_(dappId);
        let shares: [DappShare] = findShareByDapp_(dappId);

        Option.map<DappStatistics, DappDetail>(dsOpt, func (ds) : DappDetail {
            {
                dappStats = ds;
                likes = likes;
                shares = shares;
            }
        })

    };

    /// 分页查询Dapp，按创建时间结果忽略status的Dapp
    /// Args:
    ///     |pageSize|  每页记录数
    ///     |pageNum|   页码，从0开始，0表示第一页
    /// Returns:
    ///     包含DappProfile记录的分页表示，例如页码，每页记录数，注意：页码，从0开始，0表示第一页,只返回可用状态的Dapp
    public query func pageDappIgnoreStatus(pageSize: Nat, pageNum: Nat) : async DappPage {       
        page_(dappStatsDB, pageSize, pageNum, Utils.compareDappByLatest )       
    };

    /// 分页查询Dapp，按创建时间结果只包含enable的Dapp
    /// Args:
    ///     |pageSize|  每页记录数
    ///     |pageNum|   页码，从0开始，0表示第一页
    /// Returns:
    ///     包含DappProfile记录的分页表示，例如页码，每页记录数，注意：页码，从0开始，0表示第一页,只返回可用状态的Dapp
    public query func pageDapp(pageSize: Nat, pageNum: Nat) : async DappPage {       
        let onlyEnables : DappStatisticsDB = findDappBy(dappStatsDB, func (k, v) : Bool { v.profile.status == STATUS_ENABLE });
        page_(onlyEnables, pageSize, pageNum, Utils.compareDappByLatest )       
    };

    /// 分页查询Dapp，按点赞数倒序排序，点赞数多排在前面，结果只包含enable的Dapp
    public query func pageDappByLikeCount(pageSize: Nat, pageNum: Nat) : async DappPage {       
        let onlyEnables :  DappStatisticsDB = findDappBy(dappStatsDB, func (k, v) : Bool { v.profile.status  == STATUS_ENABLE });
        page_(onlyEnables, pageSize, pageNum, Utils.compareDappByLike )       
    };

    /// 查询指定Dapp所有者名下的DappProfile，分页查询Dapp
    /// Args:
    ///     |owner|     指定的用Dapp所有者
    ///     |pageSize|  每页记录数
    ///     |pageNum|   页码，从0开始，0表示第一页
    /// Returns:
    ///     包含DappProfile记录的分页表示，例如页码，每页记录数，注意：页码，从0开始，0表示第一页
    public query func pageDappByOwner(owner: UserPrincipal, pageSize: Nat, pageNum: Nat) : async DappPage {
        let dappsOfOwner : DappStatisticsDB = findDappBy(dappStatsDB, func (k, v) : Bool { v.profile.owner == owner and v.profile.status  == STATUS_ENABLE });
        
        page_(dappsOfOwner, pageSize, pageNum, Utils.compareDappByLatest)
        
    };

    /// 按分类分页查询Dapp
    /// Args:
    ///     |category|  Dapp的分类
    ///     |pageSize|  每页记录数
    ///     |pageNum|   页码，从0开始，0表示第一页
    public query func pageDappByCategory(category: Category, pageSize: Nat, pageNum: Nat) : async DappPage {
        let filtedByCategory : DappStatisticsDB = findDappBy(dappStatsDB, func (k, v) : Bool { 
            Text.contains(v.profile.category, #text category) and v.profile.status  == STATUS_ENABLE 
            });
        page_(filtedByCategory, pageSize, pageNum, Utils.compareDappByLatest)
    };

    /// --------------------- Dapp Update -------------------- ///
    
    /// 创建Dapp信息 
    public shared(msg) func createDapp(
        name: Text,
        description: Text,
        logoUri: Text,
        photoUri: Text,
        outerUri: [(Text, Text)],
        owner: UserPrincipal,
        walletAddr: Text,
        category: Category,
        detail: Detail
    ) : async Result<DappId, Error> {

        let dappId = getIdAndIncrementOne();

        let caller = Principal.toText(msg.caller);

        let ae = accessCheck(caller, #create, #dapp dappId);

        ignore log(ae, caller);
        
        validAndProcess(ae, func (): Result<DappId, Error> {
            
            let dappOpt = getDapp_(dappStatsDB, dappId);

            switch (dappOpt) {
                case (?_) {
                    Debug.print("The dapp id: " # Nat.toText(dappId) # " already existes");
                    #err(#alreadyExisted)
                };
                case (null) {
                    let currentTime = Time.now();
                    let createdBy = Principal.toText(msg.caller);
                    let newDapp: DappProfile = {
                        dappId = dappId;
                        name = Utils.trim(name);
                        description = description;
                        logoUri = Utils.trim(logoUri);
                        photoUri = Utils.trim(photoUri);
                        outerUri = outerUri;
                        owner = owner;
                        walletAddr = Utils.trim(walletAddr);
                        category = category;
                        detail = detail;
                        status = STATUS_PENDING;
                        createdBy = createdBy;
                        createdAt = currentTime;
                    };

                    let newDappStats: DappStatistics = {
                        profile = newDapp;
                        likeCount = 0;
                        shareCount = 0;
                        rewardCount = 0;
                        commentCount = 0;
                    };

                    dappStatsDB := updateDapp(dappStatsDB, newDappStats);
                    
                    stateMem.access.addDappOwner(dappId, caller);

                    #ok(dappId)
                };
            }
        })
    };

    /// 审核Dapp，修改Dapp的状态
    /// Args:
    ///     |dappId|    需要被审核的DappId
    ///     |status|    将要设置成对应的状态
    /// Returns:
    ///     如果找到dappId对应的Dapp并设置成功，返回更新后对应的DappProfile, 否则返回#err(#notFound)，表示没有对应的记录
    public shared(msg) func verifyDapp(dappId: DappId, status: DappStatus) : async Result<(), Error> {
        
        let caller = Principal.toText(msg.caller);

        let ae = accessCheck(caller, #admin, #dapp dappId);

        ignore log(ae, caller);
        
        validAndProcess(ae, func (): Result<(), Error> {
            let dappOpt = getDapp_(dappStatsDB, dappId);
            switch (dappOpt) {
                case (?ds) {
                    let currentTime = Time.now();
                    let createdBy = Principal.toText(msg.caller);
                    
                    let updatedDappStats = modifyDappStatus(ds, status, currentTime, createdBy);

                    dappStatsDB := updateDapp(dappStatsDB, updatedDappStats);
                    #ok(())

                };

                case (null) {
                    Debug.print("The dapp id: " # Nat.toText(dappId) # " is not found.");
                    #err(#notFound)
                };
            }
        })
    };


    /// 修改Dapp
    public shared(msg) func editDapp(
        dappId: DappId,
        name: Text,
        description: Text,
        logoUri: Text,
        photoUri: Text,
        outerUri:[(Text, Text)],
        owner: UserPrincipal,
        walletAddr: Text,
        category: Category,
        detail: Detail,
        status: DappStatus,
    ) : async Result<(), Error> {

        let caller = Principal.toText(msg.caller);

        let ae = accessCheck(caller, #update, #dapp dappId);

        ignore log(ae, caller);

        validAndProcess(ae, func (): Result<(), Error> {
            let dappOpt = getDapp_(dappStatsDB, dappId);
            switch (dappOpt) {
                case (?ds) {
                    let currentTime = Time.now();
                    let createdBy = Principal.toText(msg.caller);
                    let di = ds.profile;

                    let newDapp: DappProfile = {
                        dappId = dappId;
                        name = Utils.trim(name);
                        description = description;
                        logoUri = Utils.trim(logoUri);
                        photoUri = Utils.trim(photoUri);
                        outerUri = outerUri;
                        owner = owner;
                        walletAddr = Utils.trim(walletAddr);
                        category = category;
                        detail = detail;
                        status = status;
                        createdBy = createdBy;
                        createdAt = currentTime;
                    };
    
                    let updatedDappStats = {
                        profile = newDapp;
                        likeCount = ds.likeCount;
                        shareCount = ds.shareCount;
                        rewardCount = ds.rewardCount;
                        commentCount = ds.commentCount;
                    };

                    dappStatsDB := updateDapp(dappStatsDB, updatedDappStats);
                    #ok(())

                };

                case (null) {
                    Debug.print("The dapp id: " # Nat.toText(dappId) # " is not found.");
                    #err(#notFound)
                };
            }
        })
    };

    /// 逻辑删除Dapp,把状态设置为disable
    public shared(msg) func deleteDapp(dappId: DappId) : async Result<(), Error> {

        let caller = Principal.toText(msg.caller);

        let ae = accessCheck(caller, #admin, #dapp dappId);

        ignore log(ae, caller);
        
        validAndProcess(ae, func (): Result<(), Error> {
            let dappOpt = getDapp_(dappStatsDB, dappId);
            switch (dappOpt) {
                case (?ds) {
                    let currentTime = Time.now();
                    let createdBy = Principal.toText(msg.caller);
                    
                    let updatedDappStats = modifyDappStatus(ds, STATUS_DISABLE, currentTime, createdBy);

                    dappStatsDB := updateDapp(dappStatsDB, updatedDappStats);
                    #ok(())

                };

                case (null) {
                    Debug.print("The dapp id: " # Nat.toText(dappId) # " is not found.");
                    #err(#notFound)
                };
            }
        })
    };

    /// ------------------------ Dapp End -------------------------------- ///

    /// ------------------------ Dapp likeMem Query ------------------------ ///
    /// 获取指定dapp的点赞用户
    public query func findUserLikeByDapp(dappId: DappId) : async [UserPrincipal] {
        findUserLikeByDapp_(dappId)
    };

    /// 获取某用户点赞的所有dapp
    public query func findDappByUserLike(userPrincipal: UserPrincipal) : async [DappId] {
        stateMem.dappLikes.get1(userPrincipal)
    };

    /// 获取指定dapp的点赞数量
    public query func countLikeByDapp(dappId: DappId) : async Nat {
        stateMem.dappLikes.get0Size(dappId)
    };

    /// 获取指定用户的占赞数量
    public query func countLikeByUser(userPrincipal: UserPrincipal) : async Nat {
        stateMem.dappLikes.get1Size(userPrincipal)
    };

    /// 用户是否点赞某dapp
    public query func isUserLikeDapp(userPrincipal: UserPrincipal, dappId: DappId) : async Bool {
        stateMem.dappLikes.isMember(dappId, userPrincipal)
    }; 

    /// ------------------------- Dapp Like Update --------------------- /// 

    /// 点赞
    public shared(msg) func likeToggle(dappId: DappId) : async Result<Bool, Error> {
        let userPrincipal = Principal.toText(msg.caller);
              
        let likeCountOfDapp = stateMem.dappLikes.get0Size(dappId);
        Debug.print("current like count is: " # Nat.toText(likeCountOfDapp));

        if (stateMem.dappLikes.isMember(dappId, userPrincipal)) {
            stateMem.dappLikes.delete(dappId, userPrincipal);
            Debug.print("Deleted " #userPrincipal # " like " # Nat.toText(dappId));
            let deletedLikeCountOfDapp = stateMem.dappLikes.get0Size(dappId);
            Debug.print("After deleted, current like count is: " # Nat.toText(deletedLikeCountOfDapp));

            dappStatsDB := updateDappLike(dappStatsDB, dappId, #subOne);
            #ok(false)
        } else {      
            stateMem.dappLikes.put(dappId, userPrincipal);
            Debug.print(userPrincipal # " liked " # Nat.toText(dappId));
            let AddedLikeCountOfDapp = stateMem.dappLikes.get0Size(dappId);
            Debug.print("After liked: current like count is: " # Nat.toText(AddedLikeCountOfDapp));

            dappStatsDB := updateDappLike(dappStatsDB, dappId, #addOne);
            #ok(true)
        }
            
               
    };

    /// ----------------------- Dapp Like end -------------------------- ///

    /// ----------------------- Dapp Share Query ----------------------- ///
    /// 根据某个shareId获取某个share
    public query func getDappShare(shareId: ShareId) : async ?DappShare {
        shareRepository.get(shareDB, Utils.keyOfDappShare(shareId), Utils.dappShareEq)
    };

    /// 查询某个dapp下所有的share
    public query func findShareByDapp(dappId: DappId) : async [DappShare] {
        let filtered = findDappShareBy_(shareDB, func (k, v) : Bool { v.dappId == dappId });
        Trie.toArray<ShareId, DappShare, DappShare>(filtered, func (k, v) : DappShare { v })
    };

    /// 查询某个dapp的share数量
    public query func countShareByDapp(dappId: DappId) : async Nat {
        let filtered = findDappShareBy_(shareDB, func (k, v) : Bool { v.dappId == dappId });
        Trie.size<ShareId, DappShare>(filtered)
    };
    
    /// 所有分享总数
    public query func countDappShareTotal() : async Nat {
        Trie.size<ShareId, DappShare>(shareDB)
    };

    /// ------------------------ Dapp Share Update -------------------- ///
    /// 保存share
    public shared(msg) func createDappShare(dappId: DappId, shareTo: Text) : async Result<ShareId, Error> {
        let id = getIdAndIncrementOne();

        let dappShare: DappShare = {
            shareId = id;
            dappId = dappId;
            shareBy = Principal.toText(msg.caller);
            shareTo = shareTo;
            shareTime = Time.now();
        };

        shareDB := updateDappShare_(shareDB, dappShare);
        /// 更新DappStatisticsDB, 分享数+1
        dappStatsDB := updateDappStatsByItem(dappStatsDB, dappId, #share, #addOne);
        
        #ok(id)
    };

    /// 删除某个share
    public shared(msg) func deleteDappShare(shareId: ShareId) : async Result<(), Error> {
        let (newShareDB, deletedShare) = shareRepository.delete(shareDB, Utils.keyOfDappShare(shareId), Utils.dappShareEq);

        shareDB := newShareDB;
        /// 更新DappStatisticsDB, 分享数-1
        switch (deletedShare) {
            case (?dds) {
                dappStatsDB := updateDappStatsByItem(dappStatsDB, dds.dappId, #share, #subOne);
                #ok(())
            };
            case null {
                Debug.print("DappShare id: " # Nat.toText(shareId) # " not found!");
                #err(#dappShareNotFound)
            }
        }
        
    };

    /// --------------------------- Dapp Photo --------------------- ///
    /// 上传Dapp logo或图片
    /// 实际调用图库服务的功能进行图片的存储功能，简化输入参数，图片保存成功后返回在图库服务中对应的id
    /// Args:
    ///     |pic|   图片的字符串表示，如果没有，用""代替
    ///     |picBin|    图片的字节数组表示，如果没有，用空数据[]代替
    ///     |picName|   图片的名字，如果没有，用""代替
    /// Returns:
    ///     保存成功会返回图片的id，否则返回上传图片失败错误
    public shared(msg) func uploadDappPic(pic: Picture, picBin: PictureBin, picName: Text) : async Result<PictureId, Error> {
        let caller = Principal.toText(msg.caller);
        let createdLogo = await PhotoService.createPic(pic, picBin, picName, "", caller);
        switch (createdLogo) {
            case (#ok(pid)) { #ok(pid) };
            case (#err(_))  { #err(#uploadPicFailed) };
        }
    };

    /// ------------------------ private functions -------------------------- ///

    /// 私有辅助方法，保存DappStatistics到数据库中
    /// Args:
    ///     |db| 保存DappProfile的数据库
    ///     |DappProfile| 需要被保存的DappProfile
    /// Returns:
    ///     返回保存新DappProfile后的数据库
    func updateDapp(db_: DappStatisticsDB, dappStats: DappStatistics) : DappStatisticsDB {
        
        let (newDb, _) = dappRepository.update(db_, dappStats, Utils.keyOfDapp(dappStats.profile.dappId), Utils.dappEq);
        newDb
    };

    /// 修改Dapp的状态
    func modifyDappStatus(ds: DappStatistics, status: DappStatus, currentTime: Int, modifiedBy: UserPrincipal) : DappStatistics {
       
        let di = ds.profile;

        let newDapp: DappProfile = {
            dappId = di.dappId;
            name = di.name;
            description = di.description;
            logoUri = di.logoUri;
            photoUri = di.photoUri;
            outerUri = di.outerUri;
            owner = di.owner;
            walletAddr = di.walletAddr;
            category = di.category;
            detail = di.detail;
            status = status;
            createdBy = modifiedBy;
            createdAt = currentTime;
        };

        let updatedDappStats = {
            profile = newDapp;
            likeCount = ds.likeCount;
            shareCount = ds.shareCount;
            rewardCount = ds.rewardCount;
            commentCount = ds.commentCount;
        };
    };

    /// 辅助方法，获取对应DappId的数据集
    func getDapp_(db_: DappStatisticsDB, dappId: DappId) : ?DappStatistics {
        dappRepository.get(db_, Utils.keyOfDapp(dappId), Utils.dappEq)
    };

    /// 辅助方法，根据指定条件查询并返回满足条件的Dapp数据集
    func findDappBy(db_: DappStatisticsDB, filter: (DappId, DappStatistics) -> Bool) : DappStatisticsDB {
        dappRepository.findBy(db_, filter)
    };

    /// 辅助方法，分页查询Dapp
    func page_(db_ : DappStatisticsDB, pageSize: Nat, pageNum : Nat, sortWith: (DappStatistics, DappStatistics) -> Order.Order) : DappPage {
        Debug.print("Teh page origin db size: " # Nat.toText(Trie.size<DappId, DappStatistics>(db_)));
        let dba = Trie.toArray<DappId, DappStatistics, DappStatistics>(db_, func (id: DappId, stats: DappStatistics) : DappStatistics {
            stats
        });

        let sorted = Utils.sort(dba, sortWith);
        dappRepository.page(sorted, pageSize, pageNum)
    };

    /// DappShare辅助方法
    /// 私有辅助方法，保存Dapp share
    func updateDappShare_(sdb_ : ShareDB, dappShare: DappShare) : ShareDB {
        let (newShareDB, _) = shareRepository.update(sdb_, dappShare, Utils.keyOfDappShare(dappShare.shareId), Utils.dappShareEq);
        newShareDB
    };

    /// 获取指定dapp的点赞用户
    func findUserLikeByDapp_(dappId: DappId) : [UserPrincipal] {
        stateMem.dappLikes.get0(dappId)
    };

    func findShareByDapp_(dappId: DappId) : [DappShare] {
        let filtered = findDappShareBy_(shareDB, func (k, v) : Bool { v.dappId == dappId });
        Trie.toArray<ShareId, DappShare, DappShare>(filtered, func (k, v) : DappShare { v })
    };

    /// 私有辅助方法，按条件查询Dapp share
    func findDappShareBy_(sdb_ : ShareDB, filter: (ShareId, DappShare) -> Bool) : ShareDB {
        shareRepository.findBy(sdb_, filter)      
    };

    /// 获取当前的id，并对id+1,这是有size effects的操作
    func getIdAndIncrementOne() : Nat {
        let id = idGenerator;
        idGenerator += 1;
        id
    };

    /// 根据点赞行为更新数据集
    func updateDappLike(dappDB_ : DappStatisticsDB, dappId: DappId, op: DappStatisticsOp) : DappStatisticsDB {
        updateDappStatsByItem(dappDB_, dappId, #like, op)
    };

    /// 根据Dapp数据项行为更新数据集
    func updateDappStatsByItem(dappDB_ : DappStatisticsDB, dappId: DappId, dsItem: DappStatisticsItem, op: DappStatisticsOp) : DappStatisticsDB {
        switch (getDapp_(dappDB_, dappId)) {
            case (?ds) {
                let newStats = Utils.computeStatsItem(ds, dsItem, op);
                updateDapp(dappDB_, newStats)
            };
            case (_) {
                Debug.print("Dapp id: " # Nat.toText(dappId) # " not found!");
                dappDB_
            };
        }
    };

    /// --------------- User helper functions --------------------- /// 
    /// 私有辅助方法，获取用户信息
    func getUser_(userDB_ : UserDB, userPrincipal: UserPrincipal) : ?UserProfile {
        userRepository.get(userDB_, Utils.keyOfUser(userPrincipal), Utils.userEq)
    };

    /// 私有辅助方法，保存用户信息到数据库中
    /// Args:
    ///     |db| 保存用户信息的数据库
    ///     |userProfile| 需要被保存的用户信息
    /// Returns:
    ///     返回保存新DappProfile后的数据库
    func updateUser_(userDB_: UserDB, userProfile: UserProfile) : UserDB {
        
        let (newDb, _) = userRepository.update(userDB_, userProfile, Utils.keyOfUser(userProfile.principal), Utils.userEq);
        newDb
    };

    /// 根据用户名查询用户
    func findOneUserByName_(userDB_ : UserDB, username: Text) : ?(UserPrincipal, UserProfile) {
        let users = userRepository.findBy(userDB_, func (uid, up): Bool { up.username == username });
        Utils.iter<UserPrincipal, UserProfile>(users).next()
    };

    func findBy<K, V>(db_ : Database<K, V>, repo: Repository.Repository<K, V>, filter: (K, V) -> Bool) : Database<K, V> {
        repo.findBy(db_, filter)
    };

    /// 根据用户查找用户图片
    func getUserPic_(userPicDB_ : UserPicDB, userPrincipal: UserPrincipal) : ?UserPic {
        userPicRepository.get(userPicDB_, Utils.keyOfUser(userPrincipal), Utils.userEq)
    };

    /// 记录日志，异步操作
    func log(ae: AccessEvent, caller: UserPrincipal ) : async () {
        ignore Logger.info(Access.accessEventToText(ae), getCanisterId(), caller);
    };

    /// 检查权限返回访问事件，包含是否能操作
    func accessCheck(caller : UserPrincipal, action : Types.UserAction, target : Types.ActionTarget) : AccessEvent {
        stateMem.access.check(timeNow_(), caller, action, target)       
    };

    /// 辅助方法，判断权限是否允许，然后逻辑处理并返回
    func validAndProcess<T>(ae: AccessEvent, f: () -> Result<T, Error>) : Result<T, Error> {
        if (ae.isOk) {
            f()
        } else {
            #err(#unauthorized)
        }
    };

    /// 判断用户是不是dapp的owner
    func isDappOwner(dappDB_ : DappStatisticsDB,  dappId: DappId, operator_ : UserPrincipal) : Bool {
        switch (getDapp_(dappDB_, dappId)) {
            case (?d) {
                if (d.profile.owner == operator_) { true }
                else false
            };
            case (_) false;
        }
    };

    /// 时间模式，#ic是普通开发模式，#script是脚本模式，默认是#ic
    var timeMode : {#ic ; #script} = switch (Param.timeMode) {
        case (#ic) #ic;
        case (#script _) #script
    };

    var scriptTime : Int = 0;

    /// 辅助方法，获取当前时间
    func timeNow_() : Int {
        switch timeMode {
            case (#ic) { Time.now() };
            case (#script) { scriptTime };
        }
    };

    /// 辅助方法, 重置时间模式和StateMem
    func reset_( mode : { #ic ; #script : Int } ) {
        setTimeMode_(mode);
        stateMem := State.init(owner_, dappOwnerMap, likeDBToRel(likeDB));
    };

    /// 辅助方法, 设置时间模式
    func setTimeMode_( mode : { #ic ; #script : Int } ) {
        switch mode {
            case (#ic) { timeMode := #ic };
            case (#script st) { timeMode := #script ; scriptTime := st };
        }
    };

};
