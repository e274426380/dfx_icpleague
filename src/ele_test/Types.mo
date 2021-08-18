
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Trie "mo:base/Trie";

module {

    
    /// Dapp type
    public type DappId = Nat;
    public type Category = Text;
    public type Detail = Text;

    public type StatusEnum = Text;

    public type DappPage = Page<DappStatistics>;

    public type Timestamp = Int;    // See mo:base/Time and Time.now()

    /// DappShare type
    public type ShareId = Nat;

    public type Database<K, V> = Trie.Trie<K, V>;

    public type DBKey<K> = Trie.Key<K>;

    // public type StatusEnum = {
    //     #enable;
    //     #disable;
    //     #pending;
    // };

    // 三种状态：审核通过enable,无效disable,审核中pending
    public let STATUS_ENABLE : StatusEnum = "enable";
    public let STATUS_DISABLE : StatusEnum = "disable";
    public let STATUS_PENDING : StatusEnum = "pending";


    public let natTextPairEqual = (Nat.equal, Text.equal);
    public let natTextPairHash = (Hash.hash, Text.hash);

    public let textNatPairEqual = (Text.equal, Nat.equal);
    public let textNatPairHash = (Text.hash, Hash.hash);

    /// Dapp元数据
    public type DappProfile = {
        dappId : DappId;
        name: Text;
        description: Text;
        logoUri: Text;
        photoUri: Text;
        outerUri: [(Text, Text)];   /// 外链名称及对应的链接，例如(”twitter", "https://twitter.com/dfinfity")
        owner: UserPrincipal;
        walletAddr: Text;
        category: Category;
        detail: Detail;
        status: StatusEnum;
        createdBy: UserPrincipal;
        createdAt: Timestamp;
    };

    /// 分页数据结构
    public type Page<T> = {
        data : [T];
        pageSize : Nat;
        pageNum : Nat;
    };

    /// 错误类型定义
    public type Error = {
        #idDuplicated;
        #notFound;
        #alreadyExisted;
        #uploadPicFailed;
        #dappShareNotFound;

        #userNotFound;
        #userAlreadyExists : Text;
        #usernameAlreadyExists;
        #invalidUsername;
        #unauthorized;
    };

    /// Dapp分享元数据
    public type DappShare = {
        shareId: ShareId;
        dappId: DappId;
        shareBy: UserPrincipal;
        shareTo: Text;
        shareTime: Timestamp;
    };

    
    /// Dapp评论元数据
    public type CommentId = Nat;
    public type DappComment = {
        commentId: CommentId;
        dappId: DappId;
    };

    /// Dapp元数据和行为统计
    public type DappStatistics = {
        profile: DappProfile; // Dapp信息
        likeCount: Nat;    // 点赞次数
        shareCount: Nat;   // 分享次数
        rewardCount: Nat;   // 打赏次数
        commentCount: Nat;  // 评论次数
    };

    /// DappReward 打赏数据
    public type DappRewardId = Nat;
    public type RewardAddress = Text;

    public type DappReward = {
        rewardId: DappRewardId;
        dappId: DappId;
        from: RewardAddress;
        to: RewardAddress;
        rewardTime: Timestamp;
    };

    /// Dapp各项数据明细
    public type DappDetail = {
        dappStats: DappStatistics;
        likes: [UserPrincipal];
        shares: [DappShare];
        // rewards: [DappReward];
    };

    /// Dapp统计项
    public type DappStatisticsItem = {
        #like;      
        #share;
        #reward;
        #comment;
    };

    public type DappStatisticsOp = {
        #addOne;
        #subOne;
    };

    /// 图库
    public type PictureId = Nat;
    public type Picture = Text;
    public type PictureBin = [Nat8];

    /// 黑客松
    public type HackathonId = Nat;

    /// 用户数据
    public type UserId = Nat;
    public type UserPrincipal = Text;

    public type UserProfile = {
        userId : UserId;
        principal : UserPrincipal;
        username : Text;
        status : StatusEnum;
        createdBy : UserPrincipal;
        createdAt : Timestamp;
    };

    public type UserPic = {
        principal: UserPrincipal;
        pictureId: PictureId;
    };

    /// 用户登录会话
    public type UserSession = {
        userPrincipal: UserPrincipal;
        loginTime: Timestamp;
    };

    /// profile information provided by service to front end views -- Pic is separate query
    public type ProfileInfo = {
        userName: Text;
        following: [UserPrincipal];
        followers: [UserPrincipal];
        // uploadedVideos: [VideoId];
        // likedVideos: [VideoId];
        hasPic: Bool;
        // rewards: Nat;
        abuseFlagCount: Nat; // abuseFlags counts other users' flags on this profile, for possible blurring.
    };

    /// Role for a caller into the service API.
    /// Common case is #user.
    public type Role = {
        // caller is the canister owner
        #canisterOwner;
        // caller is a user
        #user;       
        // caller is not yet a user; just a guest
        #guest
    };

    public func roleToText(role: Role) : Text {
        switch (role) {
            case (#canisterOwner)  "canisterOwner";
            case (#user) "user";
            case (#guest) "guest";
        }
    };

    /// Action is an API call classification for access control logic.
    public type UserAction = {
        /// Create a new user name, associated with a principal and role #user.
        #create;
        /// Update an existing profile, or add to its videos, etc.
        #update;
        /// View an existing profile, or its videos, etc.
        #view;
        /// Admin action, e.g., getting a dump of logs, etc
        #admin
    };

    public func userActionToText(ua: UserAction) : Text {
        switch (ua) {
            case (#create) "create";
            case (#update) "update";
            case (#view) "view";
            case (#admin) "admin";
        }
    };

    public func textToUserAction(t: Text) : UserAction {
        if (t == "admin") {
            #admin
        } else if (t == "create") {
            #create
        } else if (t == "update") {
            #update
        } else {
            #view
        }
    };

    /// An ActionTarget identifies the target of a UserAction.
    public type ActionTarget = {
        /// User's profile or dapp are all potential targets of action.
        #user : UserPrincipal ;
        /// Exactly one app is the target of the action.
        #dapp : DappId ;
        /// Hackathon
        #hackathon : HackathonId;
        /// Everything is a potential target of the action.
        #all;
        /// Everything public is a potential target (of viewing only)
        #pubView
    };

    public func actionTargetToText(at: ActionTarget) : Text {
        switch (at) {
            case (#user up) "user: " # up ;
            case (#dapp dappId) "dappId: " # Nat.toText(dappId);
            case (#hackathon hackathonId) "hackathonId: " # Nat.toText(hackathonId);
            case (#pubView) "pubView";
            case (#all) "all";
        }
    };

};