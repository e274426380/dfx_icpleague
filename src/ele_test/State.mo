
import Hash "mo:base/Hash";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Text "mo:base/Text";

import Access "Access";
import Rel "Rel";
import RelObj "RelObj";

import Types "./Types"

module {

    type HashMap<X, Y> = HashMap.HashMap<X, Y>;

    type DappId = Types.DappId;
    type UserProfile = Types.UserProfile;
    type UserPrincipal = Types.UserPrincipal;
    type Role = Types.Role;

    type RelShared<X, Y> = Rel.RelShared<X, Y>;
    type RelObj<X, Y> = RelObj.RelObj<X, Y>;
    
    
    /// 整个Dapp的临时状态，包含用户信息，用户
    public type StateMem = {
        access : Access.Access;        // 权限控制
        dappLikes : RelObj<DappId, UserPrincipal>        // dapp与点赞用户关系      
    };

    public type StateShared = {
        access : {
            admin: UserPrincipal;
            dappWithOwners: [(DappId, UserPrincipal)]
        };
        dappLikes : RelShared<DappId, UserPrincipal>
    };

    /// 初始化状态变量 TODO
    public func init(admin: UserPrincipal, 
        dappWithOwners: HashMap<DappId, UserPrincipal>, 
        dappLikes: RelObj<DappId, UserPrincipal>
        ) : StateMem {
        // let equal = (Nat.equal, Text.equal);
        // let hash = (Hash.hash, Text.hash);

        let sm: StateMem = {
            access = Access.Access(admin, dappWithOwners);
            dappLikes = dappLikes;
        };

        sm
    };

    public func stateToShare(stateMem: StateMem) : StateShared {
        {
            access = stateMem.access.toShare();
            dappLikes = Rel.share(stateMem.dappLikes.getRel())
        }
    };

};

